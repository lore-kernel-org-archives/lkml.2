Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab0EDNLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:11:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43808 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab0EDNLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=QKtUmwFVQx3gRK4+2x9fT8li0sPou5q7qob2iE+sYPXpzZw0mHs7wxC8fIpocup7Vq
         0rRyb7kEm8SmX/v8+Y6NhrHUx+sdlWskBLxla32dmjOmJEc+PO0V6XS+eBS8GI1G8K3O
         eOKrB/yuooIrVOwkRC/b3PT+4IUbqxr1w5ubY=
Date: Tue, 4 May 2010 22:11:18 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 12/12 sample] qemu-kvm: use new API for
 getting/switching dirty bitmaps
Message-Id: <20100504221118.e4942f18.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use new API for light dirty log access if KVM supports it.

This conflicts with Marcelo's patches. So please take this as a sample patch.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 kvm/include/linux/kvm.h |   11 ++++++
 qemu-kvm.c              |   81 ++++++++++++++++++++++++++++++++++++++++++-----
 qemu-kvm.h              |    1 +
 3 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/kvm/include/linux/kvm.h b/kvm/include/linux/kvm.h
index 6485981..efd9538 100644
--- a/kvm/include/linux/kvm.h
+++ b/kvm/include/linux/kvm.h
@@ -317,6 +317,14 @@ struct kvm_dirty_log {
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
@@ -499,6 +507,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_PPC_SEGSTATE 43
 
 #define KVM_CAP_PCI_SEGMENT 47
+#define KVM_CAP_USER_DIRTY_LOG 55
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -595,6 +604,8 @@ struct kvm_clock_data {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_GET_USER_DIRTY_LOG_ADDR _IOW(KVMIO,  0x49, struct kvm_user_dirty_log)
+#define KVM_SWITCH_DIRTY_LOG      _IO(KVMIO,   0x4a)
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
 #define KVM_IRQ_LINE              _IOW(KVMIO,  0x61, struct kvm_irq_level)
diff --git a/qemu-kvm.c b/qemu-kvm.c
index 91f0222..98777f0 100644
--- a/qemu-kvm.c
+++ b/qemu-kvm.c
@@ -143,6 +143,8 @@ struct slot_info {
     unsigned long userspace_addr;
     unsigned flags;
     int logging_count;
+    unsigned long *dirty_bitmap;
+    unsigned long *dirty_bitmap_old;
 };
 
 struct slot_info slots[KVM_MAX_NUM_MEM_REGIONS];
@@ -232,6 +234,29 @@ int kvm_is_containing_region(kvm_context_t kvm, unsigned long phys_addr,
     return 1;
 }
 
+static int kvm_user_dirty_log_works(void)
+{
+    return kvm_state->user_dirty_log;
+}
+
+static int kvm_set_user_dirty_log(int slot)
+{
+    int r;
+    struct kvm_user_dirty_log dlog;
+
+    dlog.slot = slot;
+    r = kvm_vm_ioctl(kvm_state, KVM_GET_USER_DIRTY_LOG_ADDR, &dlog);
+    if (r < 0) {
+        DPRINTF("KVM_GET_USER_DIRTY_LOG_ADDR failed: %s\n", strerror(-r));
+        return r;
+    }
+    slots[slot].dirty_bitmap = (unsigned long *)
+                               ((unsigned long)dlog.dirty_bitmap);
+    slots[slot].dirty_bitmap_old = (unsigned long *)
+                                   ((unsigned long)dlog.dirty_bitmap_old);
+    return r;
+}
+
 /*
  * dirty pages logging control
  */
@@ -265,8 +290,16 @@ static int kvm_dirty_pages_log_change(kvm_context_t kvm,
         DPRINTF("slot %d start %llx len %llx flags %x\n",
                 mem.slot, mem.guest_phys_addr, mem.memory_size, mem.flags);
         r = kvm_vm_ioctl(kvm_state, KVM_SET_USER_MEMORY_REGION, &mem);
-        if (r < 0)
+        if (r < 0) {
             fprintf(stderr, "%s: %m\n", __FUNCTION__);
+            return r;
+        }
+    }
+    if (flags & KVM_MEM_LOG_DIRTY_PAGES) {
+        r = kvm_set_user_dirty_log(slot);
+    } else {
+        slots[slot].dirty_bitmap = NULL;
+        slots[slot].dirty_bitmap_old = NULL;
     }
     return r;
 }
@@ -589,7 +622,6 @@ int kvm_register_phys_mem(kvm_context_t kvm,
                           unsigned long phys_start, void *userspace_addr,
                           unsigned long len, int log)
 {
-
     struct kvm_userspace_memory_region memory = {
         .memory_size = len,
         .guest_phys_addr = phys_start,
@@ -608,6 +640,9 @@ int kvm_register_phys_mem(kvm_context_t kvm,
         fprintf(stderr, "create_userspace_phys_mem: %s\n", strerror(-r));
         return -1;
     }
+    if (log) {
+        r = kvm_set_user_dirty_log(memory.slot);
+    }
     register_slot(memory.slot, memory.guest_phys_addr, memory.memory_size,
                   memory.userspace_addr, memory.flags);
     return 0;
@@ -652,6 +687,8 @@ void kvm_destroy_phys_mem(kvm_context_t kvm, unsigned long phys_start,
         fprintf(stderr, "destroy_userspace_phys_mem: %s", strerror(-r));
         return;
     }
+    slots[memory.slot].dirty_bitmap = NULL;
+    slots[memory.slot].dirty_bitmap_old = NULL;
 
     free_slot(memory.slot);
 }
@@ -692,6 +729,21 @@ int kvm_get_dirty_pages(kvm_context_t kvm, unsigned long phys_addr, void *buf)
     return kvm_get_map(kvm, KVM_GET_DIRTY_LOG, slot, buf);
 }
 
+static int kvm_switch_map(int slot)
+{
+    int r;
+
+    r = kvm_vm_ioctl(kvm_state, KVM_SWITCH_DIRTY_LOG, slot);
+    if (r == 0) {
+        unsigned long *dirty_bitmap;
+
+        dirty_bitmap = slots[slot].dirty_bitmap;
+        slots[slot].dirty_bitmap = slots[slot].dirty_bitmap_old;
+        slots[slot].dirty_bitmap_old = dirty_bitmap;
+    }
+    return r;
+}
+
 int kvm_get_dirty_pages_range(kvm_context_t kvm, unsigned long phys_addr,
                               unsigned long len, void *opaque,
                               int (*cb)(unsigned long start,
@@ -706,14 +758,25 @@ int kvm_get_dirty_pages_range(kvm_context_t kvm, unsigned long phys_addr,
     for (i = 0; i < KVM_MAX_NUM_MEM_REGIONS; ++i) {
         if ((slots[i].len && (uint64_t) slots[i].phys_addr >= phys_addr)
             && ((uint64_t) slots[i].phys_addr + slots[i].len <= end_addr)) {
-            buf = qemu_malloc(BITMAP_SIZE(slots[i].len));
-            r = kvm_get_map(kvm, KVM_GET_DIRTY_LOG, i, buf);
-            if (r) {
+            if (kvm_user_dirty_log_works()) {
+                r = kvm_switch_map(i);
+                if (r == 1) { /* slot was clean */
+                    continue;
+                } else if (r < 0) {
+                    return r;
+                }
+                r = cb(slots[i].phys_addr, slots[i].len,
+                       slots[i].dirty_bitmap_old, opaque);
+            } else {
+                buf = qemu_malloc(BITMAP_SIZE(slots[i].len));
+                r = kvm_get_map(kvm, KVM_GET_DIRTY_LOG, i, buf);
+                if (r) {
+                    qemu_free(buf);
+                    return r;
+                }
+                r = cb(slots[i].phys_addr, slots[i].len, buf, opaque);
                 qemu_free(buf);
-                return r;
             }
-            r = cb(slots[i].phys_addr, slots[i].len, buf, opaque);
-            qemu_free(buf);
             if (r)
                 return r;
         }
@@ -2097,6 +2160,8 @@ static int kvm_create_context(void)
 #ifdef TARGET_I386
     destroy_region_works = kvm_destroy_memory_region_works(kvm_context);
 #endif
+    kvm_state->user_dirty_log
+        = kvm_check_extension(kvm_state, KVM_CAP_USER_DIRTY_LOG);
 
     r = kvm_arch_init_irq_routing();
     if (r < 0) {
diff --git a/qemu-kvm.h b/qemu-kvm.h
index ba3808a..aea89df 100644
--- a/qemu-kvm.h
+++ b/qemu-kvm.h
@@ -973,6 +973,7 @@ struct KVMState {
 #endif
     int irqchip_in_kernel;
     int pit_in_kernel;
+    int user_dirty_log;
 
     struct kvm_context kvm_context;
 };
-- 
1.7.0.4

