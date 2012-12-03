Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2LCXje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:39:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2LCXjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:39:31 -0500
Subject: [RFC PATCH 4/6] kvm: Move private memory slots to start of memslots
 array
To: mtosatti@redhat.com, kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 16:39:30 -0700
Message-ID: <20121203233930.3661.7744.stgit@bling.home>
In-Reply-To: <20121203231912.3661.57179.stgit@bling.home>
References: <20121203231912.3661.57179.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make the memslots array grow on demand, move the private
slots to the lower indexes of the array.  The private slots are
assumed likely to be in use, so if we didn't do this we'd end up
allocating the full memslots array all the time.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c     |    4 ++--
 arch/powerpc/kvm/book3s_hv.c |    2 +-
 arch/x86/include/asm/vmx.h   |    6 +++---
 arch/x86/kvm/vmx.c           |    2 +-
 arch/x86/kvm/x86.c           |    2 +-
 virt/kvm/kvm_main.c          |   15 ++++++++++-----
 6 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index f1a46bd..012e5dd 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -949,7 +949,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
 			goto out;
-		kvm_userspace_mem.slot = kvm_mem.slot;
+		kvm_userspace_mem.slot = kvm_mem.slot + KVM_PRIVATE_MEM_SLOTS;
 		kvm_userspace_mem.flags = kvm_mem.flags;
 		kvm_userspace_mem.guest_phys_addr =
 					kvm_mem.guest_phys_addr;
@@ -1831,7 +1831,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_USER_MEM_SLOTS)
+	if (log->slot >= KVM_MEM_SLOTS_NUM)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 75ce80e..56067db 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1262,7 +1262,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_USER_MEM_SLOTS)
+	if (log->slot >= KVM_MEM_SLOTS_NUM)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 72932d2..97bcd7d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -427,9 +427,9 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define TSS_PRIVATE_MEMSLOT			(KVM_USER_MEM_SLOTS + 0)
-#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 1)
-#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_USER_MEM_SLOTS + 2)
+#define TSS_PRIVATE_MEMSLOT			0
+#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	1
+#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	2
 
 #define VMX_NR_VPIDS				(1 << 16)
 #define VMX_VPID_EXTENT_SINGLE_CONTEXT		1
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f858159..2bb9157 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2750,7 +2750,7 @@ static gva_t rmode_tss_base(struct kvm *kvm)
 		gfn_t base_gfn;
 
 		slots = kvm_memslots(kvm);
-		slot = id_to_memslot(slots, 0);
+		slot = id_to_memslot(slots, KVM_PRIVATE_MEM_SLOTS);
 		base_gfn = slot->base_gfn + slot->npages - 3;
 
 		return base_gfn << PAGE_SHIFT;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1aa3fae..8765485 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6449,7 +6449,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	int map_flags = MAP_PRIVATE | MAP_ANONYMOUS;
 
 	/* Prevent internal slot pages from being moved by fork()/COW. */
-	if (memslot->id >= KVM_USER_MEM_SLOTS)
+	if (memslot->id < KVM_PRIVATE_MEM_SLOTS)
 		map_flags = MAP_SHARED | MAP_ANONYMOUS;
 
 	/*To keep backward compatibility with older userspace,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f8ae4b..3ce2664 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -761,7 +761,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Check for overlaps */
 	r = -EEXIST;
 	kvm_for_each_memslot(slot, kvm->memslots) {
-		if (slot->id >= KVM_USER_MEM_SLOTS || slot == memslot)
+		if (slot->id < KVM_PRIVATE_MEM_SLOTS || slot == memslot)
 			continue;
 		if (!((base_gfn + npages <= slot->base_gfn) ||
 		      (base_gfn >= slot->base_gfn + slot->npages)))
@@ -879,7 +879,7 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   kvm_userspace_memory_region *mem,
 				   int user_alloc)
 {
-	if (mem->slot >= KVM_USER_MEM_SLOTS)
+	if (mem->slot >= KVM_MEM_SLOTS_NUM)
 		return -EINVAL;
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
@@ -893,7 +893,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long any = 0;
 
 	r = -EINVAL;
-	if (log->slot >= KVM_USER_MEM_SLOTS)
+	if (log->slot >= KVM_MEM_SLOTS_NUM)
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
@@ -939,7 +939,7 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *memslot = gfn_to_memslot(kvm, gfn);
 
-	if (!memslot || memslot->id >= KVM_USER_MEM_SLOTS ||
+	if (!memslot || memslot->id < KVM_PRIVATE_MEM_SLOTS ||
 	      memslot->flags & KVM_MEMSLOT_INVALID)
 		return 0;
 
@@ -2137,6 +2137,8 @@ static long kvm_vm_ioctl(struct file *filp,
 						sizeof kvm_userspace_mem))
 			goto out;
 
+		kvm_userspace_mem.slot += KVM_PRIVATE_MEM_SLOTS;
+
 		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 1);
 		if (r)
 			goto out;
@@ -2148,6 +2150,9 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&log, argp, sizeof log))
 			goto out;
+
+		log.slot += KVM_PRIVATE_MEM_SLOTS;
+
 		r = kvm_vm_ioctl_get_dirty_log(kvm, &log);
 		if (r)
 			goto out;
@@ -2276,7 +2281,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 		if (copy_from_user(&compat_log, (void __user *)arg,
 				   sizeof(compat_log)))
 			goto out;
-		log.slot	 = compat_log.slot;
+		log.slot	 = compat_log.slot + KVM_PRIVATE_MEM_SLOTS;
 		log.padding1	 = compat_log.padding1;
 		log.padding2	 = compat_log.padding2;
 		log.dirty_bitmap = compat_ptr(compat_log.dirty_bitmap);

