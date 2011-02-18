Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab1BROWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:22:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60386 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1BROWm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 18 Feb 2011 09:22:42 -0500
Date: Fri, 18 Feb 2011 09:20:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/3] xen-pcifront: Sanity check the
 MSI/MSI-X values
Message-ID: <20110218142049.GA8847@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
 <1297894638-28007-3-git-send-email-konrad.wilk@oracle.com>
 <1297932820.16356.1317.camel@zakaz.uk.xensource.com>
 <20110218140845.GB8446@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218140845.GB8446@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D5E80A3.033B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 09:08:45AM -0500, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 17, 2011 at 08:53:40AM +0000, Ian Campbell wrote:
> > On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > > Check the returned vector values for any values that are
> > > odd or plain incorrect (say vector value zero), and if so
> > > print a warning. Also fixup the return values.
> > > 
> 
> How about this one (and there is a cleanup patch shortly following for the *(vector)...)
> 
The cleanup patch:

>From ee7eb70ab9c56a005b6023664c65da1305e3aa56 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 17 Feb 2011 12:02:23 -0500
Subject: [PATCH 4/5] pci/xen: Cleanup: convert int** to int[]

Cleanup code. Cosmetic change to make the code look easier
to read.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/pci.h |    8 ++++----
 arch/x86/pci/xen.c             |    4 ++--
 drivers/pci/xen-pcifront.c     |   12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index 2329b3e..aa86209 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -27,16 +27,16 @@ static inline void __init xen_setup_pirqs(void)
  * its own functions.
  */
 struct xen_pci_frontend_ops {
-	int (*enable_msi)(struct pci_dev *dev, int **vectors);
+	int (*enable_msi)(struct pci_dev *dev, int vectors[]);
 	void (*disable_msi)(struct pci_dev *dev);
-	int (*enable_msix)(struct pci_dev *dev, int **vectors, int nvec);
+	int (*enable_msix)(struct pci_dev *dev, int vectors[], int nvec);
 	void (*disable_msix)(struct pci_dev *dev);
 };
 
 extern struct xen_pci_frontend_ops *xen_pci_frontend;
 
 static inline int xen_pci_frontend_enable_msi(struct pci_dev *dev,
-					      int **vectors)
+					      int vectors[])
 {
 	if (xen_pci_frontend && xen_pci_frontend->enable_msi)
 		return xen_pci_frontend->enable_msi(dev, vectors);
@@ -48,7 +48,7 @@ static inline void xen_pci_frontend_disable_msi(struct pci_dev *dev)
 			xen_pci_frontend->disable_msi(dev);
 }
 static inline int xen_pci_frontend_enable_msix(struct pci_dev *dev,
-					       int **vectors, int nvec)
+					       int vectors[], int nvec)
 {
 	if (xen_pci_frontend && xen_pci_frontend->enable_msix)
 		return xen_pci_frontend->enable_msix(dev, vectors, nvec);
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6432f75..30fdd09 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -150,9 +150,9 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		return -ENOMEM;
 
 	if (type == PCI_CAP_ID_MSIX)
-		ret = xen_pci_frontend_enable_msix(dev, &v, nvec);
+		ret = xen_pci_frontend_enable_msix(dev, v, nvec);
 	else
-		ret = xen_pci_frontend_enable_msi(dev, &v);
+		ret = xen_pci_frontend_enable_msi(dev, v);
 	if (ret)
 		goto error;
 	i = 0;
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index d9fd1e0..27dae44 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -243,7 +243,7 @@ struct pci_ops pcifront_bus_ops = {
 
 #ifdef CONFIG_PCI_MSI
 static int pci_frontend_enable_msix(struct pci_dev *dev,
-				    int **vector, int nvec)
+				    int vector[], int nvec)
 {
 	int err;
 	int i;
@@ -283,10 +283,10 @@ static int pci_frontend_enable_msix(struct pci_dev *dev,
 						" is invalid: %d!\n", i,
 						op.msix_entries[i].vector);
 					err = -EINVAL;
-					*(*vector+i) = -1;
+					vector[i] = -1;
 					continue;
 				}
-				*(*vector+i) = op.msix_entries[i].vector;
+				vector[i] = op.msix_entries[i].vector;
 			}
 		} else {
 			printk(KERN_DEBUG "enable msix get value %x\n",
@@ -317,7 +317,7 @@ static void pci_frontend_disable_msix(struct pci_dev *dev)
 		dev_err(&dev->dev, "pci_disable_msix get err %x\n", err);
 }
 
-static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
+static int pci_frontend_enable_msi(struct pci_dev *dev, int vector[])
 {
 	int err;
 	struct xen_pci_op op = {
@@ -331,12 +331,12 @@ static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
 
 	err = do_pci_op(pdev, &op);
 	if (likely(!err)) {
-		*(*vector) = op.value;
+		vector[0] = op.value;
 		if (op.value <= 0) {
 			dev_warn(&dev->dev, "MSI entry is invalid: %d!\n",
 				op.value);
 			err = -EINVAL;
-			*(*vector) = -1;	
+			vector[0] = -1;
 		}
 	} else {
 		dev_err(&dev->dev, "pci frontend enable msi failed for dev "
-- 
1.7.1

