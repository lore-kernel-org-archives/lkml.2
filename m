Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2HYKAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 06:00:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63796 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2HYKAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 06:00:06 -0400
Message-ID: <5038A21C.4070200@huawei.com>
Date: Sat, 25 Aug 2012 17:59:56 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, PCI <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Jiang Liu <liuj97@gmail.com>
Subject: [RESEND BUGFIX PATCH 3/3] PCI: check whether pci device has been
 removed when remove a pci device by sysfs
References: <1344685946-8172-3-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1344685946-8172-3-git-send-email-wangyijing@huawei.com>
X-Forwarded-Message-Id: <1344685946-8172-3-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We remove a pci device maybe like this
echo 1 > /sys/bus/pci/devices/xxxx:xx:xx.x/remove
Then remove_store function will be called to complete this remove work,
later the remove work will be queued to sysfs_workqueue by device_schedule_callback.
So if we remove a pci root port device and a pci endpoint device which was the root
port's child device concurrently.The endponit device will be removed when root port's
remove work completed,so when endpoint device itself's remove work start, since endpoint
device has been removed, it will result to oops.
This patch fix this.

CallTrace:
kworker/u:2[220]: Oops 11003706212352 [1]
Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi
_cpufreq binfmt_misc fuse nls_iso8859_1 loop ipmi_si ipmi_devintf ipmi_msghandle
r dm_mod igb ppdev iTCO_wdt parport_pc iTCO_vendor_support i2c_i801 parport sg m
ptctl serio_raw i2c_core lpc_ich mfd_core hid_generic button container usbhid hi
d uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif ext3 mbcache jbd fan pr
ocessor ide_pci_generic ide_core ata_piix libata mptsas mptscsih mptbase scsi_tr
ansport_sas scsi_mod thermal thermal_sys hwmon

Pid: 220, CPU 30, comm:          kworker/u:2
psr : 0000121008526030 ifs : 8000000000000388 ip  : [<a0000001004b3081>]    Not
tainted (3.5.0-rc6yijing-repo)
ip is at __pci_remove_bus_device+0x101/0x1e0
unat: 0000000000000000 pfs : 0000000000000388 rsc : 0000000000000003
rnat: ffffffffffffffff bsps: ffffffffffffffff pr  : 0000080001919585
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c9e70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001004b3060 b6  : a0000001004c2400 b7  : a0000001000faae0
f6  : 000000000000000000000 f7  : 1003e00000000000057cd
f8  : 1003e0000000050000003 f9  : 1003e000001cb8678a0d0
f10 : 1003e9a05b7a39369e270 f11 : 1003e000000000000008f
r1  : a0000001014e63c0 r2  : e000001f075dec00 r3  : 0000000000000000
r8  : 0000000000000008 r9  : a0000001012e7308 r10 : 0000000004000000
r11 : e000000f0006e800 r12 : e000001f08dbfe00 r13 : e000001f08db0000
r14 : 0000000000000000 r15 : 0000000000000000 r16 : 0000000000000000
r17 : e000000f0006f008 r18 : 000000000f000000 r19 : a0000001012f3910
r20 : 0000000000100001 r21 : a000000101a62990 r22 : a000000100344580
r23 : 0000000000000000 r24 : 0000000000001000 r25 : 0000000000000000
r26 : a000000101a62988 r27 : e000003f0fc37e60 r28 : e000003f0fc37e68
r29 : e000002f07012be0 r30 : 0000000082aa0260 r31 : 0000000000004000

Call Trace:
 [<a000000100016500>] show_stack+0x80/0xa0
                                sp=e000001f08dbf9c0 bsp=e000001f08db1388
 [<a000000100016b60>] show_regs+0x640/0x920
                                sp=e000001f08dbfb90 bsp=e000001f08db1330
 [<a000000100040770>] die+0x190/0x2c0
                                sp=e000001f08dbfba0 bsp=e000001f08db12f0
 [<a000000100908f60>] ia64_do_page_fault+0x7e0/0xac0
                                sp=e000001f08dbfba0 bsp=e000001f08db1290
 [<a00000010000c0a0>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000001f08dbfc30 bsp=e000001f08db1290
 [<a0000001004b3080>] __pci_remove_bus_device+0x100/0x1e0
                                sp=e000001f08dbfe00 bsp=e000001f08db1250
 [<a0000001004b32f0>] pci_stop_and_remove_bus_device+0x30/0x60
                                sp=e000001f08dbfe00 bsp=e000001f08db1230
 [<a0000001004c2440>] remove_callback+0x40/0x80
                                sp=e000001f08dbfe00 bsp=e000001f08db1208
 [<a0000001003445d0>] sysfs_schedule_callback_work+0x50/0x120
                                sp=e000001f08dbfe00 bsp=e000001f08db11d0
 [<a0000001000bc2d0>] process_one_work+0x6f0/0xae0
                                sp=e000001f08dbfe00 bsp=e000001f08db1158
 [<a0000001000bcf70>] worker_thread+0x3b0/0xc80
                                sp=e000001f08dbfe00 bsp=e000001f08db1060
 [<a0000001000cf050>] kthread+0x110/0x140
                                sp=e000001f08dbfe00 bsp=e000001f08db1028
 [<a000000100014590>] kernel_thread_helper+0x30/0x60
                                sp=e000001f08dbfe30 bsp=e000001f08db1000
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e000001f08dbfe30 bsp=e000001f08db1000
Disabling lock debugging due to kernel taint
Unable to handle kernel NULL pointer dereference (address 0000000000000048)
kworker/u:2[220]: Oops 11012296146944 [2]

Pid: 220, CPU 30, comm:          kworker/u:2
psr : 0000121008022038 ifs : 8000000000000288 ip  : [<a0000001000c4961>]    Tain
ted: G      D      (3.5.0-rc6yijing-repo)
ip is at wq_worker_sleeping+0x61/0x200
unat: 0000000000000000 pfs : 0000000000000288 rsc : 0000000000000003
rnat: 0000121008026038 bsps: a0000001000407e0 pr  : 965a684515516955
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000c4920 b6  : a0000001000f9fc0 b7  : a0000001000faae0
f6  : 000000000000000000000 f7  : 1003e9e3779b97f4a7c16
f8  : 1003e0000000050000003 f9  : 1003e000001cb87e8a5a8
f10 : 1003e9a78b92717b9f0f8 f11 : 1003e000000000000008f
r1  : a0000001014e63c0 r2  : 0000000000000000 r3  : fffffffffffc1200
r8  : 0000000000000000 r9  : 000000000000001e r10 : a000000101432530
r11 : a000000101432530 r12 : e000001f08dbfb70 r13 : e000001f08db0000
r14 : 0000000000001000 r15 : a000000101432620 r16 : e000003000245d40
r17 : fffffffffffc5c00 r18 : e000003000245d00 r19 : 00000000000000f8
r20 : e000001f08db0070 r21 : 0000000000000048 r22 : e000003000245ce8
r23 : e000003000245ce0 r24 : a000000101a638e0 r25 : ffffffffff48e500
r26 : e000003f088a0098 r27 : 0000000000000400 r28 : 0000000000000001
r29 : 000000000420806c r30 : e000001f08db0014 r31 : 0000000000000000

Call Trace:
 [<a000000100016500>] show_stack+0x80/0xa0
                                sp=e000001f08dbf730 bsp=e000001f08db16f8
 [<a000000100016b60>] show_regs+0x640/0x920
                                sp=e000001f08dbf900 bsp=e000001f08db16a0
 [<a000000100040770>] die+0x190/0x2c0
                                sp=e000001f08dbf910 bsp=e000001f08db1660
 [<a000000100908f60>] ia64_do_page_fault+0x7e0/0xac0
                                sp=e000001f08dbf910 bsp=e000001f08db1600
 [<a00000010000c0a0>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000001f08dbf9a0 bsp=e000001f08db1600
 [<a0000001000c4960>] wq_worker_sleeping+0x60/0x200
                                sp=e000001f08dbfb70 bsp=e000001f08db15b8
 [<a0000001009007e0>] __schedule+0x14c0/0x18c0
                                sp=e000001f08dbfb70 bsp=e000001f08db1440
 [<a000000100900ea0>] schedule+0x60/0x140
                                sp=e000001f08dbfb80 bsp=e000001f08db13e0
 [<a000000100090d10>] do_exit+0xef0/0x1740
                                sp=e000001f08dbfb80 bsp=e000001f08db1330
 [<a000000100040840>] die+0x260/0x2c0
                                sp=e000001f08dbfba0 bsp=e000001f08db12f0
 [<a000000100908f60>] ia64_do_page_fault+0x7e0/0xac0
                                sp=e000001f08dbfba0 bsp=e000001f08db1290
 [<a00000010000c0a0>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000001f08dbfc30 bsp=e000001f08db1290
 [<a0000001004b3080>] __pci_remove_bus_device+0x100/0x1e0
                                sp=e000001f08dbfe00 bsp=e000001f08db1250
 [<a0000001004b32f0>] pci_stop_and_remove_bus_device+0x30/0x60
                                sp=e000001f08dbfe00 bsp=e000001f08db1230
 [<a0000001004c2440>] remove_callback+0x40/0x80
                                sp=e000001f08dbfe00 bsp=e000001f08db1208
 [<a0000001003445d0>] sysfs_schedule_callback_work+0x50/0x120
                                sp=e000001f08dbfe00 bsp=e000001f08db11d0
 [<a0000001000bc2d0>] process_one_work+0x6f0/0xae0
                                sp=e000001f08dbfe00 bsp=e000001f08db1158
 [<a0000001000bcf70>] worker_thread+0x3b0/0xc80
                                sp=e000001f08dbfe00 bsp=e000001f08db1060
 [<a0000001000cf050>] kthread+0x110/0x140
                                sp=e000001f08dbfe00 bsp=e000001f08db1028
 [<a000000100014590>] kernel_thread_helper+0x30/0x60
                                sp=e000001f08dbfe30 bsp=e000001f08db1000
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e000001f08dbfe30 bsp=e000001f08db1000
Fixing recursive fault but reboot is needed!
Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi
_cpufreq binfmt_misc fuse nls_iso8859_1 loop ipmi_si ipmi_devintf ipmi_msghandle
r dm_mod igb ppdev iTCO_wdt parport_pc iTCO_vendor_support i2c_i801 parport sg m
ptctl serio_raw i2c_core lpc_ich mfd_core hid_generic button container usbhid hi
d uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif ext3 mbcache jbd fan pr
ocessor ide_pci_generic ide_core ata_piix libata mptsas mptscsih mptbase scsi_tr
ansport_sas scsi_mod thermal thermal_sys hwmon

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci-sysfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 6869009..b0be682 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -332,7 +332,10 @@ static void remove_callback(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);

 	mutex_lock(&pci_remove_rescan_mutex);
+	if (!pdev->is_added)
+		goto out;
 	pci_stop_and_remove_bus_device(pdev);
+out:
 	mutex_unlock(&pci_remove_rescan_mutex);
 }

-- 
1.7.1



.




