Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab1BROWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:22:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60434 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab1BROWo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 18 Feb 2011 09:22:44 -0500
Date: Fri, 18 Feb 2011 09:22:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] Xen PCI fronted fixes for 2.6.39
Message-ID: <20110218142230.GB8847@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D5E80AA.00D3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 05:17:15PM -0500, Konrad Rzeszutek Wilk wrote:
> I am proposing these three patches for 2.6.39.
> 
> The first is to take advantage of the new method of requesting
> a Linux IRQ and providing the Xen PIRQ value. The second
> makes it possible for a PV guest to bootup if the backend has provided
> incorrect values. [*2]
> 
> Lastly, the third is to remove deprecated code.

And lets add one more:

>From e4e8523b1d374a3f4276c34e6d017b425ce0d1ae Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 17 Feb 2011 16:12:51 -0500
Subject: [PATCH 5/5] pci/xen: When free-ing MSI-X/MSI irq->desc also use generic code.

This code path is only run when an MSI/MSI-X PCI device is passed
in to PV DomU.

In 2.6.37 time-frame we over-wrote the default cleanup handler for
MSI/MSI-X irq->desc to be "xen_teardown_msi_irqs". That function
calls the the xen-pcifront driver which can tell the backend to
cleanup/take back the MSI/MSI-X device.

However, we forgot to continue the process of free-ing the MSI/MSI-X
device resources (irq->desc) in the PV domU side. Which is what
the default cleanup handler "default_teardown_msi_irqs" did.

Hence we would leak IRQ descriptors.

Without this patch, doing "rmmod igbvf;modprobe igbvf" multiple
times ends with abandoned IRQ descriptors:

 28:          5  xen-pirq-pcifront-msi-x
 29:          8  xen-pirq-pcifront-msi-x
...
130:         10  xen-pirq-pcifront-msi-x

with the end result of running out of IRQ descriptors.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 30fdd09..57afd1d 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -193,6 +193,9 @@ static void xen_teardown_msi_irqs(struct pci_dev *dev)
 		xen_pci_frontend_disable_msix(dev);
 	else
 		xen_pci_frontend_disable_msi(dev);
+
+	/* Free the IRQ's and the msidesc using the generic code. */
+	default_teardown_msi_irqs(dev);
 }
 
 static void xen_teardown_msi_irq(unsigned int irq)
-- 
1.7.1

