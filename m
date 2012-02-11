Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2BKISv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 03:18:51 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42192 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2BKISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 03:18:50 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: fix memleak for pci dev removing during hotplug
Date: Sat, 11 Feb 2012 00:18:30 -0800
Message-Id: <1328948310-14748-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F362468.0032,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unreferenced object 0xffff880276d17700 (size 64):
  comm "swapper/0", pid 1, jiffies 4294897182 (age 3976.028s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 18 f9 de 76 02 88 ff ff  ...........v....
    10 00 00 00 0e 00 00 00 0f 28 40 00 00 00 00 00  .........(@.....
  backtrace:
    [<ffffffff81c8aede>] kmemleak_alloc+0x26/0x43
    [<ffffffff811385f0>] __kmalloc+0x121/0x183
    [<ffffffff813cf821>] pci_add_cap_save_buffer+0x35/0x7c
    [<ffffffff813d12b7>] pci_allocate_cap_save_buffers+0x1d/0x65
    [<ffffffff813cdb52>] pci_device_add+0x92/0xf1
    [<ffffffff81c8afe6>] pci_scan_single_device+0x9f/0xa1
    [<ffffffff813cdbd2>] pci_scan_slot.part.20+0x21/0x106
    [<ffffffff813cdce2>] pci_scan_slot+0x2b/0x35
    [<ffffffff81c8dae4>] __pci_scan_child_bus+0x51/0x107
    [<ffffffff81c8d75b>] pci_scan_bridge+0x376/0x6ae
    [<ffffffff81c8db60>] __pci_scan_child_bus+0xcd/0x107
    [<ffffffff81c8dbab>] pci_scan_child_bus+0x11/0x2a
    [<ffffffff81cca58c>] pci_acpi_scan_root+0x18b/0x21c
    [<ffffffff81c916be>] acpi_pci_root_add+0x1e1/0x42a
    [<ffffffff81406210>] acpi_device_probe+0x50/0x190
    [<ffffffff814a0227>] really_probe+0x99/0x126

Need to free saved_buffer for capabilities.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci.c   |    9 +++++++++
 drivers/pci/pci.h   |    1 +
 drivers/pci/probe.c |    1 +
 3 files changed, 11 insertions(+)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1225,6 +1225,7 @@ static void pci_release_capabilities(str
 {
 	pci_vpd_release(dev);
 	pci_iov_release(dev);
+	pci_free_cap_save_buffers(dev);
 }
 
 /**
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1916,6 +1916,15 @@ void pci_allocate_cap_save_buffers(struc
 			"unable to preallocate PCI-X save buffer\n");
 }
 
+void pci_free_cap_save_buffers(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *tmp;
+	struct hlist_node *pos, *n;
+
+	hlist_for_each_entry_safe(tmp, pos, n, &dev->saved_cap_space, next)
+		kfree(tmp);
+}
+
 /**
  * pci_enable_ari - enable ARI forwarding if hardware support it
  * @dev: the PCI device
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -73,6 +73,7 @@ extern int __pci_pme_wakeup(struct pci_d
 extern void pci_pm_init(struct pci_dev *dev);
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
+void pci_free_cap_save_buffers(struct pci_dev *dev);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {
