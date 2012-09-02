Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2IBVrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:47:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32860 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab2IBVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:47:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        stable@vger.kernel.org
Subject: [PATCH part1 1/4] PCI, pciehp: Turn on link again after power off the slot
Date: Sun,  2 Sep 2012 14:47:35 -0700
Message-Id: <1346622458-30595-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
References: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During debugging hotplug surpise support, found slot status reg does not report
present status anymore after removing the card. That present bit
does not get cleared even that card is removed. So no interrupt is generated
later after reinsert the card.

That problem is caused by commit:
| commit 2debd9289997fc5d1c0043b41201a8b40d5e11d0
|
|    PCI: pciehp: Disable/enable link during slot power off/on

Try turn on link after power off.
With the fix present bit will report correctly, also still avoid the aer
during the power off.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: stable@vger.kernel.org
---
 drivers/pci/hotplug/pciehp_hpc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 13b2eaf..7cee8db 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -631,6 +631,8 @@ int pciehp_power_off_slot(struct slot * slot)
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
 	retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
+	/* need to enable link again for present bit report */
+	pciehp_link_enable(ctrl);
 	if (retval) {
 		ctrl_err(ctrl, "Write command failed!\n");
 		return retval;
-- 
1.7.7

