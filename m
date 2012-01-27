Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2A0S4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:56:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24534 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2A0Szi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:55:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Yinghai Lu <yinghai.lu@oracle.com>
Subject: [PATCH 7/7] pciehp: Disable/enable link during slot power off/on
Date: Fri, 27 Jan 2012 10:55:15 -0800
Message-Id: <1327690515-2991-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F22F325.0041,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One system have repeater in system board to support gen2 hotplug.

Found when EM is removed from some slots, /var/log/message will be full of
"card present/not present" warning.

It turns out root complex still try to train the link to repeater because
repeater is not reset.

This patch will disable link to make repeater could reset properly.
Also could kill AER during EM removal.

Recently when testing hotplug on one system under development, found if boot
the system without EM, and later hotplug does not work with Linux.
But other OS is ok.
The root cause is that bios left link disabled when slot is empty,
and other OS is playing link disable bit in link ctrl during power on/off.

So We could do the same thing to disable/enable link during power off/on.

-v2: check link DLLA bit instead of 100ms waiting.
     Separate link disable/enable functions to another patch.

Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
---
 drivers/pci/hotplug/pciehp_hpc.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index fdab8a6..0e35d70 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -606,6 +606,10 @@ int pciehp_power_on_slot(struct slot * slot)
 	ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n", __func__,
 		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, slot_cmd);
 
+	retval = pciehp_link_enable(ctrl);
+	if (retval)
+		ctrl_err(ctrl, "%s: Can not enable the link!\n", __func__);
+
 	return retval;
 }
 
@@ -616,6 +620,14 @@ int pciehp_power_off_slot(struct slot * slot)
 	u16 cmd_mask;
 	int retval;
 
+	/* Disable the link at first */
+	pciehp_link_disable(ctrl);
+	/* wait the link is down */
+	if (ctrl->link_active_reporting)
+		pcie_wait_link_not_active(ctrl);
+	else
+		msleep(1000);
+
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
 	retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
-- 
1.7.7

