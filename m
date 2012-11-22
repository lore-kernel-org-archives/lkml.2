Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab2KVWPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:15:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:49370 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2KVSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 08/83] PCI/PM: Resume device before shutdown
Date: Wed, 21 Nov 2012 16:41:30 -0800
Message-Id: <20121122004213.330778914@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Ying <ying.huang@intel.com>

commit 3ff2de9ba1a2e22e548979dbcd46e999b22c93d8 upstream.

Some actions during shutdown need device to be in D0 state, such as
MSI shutdown etc, so resume device before shutdown.

Without this patch, a device may not be enumerated after a kexec
because the corresponding bridge is not in D0, so that
configuration space of the device is not accessible.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -421,6 +421,8 @@ static void pci_device_shutdown(struct d
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	pm_runtime_resume(dev);
+
 	if (drv && drv->shutdown)
 		drv->shutdown(pci_dev);
 	pci_msi_shutdown(pci_dev);
@@ -431,16 +433,6 @@ static void pci_device_shutdown(struct d
 	 * continue to do DMA
 	 */
 	pci_disable_device(pci_dev);
-
-	/*
-	 * Devices may be enabled to wake up by runtime PM, but they need not
-	 * be supposed to wake up the system from its "power off" state (e.g.
-	 * ACPI S5).  Therefore disable wakeup for all devices that aren't
-	 * supposed to wake up the system at this point.  The state argument
-	 * will be ignored by pci_enable_wake().
-	 */
-	if (!device_may_wakeup(dev))
-		pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
 }
 
 #ifdef CONFIG_PM


