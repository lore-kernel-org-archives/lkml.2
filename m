Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2BXDw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:52:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21264 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2BXDtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:43 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/13] PCI: Disable mem in the ioapic removing path
Date: Thu, 23 Feb 2012 19:48:59 -0800
Message-Id: <1330055339-11662-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F4708CB.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For physical hot plug should be ok, but for remove/rescan path will need us
to disable that.

otherwise rescan mmio resource for pci ioapic device will not be sized and
allocated, aka skiped.
For ioapic_probe:pci_enable_device will not enable the device correctly, and
will bail out early.

So we can just disable mmio for all removing case. that will hurt real hotplug
path.

Signed-off-by: <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/ioapic.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 4183a5c..0b2c210 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -88,6 +88,17 @@ exit_free:
 	return -ENODEV;
 }
 
+static void pci_disable_device_mem(struct pci_dev *dev)
+{
+	u16 pci_command;
+
+	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
+	if (pci_command & PCI_COMMAND_MEMORY) {
+		pci_command &= ~PCI_COMMAND_MEMORY;
+		pci_write_config_word(dev, PCI_COMMAND, pci_command);
+	}
+}
+
 static void __devexit ioapic_remove(struct pci_dev *dev)
 {
 	struct ioapic *ioapic = pci_get_drvdata(dev);
@@ -95,6 +106,8 @@ static void __devexit ioapic_remove(struct pci_dev *dev)
 	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
+	/* need to disable it, otherwise remove/rescan will not work */
+	pci_disable_device_mem(dev);
 	kfree(ioapic);
 }
 
-- 
1.7.7

