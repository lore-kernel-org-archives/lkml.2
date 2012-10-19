Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2JSRnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:43:37 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:50808 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2JSRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:43:35 -0400
Message-ID: <50819140.8030806@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 14:43:28 -0300
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: radeon: RFC speed cap detection on ppc64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101917-2362-0000-0000-000008BCBB16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radeon driver does speed cap detection on the root PCI device for 
the maximum speed with which the adapter can communicate. On ppc64 
systems, however, the root device belongs to the Hypervisor, so the 
current code would case a null pointer dereference.

I propose to look for the outmost bus with a parent node and get speed 
caps from it, though I suppose the cleaner way would be to inspect all 
devices along the way and choose the smallest speed cap.

Does anyone have suggestions for this?

Thanks

--
--- 
/home/lucaskt/work/devdrivers/kernel/linux/drivers/gpu/drm/drm_pci.c 
2012-09-26 10:06:00.280549928 -0300
+++ drm_pci.c	2012-09-26 15:38:51.121786353 -0300
@@ -466,6 +466,19 @@
  }
  EXPORT_SYMBOL(drm_pci_exit);

+static struct pci_dev *drm_get_pcie_root_dev(struct pci_dev *dev)
+{
+	// Go up through all possible busses to get the info for the outmost bus
+	while (!pci_is_root_bus(dev->bus))
+		dev = dev->bus->parent->self;
+	
+	// In POWER architectures there's no PCI root device, so it should 
just read
+	// the caps from the device itself
+	if (dev->bus->self != NULL)
+		return dev->bus->self;
+	else
+		return dev;
+}
+
  int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
  {
  	struct pci_dev *root;
@@ -479,7 +492,7 @@
  	if (!pci_is_pcie(dev->pdev))
  		return -EINVAL;

-	root = dev->pdev->bus->self;
+	root = drm_get_pcie_root_dev(dev->pdev);

  	pos = pci_pcie_cap(root);
  	if (!pos)


-- 
Lucas Kannebley Tavares
Software Engineer
IBM Linux Technology Center

