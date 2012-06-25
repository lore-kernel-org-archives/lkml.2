Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2FYUyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:54:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:55461 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab2FYUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:54:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169875851"
Subject: Re: [PATCH] pci: support alignments upto 8Gb in pbus_size_mem()
From: Nikhil P Rao <nikhil.rao@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <CAErSpo7AWQCofnTRhtMKVP3pm_BDq9v+axGpide0RbmignsV9A@mail.gmail.com>
References: <1340222160.77018.19.camel@localhost.localdomain>
	 <1340322477.56127.2.camel@localhost.localdomain>
	 <CAErSpo7AWQCofnTRhtMKVP3pm_BDq9v+axGpide0RbmignsV9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 13:54:47 -0700
Message-ID: <1340657687.36341.178.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-10.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 12:15 -0600, Bjorn Helgaas wrote:
> On Thu, Jun 21, 2012 at 5:47 PM, Nikhil P Rao <nikhil.rao@intel.com> wrote:
> > I ran into the "disabling BAR .." error message when
> > trying to use a 8Gb PCIe card on a system with a BIOS
> > that didnt have support for BAR size > 2Gb.
> 
> So the BIOS left the 8Gb BAR unassigned, and you got the "disabling
> BAR ... (bad alignment)" message when Linux tried to enable it?

Yes.

> How do we know 8Gb is the correct new limit?  Are we going to be
> fixing this again when we see a 16Gb or a 32Gb BAR?  Do we need a
> better algorithm that doesn't have a limit like this?
> 

The original error message seems applicable to 32bit archs. and not to
64 bit archs. How about the patch below - is aligns[44] (256bytes more)
acceptable ?


From: Nikhil P Rao <nikhil.rao@intel.com>
Date: Mon, 25 Jun 2012 13:33:55 -0700
Subject: [PATCH] pci: fix resource size check

Support a PCI BAR alignment of > 2Gb, the original check was
only applicable to 32 bit kernels,

Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
---
 drivers/pci/setup-bus.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..9f8d9ea 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -780,7 +780,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size, size0, size1;
-	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
+	resource_size_t aligns[44];	/* Alignments from 1Mb to 2^63 */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 	unsigned int mem64_mask = 0;
@@ -819,7 +819,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
-			if (order > 11) {
+			if ((sizeof(size_t) == 4 && order > 11) ||
+					(sizeof(size_t) == 8 && order > 43)) {
 				dev_warn(&dev->dev, "disabling BAR %d: %pR "
 					 "(bad alignment %#llx)\n", i, r,
 					 (unsigned long long) align);
-- 
1.7.1

