Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab2D0PWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:22:40 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50093 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760333Ab2D0PWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:22:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 17/19] PCI: serialize PCI hotplug operations triggered by fakephp drivers
Date: Fri, 27 Apr 2012 23:16:58 +0800
Message-Id: <1335539820-11232-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCI hotplug lock to globally serialize hotplug operations triggered
by fakephp driver. This patch solves following crash.

[ 1426.145264] IP: [<ffffffff812f811b>] __pci_remove_bus_device+0x4b/0xc0
[ 1426.145264] PGD 30463067 PUD 38f9e067 PMD 0
[ 1426.145264] Oops: 0002 [#1] SMP
[ 1426.145264] CPU 0
[ 1426.145264] Modules linked in: fakephp shpchp r8169 [last unloaded: fakephp]
[ 1426.145264]
[ 1426.145264] Pid: 2086, comm: kworker/u:0 Tainted: G        W    3.4.0-rc2+ #19 To Be Filled By O.E.M. To Be Filled .
[ 1426.145264] RIP: 0010:[<ffffffff812f811b>]  [<ffffffff812f811b>] __pci_remove_bus_device+0x4b/0xc0
[ 1426.145264] RSP: 0018:ffff88002e851d10  EFLAGS: 00010282
[ 1426.145264] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000001880
[ 1426.145264] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81c4fec0
[ 1426.145264] RBP: ffff88002e851d20 R08: 0000000000000000 R09: 0000000000000000
[ 1426.145264] R10: 00000000000003c7 R11: 0001f630d1b3ac30 R12: ffff880030db3800
[ 1426.145264] R13: ffff880030443400 R14: ffffffff81fa8840 R15: ffffffff811a5220
[ 1426.145264] FS:  0000000000000000(0000) GS:ffff88003d600000(0000) knlGS:0000000000000000
[ 1426.145264] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1426.145264] CR2: 0000000000000008 CR3: 0000000030ff8000 CR4: 00000000000007f0
[ 1426.145264] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1426.145264] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1426.145264] Process kworker/u:0 (pid: 2086, threadinfo ffff88002e850000, task ffff880037b38000)
[ 1426.145264] Stack:
[ 1426.145264]  ffff880030db3800 ffff88002aa1c530 ffff88002e851d40 ffffffff812f81a9
[ 1426.145264]  0000000000000000 ffff88002a81b900 ffff88002e851d60 ffffffffa17ec0a4
[ 1426.145264]  ffffffff81fa8840 ffff88002aa1c530 ffff88002e851d80 ffffffff811a5233
[ 1426.145264] Call Trace:
[ 1426.145264]  [<ffffffff812f81a9>] pci_stop_and_remove_bus_device+0x19/0x20
[ 1426.145264]  [<ffffffffa17ec0a4>] remove_callback+0x24/0x30 [fakephp]
[ 1426.145264]  [<ffffffff811a5233>] sysfs_schedule_callback_work+0x13/0x80
[ 1426.145264]  [<ffffffff81053462>] process_one_work+0x192/0x570
[ 1426.145264]  [<ffffffff810533f6>] ? process_one_work+0x126/0x570
[ 1426.145264]  [<ffffffff81054e7f>] worker_thread+0x15f/0x350
[ 1426.145264]  [<ffffffff81054d20>] ? manage_workers.isra.27+0x220/0x220
[ 1426.145264]  [<ffffffff81059f4d>] kthread+0x9d/0xb0
[ 1426.145264]  [<ffffffff8178b594>] kernel_thread_helper+0x4/0x10
[ 1426.145264]  [<ffffffff81059eb0>] ? __init_kthread_worker+0x70/0x70
[ 1426.145264]  [<ffffffff8178b590>] ? gs_change+0xb/0xb
[ 1426.145264] Code: 0c ff ff ff 49 c7 44 24 18 00 00 00 00 48 c7 c7 c0 fe c4 81 31 db e8 d5 7f 48 00 49 8b 14 24 49 8
[ 1426.145264] RIP  [<ffffffff812f811b>] __pci_remove_bus_device+0x4b/0xc0
[ 1426.145264]  RSP <ffff88002e851d10>
[ 1426.145264] CR2: 0000000000000008
[ 1426.426612] ---[ end trace 5217fdeceed9de00 ]---
[ 1426.431546] BUG: unable to handle kernel paging request at fffffffffffffff8
[ 1426.432252] IP: [<ffffffff8105a41b>] kthread_data+0xb/0x20
[ 1426.432252] PGD 1c0d067 PUD 1c0e067 PMD 0
[ 1426.432252] Oops: 0000 [#2] SMP
[ 1426.432252] CPU 0
[ 1426.432252] Modules linked in: fakephp shpchp r8169 [last unloaded: fakephp]
[ 1426.432252]
[ 1426.432252] Pid: 2086, comm: kworker/u:0 Tainted: G      D W    3.4.0-rc2+ #19 To Be Filled By O.E.M. To Be Filled .
[ 1426.432252] RIP: 0010:[<ffffffff8105a41b>]  [<ffffffff8105a41b>] kthread_data+0xb/0x20
[ 1426.432252] RSP: 0018:ffff88002e851908  EFLAGS: 00010096
[ 1426.432252] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1426.432252] RDX: ffffffff81fa9440 RSI: 0000000000000000 RDI: ffff880037b38000
[ 1426.432252] RBP: ffff88002e851908 R08: 0000000000989680 R09: 0000000000000000
[ 1426.432252] R10: 0000000000000400 R11: 0000000000000004 R12: 0000000000000000
[ 1426.432252] R13: ffff880037b38378 R14: ffff88003c9b8000 R15: ffff880037b38280
[ 1426.432252] FS:  0000000000000000(0000) GS:ffff88003d600000(0000) knlGS:0000000000000000
[ 1426.432252] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1426.432252] CR2: fffffffffffffff8 CR3: 0000000030ff8000 CR4: 00000000000007f0
[ 1426.432252] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1426.432252] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1426.432252] Process kworker/u:0 (pid: 2086, threadinfo ffff88002e850000, task ffff880037b38000)
[ 1426.432252] Stack:
[ 1426.432252]  ffff88002e851928 ffffffff81055810 ffff88002e851928 ffff88003d7d2900
[ 1426.432252]  ffff88002e8519a8 ffffffff81780a38 ffff880000000000 ffffffff810bda82
[ 1426.432252]  ffff88002e851fd8 ffff880037b38000 ffff88002e851fd8 ffff88002e851fd8
[ 1426.432252] Call Trace:
[ 1426.432252]  [<ffffffff81055810>] wq_worker_sleeping+0x10/0xa0
[ 1426.432252]  [<ffffffff81780a38>] __schedule+0x538/0x7c0
[ 1426.432252]  [<ffffffff810bda82>] ? call_rcu_sched+0x12/0x20
[ 1426.432252]  [<ffffffff81780fa4>] schedule+0x24/0x70
[ 1426.432252]  [<ffffffff8103b8b0>] do_exit+0x600/0x9d0
[ 1426.432252]  [<ffffffff81039065>] ? kmsg_dump+0x105/0x160
[ 1426.432252]  [<ffffffff8178366e>] oops_end+0x9e/0xe0
[ 1426.432252]  [<ffffffff81037b65>] ? console_unlock+0x1e5/0x260
[ 1426.432252]  [<ffffffff81774e1e>] no_context+0x271/0x280
[ 1426.432252]  [<ffffffff810884b8>] ? __lock_acquire.isra.31+0x298/0x960
[ 1426.432252]  [<ffffffff81774ff3>] __bad_area_nosemaphore+0x1c6/0x1e5
[ 1426.432252]  [<ffffffff8106cd15>] ? sched_clock_local+0x25/0x90
[ 1426.432252]  [<ffffffff81775020>] bad_area_nosemaphore+0xe/0x10
[ 1426.432252]  [<ffffffff81785fbe>] do_page_fault+0x30e/0x500
[ 1426.432252]  [<ffffffff8106cea8>] ? sched_clock_cpu+0xa8/0x120
[ 1426.432252]  [<ffffffff810884b8>] ? __lock_acquire.isra.31+0x298/0x960
[ 1426.432252]  [<ffffffff810884b8>] ? __lock_acquire.isra.31+0x298/0x960
[ 1426.432252]  [<ffffffff8106cd15>] ? sched_clock_local+0x25/0x90
[ 1426.432252]  [<ffffffff812f810b>] ? __pci_remove_bus_device+0x3b/0xc0
[ 1426.432252]  [<ffffffff811a5220>] ? sysfs_write_file+0x180/0x180
[ 1426.432252]  [<ffffffff81782b7f>] page_fault+0x1f/0x30
[ 1426.432252]  [<ffffffff811a5220>] ? sysfs_write_file+0x180/0x180
[ 1426.432252]  [<ffffffff812f811b>] ? __pci_remove_bus_device+0x4b/0xc0
[ 1426.432252]  [<ffffffff812f81a9>] pci_stop_and_remove_bus_device+0x19/0x20
[ 1426.432252]  [<ffffffffa17ec0a4>] remove_callback+0x24/0x30 [fakephp]
[ 1426.432252]  [<ffffffff811a5233>] sysfs_schedule_callback_work+0x13/0x80
[ 1426.432252]  [<ffffffff81053462>] process_one_work+0x192/0x570
[ 1426.432252]  [<ffffffff810533f6>] ? process_one_work+0x126/0x570
[ 1426.432252]  [<ffffffff81054e7f>] worker_thread+0x15f/0x350
[ 1426.432252]  [<ffffffff81054d20>] ? manage_workers.isra.27+0x220/0x220
[ 1426.432252]  [<ffffffff81059f4d>] kthread+0x9d/0xb0
[ 1426.432252]  [<ffffffff8178b594>] kernel_thread_helper+0x4/0x10
[ 1426.432252]  [<ffffffff81059eb0>] ? __init_kthread_worker+0x70/0x70
[ 1426.432252]  [<ffffffff8178b590>] ? gs_change+0xb/0xb
[ 1426.432252] Code: eb 90 be 57 01 00 00 48 c7 c7 86 19 a1 81 e8 1d cb fd ff e9 77 fe ff ff 0f 1f 84 00 00 00 00 00 4
[ 1426.432252] RIP  [<ffffffff8105a41b>] kthread_data+0xb/0x20
[ 1426.432252]  RSP <ffff88002e851908>
[ 1426.432252] CR2: fffffffffffffff8
[ 1426.432252] ---[ end trace 5217fdeceed9de01 ]---
[ 1426.432252] Fixing recursive fault but reboot is needed!
[ 1428.998901] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
[ 1428.998901] panic occurred, switching back to text console

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/fakephp.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index a019c9a..ee6c79e 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -38,9 +38,24 @@ static ssize_t legacy_show(struct kobject *kobj, struct attribute *attr,
 	return 2;
 }
 
+static void rescan_callback(void *data)
+{
+	struct legacy_slot *slot = data;
+
+	pci_hotplug_enter();
+	if (!list_empty(&slot->list))
+		pci_rescan_bus(slot->dev->bus);
+	pci_hotplug_exit();
+}
+
 static void remove_callback(void *data)
 {
-	pci_stop_and_remove_bus_device((struct pci_dev *)data);
+	struct legacy_slot *slot = data;
+
+	pci_hotplug_enter();
+	if (!list_empty(&slot->list))
+		pci_stop_and_remove_bus_device(slot->dev);
+	pci_hotplug_exit();
 }
 
 static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
@@ -53,10 +68,11 @@ static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
 		return -EINVAL;
 
 	if (val)
-		pci_rescan_bus(slot->dev->bus);
+		sysfs_schedule_callback(&slot->kobj, rescan_callback,
+					slot, THIS_MODULE);
 	else
-		sysfs_schedule_callback(&slot->dev->dev.kobj, remove_callback,
-					slot->dev, THIS_MODULE);
+		sysfs_schedule_callback(&slot->kobj, remove_callback,
+					slot, THIS_MODULE);
 	return len;
 }
 
@@ -107,20 +123,25 @@ static int legacy_notify(struct notifier_block *nb,
 	struct pci_dev *pdev = to_pci_dev(data);
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		pci_hotplug_enter();
 		legacy_add_slot(pdev);
+		pci_hotplug_exit();
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		struct legacy_slot *slot;
 
+		pci_hotplug_enter();
 		list_for_each_entry(slot, &legacy_list, list)
 			if (slot->dev == pdev)
 				goto found;
 
+		pci_hotplug_exit();
 		dev_warn(&pdev->dev, "Missing legacy fake slot?");
 		return -ENODEV;
 found:
 		kobject_del(&slot->kobj);
-		list_del(&slot->list);
+		list_del_init(&slot->list);
 		kobject_put(&slot->kobj);
+		pci_hotplug_exit();
 	}
 
 	return 0;
@@ -135,11 +156,14 @@ static int __init init_legacy(void)
 	struct pci_dev *pdev = NULL;
 
 	/* Add existing devices */
+	pci_hotplug_disable();
 	for_each_pci_dev(pdev)
 		legacy_add_slot(pdev);
 
 	/* Be alerted of any new ones */
 	bus_register_notifier(&pci_bus_type, &legacy_notifier);
+	pci_hotplug_enable();
+
 	return 0;
 }
 module_init(init_legacy);
@@ -150,11 +174,13 @@ static void __exit remove_legacy(void)
 
 	bus_unregister_notifier(&pci_bus_type, &legacy_notifier);
 
+	pci_hotplug_disable();
 	list_for_each_entry_safe(slot, tmp, &legacy_list, list) {
-		list_del(&slot->list);
+		list_del_init(&slot->list);
 		kobject_del(&slot->kobj);
 		kobject_put(&slot->kobj);
 	}
+	pci_hotplug_enable();
 }
 module_exit(remove_legacy);
 
-- 
1.7.5.4

