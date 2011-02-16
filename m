Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1BPAXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:36 -0500
Received: from kroah.org ([198.145.64.141]:49361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab1BPAXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:43 2011
Message-Id: <20110216001443.195966005@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [181/272] xen-platform: use PCI interfaces to request IO and MEM resources.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 00f28e4037c8d5782fa7a1b2666b0dca21522d69 upstream.

This is the correct interface to use and something has broken the use
of the previous incorrect interface (which fails because the request
conflicts with the resources assigned for the PCI device itself
instead of nesting like the PCI interfaces do).

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/platform-pci.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -105,7 +105,7 @@ static int __devinit platform_pci_init(s
 				       const struct pci_device_id *ent)
 {
 	int i, ret;
-	long ioaddr, iolen;
+	long ioaddr;
 	long mmio_addr, mmio_len;
 	unsigned int max_nr_gframes;
 
@@ -114,7 +114,6 @@ static int __devinit platform_pci_init(s
 		return i;
 
 	ioaddr = pci_resource_start(pdev, 0);
-	iolen = pci_resource_len(pdev, 0);
 
 	mmio_addr = pci_resource_start(pdev, 1);
 	mmio_len = pci_resource_len(pdev, 1);
@@ -125,19 +124,13 @@ static int __devinit platform_pci_init(s
 		goto pci_out;
 	}
 
-	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
-		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
-		       mmio_addr, mmio_len);
-		ret = -EBUSY;
+	ret = pci_request_region(pdev, 1, DRV_NAME);
+	if (ret < 0)
 		goto pci_out;
-	}
 
-	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
-		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
-		       iolen, ioaddr);
-		ret = -EBUSY;
+	ret = pci_request_region(pdev, 0, DRV_NAME);
+	if (ret < 0)
 		goto mem_out;
-	}
 
 	platform_mmio = mmio_addr;
 	platform_mmiolen = mmio_len;
@@ -169,9 +162,9 @@ static int __devinit platform_pci_init(s
 	return 0;
 
 out:
-	release_region(ioaddr, iolen);
+	pci_release_region(pdev, 0);
 mem_out:
-	release_mem_region(mmio_addr, mmio_len);
+	pci_release_region(pdev, 1);
 pci_out:
 	pci_disable_device(pdev);
 	return ret;


