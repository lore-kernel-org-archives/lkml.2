Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2A0S4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:56:25 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40361 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2A0Szh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:55:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/7] pciehp: Checking pci conf reading to new added device instead of sleep 1s
Date: Fri, 27 Jan 2012 10:55:11 -0800
Message-Id: <1327690515-2991-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F22F323.0042,ss=1,re=0.000,fgs=0
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

-v2: seperate code to pci_bus_read_dev_vendor_id() from pci_scan_device()
    and reuse it from pciehp code. Suggested by Matthew Wilcox.
-v3: According to Kenj, don't use array in stack, and don't wait too long
    for crs, also return fail status if not found.
    Also separate pci_bus_dev_read_vendor_id() change to another patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c |   49 ++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 7b14148..ad8c1be 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -265,10 +265,37 @@ static void pcie_wait_link_active(struct controller *ctrl)
 	ctrl_dbg(ctrl, "Data Link Layer Link Active not set in 1000 msec\n");
 }
 
+static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
+{
+	u32 l;
+	int count = 0;
+	int delay = 1000, step = 20;
+	bool found = false;
+
+	do {
+		found = pci_bus_read_dev_vendor_id(bus, devfn, &l, 0);
+		count++;
+
+		if (found)
+			break;
+
+		msleep(step);
+		delay -= step;
+	} while (delay > 0);
+
+	if (count > 1 && pciehp_debug)
+		printk(KERN_DEBUG "pci %04x:%02x:%02x.%d id reading try %d times with interval %d ms to get %08x\n",
+			pci_domain_nr(bus), bus->number, PCI_SLOT(devfn),
+			PCI_FUNC(devfn), count, step, l);
+
+	return found;
+}
+
 int pciehp_check_link_status(struct controller *ctrl)
 {
 	u16 lnk_status;
 	int retval = 0;
+	bool found = false;
 
         /*
          * Data Link Layer Link Active Reporting must be capable for
@@ -280,13 +307,10 @@ int pciehp_check_link_status(struct controller *ctrl)
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
+	found = pci_bus_check_dev(ctrl->pcie->port->subordinate,
+					PCI_DEVFN(0, 0));
 
 	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
 	if (retval) {
@@ -302,16 +326,11 @@ int pciehp_check_link_status(struct controller *ctrl)
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
 
+	if (!found && !retval)
+		retval = -1;
+
 	return retval;
 }
 
-- 
1.7.7

