Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1FGM7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:59:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63200 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab1FGM73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:59:29 -0400
Message-ID: <4DEE212E.90904@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:01:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 06/15] KVM: MMU: cleanup for FNAME(fetch)
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:59:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:59:16,
	Serialize complete at 2011-06-07 20:59:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gw->pte_access is the final access permission, since it is unified with
gw->pt_access when we walked guest page table:

FNAME(walk_addr_generic):
	pte_access = pt_access & FNAME(gpte_access)(vcpu, pte);

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 67971da..95da29e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -477,7 +477,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (!is_present_gpte(gw->ptes[gw->level - 1]))
 		return NULL;
 
-	direct_access = gw->pt_access & gw->pte_access;
+	direct_access = gw->pte_access;
 
 	top_level = vcpu->arch.mmu.root_level;
 	if (top_level == PT32E_ROOT_LEVEL)
@@ -535,7 +535,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		link_shadow_page(it.sptep, sp);
 	}
 
-	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
+	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
 		     user_fault, write_fault, ptwrite, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
-- 
1.7.4.4

