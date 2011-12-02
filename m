Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1LBXLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:11:02 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24157 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1LBXK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:10:59 -0500
Message-ID: <4ED95AD0.7090003@oracle.com>
Date: Fri, 02 Dec 2011 15:10:08 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] pciehp: Disable/enable link during slot power off/on
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4ED95AFF.00CD,ss=1,re=0.000,fgs=0
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

Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>

---
 drivers/pci/hotplug/pciehp_hpc.c |   46 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
@@ -315,6 +315,42 @@ int pciehp_check_link_status(struct cont
 	return retval;
 }
 
+static int __pciehp_link_set(struct controller *ctrl, bool enable)
+{
+	u16 lnk_ctrl;
+	int retval = 0;
+
+	retval = pciehp_readw(ctrl, PCI_EXP_LNKCTL, &lnk_ctrl);
+	if (retval) {
+		ctrl_err(ctrl, "Cannot read LNKCTRL register\n");
+		return retval;
+	}
+
+	if (enable)
+		lnk_ctrl &= ~PCI_EXP_LNKCTL_LD;
+	else
+		lnk_ctrl |= PCI_EXP_LNKCTL_LD;
+
+	retval = pciehp_writew(ctrl, PCI_EXP_LNKCTL, lnk_ctrl);
+	if (retval) {
+		ctrl_err(ctrl, "Cannot write LNKCTRL register\n");
+		return retval;
+	}
+	ctrl_dbg(ctrl, "%s: lnk_ctrl = %x\n", __func__, lnk_ctrl);
+
+	return retval;
+}
+
+static int pciehp_link_enable(struct controller *ctrl)
+{
+	return __pciehp_link_set(ctrl, true);
+}
+
+static int pciehp_link_disable(struct controller *ctrl)
+{
+	return __pciehp_link_set(ctrl, false);
+}
+
 int pciehp_get_attention_status(struct slot *slot, u8 *status)
 {
 	struct controller *ctrl = slot->ctrl;
@@ -533,6 +569,12 @@ int pciehp_power_on_slot(struct slot * s
 	ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n", __func__,
 		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, slot_cmd);
 
+	/* Need to wait before enabling link */
+	msleep(100);
+	retval = pciehp_link_enable(ctrl);
+	if (retval)
+		ctrl_err(ctrl, "%s: Can not enable the link!\n", __func__);
+
 	return retval;
 }
 
@@ -543,6 +585,10 @@ int pciehp_power_off_slot(struct slot *
 	u16 cmd_mask;
 	int retval;
 
+	/* Disable the link at first */
+	pciehp_link_disable(ctrl);
+	msleep(100);
+
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
 	retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
