Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2EWGdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:33:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38191 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964937Ab2EWGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:33:10 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Subject: [PATCH] Qemu: add virt sched domain device
Date: Wed, 23 May 2012 14:32:31 +0800
Message-Id: <1337754751-9018-5-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

The device will demand the collection of vcpus' numa info, and
trigger the guest to rebuild the sched domain.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 Makefile.target           |    1 +
 hmp-commands.hx           |   16 +++++
 hw/qdev.h                 |    1 +
 hw/virt_sd.c              |  155 +++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h |    8 ++-
 5 files changed, 180 insertions(+), 1 deletions(-)
 create mode 100644 hw/virt_sd.c

diff --git a/Makefile.target b/Makefile.target
index 4fbbabf..fded330 100644
--- a/Makefile.target
+++ b/Makefile.target
@@ -265,6 +265,7 @@ obj-i386-y += pci-hotplug.o smbios.o wdt_ib700.o
 obj-i386-y += debugcon.o multiboot.o
 obj-i386-y += pc_piix.o
 obj-i386-y += pc_sysfw.o
+obj-i386-y += virt_sd.o
 obj-i386-$(CONFIG_KVM) += kvm/clock.o kvm/apic.o kvm/i8259.o kvm/ioapic.o kvm/i8254.o
 obj-i386-$(CONFIG_SPICE) += qxl.o qxl-logger.o qxl-render.o
 
diff --git a/hmp-commands.hx b/hmp-commands.hx
index 461fa59..47b826c 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1254,6 +1254,22 @@ Change I/O throttle limits for a block drive to @var{bps} @var{bps_rd} @var{bps_
 ETEXI
 
     {
+        .name       = "guest_numa_notify",
+        .args_type  = "",
+        .params     = "",
+        .help       = "force guest to update numa info based on host",
+        .user_print = monitor_user_noop,
+        .mhandler.cmd_new = do_guest_numa_notify,
+    },
+
+STEXI
+@item device_add @var{config}
+@findex device_add
+
+Add device.
+ETEXI
+
+    {
         .name       = "block_set_io_throttle",
         .args_type  = "device:B,bps:l,bps_rd:l,bps_wr:l,iops:l,iops_rd:l,iops_wr:l",
         .params     = "device bps bps_rd bps_wr iops iops_rd iops_wr",
diff --git a/hw/qdev.h b/hw/qdev.h
index 4e90119..6902474 100644
--- a/hw/qdev.h
+++ b/hw/qdev.h
@@ -203,6 +203,7 @@ void do_info_qtree(Monitor *mon);
 void do_info_qdm(Monitor *mon);
 int do_device_add(Monitor *mon, const QDict *qdict, QObject **ret_data);
 int do_device_del(Monitor *mon, const QDict *qdict, QObject **ret_data);
+int do_guest_numa_notify(Monitor *mon, const QDict *qdict, QObject **ret_data);
 
 /*** qdev-properties.c ***/
 
diff --git a/hw/virt_sd.c b/hw/virt_sd.c
new file mode 100644
index 0000000..c3aece4
--- /dev/null
+++ b/hw/virt_sd.c
@@ -0,0 +1,155 @@
+/*
+ * Virt sched domain Support
+ *
+ * Copyright IBM, Corp. 2012
+ *
+ * Authors:
+ *  Liu Ping Fan   <pingfanl@linux.vnet.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+*/
+#include "hw.h"
+#include "pci.h"
+#include "kvm.h"
+#include <linux/kvm.h>
+
+/* #define DEBUG_VSD */
+#ifdef DEBUG_VSD
+#define dprintf(fmt, ...) \
+    do { fprintf(stderr, fmt, ## __VA_ARGS__); } while (0)
+#else
+#define dprintf(fmt, ...) \
+    do { } while (0)
+#endif
+
+#define PCI_DEVICE_ID_CPUSTATE  0x1010
+
+typedef struct VirtSdState VirtSdState;
+typedef struct Regs Regs;
+
+#define VSD_REGS_SIZE  0x1000
+struct Regs {
+    unsigned int gpa_apic_node;
+    unsigned int size;
+};
+
+struct VirtSdState {
+    PCIDevice dev;
+    MemoryRegion mmio;
+    Regs regs;
+};
+
+static const VMStateDescription vmstate_vsd = {
+    .name = "vsd",
+    .version_id = 1,
+    .minimum_version_id = 0,
+    .fields = (VMStateField[]) {
+        VMSTATE_END_OF_LIST()
+    },
+};
+
+static VirtSdState *vsd_dev;
+
+static int update_guest_numa(void)
+{
+    int ret = 0;
+    target_phys_addr_t sz;
+    struct kvm_virt_sd vsd;
+    sz = vsd.sz = vsd_dev->regs.size;
+    vsd.vapic_map = cpu_physical_memory_map(vsd_dev->regs.gpa_apic_node,
+                    &sz, 1);
+    ret = kvm_ioctl(kvm_state, KVM_SET_GUEST_NUMA, &vsd);
+    if (ret < 0) {
+        return -1;
+    } else {
+        qemu_set_irq(vsd_dev->dev.irq[0], 1);
+        qemu_set_irq(vsd_dev->dev.irq[0], 0);
+    }
+    return 0;
+}
+
+int do_guest_numa_notify(Monitor *mon, const QDict *qdict, QObject **ret_data)
+{
+    return update_guest_numa();
+}
+
+static void
+vsd_mmio_write(void *opaque, target_phys_addr_t addr, uint64_t val,
+                 unsigned size)
+{
+    VirtSdState *vsd = opaque;
+    dprintf("vsd_mmio_write,addr=0x%lx, val=0x%lx\n", addr, val);
+    switch (addr) {
+    case 0:
+        vsd->regs.gpa_apic_node = val;
+        break;
+    case 4:
+        vsd->regs.size = val;
+        break;
+    default:
+        fprintf(stderr, "reg unimplemented\n");
+        break;
+    }
+}
+
+static uint64_t
+vsd_mmio_read(void *opaque, target_phys_addr_t addr, unsigned size)
+{
+    return 0;
+}
+
+static const MemoryRegionOps vsd_ops = {
+    .read = vsd_mmio_read,
+    .write = vsd_mmio_write,
+    .endianness = DEVICE_LITTLE_ENDIAN,
+};
+
+static int pci_vsd_init(PCIDevice *dev)
+{
+    uint8_t *pci_cfg = dev->config;
+    VirtSdState *s = DO_UPCAST(VirtSdState, dev, dev);
+    memory_region_init_io(&s->mmio, &vsd_ops, s, "vsd", VSD_REGS_SIZE);
+    vsd_dev = s;
+    pci_cfg[PCI_INTERRUPT_PIN] = 1;
+    pci_cfg[PCI_CAPABILITY_LIST] = 0xdc;
+    pci_register_bar(&s->dev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY,  &s->mmio);
+    return 0;
+}
+
+static int pci_vsd_exit(PCIDevice *dev)
+{
+    return 0;
+}
+
+static Property vsd_properties[] = {
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void vsd_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    PCIDeviceClass *k = PCI_DEVICE_CLASS(klass);
+
+    k->init = pci_vsd_init;
+    k->exit = pci_vsd_exit;
+    k->vendor_id = PCI_VENDOR_ID_IBM;
+    k->device_id = PCI_DEVICE_ID_CPUSTATE;
+    k->revision = 0x10;
+    k->class_id = PCI_CLASS_MEMORY_RAM;
+    dc->props = vsd_properties;
+}
+
+static TypeInfo vsd_info = {
+    .name          = "vsd",
+    .parent        = TYPE_PCI_DEVICE,
+    .instance_size = sizeof(VirtSdState),
+    .class_init    = vsd_class_init,
+};
+
+static void vsd_register_types(void)
+{
+    type_register_static(&vsd_info);
+}
+type_init(vsd_register_types)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index ee7bd9c..aa5aec3 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -448,7 +448,6 @@ struct kvm_ppc_pvinfo {
 	__u32 hcall[4];
 	__u8  pad[108];
 };
-
 #define KVMIO 0xAE
 
 /* machine type bits, to be used as argument to KVM_CREATE_VM */
@@ -478,6 +477,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
 #define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
 
+
 /*
  * Extension capability list.
  */
@@ -733,6 +733,7 @@ struct kvm_one_reg {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SET_GUEST_NUMA             _IOW(KVMIO,  0x49, struct kvm_virt_sd)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
@@ -913,4 +914,9 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
 
+struct kvm_virt_sd {
+	__u64 *vapic_map;
+	__u64 sz;
+};
+
 #endif /* __LINUX_KVM_H */
-- 
1.7.4.4

