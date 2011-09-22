Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1IVJfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:35:33 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44259 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1IVJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:35:29 -0400
Date: Thu, 22 Sep 2011 11:35:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL] s390 fixes
Message-ID: <20110922093525.GA2577@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

There are only two patches: the first one fixes a regression introduced
with the "gmap address spaces for kvm guest images" patches during this
merge window which break kvm on s390.
The second patch adds a missing feature bit for the same patch series.
Also both patches have been Acked by Avi.

Thanks,
Heiko

Christian Borntraeger (2):
      [S390] kvm: fix address mode switching
      [S390] kvm: extension capability for new address space layout

 arch/s390/include/asm/pgtable.h |    2 ++
 arch/s390/kernel/asm-offsets.c  |    3 +++
 arch/s390/kernel/entry64.S      |    6 ++++++
 arch/s390/kvm/kvm-s390.c        |    5 +++--
 arch/s390/mm/pgtable.c          |   10 ++--------
 include/linux/kvm.h             |    1 +
 6 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 519eb5f..c0cb794 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -658,12 +658,14 @@ static inline void pgste_set_pte(pte_t *ptep, pgste_t pgste)
  * struct gmap_struct - guest address space
  * @mm: pointer to the parent mm_struct
  * @table: pointer to the page directory
+ * @asce: address space control element for gmap page table
  * @crst_list: list of all crst tables used in the guest address space
  */
 struct gmap {
 	struct list_head list;
 	struct mm_struct *mm;
 	unsigned long *table;
+	unsigned long asce;
 	struct list_head crst_list;
 };
 
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 532fd43..2b45591 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <asm/vdso.h>
 #include <asm/sigp.h>
+#include <asm/pgtable.h>
 
 /*
  * Make sure that the compiler is new enough. We want a compiler that
@@ -126,6 +127,7 @@ int main(void)
 	DEFINE(__LC_KERNEL_STACK, offsetof(struct _lowcore, kernel_stack));
 	DEFINE(__LC_ASYNC_STACK, offsetof(struct _lowcore, async_stack));
 	DEFINE(__LC_PANIC_STACK, offsetof(struct _lowcore, panic_stack));
+	DEFINE(__LC_USER_ASCE, offsetof(struct _lowcore, user_asce));
 	DEFINE(__LC_INT_CLOCK, offsetof(struct _lowcore, int_clock));
 	DEFINE(__LC_MCCK_CLOCK, offsetof(struct _lowcore, mcck_clock));
 	DEFINE(__LC_MACHINE_FLAGS, offsetof(struct _lowcore, machine_flags));
@@ -151,6 +153,7 @@ int main(void)
 	DEFINE(__LC_VDSO_PER_CPU, offsetof(struct _lowcore, vdso_per_cpu_data));
 	DEFINE(__LC_GMAP, offsetof(struct _lowcore, gmap));
 	DEFINE(__LC_CMF_HPP, offsetof(struct _lowcore, cmf_hpp));
+	DEFINE(__GMAP_ASCE, offsetof(struct gmap, asce));
 #endif /* CONFIG_32BIT */
 	return 0;
 }
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 5f729d6..713da07 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -1076,6 +1076,11 @@ sie_loop:
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
 	tm	__TI_flags+7(%r14),_TIF_EXIT_SIE
 	jnz	sie_exit
+	lg	%r14,__LC_GMAP			# get gmap pointer
+	ltgr	%r14,%r14
+	jz	sie_gmap
+	lctlg	%c1,%c1,__GMAP_ASCE(%r14)	# load primary asce
+sie_gmap:
 	lg	%r14,__SF_EMPTY(%r15)		# get control block pointer
 	SPP	__SF_EMPTY(%r15)		# set guest id
 	sie	0(%r14)
@@ -1083,6 +1088,7 @@ sie_done:
 	SPP	__LC_CMF_HPP			# set host id
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
 sie_exit:
+	lctlg	%c1,%c1,__LC_USER_ASCE		# load primary asce
 	ni	__TI_flags+6(%r14),255-(_TIF_SIE>>8)
 	lg	%r14,__SF_EMPTY+8(%r15)		# load guest register save area
 	stmg	%r0,%r13,0(%r14)		# save guest gprs 0-13
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f17296e..dc2b580 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -123,6 +123,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 
 	switch (ext) {
 	case KVM_CAP_S390_PSW:
+	case KVM_CAP_S390_GMAP:
 		r = 1;
 		break;
 	default:
@@ -263,10 +264,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.guest_fpregs.fpc &= FPC_VALID_MASK;
 	restore_fp_regs(&vcpu->arch.guest_fpregs);
 	restore_access_regs(vcpu->arch.guest_acrs);
+	gmap_enable(vcpu->arch.gmap);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	gmap_disable(vcpu->arch.gmap);
 	save_fp_regs(&vcpu->arch.guest_fpregs);
 	save_access_regs(vcpu->arch.guest_acrs);
 	restore_fp_regs(&vcpu->arch.host_fpregs);
@@ -461,7 +464,6 @@ static void __vcpu_run(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	kvm_guest_enter();
 	local_irq_enable();
-	gmap_enable(vcpu->arch.gmap);
 	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
 		   atomic_read(&vcpu->arch.sie_block->cpuflags));
 	if (sie64a(vcpu->arch.sie_block, vcpu->arch.guest_gprs)) {
@@ -470,7 +472,6 @@ static void __vcpu_run(struct kvm_vcpu *vcpu)
 	}
 	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
 		   vcpu->arch.sie_block->icptcode);
-	gmap_disable(vcpu->arch.gmap);
 	local_irq_disable();
 	kvm_guest_exit();
 	local_irq_enable();
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 4d1f2bc..f69ff3c 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -160,6 +160,8 @@ struct gmap *gmap_alloc(struct mm_struct *mm)
 	table = (unsigned long *) page_to_phys(page);
 	crst_table_init(table, _REGION1_ENTRY_EMPTY);
 	gmap->table = table;
+	gmap->asce = _ASCE_TYPE_REGION1 | _ASCE_TABLE_LENGTH |
+		     _ASCE_USER_BITS | __pa(table);
 	list_add(&gmap->list, &mm->context.gmap_list);
 	return gmap;
 
@@ -240,10 +242,6 @@ EXPORT_SYMBOL_GPL(gmap_free);
  */
 void gmap_enable(struct gmap *gmap)
 {
-	/* Load primary space page table origin. */
-	S390_lowcore.user_asce = _ASCE_TYPE_REGION1 | _ASCE_TABLE_LENGTH |
-				 _ASCE_USER_BITS | __pa(gmap->table);
-	asm volatile("lctlg 1,1,%0\n" : : "m" (S390_lowcore.user_asce) );
 	S390_lowcore.gmap = (unsigned long) gmap;
 }
 EXPORT_SYMBOL_GPL(gmap_enable);
@@ -254,10 +252,6 @@ EXPORT_SYMBOL_GPL(gmap_enable);
  */
 void gmap_disable(struct gmap *gmap)
 {
-	/* Load primary space page table origin. */
-	S390_lowcore.user_asce =
-		gmap->mm->context.asce_bits | __pa(gmap->mm->pgd);
-	asm volatile("lctlg 1,1,%0\n" : : "m" (S390_lowcore.user_asce) );
 	S390_lowcore.gmap = 0UL;
 }
 EXPORT_SYMBOL_GPL(gmap_disable);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2c366b5..aace6b8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -553,6 +553,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_SPAPR_TCE 63
 #define KVM_CAP_PPC_SMT 64
 #define KVM_CAP_PPC_RMA	65
+#define KVM_CAP_S390_GMAP 71
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
