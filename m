Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584Ab2D0PVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:21:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760576Ab2D0PVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:03 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 07/19] PCI: serialize hotplug operaitons triggered by the pciehp driver
Date: Fri, 27 Apr 2012 23:16:48 +0800
Message-Id: <1335539820-11232-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCI hotplug lock to serialize hotplug operations triggered by the
pciehp driver. It solves following crash issues.

test scripts:
[root]cat offline.sh
#!/bin/bash

for((i=0;i<100000;i++))
do
	`echo 0 > /sys/bus/pci/slots/16/power`
	`echo 1 > /sys/bus/pci/slots/16/power`
done

[root]cat remove.sh
#!/bin/bash

for((i=0;i<100000;i++))
do
	`echo 1 > /sys/bus/pci/devices/0000:0f:00.0/remove`
	`echo 1 > /sys/bus/pci/rescan`
done

--------------------------------------------
CPU 11
Modules linked in: pciehp pci_hotplug ipv6 cpufreq_conservative cpufreq_userspac

Pid: 8675, comm: offline.sh Not tainted 3.4.0-rc3-yijing+ #7 Huawei Technologies
CPU 11
Modules linked in: pciehp pci_hotplug ipv6 cpufreq_conservative cpufreq_userspac

Pid: 8675, comm: offline.sh Not tainted 3.4.0-rc3-yijing+ #7 Huawei Technologies
RIP: 0010:[<ffffffff81141f90>]  [<ffffffff81141f90>] sysfs_name_hash+0x17/0xaa
RSP: 0018:ffff880c1a487c60  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff880c1c230c40 RCX: ffffffffffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff880c1a487c68 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff811bd401 R11: ffff880c1a4d5d40 R12: ffff880c1babd558
R13: 0000000000000000 R14: 0000000000000000 R15: ffff880c1a487dbf
FS:  00007f00722e36f0(0000) GS:ffff880c3fce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000c1b594000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process offline.sh (pid: 8675, threadinfo ffff880c1a486000, task ffff880c1b84000
Stack:
 0000000000000000 ffff880c1a487ca8 ffffffff811421fc ffff880c1a487cd8
 ffff880c1c230c40 0000000000000000 0000000000000000 ffff880c1a487cb8
 ffff880c1a487dbf ffff880c1a487ce8 ffffffff81140e99 ffff880c1c230c40
Call Trace:
 [<ffffffff811421fc>] sysfs_find_dirent+0x78/0xd4
 [<ffffffff81140e99>] sysfs_hash_and_remove+0x5e/0x8e
 [<ffffffff81143ffc>] sysfs_remove_bin_file+0x12/0x14
 [<ffffffff811bd030>] pci_remove_resource_files+0x30/0x6b
 [<ffffffff811bd454>] pci_remove_sysfs_dev_files+0x9d/0x110
 [<ffffffff811b748e>] pci_stop_bus_device+0x52/0x80
 [<ffffffff811b766c>] pci_stop_and_remove_bus_device+0x11/0x21
 [<ffffffffa02164ae>] pciehp_unconfigure_device+0x102/0x166 [pciehp]
 [<ffffffffa0216934>] ? pciehp_get_power_status+0x33/0xc3 [pciehp]
 [<ffffffffa02157aa>] pciehp_disable_slot+0x106/0x163 [pciehp]
 [<ffffffffa0215866>] pciehp_sysfs_disable_slot+0x5f/0xee [pciehp]
 [<ffffffffa0215649>] disable_slot+0x52/0x56 [pciehp]
 [<ffffffffa01f640d>] power_write_file+0x8c/0xcd [pci_hotplug]
 [<ffffffff811bf10e>] pci_slot_attr_store+0x24/0x26
 [<ffffffff811417c5>] sysfs_write_file+0xdc/0x111
 [<ffffffff810eb55c>] vfs_write+0xae/0x151
 [<ffffffff810eb6c3>] sys_write+0x47/0x6e
 [<ffffffff8131fce2>] system_call_fastpath+0x16/0x1b
Code: 48 8b 47 78 55 48 89 e5 0f b7 40 60 c9 c1 e8 0d 83 e0 01 c3 55 49 89 f8 31
RIP  [<ffffffff81141f90>] sysfs_name_hash+0x17/0xaa
 RSP <ffff880c1a487c60>
CR2: 0000000000000000
---[ end trace af1f0f7871dbd9bc ]---

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/pciehp.h      |    2 +
 drivers/pci/hotplug/pciehp_core.c |    7 ++++-
 drivers/pci/hotplug/pciehp_ctrl.c |   48 +++++++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/pciehp_hpc.c  |    1 +
 4 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index c8a1a27..6078eea 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -117,6 +117,7 @@ struct controller {
 #define BLINKINGOFF_STATE		2
 #define POWERON_STATE			3
 #define POWEROFF_STATE			4
+#define SHUTDOWN_STATE			5
 
 #define ATTN_BUTTN(ctrl)	((ctrl)->slot_cap & PCI_EXP_SLTCAP_ABP)
 #define POWER_CTRL(ctrl)	((ctrl)->slot_cap & PCI_EXP_SLTCAP_PCP)
@@ -160,6 +161,7 @@ void pciehp_green_led_off(struct slot *slot);
 void pciehp_green_led_blink(struct slot *slot);
 int pciehp_check_link_status(struct controller *ctrl);
 void pciehp_release_ctrl(struct controller *ctrl);
+void pciehp_shutdown_slot(struct slot *slot);
 
 static inline const char *slot_name(struct slot *slot)
 {
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 4ceefe3..2195f67 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -268,8 +268,11 @@ static int pciehp_probe(struct pcie_device *dev)
 	slot = ctrl->slot;
 	pciehp_get_adapter_status(slot, &occupied);
 	pciehp_get_power_status(slot, &poweron);
-	if (occupied && pciehp_force)
+	if (occupied && pciehp_force) {
+		pci_hotplug_enter();
 		pciehp_enable_slot(slot);
+		pci_hotplug_exit();
+	}
 	/* If empty slot's power status is on, turn power off */
 	if (!occupied && poweron && POWER_CTRL(ctrl))
 		pciehp_power_off_slot(slot);
@@ -313,11 +316,13 @@ static int pciehp_resume (struct pcie_device *dev)
 		slot = ctrl->slot;
 
 		/* Check if slot is occupied */
+		pci_hotplug_enter();
 		pciehp_get_adapter_status(slot, &status);
 		if (status)
 			pciehp_enable_slot(slot);
 		else
 			pciehp_disable_slot(slot);
+		pci_hotplug_exit();
 	}
 	return 0;
 }
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 8f4d261..b83f2cc 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <linux/pci.h>
 #include "../pci.h"
 #include "pciehp.h"
@@ -290,6 +291,30 @@ static void pciehp_power_thread(struct work_struct *work)
 	struct power_work_info *info =
 		container_of(work, struct power_work_info, work);
 	struct slot *p_slot = info->p_slot;
+	bool shutdown;
+
+	/*
+	 * Break out deadlock issues caused by following scenario:
+	 * Thread A:
+	 *	1) acquire the PCI hotplug lock
+	 *	2) remove the PCI device associated with this PCIe HPC
+	 *	3) call pciehp_remove() for this PCIe HPC
+	 *	4) call flush_workqueue(pciehp_wq_power) to flush queued works
+	 *      5) wait until all queued works done
+	 * Thread B is a workqueue worker thread:
+	 *	1) call pciehp_power_thread() to handle hotplug requests
+	 *	2) try to acquire the PCI hotplug lock
+	 * Please refer to pciehp_shutdown_slot() for the counterpart.
+	 */
+	while (!pci_hotplug_try_enter()) {
+		mutex_lock(&p_slot->lock);
+		shutdown = p_slot->state == SHUTDOWN_STATE;
+		mutex_unlock(&p_slot->lock);
+		if (shutdown)
+			goto out;
+		else
+			mdelay(1);
+	}
 
 	mutex_lock(&p_slot->lock);
 	switch (p_slot->state) {
@@ -315,6 +340,9 @@ static void pciehp_power_thread(struct work_struct *work)
 	}
 	mutex_unlock(&p_slot->lock);
 
+	pci_hotplug_exit();
+
+out:
 	kfree(info);
 }
 
@@ -623,3 +651,23 @@ int pciehp_sysfs_disable_slot(struct slot *p_slot)
 
 	return retval;
 }
+
+void pciehp_shutdown_slot(struct slot *slot)
+{
+	u8 getstatus;
+	struct controller *ctrl = slot->ctrl;
+
+	mutex_lock(&slot->lock);
+	slot->state = SHUTDOWN_STATE;
+	mutex_unlock(&slot->lock);
+
+	if (ATTN_LED(ctrl))
+		pciehp_set_attention_status(slot, 0);
+	if (PWR_LED(ctrl)) {
+		pciehp_get_power_status(slot, &getstatus);
+		if (getstatus)
+			pciehp_green_led_on(slot);
+		else
+			pciehp_green_led_off(slot);
+	}
+}
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index d5c826d..c492b2c 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -902,6 +902,7 @@ static void pcie_cleanup_slot(struct controller *ctrl)
 	 */
 	flush_workqueue(pciehp_wq_event);
 	cancel_delayed_work_sync(&slot->work);
+	pciehp_shutdown_slot(slot);
 	flush_workqueue(pciehp_wq_power);
 
 	kfree(slot);
-- 
1.7.5.4

