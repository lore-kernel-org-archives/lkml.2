Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1KHBN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:13:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44852 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1KHBN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:13:57 -0500
Message-ID: <4EB88238.4050409@oracle.com>
Date: Mon, 07 Nov 2011 17:13:28 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [RFC PATCH] pciehp: Wait for link get trained in pci_check_link_status()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EB88252.009D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Found one PCI Express Modules has link training error after hotplug.
It turns out that after DLLLA is set, LT is still set for a while.
So pciehp will delcare that hotplug fail in 1s.

HW guys say that pciehp is against PCI-e SPEC:
 From PCI Express Base Specification Revision 2.1, Section 6.7.3.3:
 Software must allow 1 second after the Data Link Layer Link Active bit reads 1b
 before it is permitted to determine that a hot plugged device which fails to
 return a Successful Completion for a Valid Configuration Request is a broken
 device (see section 6.6).

Try to wait for long enough by adding LT checking in 1s.

Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>

---
 drivers/pci/hotplug/pciehp_hpc.c |   52 +++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
@@ -241,28 +241,49 @@ static int pcie_write_cmd(struct control
 	return retval;
 }
 
-static inline int check_link_active(struct controller *ctrl)
+static inline bool
+check_link_status_bits(struct controller *ctrl, u16 mask, u16 val)
 {
 	u16 link_status;
 
 	if (pciehp_readw(ctrl, PCI_EXP_LNKSTA, &link_status))
-		return 0;
-	return !!(link_status & PCI_EXP_LNKSTA_DLLLA);
+		return false;
+
+	if ((link_status & mask) == val)
+		return true;
+
+	return false;
 }
 
-static void pcie_wait_link_active(struct controller *ctrl)
+static bool
+pcie_wait_link_status_bits(struct controller *ctrl, u16 mask, u16 val)
 {
 	int timeout = 1000;
 
-	if (check_link_active(ctrl))
-		return;
+	if (check_link_status_bits(ctrl, mask, val))
+		return true;
 	while (timeout > 0) {
-		msleep(10);
-		timeout -= 10;
-		if (check_link_active(ctrl))
-			return;
+		msleep(20);
+		timeout -= 20;
+		if (check_link_status_bits(ctrl, mask, val))
+			return true;
 	}
-	ctrl_dbg(ctrl, "Data Link Layer Link Active not set in 1000 msec\n");
+
+	return false;
+}
+
+static void pcie_wait_link_active(struct controller *ctrl)
+{
+	if (!pcie_wait_link_status_bits(ctrl, PCI_EXP_LNKSTA_DLLLA,
+					 PCI_EXP_LNKSTA_DLLLA))
+		ctrl_dbg(ctrl,
+			 "Data Link Layer Link Active not set in 1000 msec\n");
+}
+
+static void pcie_wait_link_training_done(struct controller *ctrl)
+{
+	if (!pcie_wait_link_status_bits(ctrl, PCI_EXP_LNKSTA_LT, 0))
+		ctrl_dbg(ctrl, "Link Training is not done in 1000 msec\n");
 }
 
 int pciehp_check_link_status(struct controller *ctrl)
@@ -275,10 +296,11 @@ int pciehp_check_link_status(struct cont
          * hot-plug capable downstream port. But old controller might
          * not implement it. In this case, we wait for 1000 ms.
          */
-        if (ctrl->link_active_reporting)
-                pcie_wait_link_active(ctrl);
-        else
-                msleep(1000);
+	if (ctrl->link_active_reporting) {
+		pcie_wait_link_active(ctrl);
+		pcie_wait_link_training_done(ctrl);
+	} else
+		msleep(1000);
 
 	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
 	if (retval) {
