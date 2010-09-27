Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0I0KFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:05:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60348 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab0I0KFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:05:03 -0400
Message-ID: <4CA06D59.5050704@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:09:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 7/7] KVM: MMU: audit: check whether have unsync sps after
 root sync
References: <4CA06BA4.4090303@cn.fujitsu.com>
In-Reply-To: <4CA06BA4.4090303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After root synced, all unsync sps are synced, this patch add a check to make
sure it's no unsync sps in VCPU's page table

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c       |   11 +++++++++--
 arch/x86/kvm/mmu_audit.c |   11 ++++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index afde64b..ba7e764 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -53,14 +53,18 @@ enum {
 	AUDIT_PRE_PAGE_FAULT,
 	AUDIT_POST_PAGE_FAULT,
 	AUDIT_PRE_PTE_WRITE,
-	AUDIT_POST_PTE_WRITE
+	AUDIT_POST_PTE_WRITE,
+	AUDIT_PRE_SYNC,
+	AUDIT_POST_SYNC
 };
 
 char *audit_point_name[] = {
 	"pre page fault",
 	"post page fault",
 	"pre pte write",
-	"post pte write"
+	"post pte write",
+	"pre sync",
+	"post sync"
 };
 
 #undef MMU_DEBUG
@@ -2516,6 +2520,8 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
+
+	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 		sp = page_header(root);
@@ -2531,6 +2537,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 			mmu_sync_children(vcpu, sp);
 		}
 	}
+	trace_kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 }
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 66219af..4aee32c 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -164,6 +164,14 @@ static void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 		inspect_spte_has_rmap(vcpu->kvm, sptep);
 }
 
+static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep, int level)
+{
+	struct kvm_mmu_page *sp = page_header(__pa(sptep));
+
+	if (audit_point == AUDIT_POST_SYNC && sp->unsync)
+		audit_printk("meet unsync sp(%p) after sync root.\n", sp);
+}
+
 static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	int i;
@@ -179,7 +187,7 @@ static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
 	}
 }
 
-void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
@@ -215,6 +223,7 @@ static void audit_spte(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
 	audit_sptes_have_rmaps(vcpu, sptep, level);
 	audit_mappings(vcpu, sptep, level);
+	audit_spte_after_sync(vcpu, sptep, level);
 }
 
 static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
-- 
1.7.0.4

