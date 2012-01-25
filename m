Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2AYVYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:24:37 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28431 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2AYVYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:24:36 -0500
Date: Wed, 25 Jan 2012 16:22:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Fwd: BUG in linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c
Message-ID: <20120125212214.GA29571@phenom.dumpdata.com>
References: <CAEmTpZHkKB29FLWqs0R=uD1zXBOJkfSstGgMM=8bA1VVXGT+wQ@mail.gmail.com>
 <CAEmTpZH+OeQO=RNBFh_+j_QCmPa8sGhV_OOqqsiKUMmjhBwESw@mail.gmail.com>
 <20120125163910.GC23999@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120125163910.GC23999@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F207311.005E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:39:10AM -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 25, 2012 at 04:20:26PM +0600, Марк Коренберг wrote:
> > First, maintainer's addresses (Ryan Wilson <hap9@epoch.ncsc.mil>,
> > Chris Bookholt <hap10@epoch.ncsc.mil>) are wrong (users unknown to
> > remote mailsystem), so posting to you:
> 
> Those are the authors ones.. If you do:
> konrad@phenom:~/work/linux$ scripts/get_maintainer.pl -f drivers/xen/xen-pciback/pci_stub.c
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> (supporter:XEN HYPERVISOR IN...,commit_signer:11/11=100%)
> Jeremy Fitzhardinge <jeremy@goop.org> (supporter:XEN HYPERVISOR IN...,commit_signer:2/11=18%)
> Jan Beulich <jbeulich@suse.com> (commit_signer:1/11=9%)
> xen-devel@lists.xensource.com (open list:XEN HYPERVISOR IN...)
> virtualization@lists.linux-foundation.org (open list:XEN HYPERVISOR IN...)
> linux-kernel@vger.kernel.org (open list)
> 
> > 
> > PCI bus format strings are wrong.
> > 
> > "%04x:%02x:%02x.%d"
> > 
> > should be used instead of
> > 
> > "%04x:%02x:%02x.%1x"
> 
> Oh? Would you be willing to come up with a patch with your SOB, please?

Actually I think it is something like this: But we still need something for the
protocol..

>From e7d7514133427134d186b58b842ecd6beda3bf03 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 25 Jan 2012 16:00:00 -0500
Subject: [PATCH] xen/pci[front|back]: Use %d instead of %1x for displaying
 PCI devfn.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

.. as the rest of the kernel is using that format.

Suggested-by: Марк Коренберг <socketpair@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c         |   10 +++++-----
 drivers/xen/xen-pciback/pci_stub.c |    8 ++++----
 drivers/xen/xen-pciback/xenbus.c   |    7 ++++---
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 7cf3d2f..1620088 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -189,7 +189,7 @@ static int pcifront_bus_read(struct pci_bus *bus, unsigned int devfn,
 
 	if (verbose_request)
 		dev_info(&pdev->xdev->dev,
-			 "read dev=%04x:%02x:%02x.%01x - offset %x size %d\n",
+			 "read dev=%04x:%02x:%02x.%d - offset %x size %d\n",
 			 pci_domain_nr(bus), bus->number, PCI_SLOT(devfn),
 			 PCI_FUNC(devfn), where, size);
 
@@ -228,7 +228,7 @@ static int pcifront_bus_write(struct pci_bus *bus, unsigned int devfn,
 
 	if (verbose_request)
 		dev_info(&pdev->xdev->dev,
-			 "write dev=%04x:%02x:%02x.%01x - "
+			 "write dev=%04x:%02x:%02x.%d - "
 			 "offset %x size %d val %x\n",
 			 pci_domain_nr(bus), bus->number,
 			 PCI_SLOT(devfn), PCI_FUNC(devfn), where, size, val);
@@ -432,7 +432,7 @@ static int __devinit pcifront_scan_bus(struct pcifront_device *pdev,
 		d = pci_scan_single_device(b, devfn);
 		if (d)
 			dev_info(&pdev->xdev->dev, "New device on "
-				 "%04x:%02x:%02x.%02x found.\n", domain, bus,
+				 "%04x:%02x:%02x.%d found.\n", domain, bus,
 				 PCI_SLOT(devfn), PCI_FUNC(devfn));
 	}
 
@@ -1041,7 +1041,7 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
 		pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
 		if (!pci_dev) {
 			dev_dbg(&pdev->xdev->dev,
-				"Cannot get PCI device %04x:%02x:%02x.%02x\n",
+				"Cannot get PCI device %04x:%02x:%02x.%d\n",
 				domain, bus, slot, func);
 			continue;
 		}
@@ -1049,7 +1049,7 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
 		pci_dev_put(pci_dev);
 
 		dev_dbg(&pdev->xdev->dev,
-			"PCI device %04x:%02x:%02x.%02x removed.\n",
+			"PCI device %04x:%02x:%02x.%d removed.\n",
 			domain, bus, slot, func);
 	}
 
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 6f63b9d..097e536 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -919,7 +919,7 @@ static inline int str_to_quirk(const char *buf, int *domain, int *bus, int
 	int err;
 
 	err =
-	    sscanf(buf, " %04x:%02x:%02x.%1x-%08x:%1x:%08x", domain, bus, slot,
+	    sscanf(buf, " %04x:%02x:%02x.%d-%08x:%1x:%08x", domain, bus, slot,
 		   func, reg, size, mask);
 	if (err == 7)
 		return 0;
@@ -939,7 +939,7 @@ static int pcistub_device_id_add(int domain, int bus, int slot, int func)
 	pci_dev_id->bus = bus;
 	pci_dev_id->devfn = PCI_DEVFN(slot, func);
 
-	pr_debug(DRV_NAME ": wants to seize %04x:%02x:%02x.%01x\n",
+	pr_debug(DRV_NAME ": wants to seize %04x:%02x:%02x.%d\n",
 		 domain, bus, slot, func);
 
 	spin_lock_irqsave(&device_ids_lock, flags);
@@ -969,7 +969,7 @@ static int pcistub_device_id_remove(int domain, int bus, int slot, int func)
 
 			err = 0;
 
-			pr_debug(DRV_NAME ": removed %04x:%02x:%02x.%01x from "
+			pr_debug(DRV_NAME ": removed %04x:%02x:%02x.%d from "
 				 "seize list\n", domain, bus, slot, func);
 		}
 	}
@@ -1064,7 +1064,7 @@ static ssize_t pcistub_slot_show(struct device_driver *drv, char *buf)
 			break;
 
 		count += scnprintf(buf + count, PAGE_SIZE - count,
-				   "%04x:%02x:%02x.%01x\n",
+				   "%04x:%02x:%02x.%d\n",
 				   pci_dev_id->domain, pci_dev_id->bus,
 				   PCI_SLOT(pci_dev_id->devfn),
 				   PCI_FUNC(pci_dev_id->devfn));
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index d5dcf8d..9b2f705 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -206,8 +206,9 @@ static int xen_pcibk_publish_pci_dev(struct xen_pcibk_device *pdev,
 		goto out;
 	}
 
+	/* TODO: implement feature-use-decimal-for-devfn */
 	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
-			    "%04x:%02x:%02x.%02x", domain, bus,
+			    "%04x:%02x:%02x.%1x", domain, bus,
 			    PCI_SLOT(devfn), PCI_FUNC(devfn));
 
 out:
@@ -229,7 +230,7 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 		err = -EINVAL;
 		xenbus_dev_fatal(pdev->xdev, err,
 				 "Couldn't locate PCI device "
-				 "(%04x:%02x:%02x.%01x)! "
+				 "(%04x:%02x:%02x.%d)! "
 				 "perhaps already in-use?",
 				 domain, bus, slot, func);
 		goto out;
@@ -274,7 +275,7 @@ static int xen_pcibk_remove_device(struct xen_pcibk_device *pdev,
 	if (!dev) {
 		err = -EINVAL;
 		dev_dbg(&pdev->xdev->dev, "Couldn't locate PCI device "
-			"(%04x:%02x:%02x.%01x)! not owned by this domain\n",
+			"(%04x:%02x:%02x.%d)! not owned by this domain\n",
 			domain, bus, slot, func);
 		goto out;
 	}
-- 
1.7.7.5

