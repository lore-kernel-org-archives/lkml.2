Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0DSJlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:41:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0DSJlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:41:49 -0400
Message-ID: <4BCC2543.7050104@cn.fujitsu.com>
Date: Mon, 19 Apr 2010 17:41:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: [PATCH] kvm: use the correct RCU API
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU/SRCU API have already changed for proving RCU usage.

I got the following dmesg when PROVE_RCU=y because we used incorrect API.
This patch coverts rcu_deference() to srcu_dereference() or family API.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
arch/x86/kvm/mmu.c:3020 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by qemu-system-x86/8550:
 #0:  (&kvm->slots_lock){+.+.+.}, at: [<ffffffffa011a6ac>] kvm_set_memory_region+0x29/0x50 [kvm]
 #1:  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<ffffffffa012262d>] kvm_arch_commit_memory_region+0xa6/0xe2 [kvm]

stack backtrace:
Pid: 8550, comm: qemu-system-x86 Not tainted 2.6.34-rc4-tip-01028-g939eab1 #27
Call Trace:
 [<ffffffff8106c59e>] lockdep_rcu_dereference+0xaa/0xb3
 [<ffffffffa012f6c1>] kvm_mmu_calculate_mmu_pages+0x44/0x7d [kvm]
 [<ffffffffa012263e>] kvm_arch_commit_memory_region+0xb7/0xe2 [kvm]
 [<ffffffffa011a5d7>] __kvm_set_memory_region+0x636/0x6e2 [kvm]
 [<ffffffffa011a6ba>] kvm_set_memory_region+0x37/0x50 [kvm]
 [<ffffffffa015e956>] vmx_set_tss_addr+0x46/0x5a [kvm_intel]
 [<ffffffffa0126592>] kvm_arch_vm_ioctl+0x17a/0xcf8 [kvm]
 [<ffffffff810a8692>] ? unlock_page+0x27/0x2c
 [<ffffffff810bf879>] ? __do_fault+0x3a9/0x3e1
 [<ffffffffa011b12f>] kvm_vm_ioctl+0x364/0x38d [kvm]
 [<ffffffff81060cfa>] ? up_read+0x23/0x3d
 [<ffffffff810f3587>] vfs_ioctl+0x32/0xa6
 [<ffffffff810f3b19>] do_vfs_ioctl+0x495/0x4db
 [<ffffffff810e6b2f>] ? fget_light+0xc2/0x241
 [<ffffffff810e416c>] ? do_sys_open+0x104/0x116
 [<ffffffff81382d6d>] ? retint_swapgs+0xe/0x13
 [<ffffffff810f3ba6>] sys_ioctl+0x47/0x6a
 [<ffffffff810021db>] system_call_fastpath+0x16/0x1b

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 73c5c2b..52b8ece 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1379,7 +1379,7 @@ static void kvm_release_vm_pages(struct kvm *kvm)
 	int i, j;
 	unsigned long base_gfn;
 
-	slots = rcu_dereference(kvm->memslots);
+	slots = kvm_memslots(kvm);
 	for (i = 0; i < slots->nmemslots; i++) {
 		memslot = &slots->memslots[i];
 		base_gfn = memslot->base_gfn;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 60f09ab..cfa9d17 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -72,7 +72,7 @@ static inline void kvm_s390_vcpu_set_mem(struct kvm_vcpu *vcpu)
 	struct kvm_memslots *memslots;
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	memslots = rcu_dereference(vcpu->kvm->memslots);
+	memslots = kvm_memslots(vcpu->kvm);
 
 	mem = &memslots->memslots[0];
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 71faa04..bb61881 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -792,7 +792,7 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	int retval = 0;
 	struct kvm_memslots *slots;
 
-	slots = rcu_dereference(kvm->memslots);
+	slots = kvm_memslots(kvm);
 
 	for (i = 0; i < slots->nmemslots; i++) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
@@ -3017,7 +3017,8 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 	unsigned int  nr_pages = 0;
 	struct kvm_memslots *slots;
 
-	slots = rcu_dereference(kvm->memslots);
+	slots = kvm_memslots(kvm);
+
 	for (i = 0; i < slots->nmemslots; i++)
 		nr_pages += slots->memslots[i].npages;
 
@@ -3292,7 +3293,7 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 	int i, j, k, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	slots = rcu_dereference(kvm->memslots);
+	slots = kvm_memslots(kvm);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
 		struct kvm_memory_slot *m = &slots->memslots[i];
 		struct kvm_rmap_desc *d;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 077cac5..725e7b6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1514,7 +1514,7 @@ static gva_t rmode_tss_base(struct kvm *kvm)
 		struct kvm_memslots *slots;
 		gfn_t base_gfn;
 
-		slots = rcu_dereference(kvm->memslots);
+		slots = kvm_memslots(kvm);
 		base_gfn = kvm->memslots->memslots[0].base_gfn +
 				 kvm->memslots->memslots[0].npages - 3;
 		return base_gfn << PAGE_SHIFT;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6120e33..4dcd62c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2408,7 +2408,7 @@ gfn_t unalias_gfn_instantiation(struct kvm *kvm, gfn_t gfn)
 	struct kvm_mem_alias *alias;
 	struct kvm_mem_aliases *aliases;
 
-	aliases = rcu_dereference(kvm->arch.aliases);
+	aliases = kvm_aliases(kvm);
 
 	for (i = 0; i < aliases->naliases; ++i) {
 		alias = &aliases->aliases[i];
@@ -2427,7 +2427,7 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 	struct kvm_mem_alias *alias;
 	struct kvm_mem_aliases *aliases;
 
-	aliases = rcu_dereference(kvm->arch.aliases);
+	aliases = kvm_aliases(kvm);
 
 	for (i = 0; i < aliases->naliases; ++i) {
 		alias = &aliases->aliases[i];
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2d10163..e218fed 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -65,4 +65,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 }
 
+static inline struct kvm_mem_aliases *kvm_aliases(struct kvm *kvm)
+{
+	return rcu_dereference_check(kvm->arch.aliases,
+			srcu_read_lock_held(&kvm->srcu)
+			|| lockdep_is_held(&kvm->slots_lock));
+}
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a3fd0f9..f735752 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -239,6 +239,13 @@ void kvm_exit(void);
 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 
+static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
+{
+	return rcu_dereference_check(kvm->memslots,
+			srcu_read_lock_held(&kvm->srcu)
+			|| lockdep_is_held(&kvm->slots_lock));
+}
+
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 80fd3ad..37ca71e 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -78,7 +78,7 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
 	int i, r = 0;
 	struct kvm_memslots *slots;
 
-	slots = rcu_dereference(kvm->memslots);
+	slots = kvm_memslots(kvm);
 
 	for (i = 0; i < slots->nmemslots; i++) {
 		r = kvm_iommu_map_pages(kvm, &slots->memslots[i]);
@@ -217,7 +217,7 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 	int i;
 	struct kvm_memslots *slots;
 
-	slots = rcu_dereference(kvm->memslots);
+	slots = kvm_memslots(kvm);
 
 	for (i = 0; i < slots->nmemslots; i++) {
 		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b03f863..58b2147 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -829,7 +829,7 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 struct kvm_memory_slot *gfn_to_memslot_unaliased(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
+	struct kvm_memslots *slots = kvm_memslots(kvm);
 
 	for (i = 0; i < slots->nmemslots; ++i) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
@@ -851,7 +851,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
+	struct kvm_memslots *slots = kvm_memslots(kvm);
 
 	gfn = unalias_gfn_instantiation(kvm, gfn);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
@@ -895,7 +895,7 @@ out:
 int memslot_id(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
+	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *memslot = NULL;
 
 	gfn = unalias_gfn(kvm, gfn);
@@ -1979,7 +1979,9 @@ int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val)
 {
 	int i;
-	struct kvm_io_bus *bus = rcu_dereference(kvm->buses[bus_idx]);
+	struct kvm_io_bus *bus;
+
+	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
 	for (i = 0; i < bus->dev_count; i++)
 		if (!kvm_iodevice_write(bus->devs[i], addr, len, val))
 			return 0;
@@ -1991,8 +1993,9 @@ int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		    int len, void *val)
 {
 	int i;
-	struct kvm_io_bus *bus = rcu_dereference(kvm->buses[bus_idx]);
+	struct kvm_io_bus *bus;
 
+	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
 	for (i = 0; i < bus->dev_count; i++)
 		if (!kvm_iodevice_read(bus->devs[i], addr, len, val))
 			return 0;

