Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3ACPjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:39:44 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53007 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3ACPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:39:42 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.69.232]
Date: Thu, 3 Jan 2013 23:11:17 +0800
Message-ID: <CAMVG2ssiRgcTD1bej2tkUUfsWmpL5eNtPcNif9va2-Gzb2u8nQ@mail.gmail.com>
Subject: 3.8-rc2: pciehp waitqueue hang...
From: Daniel J Blueman <daniel@quora.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the Apple thunderbolt ethernet adapter comes loose on my Macbook
Pro Retina (Intel DSL3510), we see pci_slot_name return
non-deterministic data (ie varying each boot), and we see pciehp_wp
remain armed with events causing the kthread to get stuck:

tg3 0000:0a:00.0 eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:0a:00.0 eth0: Flow control is on for TX and on for RX
<thunderbold adapter comes loose>
pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
clear MAC_TX_MODE=ffffffff
tg3 0000:0a:00.0 eth0: No firmware running
tg3 0000:0a:00.0 eth0: Link is down
pcieport 0000:00:01.1: System wakeup enabled by ACPI
pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
pciehp 0000:09:00.0:pcie24: Latch open on
Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
pciehp 0000:09:00.0:pcie24: Button pressed on
Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
pciehp 0000:09:00.0:pcie24: Card present on
Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
pciehp 0000:09:00.0:pcie24: Power fault on slot
\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
pciehp 0000:09:00.0:pcie24: PCI slot
#\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
- powering on due to button press.
pciehp 0000:09:00.0:pcie24: Link Training Error occurs
pciehp 0000:09:00.0:pcie24: Failed to check link status
INFO: task kworker/0:1:52 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:1   D ffff880265893090   0  52   2 0x00000000
 ffff8802655456f8 0000000000000046 ffffffff81a21a60 ffff880265545fd8
 0000000000004000 ffff880265545fd8 ffff880265892bb0 ffff880265adc8d0
 000000000000059e 0000000000000082 ffff880265545668 ffffffff810415aa
Call Trace:
 [<ffffffff810415aa>] ? console_unlock+0x1fa/0x4a0
 [<ffffffff8108d16d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81041b19>] ? vprintk_emit+0x1c9/0x510
 [<ffffffff81558db4>] schedule+0x24/0x70
 [<ffffffff8155653c>] schedule_timeout+0x19c/0x1e0
 [<ffffffff81558c43>] wait_for_common+0xe3/0x180
 [<ffffffff8105adc1>] ? flush_workqueue+0x111/0x4d0
 [<ffffffff81071140>] ? try_to_wake_up+0x2d0/0x2d0
 [<ffffffff81558d88>] wait_for_completion+0x18/0x20
 [<ffffffff8105ae86>] flush_workqueue+0x1d6/0x4d0
 [<ffffffff8105acb0>] ? flush_workqueue_prep_cwqs+0x200/0x200
 [<ffffffff8125e909>] pciehp_release_ctrl+0x39/0x90
 [<ffffffff8125b945>] pciehp_remove+0x25/0x30
 [<ffffffff81255bf2>] pcie_port_remove_service+0x52/0x70
 [<ffffffff81306a27>] __device_release_driver+0x77/0xe0
 [<ffffffff81306ab9>] device_release_driver+0x29/0x40
 [<ffffffff813064b1>] bus_remove_device+0xf1/0x140
 [<ffffffff81303fe7>] device_del+0x127/0x1c0
 [<ffffffff81255d70>] ? resume_iter+0x40/0x40
 [<ffffffff81304091>] device_unregister+0x11/0x20
 [<ffffffff81255da5>] remove_iter+0x35/0x40
 [<ffffffff81302eb6>] device_for_each_child+0x36/0x70
 [<ffffffff81256341>] pcie_port_device_remove+0x21/0x40
 [<ffffffff81256588>] pcie_portdrv_remove+0x28/0x50
 [<ffffffff8124a821>] pci_device_remove+0x41/0xc0
 [<ffffffff81306a27>] __device_release_driver+0x77/0xe0
 [<ffffffff81306ab9>] device_release_driver+0x29/0x40
 [<ffffffff813064b1>] bus_remove_device+0xf1/0x140
 [<ffffffff81303fe7>] device_del+0x127/0x1c0
 [<ffffffff81304091>] device_unregister+0x11/0x20
 [<ffffffff8124566c>] pci_stop_bus_device+0x8c/0xa0
 [<ffffffff81245615>] pci_stop_bus_device+0x35/0xa0
 [<ffffffff81245811>] pci_stop_and_remove_bus_device+0x11/0x20
 [<ffffffff8125cc91>] pciehp_unconfigure_device+0x91/0x190
 [<ffffffff8125c76d>] ? pciehp_power_thread+0x2d/0x110
 [<ffffffff8125c591>] pciehp_disable_slot+0x71/0x220
 [<ffffffff8125c826>] pciehp_power_thread+0xe6/0x110
 [<ffffffff8105d203>] process_one_work+0x193/0x550
 [<ffffffff8105d1a1>] ? process_one_work+0x131/0x550
 [<ffffffff8125c740>] ? pciehp_disable_slot+0x220/0x220
 [<ffffffff8105d96d>] worker_thread+0x15d/0x400
 [<ffffffff8109213d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8105d810>] ? rescuer_thread+0x210/0x210
 [<ffffffff81062bd6>] kthread+0xd6/0xe0
 [<ffffffff8155a18b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffff81062b00>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8155ae6c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81062b00>] ? __init_kthread_worker+0x70/0x70
-- 
Daniel J Blueman
