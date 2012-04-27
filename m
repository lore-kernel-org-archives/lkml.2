Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2D0PW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:22:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272Ab2D0PWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:22:54 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 19/19] PCI: hide sys interface 'remove' and 'rescan' for SR-IOV virtual devices
Date: Fri, 27 Apr 2012 23:17:00 +0800
Message-Id: <1335539820-11232-20-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

From: Jiang Liu <liuj97@gmail.com>

All SR-IOV virtual PCI devices should be managed by corresponding physical
device drivers. And the PCI core shouldn't create or destroy virtual PCI
devices directly without cordination with physical device drivers.
Otherwise it may cause system crashes like below.  So hide the remove and
rescan sys interfaces for SR-IOV virtual PCI devices.

Running following two scripts may trigger system dump on a system with
Intel 82576 NIC.

[root@localhost tests]# cat mod.sh
#!/bin/bash
while true; do
        modprobe igb max_vfs=2
        sleep 0.01
        rmmod igb
done
[root@localhost tests]# cat remove_virt.sh
#!/bin/bash
while true; do
        echo 1 > /sys/devices/pci0000:40/0000:40:03.0/0000:41:00.0/0000:42:02.0/0000:44:10.0/remove
        echo 1 > /sys/devices/pci0000:40/0000:40:03.0/0000:41:00.0/0000:42:02.0/0000:44:10.1/remove
        echo 1 > /sys/devices/pci0000:40/0000:40:03.0/0000:41:00.0/0000:42:02.0/0000:44:10.2/remove
        echo 1 > /sys/devices/pci0000:40/0000:40:03.0/0000:41:00.0/0000:42:02.0/0000:43:10.3/rescan
        sleep 0.01
done

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:481 sysfs_add_one+0xb8/0xd0()
Hardware name: FBSA
sysfs: cannot create duplicate filename '/devices/pci0000:40/0000:40:03.0/0000:41:00.0/0000:42:02.0/0000:43:00.0/virtfn0'
Modules linked in: igb(+) igbvf fuse ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat bridge autofs4 sunrpc 8021q fcoe libfcoe garp stp llc libfc scsi_transport_fc scsi_tgt cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm uinput wmi pcspkr sg iTCO_wdt iTCO_vendor_support e1000e i2c_i801 i2c_core ioatdma ixgbe dca mdio ext4 mbcache jbd2 sd_mod crc_t10dif ahci libahci [last unloaded: igb]
Pid: 6297, comm: work_for_cpu Not tainted 3.2.0IOAT+ #1
Call Trace:
 [<ffffffff81060c1f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81060d16>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff811d0428>] sysfs_add_one+0xb8/0xd0
 [<ffffffff811d15ab>] sysfs_do_create_link+0x13b/0x210
 [<ffffffff81242330>] ? sprintf+0x40/0x50
 [<ffffffff811d16b3>] sysfs_create_link+0x13/0x20
 [<ffffffff81272d33>] virtfn_add+0x283/0x430
 [<ffffffff81273252>] pci_enable_sriov+0x232/0x4c0
 [<ffffffffa049ae1b>] igb_probe+0x6b4/0x1212 [igb]
 [<ffffffff81321aa2>] ? __pm_runtime_set_status+0x172/0x210
 [<ffffffff8125dc0f>] local_pci_probe+0x5f/0xd0
 [<ffffffff8107ab60>] ? move_linked_works+0x90/0x90
 [<ffffffff8107ab78>] do_work_for_cpu+0x18/0x30
 [<ffffffff810829e6>] kthread+0x96/0xa0
 [<ffffffff814e4ab4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81082950>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814e4ab0>] ? gs_change+0x13/0x13
---[ end trace 7c33eee57d617c55 ]---
libfcoe_device_notification: NETDEV_UNREGISTER eth3
Trying to free nonexistent resource <00000000e1660000-00000000e1663fff>
Trying to free nonexistent resource <00000000e1640000-00000000e1643fff>
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8124a529>] __list_del_entry+0x29/0xd0
PGD 3fdf7e3067 PUD 3fdf45d067 PMD 0
Oops: 0000 [#1] SMP
CPU 8
Modules linked in: igb(+) igbvf fuse ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat bridge autofs4 sunrpc 8021q fcoe libfcoe garp stp llc libfc scsi_transport_fc scsi_tgt cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm uinput wmi pcspkr sg iTCO_wdt iTCO_vendor_support e1000e i2c_i801 i2c_core ioatdma ixgbe dca mdio ext4 mbcache jbd2 sd_mod crc_t10dif ahci libahci [last unloaded: igb]

Pid: 6297, comm: work_for_cpu Tainted: G        W    3.2.0IOAT+ #1 INSYDE FBSA/Type2 - Board Product Name1
RIP: 0010:[<ffffffff8124a529>]  [<ffffffff8124a529>] __list_del_entry+0x29/0xd0
RSP: 0018:ffff883fdb499cb0  EFLAGS: 00010207
RAX: 0000000000000000 RBX: ffff881fdde1e000 RCX: dead000000200200
RDX: 0000000000000000 RSI: ffffffff81238d10 RDI: ffff881fdde1e000
RBP: ffff883fdb499cb0 R08: ffff881fdde1e0a8 R09: 0000000000000000
R10: 00000000000009c5 R11: 0000000000000000 R12: 0000000000000011
R13: ffff881fdde1e000 R14: ffff883fdb499d30 R15: ffff883fe07ae0a0
FS:  0000000000000000(0000) GS:ffff88203fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000003fdf88c000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process work_for_cpu (pid: 6297, threadinfo ffff883fdb498000, task ffff883fda832a70)
Stack:
 ffff883fdb499cd0 ffffffff8124a5e1 ffff883fe07ae000 0000000000000000
 ffff883fdb499d00 ffffffff81259467 ffff883fdb499d00 ffff881fdde1e000
 ffff883fe07ae000 ffff882fe0f87b40 ffff883fdb499d80 ffffffff81272d64
Call Trace:
 [<ffffffff8124a5e1>] list_del+0x11/0x40
 [<ffffffff81259467>] pci_remove_bus_device+0x57/0xd0
 [<ffffffff81272d64>] virtfn_add+0x2b4/0x430
 [<ffffffff81273252>] pci_enable_sriov+0x232/0x4c0
 [<ffffffffa049ae1b>] igb_probe+0x6b4/0x1212 [igb]
 [<ffffffff81321aa2>] ? __pm_runtime_set_status+0x172/0x210
 [<ffffffff8125dc0f>] local_pci_probe+0x5f/0xd0
 [<ffffffff8107ab60>] ? move_linked_works+0x90/0x90
 [<ffffffff8107ab78>] do_work_for_cpu+0x18/0x30
 [<ffffffff810829e6>] kthread+0x96/0xa0
 [<ffffffff814e4ab4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81082950>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814e4ab0>] ? gs_change+0x13/0x13
Code: 90 90 55 48 8b 17 48 b9 00 01 10 00 00 00 ad de 48 8b 47 08 48 89 e5 48 39 ca 74 29 48 b9 00 02 20 00 00 00 ad de 48 39 c8 74 7a <4c> 8b 00 4c 39 c7 75 53 4c 8b 42 08 4c 39 c7 75 2b 48 89 42 08
RIP  [<ffffffff8124a529>] __list_del_entry+0x29/0xd0
 RSP <ffff883fdb499cb0>
CR2: 0000000000000000
---[ end trace 7c33eee57d617c56 ]---

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/pci-sysfs.c |   34 ++++++++++++++++++++++++++++++----
 include/linux/pci.h     |    4 +++-
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index bc3c422..348995d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -367,6 +367,9 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 	return schedule_hp_callback(dev, buf, count, remove_callback);
 }
 
+static struct device_attribute pci_dev_remove_attr =
+	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store);
+
 static void dev_bus_rescan_callback(struct device *dev)
 {
 	struct pci_bus *bus = to_pci_bus(dev);
@@ -389,6 +392,8 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 	return schedule_hp_callback(dev, buf, count, dev_bus_rescan_callback);
 }
 
+static struct device_attribute pci_dev_rescan_attr =
+	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store);
 #endif
 
 struct device_attribute pci_dev_attrs[] = {
@@ -411,10 +416,6 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
-#ifdef CONFIG_HOTPLUG
-	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
-	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
-#endif
 	__ATTR_NULL,
 };
 
@@ -1350,6 +1351,30 @@ static int __init pci_sysfs_init(void)
 
 late_initcall(pci_sysfs_init);
 
+static struct attribute *pci_dev_phys_attrs[] = {
+#ifdef CONFIG_HOTPLUG
+	&pci_dev_remove_attr.attr,
+	&pci_dev_rescan_attr.attr,
+#endif
+	NULL
+};
+
+static umode_t pci_dev_phys_attrs_are_visible(struct kobject *kobj,
+					      struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+
+	if (dev_is_pf(dev))
+		return a->mode;
+
+	return 0;
+}
+
+static struct attribute_group pci_dev_phys_attr_group = {
+	.attrs = pci_dev_phys_attrs,
+	.is_visible = pci_dev_phys_attrs_are_visible,
+};
+
 static struct attribute *pci_dev_bridge_attrs[] = {
 	NULL,
 };
@@ -1373,6 +1398,7 @@ static struct attribute_group pci_dev_bridge_attr_group = {
 
 static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_bridge_attr_group,
+	&pci_dev_phys_attr_group,
 	NULL,
 };
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1c5f153..6c2c5c9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -692,7 +692,8 @@ extern void pci_stop_bus_device(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
 extern void pci_sort_breadthfirst(void);
 #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
-#define dev_is_pf(d) ((dev_is_pci(d) ? to_pci_dev(d)->is_physfn : false))
+#define dev_is_vf(d) ((dev_is_pci(d) ? to_pci_dev(d)->is_virtfn : false))
+#define dev_is_pf(d) (!dev_is_vf(d))
 #define dev_num_vf(d) ((dev_is_pci(d) ? pci_num_vf(to_pci_dev(d)) : 0))
 
 /* Generic PCI functions exported to card drivers */
@@ -1343,6 +1344,7 @@ static inline int pci_domain_nr(struct pci_bus *bus)
 
 #define dev_is_pci(d) (false)
 #define dev_is_pf(d) (false)
+#define dev_is_vf(d) (false)
 #define dev_num_vf(d) (0)
 #endif /* CONFIG_PCI */
 
-- 
1.7.5.4

