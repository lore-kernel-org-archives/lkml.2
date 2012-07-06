Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2GFJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:56:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21963 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab2GFJ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:56:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,537,1336320000"; 
   d="scan'208";a="5344264"
Message-ID: <4FF6B2AC.9010204@cn.fujitsu.com>
Date: Fri, 06 Jul 2012 17:41:00 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 5/7 v6] introduce a new qom device to deal with panicked event
References: <4FF6B188.2060607@cn.fujitsu.com>
In-Reply-To: <4FF6B188.2060607@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/06 17:36:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/06 17:37:01,
	Serialize complete at 2012/07/06 17:37:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the target is x86/x86_64, the guest's kernel will write 0x01 to the
port KVM_PV_PORT when it is panciked. This patch introduces a new qom
device kvm_pv_ioport to listen this I/O port, and deal with panicked
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
---
 hw/kvm/Makefile.objs |    2 +-
 hw/kvm/pv_event.c    |   73 +++++++++++++++++++++++++++
 hw/kvm/pv_ioport.c   |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kvm-stub.c           |    9 +++
 kvm.h                |    3 +
 vl.c                 |    4 ++
 6 files changed, 223 insertions(+), 1 deletions(-)
 create mode 100644 hw/kvm/pv_event.c
 create mode 100644 hw/kvm/pv_ioport.c

diff --git a/hw/kvm/Makefile.objs b/hw/kvm/Makefile.objs
index 226497a..23e3b30 100644
--- a/hw/kvm/Makefile.objs
+++ b/hw/kvm/Makefile.objs
@@ -1 +1 @@
-obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o
+obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pv_event.o
diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
new file mode 100644
index 0000000..d7ded37
--- /dev/null
+++ b/hw/kvm/pv_event.c
@@ -0,0 +1,73 @@
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
+static int panicked_action = PANICKED_REPORT;
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
+        exit(0);
+        break;
+    case PANICKED_RESET:
+        panicked_mon_event("reset");
+        qemu_system_reset_request();
+        break;
+    }
+}
+
+#if defined(KVM_PV_PORT)
+#include "pv_ioport.c"
+
+void kvm_pv_event_init(void)
+{
+    pv_ioport_init(panicked_action);
+}
+#else
+void kvm_pv_event_init(void)
+{
+}
+#endif
diff --git a/hw/kvm/pv_ioport.c b/hw/kvm/pv_ioport.c
new file mode 100644
index 0000000..e93d819
--- /dev/null
+++ b/hw/kvm/pv_ioport.c
@@ -0,0 +1,133 @@
+/*
+ * QEMU KVM support, paravirtual I/O port device
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
+#include "hw/isa.h"
+
+typedef struct {
+    ISADevice dev;
+    MemoryRegion ioport;
+    uint32_t panicked_action;
+} PVState;
+
+static PVState *pv_state;
+
+static uint64_t pv_io_read(void *opaque, target_phys_addr_t addr, unsigned size)
+{
+    return 1 << KVM_PV_FEATURE_PANICKED;
+}
+
+static void pv_io_write(void *opaque, target_phys_addr_t addr, uint64_t val,
+                        unsigned size)
+{
+    PVState *s = opaque;
+
+    if (val == KVM_PV_PANICKED) {
+        panicked_perform_action(s->panicked_action);
+    }
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
+    PVState *s = DO_UPCAST(PVState, dev, dev);
+
+    memory_region_init_io(&s->ioport, &pv_io_ops, s, "pv_event", 1);
+    isa_register_ioport(dev, &s->ioport, KVM_PV_PORT);
+
+    pv_state = s;
+
+    return 0;
+}
+
+static const VMStateDescription pv_ioport_vmsd = {
+    .name = "pv_ioport",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .minimum_version_id_old = 1,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT32(panicked_action, PVState),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static Property pv_ioport_properties[] = {
+    DEFINE_PROP_UINT32("panicked_action", PVState, panicked_action, PANICKED_REPORT),
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
+    dc->vmsd = &pv_ioport_vmsd;
+    dc->props = pv_ioport_properties;
+}
+
+static TypeInfo pv_ioport_info = {
+    .name          = "kvm_pv_ioport",
+    .parent        = TYPE_ISA_DEVICE,
+    .instance_size = sizeof(PVState),
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
+static int is_isa_bus(BusState *bus, void *opaque)
+{
+    const char *bus_type_name;
+    ISABus **isa_bus_p = opaque;
+
+    bus_type_name = object_class_get_name(bus->obj.class);
+    if (!strcmp(bus_type_name, TYPE_ISA_BUS)) {
+        *isa_bus_p = ISA_BUS(&bus->obj);
+        return -1;
+    }
+
+    return 0;
+}
+
+static ISABus *get_isa_bus(void)
+{
+    ISABus *isa_bus = NULL;
+
+    qbus_walk_children(sysbus_get_default(), NULL, is_isa_bus, &isa_bus);
+
+    return isa_bus;
+}
+
+static void pv_ioport_init(uint32_t panicked_action)
+{
+    ISADevice *dev;
+    ISABus *bus;
+
+    bus = get_isa_bus();
+    dev = isa_create(bus, "kvm_pv_ioport");
+    qdev_prop_set_uint32(&dev->qdev, "panicked_action", panicked_action);
+    qdev_init_nofail(&dev->qdev);
+}
diff --git a/kvm-stub.c b/kvm-stub.c
index ec9a364..a28d078 100644
--- a/kvm-stub.c
+++ b/kvm-stub.c
@@ -151,3 +151,12 @@ int kvm_irqchip_remove_irqfd(KVMState *s, int fd, int virq)
 {
     return -ENOSYS;
 }
+
+void kvm_pv_event_init(void)
+{
+}
+
+int select_panicked_action(const char *p)
+{
+    return 0;
+}
diff --git a/kvm.h b/kvm.h
index 9c7b0ea..1f7c72b 100644
--- a/kvm.h
+++ b/kvm.h
@@ -218,4 +218,7 @@ void kvm_irqchip_release_virq(KVMState *s, int virq);
 
 int kvm_irqchip_add_irqfd(KVMState *s, int fd, int virq);
 int kvm_irqchip_remove_irqfd(KVMState *s, int fd, int virq);
+
+void kvm_pv_event_init(void);
+int select_panicked_action(const char *p);
 #endif
diff --git a/vl.c b/vl.c
index ea5ef1c..f5cd28d 100644
--- a/vl.c
+++ b/vl.c
@@ -3622,6 +3622,10 @@ int main(int argc, char **argv, char **envp)
         exit(1);
     }
 
+    if (kvm_enabled()) {
+        kvm_pv_event_init();
+    }
+
     qdev_machine_creation_done();
 
     if (rom_load_all() != 0) {
-- 
1.7.1

