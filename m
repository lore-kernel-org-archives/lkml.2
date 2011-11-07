Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1KGPxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:53:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43114 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1KGPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:53:48 -0500
Message-ID: <4EB7FEF3.7090105@oracle.com>
Date: Mon, 07 Nov 2011 07:53:23 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH -v2] pciehp: Retrieve link speed after link is trained
References: <4E9147DE.3050006@oracle.com> <20111102140522.411ef343@jbarnes-desktop> <4EB23DBC.8050805@jp.fujitsu.com> <4EB7C14E.1070503@jp.fujitsu.com>
In-Reply-To: <4EB7C14E.1070503@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EB7FF09.011C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During hot plug, board_added will call pciehp_power_on_slot().
But link speed is updated in pciehp_power_on_slot().

We should not update link speed there, because that is too early.

Move updating to pciehp_check_link_status() after making sure link is trained.

-v2: compiling warning that Kenji found.

Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/pciehp_hpc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

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
 
@@ -484,7 +486,6 @@ int pciehp_power_on_slot(struct slot * s
 	u16 slot_cmd;
 	u16 cmd_mask;
 	u16 slot_status;
-	u16 lnk_status;
 	int retval = 0;
 
 	/* Clear sticky power-fault bit from previous power failures */
@@ -516,14 +517,6 @@ int pciehp_power_on_slot(struct slot * s
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
 
