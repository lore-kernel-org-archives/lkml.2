Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2AUJxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:53:31 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:59924 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2AUJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:52:55 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/7] PCI: Make sriov work with hotplug remove
Date: Sat, 21 Jan 2012 01:52:13 -0800
Message-Id: <1327139539-14301-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F1A8AE9.005C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot remove pci express module that have pcie switch and support SRIOV, got

[ 5918.610127] pciehp 0000:80:02.2:pcie04: pcie_isr: intr_loc 1
[ 5918.615779] pciehp 0000:80:02.2:pcie04: Attention button interrupt received
[ 5918.622730] pciehp 0000:80:02.2:pcie04: Button pressed on Slot(3)
[ 5918.629002] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 1f9
[ 5918.637416] pciehp 0000:80:02.2:pcie04: PCI slot #3 - powering off due to button press.
[ 5918.647125] pciehp 0000:80:02.2:pcie04: pcie_isr: intr_loc 10
[ 5918.653039] pciehp 0000:80:02.2:pcie04: pciehp_green_led_blink: SLOTCTRL a8 write cmd 200
[ 5918.661229] pciehp 0000:80:02.2:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd c0
[ 5924.667627] pciehp 0000:80:02.2:pcie04: Disabling domain:bus:device=0000:b0:00
[ 5924.674909] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 2f9
[ 5924.683262] pciehp 0000:80:02.2:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:b0:00
[ 5924.693976] libfcoe_device_notification: NETDEV_UNREGISTER eth6
[ 5924.764979] libfcoe_device_notification: NETDEV_UNREGISTER eth14
[ 5924.873539] libfcoe_device_notification: NETDEV_UNREGISTER eth15
[ 5924.995209] libfcoe_device_notification: NETDEV_UNREGISTER eth16
[ 5926.114407] sxge 0000:b2:00.0: PCI INT A disabled
[ 5926.119342] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 5926.127189] IP: [<ffffffff81353a3b>] pci_stop_bus_device+0x33/0x83
[ 5926.133377] PGD 0
[ 5926.135402] Oops: 0000 [#1] SMP
[ 5926.138659] CPU 2
[ 5926.140499] Modules linked in:
...
[ 5926.143754]
[ 5926.275823] Call Trace:
[ 5926.278267]  [<ffffffff81353a38>] pci_stop_bus_device+0x30/0x83
[ 5926.284180]  [<ffffffff81353af4>] pci_remove_bus_device+0x1a/0xba
[ 5926.290264]  [<ffffffff81366311>] pciehp_unconfigure_device+0x110/0x17b
[ 5926.296866]  [<ffffffff81365dd9>] ? pciehp_disable_slot+0x188/0x188
[ 5926.303123]  [<ffffffff81365d6f>] pciehp_disable_slot+0x11e/0x188
[ 5926.309206]  [<ffffffff81365e68>] pciehp_power_thread+0x8f/0xe0
...

 +-[0000:80]-+-00.0-[81-8f]--
 |           +-01.0-[90-9f]--
 |           +-02.0-[a0-af]--
 |           +-02.2-[b0-bf]----00.0-[b1-b3]--+-02.0-[b2]--+-00.0 Device
 |           |                               |            +-00.1 Device
 |           |                               |            +-00.2 Device
 |           |                               |            \-00.3 Device
 |           |                               \-03.0-[b3]--+-00.0 Device
 |           |                                            +-00.1 Device
 |           |                                            +-00.2 Device
 |           |                                            \-00.3 Device

root complex: 80:02.2
pci express modules: have pcie switch and are listed as b0:00.0, b1:02.0 and b1:03.0.
                end devices  are b2:00.0 and b3.00.0.
                VFs are: b2:00.1,... b2:00.3, and b3:00.1,...,b3:00.3

Root cause: when doing pci_stop_bus_device() with phys fn, it will stop virt fn and
remove the fn, so
	list_for_each_safe(l, n, &bus->devices)
will have problem to refer freed n that is pointed to vf entry.

Solution is just replacing list_for_each_safe() with list_for_each().
	pci_stop_bus_device(dev) will not remove dev from bus->devices list,
	so We only need use for_each here.

During reviewing the patch, Bjorn said:
|   The PCI hot-remove path calls pci_stop_bus_devices() via
|   pci_remove_bus_device().
|
|   pci_stop_bus_devices() traverses the bus->devices list (point A below),
|   stopping each device in turn, which calls the driver remove() method.  When
|   the device is an SR-IOV PF, the driver calls pci_disable_sriov(), which
|   also uses pci_remove_bus_device() to remove the VF devices from the
|   bus->devices list (point B).
|
|       pci_remove_bus_device
|         pci_stop_bus_device
|           pci_stop_bus_devices(subordinate)
|             list_for_each(bus->devices)             <-- A
|               pci_stop_bus_device(PF)
|                 ...
|                   driver->remove
|                     pci_disable_sriov
|                       ...
|                         pci_remove_bus_device(VF)
|                             <remove from bus_list>  <-- B
|
|   At B, we're changing the same list we're iterating through at A, so when
|   the driver remove() method returns, the pci_stop_bus_devices() iterator has
|   a pointer to a list entry that has already been freed.

Discussion thread can be found : https://lkml.org/lkml/2011/10/15/141

-v2: updated changelog.
-v3: According to Kenji, do not allocate another list for PF.
     Also We don't need to check dev->is_virtfn anymore, because PF should come
	first in the list, and even VF come first, it is still ok.
-v4: According to Kenji, expand list_for_each(), and add is_virtfn checking

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 7f87bee..932c5e2 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -123,10 +123,36 @@ void pci_remove_behind_bridge(struct pci_dev *dev)
 static void pci_stop_bus_devices(struct pci_bus *bus)
 {
 	struct list_head *l, *n;
+	struct list_head *head = &bus->devices;
 
+	/*
+	 * pci_stop_bus_device(dev) will not remove dev from bus->devices list,
+	 *  so We don't need use _safe version for_each here.
+	 * Also _safe version has problem when pci_stop_bus_device() for PF try
+	 *  to remove VFs.
+	 */
+	for (l = head->next; l != head;) {
+		struct pci_dev *dev = pci_dev_b(l);
+
+		/*
+		 * VFs are removed by pci_remove_bus_device() in the
+		 *  pci_stop_bus_devices() code path for PF.
+		 *  aka, bus->devices get updated in the process.
+		 * barrier() will make sure we get right next from that list.
+		 */
+		if (!dev->is_virtfn) {
+			pci_stop_bus_device(dev);
+			barrier();
+		}
+		l = l->next;
+	}
+
+	/* For left over VFs in case */
 	list_for_each_safe(l, n, &bus->devices) {
 		struct pci_dev *dev = pci_dev_b(l);
-		pci_stop_bus_device(dev);
+
+		if (dev->is_virtfn)
+			pci_stop_bus_device(dev);
 	}
 }
 
-- 
1.7.7

