Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0KQEFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:05:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50003 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0KQEFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:05:51 -0500
Message-ID: <4CE355A0.6020907@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:10:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/6] KVM: MMU: fix forgot flush vcpu tlbs
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:06:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:06:12,
	Serialize complete at 2010-11-17 12:06:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some paths forgot to flush vcpu tlbs after remove rmap, this
patch fix it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |   14 +++++++++++---
 arch/x86/kvm/paging_tmpl.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bdb9fa9..e008ae7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -736,10 +736,16 @@ static int set_spte_track_bits(u64 *sptep, u64 new_spte)
 	return 1;
 }
 
-static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
+static bool drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 {
-	if (set_spte_track_bits(sptep, new_spte))
+	bool ret = false;
+
+	if (set_spte_track_bits(sptep, new_spte)) {
 		rmap_remove(kvm, sptep);
+		ret = true;
+	}
+
+	return ret;
 }
 
 static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
@@ -1997,7 +2003,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
 			ret = 1;
-			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
+			if (drop_spte(vcpu->kvm, sptep,
+				      shadow_trap_nonpresent_pte))
+				kvm_flush_remote_tlbs(vcpu->kvm);
 			goto done;
 		}
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ba00eef..58b4d9a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -781,6 +781,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
 			drop_spte(vcpu->kvm, &sp->spt[i], nonpresent);
+			kvm_flush_remote_tlbs(vcpu->kvm);
 			continue;
 		}
 
-- 
1.7.0.4
