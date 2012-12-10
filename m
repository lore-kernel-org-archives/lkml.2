Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2LJRd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:33:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2LJRdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:33:22 -0500
Subject: [PATCH v2 07/10] kvm: struct kvm_memory_slot.user_alloc -> bool
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:33:21 -0700
Message-ID: <20121210173320.10461.49937.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for this to be an int, it holds a boolean.
Move to the end of the struct for alignment.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c   |    6 +++---
 arch/powerpc/kvm/powerpc.c |    4 ++--
 arch/s390/kvm/kvm-s390.c   |    4 ++--
 arch/x86/kvm/vmx.c         |    6 +++---
 arch/x86/kvm/x86.c         |    4 ++--
 include/linux/kvm_host.h   |   12 ++++++------
 virt/kvm/kvm_main.c        |    9 +++++----
 7 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index f1a46bd..a8b4022 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -955,7 +955,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 					kvm_mem.guest_phys_addr;
 		kvm_userspace_mem.memory_size = kvm_mem.memory_size;
 		r = kvm_vm_ioctl_set_memory_region(kvm,
-					&kvm_userspace_mem, 0);
+					&kvm_userspace_mem, false);
 		if (r)
 			goto out;
 		break;
@@ -1577,7 +1577,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		struct kvm_memory_slot *memslot,
 		struct kvm_memory_slot old,
 		struct kvm_userspace_memory_region *mem,
-		int user_alloc)
+		bool user_alloc)
 {
 	unsigned long i;
 	unsigned long pfn;
@@ -1608,7 +1608,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 		struct kvm_userspace_memory_region *mem,
 		struct kvm_memory_slot old,
-		int user_alloc)
+		bool user_alloc)
 {
 	return;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 4d213b8..da606a9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -321,7 +321,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
                                    struct kvm_memory_slot *memslot,
                                    struct kvm_memory_slot old,
                                    struct kvm_userspace_memory_region *mem,
-                                   int user_alloc)
+                                   bool user_alloc)
 {
 	return kvmppc_core_prepare_memory_region(kvm, mem);
 }
@@ -329,7 +329,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 void kvm_arch_commit_memory_region(struct kvm *kvm,
                struct kvm_userspace_memory_region *mem,
                struct kvm_memory_slot old,
-               int user_alloc)
+               bool user_alloc)
 {
 	kvmppc_core_commit_memory_region(kvm, mem);
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ecced9d..37646cb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -927,7 +927,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
 				   struct kvm_memory_slot old,
 				   struct kvm_userspace_memory_region *mem,
-				   int user_alloc)
+				   bool user_alloc)
 {
 	/* A few sanity checks. We can have exactly one memory slot which has
 	   to start at guest virtual zero and which has to be located at a
@@ -957,7 +957,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
-				int user_alloc)
+				bool user_alloc)
 {
 	int rc;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f858159..108becc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3597,7 +3597,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	kvm_userspace_mem.flags = 0;
 	kvm_userspace_mem.guest_phys_addr = 0xfee00000ULL;
 	kvm_userspace_mem.memory_size = PAGE_SIZE;
-	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem, 0);
+	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem, false);
 	if (r)
 		goto out;
 
@@ -3627,7 +3627,7 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	kvm_userspace_mem.guest_phys_addr =
 		kvm->arch.ept_identity_map_addr;
 	kvm_userspace_mem.memory_size = PAGE_SIZE;
-	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem, 0);
+	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem, false);
 	if (r)
 		goto out;
 
@@ -4191,7 +4191,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 		.flags = 0,
 	};
 
-	ret = kvm_set_memory_region(kvm, &tss_mem, 0);
+	ret = kvm_set_memory_region(kvm, &tss_mem, false);
 	if (ret)
 		return ret;
 	kvm->arch.tss_addr = addr;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1aa3fae..85dc733 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6443,7 +6443,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
 				struct kvm_memory_slot old,
 				struct kvm_userspace_memory_region *mem,
-				int user_alloc)
+				bool user_alloc)
 {
 	int npages = memslot->npages;
 	int map_flags = MAP_PRIVATE | MAP_ANONYMOUS;
@@ -6479,7 +6479,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
-				int user_alloc)
+				bool user_alloc)
 {
 
 	int nr_mmu_pages = 0, npages = mem->memory_size >> PAGE_SHIFT;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bf8380f..9ff30f2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -255,8 +255,8 @@ struct kvm_memory_slot {
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
-	int user_alloc;
 	int id;
+	bool user_alloc;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
@@ -436,10 +436,10 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
-			  int user_alloc);
+			  bool user_alloc);
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
-			    int user_alloc);
+			    bool user_alloc);
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages);
@@ -447,11 +447,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
 				struct kvm_memory_slot old,
 				struct kvm_userspace_memory_region *mem,
-				int user_alloc);
+				bool user_alloc);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
-				int user_alloc);
+				bool user_alloc);
 bool kvm_largepages_enabled(void);
 void kvm_disable_largepages(void);
 /* flush all memory translations */
@@ -537,7 +537,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   struct
 				   kvm_userspace_memory_region *mem,
-				   int user_alloc);
+				   bool user_alloc);
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e429cd6..8c70391 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -704,7 +704,7 @@ static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
  */
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
-			    int user_alloc)
+			    bool user_alloc)
 {
 	int r;
 	gfn_t base_gfn;
@@ -884,7 +884,7 @@ EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
-			  int user_alloc)
+			  bool user_alloc)
 {
 	int r;
 
@@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(kvm_set_memory_region);
 int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   struct
 				   kvm_userspace_memory_region *mem,
-				   int user_alloc)
+				   bool user_alloc)
 {
 	if (mem->slot >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
@@ -2158,7 +2158,8 @@ static long kvm_vm_ioctl(struct file *filp,
 						sizeof kvm_userspace_mem))
 			goto out;
 
-		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 1);
+		r = kvm_vm_ioctl_set_memory_region(kvm,
+						   &kvm_userspace_mem, true);
 		if (r)
 			goto out;
 		break;

