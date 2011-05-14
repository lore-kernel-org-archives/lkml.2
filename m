Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141Ab1ENVeC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:34:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55624 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab1ENVd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:33:58 -0400
Message-ID: <4DCEF5B1.3050706@cn.fujitsu.com>
Date: Sun, 15 May 2011 05:35:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/7] KVM: MMU: optimize pte write path if don't have protected
 sp
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:34:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:34:08,
	Serialize complete at 2011-05-15 05:34:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply return from kvm_mmu_pte_write path if no shadow page is
write-protected, then we can avoid to walk all shadow pages and hold
mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d2ac8e2..d2e5fb8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -442,6 +442,7 @@ struct kvm_arch {
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	atomic_t invlpg_counter;
+	atomic_t indirect_shadow_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2841805..971e2d2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -498,6 +498,7 @@ static void account_shadowed(struct kvm *kvm, gfn_t gfn)
 		linfo = lpage_info_slot(gfn, slot, i);
 		linfo->write_count += 1;
 	}
+	atomic_inc(&kvm->arch.indirect_shadow_pages);
 }
 
 static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
@@ -513,6 +514,7 @@ static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
 		linfo->write_count -= 1;
 		WARN_ON(linfo->write_count < 0);
 	}
+	atomic_dec(&kvm->arch.indirect_shadow_pages);
 }
 
 static int has_wrprotected_page(struct kvm *kvm,
@@ -3233,6 +3235,13 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int level, npte, invlpg_counter, r, flooded = 0;
 	bool remote_flush, local_flush, zap_page;
 
+	/*
+	 * If we don't have indirect shadow pages, it means no page is
+	 * write-protected, so we can exit simply.
+	 */
+	if (!atomic_read(&vcpu->kvm->arch.indirect_shadow_pages))
+		return;
+
 	zap_page = remote_flush = local_flush = false;
 	offset = offset_in_page(gpa);
 
-- 
1.7.4.4
