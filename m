Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2KSAYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:24:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:42099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2KSAYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:24:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,275,1352102400"; 
   d="scan'208";a="219450580"
Date: Mon, 19 Nov 2012 01:24:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Subject: Re: mfd: lpc_ich: NULL pointer dereference at (second) module removal
Message-ID: <20121119002404.GD18738@sortiz-mobl>
References: <1352467148.1895.20.camel@x61.thuisdomein>
 <1352741475.6008.16.camel@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352741475.6008.16.camel@petert>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, Peter,

On Mon, Nov 12, 2012 at 11:31:15AM -0600, Peter Tyser wrote:
> Thanks for reporting the issue!
> 
> On Fri, 2012-11-09 at 14:19 +0100, Paul Bolle wrote:
> > 0) I can trigger a NULL pointer dereference if I remove the lpc_ich
> > module. This seems to only happen if I remove it for the second time
> > (ie, remove the module, insert it and remove it again). This happens
> > both on i686 and x86_64 (different setups, as inserting the module
> > triggers different messages about the initialization of the MFD cells on
> > these machines). Both machines are running v3.6.6.
> 
> I believe this is caused by the fact that non-MFD devices get attached
> to the same parent as the iTCO_wdt driver, which is an MFD.  When the
> MFD code attempts unregister the MFD drivers, it oops when the non-MFD
> devices are accessed since they don't have the mfd_cell node.
That's probably correct. I just merged commit
5dc4dda91c86ef82bd53d77e5de50ec095b33e46 into my for-next branch and that one
could fix that issue. Could you guys please give it a go ? This is the actual
patch:

>From 5dc4dda91c86ef82bd53d77e5de50ec095b33e46 Mon Sep 17 00:00:00 2001
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Date: Fri, 9 Nov 2012 16:15:28 +0000
Subject: [PATCH] mfd: Only unregister platform devices allocated by the mfd
 core

mfd_remove_devices would iterate over all devices sharing a parent with
an mfd device regardless of whether they were allocated by the mfd core
or not. This especially caused problems when the device structure was
not contained within a platform_device, because to_platform_device is
used on each device pointer.

This patch defines a device_type for mfd devices and checks this is
present from mfd_remove_devices_fn before processing the device.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/mfd-core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f8b7771..7604f4e 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -21,6 +21,10 @@
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 
+static struct device_type mfd_dev_type = {
+	.name	= "mfd_device",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -91,6 +95,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_dev_type;
 
 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
@@ -204,10 +209,16 @@ EXPORT_SYMBOL(mfd_add_devices);
 
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct platform_device *pdev;
+	const struct mfd_cell *cell;
 	atomic_t **usage_count = c;
 
+	if (dev->type != &mfd_dev_type)
+		return 0;
+
+	pdev = to_platform_device(dev);
+	cell = mfd_get_cell(pdev);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
-- 
1.7.10.4

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
