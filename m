Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247Ab2D0TAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:00:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44320 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940Ab2D0TAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:00:34 -0400
Date: Fri, 27 Apr 2012 13:00:33 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
To: linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: [PATCH] Disable Bus Master on PCI device shutdown
Message-ID: <20120427190033.GA17588@ldl.usa.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable Bus Master bit on the device in
pci_device_shutdown() to ensure PCI devices do not continue
to DMA data after shutdown. This can cause memory
corruption in case of a kexec where the current kernel
shuts down and transfers control to a new kernel while a
PCI device continues to DMA to memory that does not belong
to it any more in the new kernel.

I have tested this code on two laptops, two workstations and
a 16-socket server. kexec worked correctly on all of them.


Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
---
 drivers/pci/pci-driver.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 6b54b23..9db5940 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -420,6 +420,12 @@ static void pci_device_shutdown(struct device *dev)
 	pci_msi_shutdown(pci_dev);
 	pci_msix_shutdown(pci_dev);
 
+	/* 
+	 * Turn off Bus Master bit on the device to tell it to not
+	 * continue to do DMA
+	 */
+	pci_disable_device(pci_dev);
+
 	/*
 	 * Devices may be enabled to wake up by runtime PM, but they need not
 	 * be supposed to wake up the system from its "power off" state (e.g.
-- 
1.7.8.3

