Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab2D0PUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:20:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493Ab2D0PUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:20:15 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 02/19] PCI: introduce recursive rwsem to serialize PCI hotplug operations
Date: Fri, 27 Apr 2012 23:16:43 +0800
Message-Id: <1335539820-11232-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

There are multiple ways to trigger PCI hotplug requests concurrently,
such as:
1. Sysfs interfaces exported by the PCI core subsystem
2. Sysfs interfaces exported by the PCI hotplug subsystem
3. PCI hotplug events triggered by PCI Hotplug Controllers
4. ACPI hotplug events for PCI host bridges
5. Driver binding/unbinding events

The PCI core subsystem doesn't support concurrent hotplug operations yet,
so all PCI hotplug requests should be globally serialized. This patch
introduces several new interfaces to serialize PCI hotplug operations.

pci_hotplug_try_enter(): try to acquire write lock
pci_hotplug_enter(): acquire write lock
pci_hotplug_exit(): release write lock
pci_hotplug_disable(): acquire read lock
pci_hotplug_enable(): release read lock

Today we have reproduced the issue on a real platform by using
acpiphp driver. It's an IA64 platform running Suse 11SP1 (official
2.6.32.12 kernel). The test script is:

This issue could be reproduced on an IA64 platform with Suse 11SP1
(official 2.6.32.12 kernel) and acpiphp driver.
---------------------------------------------------------------------
#!/bin/bash

for ((i=0;i<100;i++))
do
    echo 1 > /sys/bus/pci/devices/0000\:43\:00.0/remove
    echo 0 > /sys/bus/pci/slots/3/power
    sleep 1
    echo 1 > /sys/bus/pci/slots/3/power
done

And the bug report is:

------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x210/0x240()
Hardware name: H8900
sysfs group a0000001012014f0 not found for kobject '0000:45:00.1'
Modules linked in: acpiphp(N) ipv6(N) cpufreq_conservative(N) cpufreq_userspace(
N) cpufreq_powersave(N) acpi_cpufreq(N) binfmt_misc(N) fuse(N) nls_iso8859_1(N)
loop(N) dm_mod(N) tpm_tis(N) tpm(N) ppdev(N) shpchp(N) tpm_bios(N) serio_raw(N)
qla2xxx(N) i2c_i801(N) scsi_transport_fc(N) pci_hotplug(N) scsi_tgt(N) iTCO_wdt(
N) sg(N) iTCO_vendor_support(N) i2c_core(N) mptctl(N) igb(N) parport_pc(N) parpo
rt(N) button(N) container(N) usbhid(N) hid(N) uhci_hcd(N) ehci_hcd(N) usbcore(N)
sd_mod(N) crc_t10dif(N) ext3(N) mbcache(N) jbd(N) fan(N) processor(N) ide_pci_g
eneric(N) ide_core(N) ata_piix(N) libata(N) mptsas(N) mptscsih(N) mptbase(N) scs
i_transport_sas(N) scsi_mod(N) thermal(N) thermal_sys(N) hwmon(N)
Supported: Yes

Call Trace:
 [<a000000100017640>] show_stack+0x80/0xa0
                                sp=e000002f4421fc00 bsp=e000002f44211678
 [<a0000001008cfd10>] dump_stack+0x30/0x50
                                sp=e000002f4421fdd0 bsp=e000002f44211660
 [<a0000001000b9bc0>] warn_slowpath_common+0xc0/0x120
                                sp=e000002f4421fdd0 bsp=e000002f44211628
 [<a0000001000b9d10>] warn_slowpath_fmt+0x90/0xc0
                                sp=e000002f4421fdd0 bsp=e000002f442115c0
 [<a000000100331690>] sysfs_remove_group+0x210/0x240
                                sp=e000002f4421fe10 bsp=e000002f44211590
 [<a000000100636190>] dpm_sysfs_remove+0x30/0x60
                                sp=e000002f4421fe10 bsp=e000002f44211570
 [<a0000001006236c0>] device_del+0x80/0x460
                                sp=e000002f4421fe10 bsp=e000002f44211528
 [<a000000100623ae0>] device_unregister+0x40/0x140
                                sp=e000002f4421fe10 bsp=e000002f44211508
 [<a0000001004d2320>] pci_stop_bus_device+0x160/0x200
                                sp=e000002f4421fe10 bsp=e000002f442114d8
 [<a000000223104e70>] acpiphp_disable_slot+0x170/0x580 [acpiphp]
                                sp=e000002f4421fe10 bsp=e000002f44211470
 [<a000000223100b70>] disable_slot+0x50/0x160 [acpiphp]
                                sp=e000002f4421fe20 bsp=e000002f44211448
 [<a00000021e960e60>] power_write_file+0x240/0x340 [pci_hotplug]
                                sp=e000002f4421fe20 bsp=e000002f44211418
 [<a0000001004e5e00>] pci_slot_attr_store+0x60/0xa0
                                sp=e000002f4421fe20 bsp=e000002f442113d8
 [<a00000010032a260>] sysfs_write_file+0x240/0x340
                                sp=e000002f4421fe20 bsp=e000002f44211380
 [<a000000100232910>] vfs_write+0x1b0/0x3c0
                                sp=e000002f4421fe20 bsp=e000002f44211330
 [<a000000100232ce0>] sys_write+0x80/0x100
                                sp=e000002f4421fe20 bsp=e000002f442112b8
 [<a00000010000c9c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000002f4421fe30 bsp=e000002f442112b8
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000002f44220000 bsp=e000002f442112b8
---[ end trace bd659e9a3f4f6279 ]---
offline_pci.sh[6450]: NaT consumption 17179869216 [1]
Modules linked in: acpiphp(N) ipv6(N) cpufreq_conservative(N) cpufreq_userspace(
N) cpufreq_powersave(N) acpi_cpufreq(N) binfmt_misc(N) fuse(N) nls_iso8859_1(N)
loop(N) dm_mod(N) tpm_tis(N) tpm(N) ppdev(N) shpchp(N) tpm_bios(N) serio_raw(N)                                        qla2xxx(N) i2c_i801(N) scsi_transport_fc(N) pci_hotplug(N) scsi_tgt(N) iTCO_wdt(
N) sg(N) iTCO_vendor_support(N) i2c_core(N) mptctl(N) igb(N) parport_pc(N) parpo                                       rt(N) button(N) container(N) usbhid(N) hid(N) uhci_hcd(N) ehci_hcd(N) usbcore(N)
sd_mod(N) crc_t10dif(N) ext3(N) mbcache(N) jbd(N) fan(N) processor(N) ide_pci_g
eneric(N) ide_core(N) ata_piix(N) libata(N) mptsas(N) mptscsih(N) mptbase(N) scs
i_transport_sas(N) scsi_mod(N) thermal(N) thermal_sys(N) hwmon(N)
Supported: Yes

Pid: 6450, CPU 11, comm:       offline_pci.sh
psr : 0000101009526030 ifs : 8000000000000389 ip  : [<a0000001008a9870>]    Tain
ted: G        W N  (2.6.32.12-yyz)
ip is at klist_put+0x30/0x160
unat: 0000000000000000 pfs : 0000000000000206 rsc : 0000000000000003
rnat: 8000000000000711 bsps: 0000000000000000 pr  : 65519aa656999969
ldrs: 0000000000000000 ccv : 0000000040000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001008a9a50 b6  : a0000001004b1320 b7  : a00000010000d170
qla2xxx 0000:45:00.1: PCI INT B disabled
f6  : 000000000000000000000 f7  : 1003e9e3779b97f4a7c16
f8  : 1003e0a00000000001072 f9  : 1003effffffffffffffee
f10 : 1003e0000000000000023 f11 : 1003e8208208208208209
r1  : a0000001015c8460 r2  : 0000000000000000 r3  : a0000001013e75b0
r8  : 0000000000000001 r9  : a0000001013e75b0 r10 : a0000001013e8ed8
r11 : 0000000000000000 r12 : e000002f4421fe10 r13 : e000002f44210000
r14 : 0000000000000020 r15 : 0000000000004000 r16 : 0000000000000009
r17 : 0000000000000200 r18 : 0000000040000000 r19 : 0000000040000000
r20 : 0000000040000200 r21 : 0000000040000000 r22 : 000000000001ae13
r23 : 0000000000100000 r24 : a0000001029780f0 r25 : 000000000001ae10
r26 : 000000000001ae10 r27 : 0000000000100000 r28 : 0000000000000034
r29 : 0000000000000034 r30 : a0000001029780f1 r31 : 000000000001ae11

Call Trace:
 [<a000000100017640>] show_stack+0x80/0xa0
                                sp=e000002f4421f850 bsp=e000002f442116f8
 [<a000000100017ca0>] show_regs+0x640/0x920
                                sp=e000002f4421fa20 bsp=e000002f442116a0
 [<a000000100028c70>] die+0x190/0x2e0
                                sp=e000002f4421fa30 bsp=e000002f44211660
 [<a000000100028e10>] die_if_kernel+0x50/0x80
                                sp=e000002f4421fa30 bsp=e000002f44211630
 [<a0000001008d8d70>] ia64_fault+0xf0/0x1640
                                sp=e000002f4421fa30 bsp=e000002f442115d8
 [<a00000010000cb60>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000002f4421fc40 bsp=e000002f442115d8
 [<a0000001008a9870>] klist_put+0x30/0x160
                                sp=e000002f4421fe10 bsp=e000002f44211590
 [<a0000001008a9a50>] klist_del+0x30/0x60
                                sp=e000002f4421fe10 bsp=e000002f44211570
 [<a0000001006236e0>] device_del+0xa0/0x460
                                sp=e000002f4421fe10 bsp=e000002f44211528
 [<a000000100623ae0>] device_unregister+0x40/0x140
                                sp=e000002f4421fe10 bsp=e000002f44211508
 [<a0000001004d2320>] pci_stop_bus_device+0x160/0x200
                                sp=e000002f4421fe10 bsp=e000002f442114d8
 [<a000000223104e70>] acpiphp_disable_slot+0x170/0x580 [acpiphp]
                                sp=e000002f4421fe10 bsp=e000002f44211470
 [<a000000223100b70>] disable_slot+0x50/0x160 [acpiphp]
                                sp=e000002f4421fe20 bsp=e000002f44211448
 [<a00000021e960e60>] power_write_file+0x240/0x340 [pci_hotplug]
                                sp=e000002f4421fe20 bsp=e000002f44211418
 [<a0000001004e5e00>] pci_slot_attr_store+0x60/0xa0
                                sp=e000002f4421fe20 bsp=e000002f442113d8
 [<a00000010032a260>] sysfs_write_file+0x240/0x340
                                sp=e000002f4421fe20 bsp=e000002f44211380
 [<a000000100232910>] vfs_write+0x1b0/0x3c0
                                sp=e000002f4421fe20 bsp=e000002f44211330
 [<a000000100232ce0>] sys_write+0x80/0x100
                                sp=e000002f4421fe20 bsp=e000002f442112b8
 [<a00000010000c9c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000002f4421fe30 bsp=e000002f442112b8
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000002f44220000 bsp=e000002f442112b8
Disabling lock debugging due to kernel taint

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug.c                  |   55 ++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/pci_hotplug_core.c |    8 ++--
 include/linux/pci.h                    |   14 ++++++++
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug.c b/drivers/pci/hotplug.c
index 2b5352a..975bd3d 100644
--- a/drivers/pci/hotplug.c
+++ b/drivers/pci/hotplug.c
@@ -1,8 +1,63 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/rwsem.h>
 #include "pci.h"
 
+/* Recursive mutex for PCI hotplug operations. */
+static DECLARE_RWSEM(pci_hotplug_rwsem);
+static struct task_struct *pci_hotplug_mutex_owner;
+static int pci_hotplug_mutex_recursive;
+
+/*
+ * trylock for writing -- returns 1 if successful, 0 if contention
+ */
+int pci_hotplug_try_enter(void)
+{
+	if (current != pci_hotplug_mutex_owner) {
+		if (down_write_trylock(&pci_hotplug_rwsem) == 0)
+			return 0;
+		pci_hotplug_mutex_owner = current;
+	}
+	pci_hotplug_mutex_recursive++;
+
+	return 1;
+}
+EXPORT_SYMBOL(pci_hotplug_try_enter);
+
+void pci_hotplug_enter(void)
+{
+	if (current != pci_hotplug_mutex_owner) {
+		down_write(&pci_hotplug_rwsem);
+		pci_hotplug_mutex_owner = current;
+	}
+	pci_hotplug_mutex_recursive++;
+
+}
+EXPORT_SYMBOL(pci_hotplug_enter);
+
+void pci_hotplug_exit(void)
+{
+	BUG_ON(pci_hotplug_mutex_owner != current);
+	if (--pci_hotplug_mutex_recursive == 0) {
+		pci_hotplug_mutex_owner = NULL;
+		up_write(&pci_hotplug_rwsem);
+	}
+}
+EXPORT_SYMBOL(pci_hotplug_exit);
+
+void pci_hotplug_enable(void)
+{
+	up_read(&pci_hotplug_rwsem);
+}
+EXPORT_SYMBOL(pci_hotplug_enable);
+
+void pci_hotplug_disable(void)
+{
+	down_read(&pci_hotplug_rwsem);
+}
+EXPORT_SYMBOL(pci_hotplug_disable);
+
 int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct pci_dev *pdev;
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 202f4a9..1572665 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -537,7 +537,7 @@ int __must_check pci_hp_change_slot_info(struct hotplug_slot *hotplug,
 	return 0;
 }
 
-static int __init pci_hotplug_init (void)
+static int __init pci_hp_init(void)
 {
 	int result;
 
@@ -553,13 +553,13 @@ err_cpci:
 	return result;
 }
 
-static void __exit pci_hotplug_exit (void)
+static void __exit pci_hp_exit(void)
 {
 	cpci_hotplug_exit();
 }
 
-module_init(pci_hotplug_init);
-module_exit(pci_hotplug_exit);
+module_init(pci_hp_init);
+module_exit(pci_hp_exit);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0603a60..1c5f153 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -884,6 +884,20 @@ unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge);
 unsigned int pci_rescan_bus(struct pci_bus *bus);
 #endif
 
+#ifdef CONFIG_HOTPLUG
+extern int pci_hotplug_try_enter(void);
+extern void pci_hotplug_enter(void);
+extern void pci_hotplug_exit(void);
+extern void pci_hotplug_disable(void);
+extern void pci_hotplug_enable(void);
+#else
+static inline int pci_hotplug_try_enter(void) { return 1; }
+static inline void pci_hotplug_enter(void) {}
+static inline void pci_hotplug_exit(void) {}
+static inline void pci_hotplug_enable(void) {}
+static inline void pci_hotplug_disable(void) {}
+#endif
+
 /* Vital product data routines */
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
-- 
1.7.5.4

