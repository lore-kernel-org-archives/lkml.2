Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2LLGOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:14:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2LLGN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:13:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6380977"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 6/8] introduce a new qom device to deal with panicked event
Date: Wed, 12 Dec 2012 14:13:49 +0800
Message-Id: <122618721ed661b337220319d455fecd3d02d1f9.1355290850.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1355290850.git.hutao@cn.fujitsu.com>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:06,
	Serialize complete at 2012/12/12 14:13:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the target is x86/x86_64, the guest's kernel will write 0x01 to the
port KVM_PV_EVENT_PORT when it is panciked. This patch introduces a new
qom device kvm_pv_ioport to listen this I/O port, and deal with panicked
event according to panicked_action's value. The possible actions are:
1. emit QEVENT_GUEST_PANICKED only
2. emit QEVENT_GUEST_PANICKED and pause the guest
3. emit QEVENT_GUEST_PANICKED and poweroff the guest
4. emit QEVENT_GUEST_PANICKED and reset the guest

I/O ports does not work for some targets(for example: s390). And you
can implement another qom device, and include it's code into pv_event.c
for such target.

Note: if we emit QEVENT_GUEST_PANICKED only, and the management
application does not receive this event(the management may not
run when the event is emitted), the management won't know the
guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 hw/kvm/Makefile.objs |   2 +-
 hw/kvm/pv_event.c    | 197 +++++++++++++++++++++++++++++++++++++++++++++++++++
 hw/pc_piix.c         |   5 ++
 kvm-stub.c           |   4 ++
 kvm.h                |   2 +
 5 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 hw/kvm/pv_event.c

diff --git a/hw/kvm/Makefile.objs b/hw/kvm/Makefile.objs
index f620d7f..cf93199 100644
--- a/hw/kvm/Makefile.objs
+++ b/hw/kvm/Makefile.objs
@@ -1 +1 @@
-obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pci-assign.o
+obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pci-assign.o pv_event.o
diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
new file mode 100644
index 0000000..112491e
--- /dev/null
+++ b/hw/kvm/pv_event.c
@@ -0,0 +1,197 @@
+/*
+ * QEMU KVM support, paravirtual event device
+ *
+ * Copyright Fujitsu, Corp. 2012
+ *
+ * Authors:
+ *     Wen Congyang <wency@cn.fujitsu.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#include <linux/kvm_para.h>
+#include <asm/kvm_para.h>
+#include <qobject.h>
+#include <qjson.h>
+#include <monitor.h>
+#include <sysemu.h>
+#include <kvm.h>
+
+/* Possible values for action parameter. */
+#define PANICKED_REPORT     1   /* emit QEVENT_GUEST_PANICKED only */
+#define PANICKED_PAUSE      2   /* emit QEVENT_GUEST_PANICKED and pause VM */
+#define PANICKED_POWEROFF   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
+#define PANICKED_RESET      4   /* emit QEVENT_GUEST_PANICKED and reset VM */
+
+#define PV_EVENT_DRIVER     "kvm_pv_event"
+
+struct PVEventAction {
+    char *panicked_action;
+    int panicked_action_value;
+};
+
+#define DEFINE_PV_EVENT_PROPERTIES(_state, _conf)   \
+    DEFINE_PROP_STRING("panicked_action", _state, _conf.panicked_action)
+
+static void panicked_mon_event(const char *action)
+{
+    QObject *data;
+
+    data = qobject_from_jsonf("{ 'action': %s }", action);
+    monitor_protocol_event(QEVENT_GUEST_PANICKED, data);
+    qobject_decref(data);
+}
+
+static void panicked_perform_action(uint32_t panicked_action)
+{
+    switch (panicked_action) {
+    case PANICKED_REPORT:
+        panicked_mon_event("report");
+        break;
+
+    case PANICKED_PAUSE:
+        panicked_mon_event("pause");
+        vm_stop(RUN_STATE_GUEST_PANICKED);
+        break;
+
+    case PANICKED_POWEROFF:
+        panicked_mon_event("poweroff");
+        qemu_system_shutdown_request();
+        break;
+
+    case PANICKED_RESET:
+        panicked_mon_event("reset");
+        qemu_system_reset_request();
+        break;
+    }
+}
+
+static uint64_t supported_event(void)
+{
+    return 1 << KVM_PV_FEATURE_PANICKED;
+}
+
+static void handle_event(int event, struct PVEventAction *conf)
+{
+    if (event == KVM_PV_EVENT_PANICKED) {
+        panicked_perform_action(conf->panicked_action_value);
+    }
+}
+
+static int pv_event_init(struct PVEventAction *conf)
+{
+    if (!conf->panicked_action) {
+        conf->panicked_action_value = PANICKED_REPORT;
+    } else if (strcasecmp(conf->panicked_action, "none") == 0) {
+        conf->panicked_action_value = PANICKED_REPORT;
+    } else if (strcasecmp(conf->panicked_action, "pause") == 0) {
+        conf->panicked_action_value = PANICKED_PAUSE;
+    } else if (strcasecmp(conf->panicked_action, "poweroff") == 0) {
+        conf->panicked_action_value = PANICKED_POWEROFF;
+    } else if (strcasecmp(conf->panicked_action, "reset") == 0) {
+        conf->panicked_action_value = PANICKED_RESET;
+    } else {
+        return -1;
+    }
+
+    return 0;
+}
+
+#if defined(KVM_PV_EVENT_PORT)
+
+#include "hw/isa.h"
+
+typedef struct {
+    ISADevice dev;
+    struct PVEventAction conf;
+    MemoryRegion ioport;
+} PVIOPortState;
+
+static uint64_t pv_io_read(void *opaque, hwaddr addr, unsigned size)
+{
+    return supported_event();
+}
+
+static void pv_io_write(void *opaque, hwaddr addr, uint64_t val,
+                        unsigned size)
+{
+    PVIOPortState *s = opaque;
+
+    handle_event(val, &s->conf);
+}
+
+static const MemoryRegionOps pv_io_ops = {
+    .read = pv_io_read,
+    .write = pv_io_write,
+    .impl = {
+        .min_access_size = 4,
+        .max_access_size = 4,
+    },
+};
+
+static int pv_ioport_initfn(ISADevice *dev)
+{
+    PVIOPortState *s = DO_UPCAST(PVIOPortState, dev, dev);
+
+    if (pv_event_init(&s->conf) < 0) {
+        return -1;
+    }
+
+    memory_region_init_io(&s->ioport, &pv_io_ops, s, "pv_event", 1);
+    isa_register_ioport(dev, &s->ioport, KVM_PV_EVENT_PORT);
+
+    return 0;
+}
+
+static Property pv_ioport_properties[] = {
+    DEFINE_PV_EVENT_PROPERTIES(PVIOPortState, conf),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void pv_ioport_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    ISADeviceClass *ic = ISA_DEVICE_CLASS(klass);
+
+    ic->init = pv_ioport_initfn;
+    dc->no_user = 1;
+    dc->props = pv_ioport_properties;
+}
+
+static TypeInfo pv_ioport_info = {
+    .name          = PV_EVENT_DRIVER,
+    .parent        = TYPE_ISA_DEVICE,
+    .instance_size = sizeof(PVIOPortState),
+    .class_init    = pv_ioport_class_init,
+};
+
+static void pv_ioport_register_types(void)
+{
+    type_register_static(&pv_ioport_info);
+}
+
+type_init(pv_ioport_register_types)
+
+void kvm_pv_event_init(void *opaque)
+{
+    ISABus *bus = opaque;
+    ISADevice *dev;
+
+    dev = isa_create(bus, PV_EVENT_DRIVER);
+    qdev_init_nofail(&dev->qdev);
+}
+
+#else
+
+/*
+ * If you need a qom device to handle pv event, this device should
+ * be created and initialized in kvm_pv_event_init().
+ *
+ * The parameter opaque is the device's parent bus.
+ */
+void kvm_pv_event_init(void *opaque)
+{
+}
+#endif
diff --git a/hw/pc_piix.c b/hw/pc_piix.c
index cfa839c..8380702 100644
--- a/hw/pc_piix.c
+++ b/hw/pc_piix.c
@@ -47,6 +47,7 @@
 #ifdef CONFIG_XEN
 #  include <xen/hvm/hvm_info_table.h>
 #endif
+#include <linux/kvm_para.h>
 
 #define MAX_IDE_BUS 2
 
@@ -286,6 +287,10 @@ static void pc_init1(MemoryRegion *system_memory,
     if (pci_enabled) {
         pc_pci_device_init(pci_bus);
     }
+
+    if (kvm_enabled()) {
+        kvm_pv_event_init(isa_bus);
+    }
 }
 
 static void pc_init_pci(QEMUMachineInitArgs *args)
diff --git a/kvm-stub.c b/kvm-stub.c
index a3455e2..c9cfe4a 100644
--- a/kvm-stub.c
+++ b/kvm-stub.c
@@ -140,3 +140,7 @@ int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq)
 {
     return -ENOSYS;
 }
+
+void kvm_pv_event_init(void *opaque)
+{
+}
diff --git a/kvm.h b/kvm.h
index 1e7f244..a4a0795 100644
--- a/kvm.h
+++ b/kvm.h
@@ -275,4 +275,6 @@ void kvm_irqchip_release_virq(KVMState *s, int virq);
 
 int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
 int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
+
+void kvm_pv_event_init(void *opaque);
 #endif
-- 
1.8.0.1.240.ge8a1f5a

