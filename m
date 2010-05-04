Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab0EDNI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:08:28 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:52825 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0EDNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=AsP7flWJa3Sk/7Yxp8pfAyee7t4xNCpgQZyclUNc3rlxqhMry2Kh7kXXs3Yhso5fx3
         hTs/fewMvoVfvvAw/xxF8x66ynlyTeBcyyYvsJI1UgkCuAXIaJVV2UPJGIf9GD1h4Qs6
         PcW7UzJ3E/eeRH1/KPT0O7kn/NkbSNI7pNf8o=
Date: Tue, 4 May 2010 22:08:21 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 11/12] KVM: introduce new API for getting/switching
 dirty bitmaps
Message-Id: <20100504220821.d68bde57.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that dirty bitmaps are accessible from user space, we export the
addresses of these to achieve zero-copy dirty log check:

  KVM_GET_USER_DIRTY_LOG_ADDR

We also need an API for triggering dirty bitmap switch to take the full
advantage of double buffered bitmaps.

  KVM_SWITCH_DIRTY_LOG

See the documentation in this patch for precise explanations.

About performance improvement: the most important feature of switch API
is the lightness. In our test, this appeared in the form of improved
responses for GUI manipulations.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>
---
 Documentation/kvm/api.txt |   87 +++++++++++++++++++++++++++++++++++++++++++++
 arch/ia64/kvm/kvm-ia64.c  |   27 +++++++++-----
 arch/powerpc/kvm/book3s.c |   18 +++++++--
 arch/x86/kvm/x86.c        |   44 ++++++++++++++++-------
 include/linux/kvm.h       |   11 ++++++
 include/linux/kvm_host.h  |    4 ++-
 virt/kvm/kvm_main.c       |   63 +++++++++++++++++++++++++++++----
 7 files changed, 220 insertions(+), 34 deletions(-)

diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index a237518..c106c83 100644
--- a/Documentation/kvm/api.txt
+++ b/Documentation/kvm/api.txt
@@ -892,6 +892,93 @@ arguments.
 This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
 irqchip, the multiprocessing state must be maintained by userspace.
 
+4.39 KVM_GET_USER_DIRTY_LOG_ADDR
+
+Capability: KVM_CAP_USER_DIRTY_LOG (>=1 see below)
+Architectures: all
+Type: vm ioctl
+Parameters: struct kvm_user_dirty_log (in/out)
+Returns: 0 on success, -1 on error
+
+This ioctl makes it possible to use KVM_SWITCH_DIRTY_LOG (see 4.40) instead
+of the old dirty log manipulation by KVM_GET_DIRTY_LOG.
+
+A bit about KVM_CAP_USER_DIRTY_LOG
+
+Before this ioctl was introduced, dirty bitmaps for dirty page logging were
+allocated in the kernel's memory space.  But we have now moved them to user
+space to get more flexiblity and performance.  To achive this move without
+breaking the compatibility, we will split KVM_CAP_USER_DIRTY_LOG capability
+into a few generations which can be identified by its check extension
+return values.
+
+This KVM_GET_USER_DIRTY_LOG_ADDR belongs to the first generation with the
+KVM_SWITCH_DIRTY_LOG (4.40) and must be supported by all generations.
+
+What you get
+
+By using this, you can get paired bitmap addresses which are accessible from
+user space.  See the explanation in 4.40 for the roles of these two bitmaps.
+
+How to Get
+
+Before calling this, you have to set the slot member of kvm_user_dirty_log
+to indicate the target memory slot.
+
+struct kvm_user_dirty_log {
+	__u32 slot;
+	__u32 flags;
+	__u64 dirty_bitmap;
+	__u64 dirty_bitmap_old;
+};
+
+The addresses will be set in the paired members: dirty_bitmap and _old.
+
+Note
+
+In generation 1, we support bitmaps which are created in kernel but do not
+support bitmaps created by users.  This means bitmap creation/destruction
+are done same as before when you instruct KVM by KVM_SET_USER_MEMORY_REGION
+(see 4.34) to start/stop logging.  Please do not try to free the exported
+bitmaps by yourself, or KVM will access the freed area and end with fault.
+
+4.40 KVM_SWITCH_DIRTY_LOG
+
+Capability: KVM_CAP_USER_DIRTY_LOG (>=1 see 4.39)
+Architectures: all
+Type: vm ioctl
+Parameters: memory slot id
+Returns: 0 if switched, 1 if not (slot was clean), -1 on error
+
+This ioctl allows you to switch the dirty log to the next one: a newer
+ioctl for getting dirty page logs than KVM_GET_DIRTY_LOG (see 4.7 for the
+explanation about dirty page logging, log format is not changed).
+
+If you have the capability KVM_CAP_USER_DIRTY_LOG, using this is strongly
+recommended than using KVM_GET_DIRTY_LOG because this does not need buffer
+copy between kernel and user space.
+
+How to Use
+
+Before calling this, you have to remember the paired addresses of dirty
+bitmaps which can be obtained by KVM_GET_USER_DIRTY_LOG_ADDR (see 4.39):
+dirty_bitmap (being used now by kernel) and dirty_bitmap_old (not being
+used now and containing the last log).
+
+After calling this, the role of these bitmaps will change like this;
+If the return value was 0, kernel cleared dirty_bitmap_old and began to use
+it for the next logging, so that you can use the cold dirty_bitmap to check
+the log since the last switch.  If the return value was 1, all pages were not
+dirty and bitmap switch was not done.  Note that remembering which bitmap is
+now active is your responsibility.  So you have to update your remembering
+when you get the return value 0.
+
+Note
+
+Bitmap switch may also occur when you call KVM_GET_DIRTY_LOG.  Please use
+either one, preferably this one, only to avoid extra confusion.  We do not
+guarantee on which condition KVM_GET_DIRTY_LOG causes bitmap switch.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 03503e6..b590b80 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1801,8 +1801,7 @@ void kvm_arch_exit(void)
 	kvm_vmm_info = NULL;
 }
 
-static int kvm_ia64_sync_dirty_log(struct kvm *kvm,
-		struct kvm_dirty_log *log)
+static int kvm_ia64_sync_dirty_log(struct kvm *kvm, int slot)
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
@@ -1812,10 +1811,10 @@ static int kvm_ia64_sync_dirty_log(struct kvm *kvm,
 			offsetof(struct kvm_vm_data, kvm_mem_dirty_log));
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (slot >= KVM_MEMORY_SLOTS)
 		goto out;
 
-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[slot];
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
@@ -1843,8 +1842,8 @@ out:
 	return r;
 }
 
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
-		struct kvm_dirty_log *log)
+static int kvm_ia64_update_dirty_log(struct kvm *kvm, int slot,
+				     unsigned long __user *log_bitmap)
 {
 	int r;
 	unsigned long n;
@@ -1853,15 +1852,15 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 	spin_lock(&kvm->arch.dirty_log_lock);
 
-	r = kvm_ia64_sync_dirty_log(kvm, log);
+	r = kvm_ia64_sync_dirty_log(kvm, slot);
 	if (r)
 		goto out;
 
-	r = kvm_get_dirty_log(kvm, log);
+	r = kvm_update_dirty_log(kvm, slot, log_bitmap);
 	if (r)
 		goto out;
 
-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[slot];
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (memslot->is_dirty) {
 		kvm_flush_remote_tlbs(kvm);
@@ -1879,6 +1878,16 @@ out:
 	return r;
 }
 
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	return kvm_ia64_update_dirty_log(kvm, log->slot, log->dirty_bitmap);
+}
+
+int kvm_vm_ioctl_switch_dirty_log(struct kvm *kvm, int slot)
+{
+	return kvm_ia64_update_dirty_log(kvm, slot, NULL);
+}
+
 int kvm_arch_hardware_setup(void)
 {
 	return 0;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 2a31d2f..54b3a76 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1185,8 +1185,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
-				      struct kvm_dirty_log *log)
+static int kvmppc_update_dirty_log(struct kvm *kvm, int slot,
+				   unsigned long __user *log_bitmap)
 {
 	struct kvm_memory_slot *memslot;
 	struct kvm_vcpu *vcpu;
@@ -1196,11 +1196,11 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	mutex_lock(&kvm->slots_lock);
 
-	r = kvm_get_dirty_log(kvm, log);
+	r = kvm_update_dirty_log(kvm, slot, log_bitmap);
 	if (r)
 		goto out;
 
-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[slot];
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (memslot->is_dirty) {
 		ga = memslot->base_gfn << PAGE_SHIFT;
@@ -1223,6 +1223,16 @@ out:
 	return r;
 }
 
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	return kvmppc_update_dirty_log(kvm, log->slot, log->dirty_bitmap);
+}
+
+int kvm_vm_ioctl_switch_dirty_log(struct kvm *kvm, int slot)
+{
+	return kvmppc_update_dirty_log(kvm, slot, NULL);
+}
+
 int kvmppc_core_check_processor_compat(void)
 {
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32a3d94..7a31ab1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2737,8 +2737,8 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
-				      struct kvm_dirty_log *log)
+static int kvm_x86_update_dirty_log(struct kvm *kvm, int slot,
+				    unsigned long __user *log_bitmap)
 {
 	int r;
 	struct kvm_memory_slot *memslot;
@@ -2747,10 +2747,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (slot >= KVM_MEMORY_SLOTS)
 		goto out;
 
-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[slot];
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
@@ -2764,7 +2764,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		unsigned long __user *dirty_bitmap_old;
 
 		spin_lock(&kvm->mmu_lock);
-		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		kvm_mmu_slot_remove_write_access(kvm, slot);
 		spin_unlock(&kvm->mmu_lock);
 
 		dirty_bitmap = memslot->dirty_bitmap;
@@ -2779,22 +2779,30 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 			goto out;
 
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap_old;
-		slots->memslots[log->slot].dirty_bitmap_old = dirty_bitmap;
-		slots->memslots[log->slot].is_dirty = false;
+		slots->memslots[slot].dirty_bitmap = dirty_bitmap_old;
+		slots->memslots[slot].dirty_bitmap_old = dirty_bitmap;
+		slots->memslots[slot].is_dirty = false;
 
 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
 		kfree(old_slots);
 
-		r = -EFAULT;
-		if (copy_in_user(log->dirty_bitmap, dirty_bitmap, n))
-			goto out;
+		if (log_bitmap) {
+			r = -EFAULT;
+			if (copy_in_user(log_bitmap, dirty_bitmap, n))
+				goto out;
+		}
 	} else {
-		r = -EFAULT;
-		if (clear_user(log->dirty_bitmap, n))
+		if (log_bitmap) {
+			r = -EFAULT;
+			if (clear_user(log_bitmap, n))
+				goto out;
+		} else {
+			/* Tell the user about no switch. */
+			r = 1;
 			goto out;
+		}
 	}
 
 	r = 0;
@@ -2803,6 +2811,16 @@ out:
 	return r;
 }
 
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	return kvm_x86_update_dirty_log(kvm, log->slot, log->dirty_bitmap);
+}
+
+int kvm_vm_ioctl_switch_dirty_log(struct kvm *kvm, int slot)
+{
+	return kvm_x86_update_dirty_log(kvm, slot, NULL);
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 23ea022..47980c2 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -322,6 +322,14 @@ struct kvm_dirty_log {
 	};
 };
 
+/* for KVM_GET_USER_DIRTY_LOG_ADDR */
+struct kvm_user_dirty_log {
+	__u32 slot;
+	__u32 flags;
+	__u64 dirty_bitmap;
+	__u64 dirty_bitmap_old;
+};
+
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
@@ -524,6 +532,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PPC_OSI 52
 #define KVM_CAP_PPC_UNSET_IRQ 53
 #define KVM_CAP_ENABLE_CAP 54
+#define KVM_CAP_USER_DIRTY_LOG 55
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -620,6 +629,8 @@ struct kvm_clock_data {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_GET_USER_DIRTY_LOG_ADDR _IOW(KVMIO,  0x49, struct kvm_user_dirty_log)
+#define KVM_SWITCH_DIRTY_LOG      _IO(KVMIO,   0x4a)
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
 #define KVM_IRQ_LINE              _IOW(KVMIO,  0x61, struct kvm_irq_level)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c95e2b7..a94277a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -337,9 +337,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 int kvm_dev_ioctl_check_extension(long ext);
 
-int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
+int kvm_update_dirty_log(struct kvm *kvm, int slot,
+			 unsigned long __user *log_bitmap);
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 				struct kvm_dirty_log *log);
+int kvm_vm_ioctl_switch_dirty_log(struct kvm *kvm, int slot);
 
 int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   struct
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ddcf65a..300a0c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -818,26 +818,55 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
-int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+static int kvm_vm_ioctl_get_user_dirty_log_addr(struct kvm *kvm,
+						struct kvm_user_dirty_log *log)
+{
+	struct kvm_memory_slot *memslot;
+
+	if (log->slot >= KVM_MEMORY_SLOTS)
+		return -EINVAL;
+
+	memslot = &kvm->memslots->memslots[log->slot];
+	if (!memslot->dirty_bitmap)
+		return -ENOENT;
+
+	log->dirty_bitmap = (unsigned long)memslot->dirty_bitmap;
+	log->dirty_bitmap_old = (unsigned long)memslot->dirty_bitmap_old;
+	return 0;
+}
+
+int kvm_update_dirty_log(struct kvm *kvm, int slot,
+			 unsigned long __user *log_bitmap)
 {
 	struct kvm_memory_slot *memslot;
 	int r;
-	unsigned long n;
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (slot >= KVM_MEMORY_SLOTS)
 		goto out;
 
-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[slot];
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
 
-	n = kvm_dirty_bitmap_bytes(memslot);
+	if (log_bitmap) {
+		unsigned long n = kvm_dirty_bitmap_bytes(memslot);
 
-	r = -EFAULT;
-	if (copy_in_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
+		r = -EFAULT;
+		if (copy_in_user(log_bitmap, memslot->dirty_bitmap, n))
+			goto out;
+	} else if (memslot->is_dirty) {
+		unsigned long __user *dirty_bitmap;
+
+		dirty_bitmap = memslot->dirty_bitmap;
+		memslot->dirty_bitmap = memslot->dirty_bitmap_old;
+		memslot->dirty_bitmap_old = dirty_bitmap;
+	} else {
+		/* Tell the user about no switch. */
+		r = 1;
 		goto out;
+	}
 
 	r = 0;
 out:
@@ -1647,6 +1676,25 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_GET_USER_DIRTY_LOG_ADDR: {
+		struct kvm_user_dirty_log log;
+
+		r = -EFAULT;
+		if (copy_from_user(&log, argp, sizeof log))
+			goto out;
+		r = kvm_vm_ioctl_get_user_dirty_log_addr(kvm, &log);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &log, sizeof log))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SWITCH_DIRTY_LOG: {
+		r = kvm_vm_ioctl_switch_dirty_log(kvm, arg);
+		break;
+	}
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	case KVM_REGISTER_COALESCED_MMIO: {
 		struct kvm_coalesced_mmio_zone zone;
@@ -1823,6 +1871,7 @@ static long kvm_dev_ioctl_check_extension_generic(long arg)
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_JOIN_MEMORY_REGIONS_WORKS:
+	case KVM_CAP_USER_DIRTY_LOG:
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	case KVM_CAP_SET_BOOT_CPU_ID:
 #endif
-- 
1.7.0.4

