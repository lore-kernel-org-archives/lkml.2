Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1JIHGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 03:06:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:63098 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1JIHGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 03:06:20 -0400
Message-ID: <4E9147DE.3050006@oracle.com>
Date: Sun, 09 Oct 2011 00:06:06 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pciehp: Retrieve link speed after link is trained
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090204.4E9147EB.005B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During hot plug, board_added will call pciehp_power_on_slot().
But link speed is updated in pciehp_power_on_slot().

We should not update link speed there, because that is too early.

Move updating to pciehp_check_link_status() after making sure link is trained.

Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>

---
 drivers/pci/hotplug/pciehp_hpc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
@@ -294,6 +294,8 @@ int pciehp_check_link_status(struct cont
 		return retval;
 	}
 
+	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
+
 	return retval;
 }
 
@@ -516,14 +518,6 @@ int pciehp_power_on_slot(struct slot * s
 	ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n", __func__,
 		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, slot_cmd);
 
-	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
-	if (retval) {
-		ctrl_err(ctrl, "%s: Cannot read LNKSTA register\n",
-				__func__);
-		return retval;
-	}
-	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
-
 	return retval;
 }
 
