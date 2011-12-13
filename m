Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1LMJHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:07:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:18940 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1LMJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:06:57 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] pciehp: Checking pci conf reading to new added device instead of sleep 1s
Date: Tue, 13 Dec 2011 01:05:54 -0800
Message-Id: <1323767154-6859-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EE715AB.0056,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During reviewing
|	PCI: pciehp: wait 1000 ms before Link Training check
Linus said:
>...
> That's a *long* time, and it's irritating to the user. It makes the
> user think "the machine is slow".
>...
> And quite frankly, an unconditional one-second delay here seems bad.
>Two seconds was unacceptable, one second is just bad.

Try to access the pci conf of pci device that is supposed to show up in 1s,
if could read back valid vender/device id, could bail out early.

Related discussion could be found:
	https://lkml.org/lkml/2011/12/6/339

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/hotplug/pciehp_hpc.c |   63 +++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
@@ -265,6 +265,51 @@ static void pcie_wait_link_active(struct
 	ctrl_dbg(ctrl, "Data Link Layer Link Active not set in 1000 msec\n");
 }
 
+static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
+{
+	u32 l;
+	int count = 0;
+	u32 lx[50];
+	int delay = 1000, step = 20;
+	bool found = false;
+
+again:
+	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l))
+		goto wait;
+
+	lx[count++] = l;
+
+	/* some broken boards return 0 or ~0 if a slot is empty: */
+	if (l == 0xffffffff || l == 0x00000000 ||
+	    l == 0x0000ffff || l == 0xffff0000)
+		goto wait;
+
+	/* Configuration request Retry Status */
+	if (l == 0xffff0001)
+		goto wait;
+
+	found = true;
+	goto printout;
+
+wait:
+	msleep(step);
+	delay -= step;
+	if (delay > 0)
+		goto again;
+
+printout:
+	if (count > 1) {
+		int i;
+		printk(KERN_DEBUG "pci %04x:%02x:%02x.%d id reading try %d times with interval %d ms\n",
+			pci_domain_nr(bus), bus->number, PCI_SLOT(devfn),
+			PCI_FUNC(devfn), count, step);
+		for (i = 0; i < count; i++)
+			printk(KERN_DEBUG "  [%02d]=%08x\n", i, lx[i]);
+	}
+
+	return found;
+}
+
 int pciehp_check_link_status(struct controller *ctrl)
 {
 	u16 lnk_status;
@@ -280,13 +325,9 @@ int pciehp_check_link_status(struct cont
         else
                 msleep(1000);
 
-	/*
-	 * Need to wait for 1000 ms after Data Link Layer Link Active
-	 * (DLLLA) bit reads 1b before sending configuration request.
-	 * We need it before checking Link Training (LT) bit becuase
-	 * LT is still set even after DLLLA bit is set on some platform.
-	 */
-	msleep(1000);
+	/* wait 100ms before read pci conf, and try in 1s */
+	msleep(100);
+	pci_bus_check_dev(ctrl->pcie->port->subordinate, PCI_DEVFN(0, 0));
 
 	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
 	if (retval) {
@@ -302,14 +343,6 @@ int pciehp_check_link_status(struct cont
 		return retval;
 	}
 
-	/*
-	 * If the port supports Link speeds greater than 5.0 GT/s, we
-	 * must wait for 100 ms after Link training completes before
-	 * sending configuration request.
-	 */
-	if (ctrl->pcie->port->subordinate->max_bus_speed > PCIE_SPEED_5_0GT)
-		msleep(100);
-
 	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
 
 	return retval;
