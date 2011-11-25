Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1KYCf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 21:35:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60123 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1KYCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 21:35:57 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com,
        Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Subject: [PATCH 1/2] kvm: make vcpu life cycle separated from kvm instance
Date: Fri, 25 Nov 2011 10:35:22 +0800
Message-Id: <1322188529-11609-2-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Currently, vcpu can be destructed only when kvm instance destroyed.
Change this to vcpu as a refer to kvm, and then vcpu MUST and CAN be
destroyed before kvm's destroy. Qemu will take advantage of this to
exit the vcpu thread if the thread is no longer in use by guest.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |   28 ++++++++--------------------
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   31 +++++++++++++++++++++++++++++--
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..ea2315a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6560,27 +6560,16 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
-static void kvm_free_vcpus(struct kvm *kvm)
+void kvm_arch_vcpu_zap(struct kref *ref)
 {
-	unsigned int i;
-	struct kvm_vcpu *vcpu;
-
-	/*
-	 * Unpin any mmu pages first.
-	 */
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_unload_vcpu_mmu(vcpu);
-	}
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_free(vcpu);
-
-	mutex_lock(&kvm->lock);
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
+	struct kvm_vcpu *vcpu = container_of(ref, struct kvm_vcpu, refcount);
+	struct kvm *kvm = vcpu->kvm;
 
-	atomic_set(&kvm->online_vcpus, 0);
-	mutex_unlock(&kvm->lock);
+	printk(KERN_INFO "%s, zap vcpu:0x%x\n", __func__, vcpu->vcpu_id);
+	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_unload_vcpu_mmu(vcpu);
+	kvm_arch_vcpu_free(vcpu);
+	kvm_put_kvm(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -6594,7 +6583,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_iommu_unmap_guest(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
-	kvm_free_vcpus(kvm);
 	if (kvm->arch.apic_access_page)
 		put_page(kvm->arch.apic_access_page);
 	if (kvm->arch.ept_identity_pagetable)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d526231..fe35078 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -113,6 +113,7 @@ enum {
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+	struct kref refcount;
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
 #endif
@@ -460,6 +461,7 @@ void kvm_arch_exit(void);
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 
+void kvm_arch_vcpu_zap(struct kref *ref);
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9cfb78..f166bc8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -580,6 +580,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_free_vm(kvm);
 	hardware_disable_all();
 	mmdrop(mm);
+	printk(KERN_INFO "%s finished\n", __func__);
 }
 
 void kvm_get_kvm(struct kvm *kvm)
@@ -1503,6 +1504,16 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 
+void kvm_vcpu_get(struct kvm_vcpu *vcpu)
+{
+	kref_get(&vcpu->refcount);
+}
+
+void kvm_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	kref_put(&vcpu->refcount, kvm_arch_vcpu_zap);
+}
+
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
@@ -1623,8 +1634,13 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
+	struct kvm *kvm = vcpu->kvm;
 
-	kvm_put_kvm(vcpu->kvm);
+	filp->private_data = NULL;
+	mutex_lock(&kvm->lock);
+	atomic_sub(1, &kvm->online_vcpus);
+	mutex_unlock(&kvm->lock);
+	kvm_vcpu_put(vcpu);
 	return 0;
 }
 
@@ -1646,6 +1662,17 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
 }
 
+static struct kvm_vcpu *kvm_vcpu_create(struct kvm *kvm, u32 id)
+{
+	struct kvm_vcpu *vcpu;
+	vcpu = kvm_arch_vcpu_create(kvm, id);
+	if (IS_ERR(vcpu))
+		return vcpu;
+
+	kref_init(&vcpu->refcount);
+	return vcpu;
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -1654,7 +1681,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
-	vcpu = kvm_arch_vcpu_create(kvm, id);
+	vcpu = kvm_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
-- 
1.7.4.4

