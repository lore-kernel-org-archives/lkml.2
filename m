Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0FIUbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:31:24 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:40669 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab0FIUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:31:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Greg KH <greg@kroah.com>
Subject: [PATCH 1/1] PCI: hotplug/cpqphp, fix NULL dereference
Date: Wed,  9 Jun 2010 22:31:13 +0200
Message-Id: <1276115473-2307-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are devices out there which are PCI Hot-plug controllers with
compaq PCI IDs, but are not bridges, hence have pdev->subordinate
NULL. But cpqphp expects the pointer to be non-NULL.

Add a check to the probe function to avoid oopses like:
BUG: unable to handle kernel NULL pointer dereference at 00000050
IP: [<f82e3c41>] cpqhpc_probe+0x951/0x1120 [cpqphp]
*pdpt = 0000000033779001 *pde = 0000000000000000
...

The device here was:
00:0b.0 PCI Hot-plug controller [0804]: Compaq Computer Corporation PCI Hotplug Controller [0e11:a0f7] (rev 11)
	Subsystem: Compaq Computer Corporation Device [0e11:a2f8]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/hotplug/cpqphp_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index b3e5580..4952c3b 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -828,7 +828,14 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			pci_name(pdev), err);
 		return err;
 	}
+
 	bus = pdev->subordinate;
+	if (!bus) {
+		dev_notice(&pdev->dev, "the device is not a bridge, "
+				"skipping\n");
+		rc = -ENODEV;
+		goto err_disable_device;
+	}
 
 	/* Need to read VID early b/c it's used to differentiate CPQ and INTC
 	 * discovery
-- 
1.7.1


