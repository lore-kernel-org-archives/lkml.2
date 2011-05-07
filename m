Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1EGRlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:41:36 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46413 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752832Ab1EGRle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:41:34 -0400
To: infinipath@qlogic.com, linux-rdma@vger.kernel.org
Subject: [PATCH 1/2] ipath: use pci_dev->revision, again
Content-Disposition: inline
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Sat, 7 May 2011 21:39:37 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105072139.37992.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all drivers to use
pci_device->revision) already converted this driver to using the 'revision'
field of 'struct pci_dev' but commit bb9171448deb1f7ece27674e2e431e4f267fd453
(IB/ipath: Misc changes to prepare for IB7220 introduction) later reverted that
change for some strange reason. Now restore the change...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/infiniband/hw/ipath/ipath_driver.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_driver.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_driver.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -398,7 +398,6 @@ static int __devinit ipath_init_one(stru
 	struct ipath_devdata *dd;
 	unsigned long long addr;
 	u32 bar0 = 0, bar1 = 0;
-	u8 rev;
 
 	dd = ipath_alloc_devdata(pdev);
 	if (IS_ERR(dd)) {
@@ -540,13 +539,7 @@ static int __devinit ipath_init_one(stru
 		goto bail_regions;
 	}
 
-	ret = pci_read_config_byte(pdev, PCI_REVISION_ID, &rev);
-	if (ret) {
-		ipath_dev_err(dd, "Failed to read PCI revision ID unit "
-			      "%u: err %d\n", dd->ipath_unit, -ret);
-		goto bail_regions;	/* shouldn't ever happen */
-	}
-	dd->ipath_pcirev = rev;
+	dd->ipath_pcirev = pdev->revision;
 
 #if defined(__powerpc__)
 	/* There isn't a generic way to specify writethrough mappings */
