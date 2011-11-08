Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1KHJUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:20:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35298 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1KHJUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:20:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EB8F434.6090003@jp.fujitsu.com>
Date: Tue, 08 Nov 2011 18:19:48 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH] pciehp: Wait for link get trained in pci_check_link_status()
References: <4EB88238.4050409@oracle.com>
In-Reply-To: <4EB88238.4050409@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/08 10:13), Yinghai Lu wrote:
> 
> Found one PCI Express Modules has link training error after hotplug.
> It turns out that after DLLLA is set, LT is still set for a while.
> So pciehp will delcare that hotplug fail in 1s.

I think DLLLA bit reads 1b means LT is completed. So I don't know why LT
is still set on your platform.

> 
> HW guys say that pciehp is against PCI-e SPEC:
>   From PCI Express Base Specification Revision 2.1, Section 6.7.3.3:
>   Software must allow 1 second after the Data Link Layer Link Active bit reads 1b
>   before it is permitted to determine that a hot plugged device which fails to
>   return a Successful Completion for a Valid Configuration Request is a broken
>   device (see section 6.6).
> 
> Try to wait for long enough by adding LT checking in 1s.

The pciehp driver already have this 1 second wait in board_added().
So I still don't understand what in pciehp is against PCIe spec clearly.
Can you explain more about this?

What about the patch below? I think it's much simpler and has less impact.

Regards,
Kenji Kaneshige

---
 drivers/pci/hotplug/pciehp_ctrl.c |    3 ---
 drivers/pci/hotplug/pciehp_hpc.c  |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-3.1/drivers/pci/hotplug/pciehp_ctrl.c
===================================================================
--- linux-3.1.orig/drivers/pci/hotplug/pciehp_ctrl.c
+++ linux-3.1/drivers/pci/hotplug/pciehp_ctrl.c
@@ -213,9 +213,6 @@ static int board_added(struct slot *p_sl
 		goto err_exit;
 	}
 
-	/* Wait for 1 second after checking link training status */
-	msleep(1000);
-
 	/* Check for a power fault */
 	if (ctrl->power_fault_detected || pciehp_query_power_fault(p_slot)) {
 		ctrl_err(ctrl, "Power fault on slot %s\n", slot_name(p_slot));
Index: linux-3.1/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-3.1.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-3.1/drivers/pci/hotplug/pciehp_hpc.c
@@ -280,6 +280,20 @@ int pciehp_check_link_status(struct cont
         else
                 msleep(1000);
 
+	/*
+	 * Need to wait for 1 second after the Data Link Layer Link
+	 * Active bit reads 1b before sending configuration request.
+	 * We also need additional 100 ms wait if the downstream port
+	 * supports Link speeds greater than 5.0 GT/s. We place this
+	 * wait before checking Link Training bit because Link
+	 * Training bit still is set even after Data Link Layer Link
+	 * Active bit is set on some platforms.
+	 */
+	if (ctrl->pcie->port->subordinate->max_bus_speed > PCIE_SPEED_5_0GT)
+		msleep(1100);
+	else
+		msleep(1000);
+
 	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
 	if (retval) {
 		ctrl_err(ctrl, "Cannot read LNKSTATUS register\n");
