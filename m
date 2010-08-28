Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0H1LSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:18:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab0H1LSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:18:41 -0400
Message-ID: <4C78F186.9000109@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:22:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/5] KVM: MMU: fix wrong not write protected sp report
References: <4C78F07E.1040709@cn.fujitsu.com>
In-Reply-To: <4C78F07E.1040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit code reports some sp not write protected in current code, it's just the
bug in audit_write_protection(), since:

- the invalid sp not need write protected
- using uninitialize local variable('gfn')
- call kvm_mmu_audit() out of mmu_lock's protection

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    5 +++--
 arch/x86/kvm/paging_tmpl.h |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1c784b9..68575dc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3708,16 +3708,17 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
 	u64 *spte;
-	gfn_t gfn;
 
 	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
 		if (sp->role.direct)
 			continue;
 		if (sp->unsync)
 			continue;
+		if (sp->role.invalid)
+			continue;
 
 		slot = gfn_to_memslot(vcpu->kvm, sp->gfn);
-		rmapp = &slot->rmap[gfn - slot->base_gfn];
+		rmapp = &slot->rmap[sp->gfn - slot->base_gfn];
 
 		spte = rmap_next(vcpu->kvm, rmapp, NULL);
 		while (spte) {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a4e8389..a0f2feb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -504,7 +504,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	unsigned long mmu_seq;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
-	kvm_mmu_audit(vcpu, "pre page fault");
 
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
@@ -542,6 +541,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
+
+	kvm_mmu_audit(vcpu, "pre page fault");
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			     level, &write_pt, pfn);
-- 
1.7.0.4

