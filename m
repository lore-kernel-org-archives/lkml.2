Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab1GKTXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:23:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964791Ab1GKTXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:23:21 -0400
Message-ID: <4E1B4E1F.5030809@cn.fujitsu.com>
Date: Tue, 12 Jul 2011 03:25:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 06/18] KVM: MMU: cleanup for FNAME(fetch)
References: <4E1B4CF8.605@cn.fujitsu.com>
In-Reply-To: <4E1B4CF8.605@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:22:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:22:38,
	Serialize complete at 2011-07-12 03:22:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gw->pte_access is the final access permission, since it is unified with
gw->pt_access when we walked guest page table:

FNAME(walk_addr_generic):
	pte_access = pt_access & FNAME(gpte_access)(vcpu, pte, true);

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index c9fe97b..5c2aa40 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -479,7 +479,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (!is_present_gpte(gw->ptes[gw->level - 1]))
 		return NULL;
 
-	direct_access = gw->pt_access & gw->pte_access;
+	direct_access = gw->pte_access;
 
 	top_level = vcpu->arch.mmu.root_level;
 	if (top_level == PT32E_ROOT_LEVEL)
@@ -537,7 +537,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		link_shadow_page(it.sptep, sp);
 	}
 
-	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
+	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
 		     user_fault, write_fault, ptwrite, it.level,
 		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
-- 
1.7.5.4

