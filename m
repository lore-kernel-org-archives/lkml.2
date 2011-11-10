Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1KJHkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 02:40:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46808 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1KJHkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:40:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EBB7FF5.1040109@jp.fujitsu.com>
Date: Thu, 10 Nov 2011 16:40:37 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 1/2] pciehp: wait 1000 ms before Link Training check
References: <4EB88238.4050409@oracle.com> <4EB8F434.6090003@jp.fujitsu.com> <4EB94A51.6070809@oracle.com> <4EB9A50D.1040302@oracle.com> <4EBB7F9B.8050703@jp.fujitsu.com>
In-Reply-To: <4EBB7F9B.8050703@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to wait for 1000 ms after Data Link Layer Link Active (DLLLA)
bit reads 1b before sending configuration request. Currently pciehp
does this wait after checking Link Training (LT) bit. But we need it
before checking LT bit because LT is still set even after DLLLA bit is
set on some platforms.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
---
 drivers/pci/hotplug/pciehp_ctrl.c |    3 ---
 drivers/pci/hotplug/pciehp_hpc.c  |    8 ++++++++
 2 files changed, 8 insertions(+), 3 deletions(-)

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
@@ -280,6 +280,14 @@ int pciehp_check_link_status(struct cont
         else
                 msleep(1000);
 
+	/*
+	 * Need to wait for 1000 ms after Data Link Layer Link Active
+	 * (DLLLA) bit reads 1b before sending configuration request.
+	 * We need it before checking Link Training (LT) bit becuase
+	 * LT is still set even after DLLLA bit is set on some platform.
+	 */
+	msleep(1000);
+
 	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
 	if (retval) {
 		ctrl_err(ctrl, "Cannot read LNKSTATUS register\n");
