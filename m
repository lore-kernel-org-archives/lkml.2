Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1EIAdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:34496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab1EIAdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="639848434"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 14/19] mfd: Use mfd cell platform_data for janz cells platform bits
Date: Mon,  9 May 2011 02:32:06 +0200
Message-Id: <1304901131-7104-15-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/gpio/janz-ttl.c      |    3 +--
 drivers/mfd/janz-cmodio.c    |    3 ++-
 drivers/net/can/janz-ican3.c |    3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/janz-ttl.c
index 2514fb0..813ac07 100644
--- a/drivers/gpio/janz-ttl.c
+++ b/drivers/gpio/janz-ttl.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
@@ -150,7 +149,7 @@ static int __devinit ttl_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	pdata = mfd_get_data(pdev);
+	pdata = pdev->dev.platform_data;
 	if (!pdata) {
 		dev_err(dev, "no platform data\n");
 		ret = -ENXIO;
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index fc41911..5c2a06a 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -86,7 +86,8 @@ static int __devinit cmodio_setup_subdevice(struct cmodio_device *priv,
 
 	/* Add platform data */
 	pdata->modno = modno;
-	cell->mfd_data = pdata;
+	cell->platform_data = pdata;
+	cell->pdata_size = sizeof(*pdata);
 
 	/* MODULbus registers -- PCI BAR3 is big-endian MODULbus access */
 	res->flags = IORESOURCE_MEM;
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 587fba4..f1942ca 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 
 #include <linux/netdevice.h>
 #include <linux/can.h>
@@ -1644,7 +1643,7 @@ static int __devinit ican3_probe(struct platform_device *pdev)
 	struct device *dev;
 	int ret;
 
-	pdata = mfd_get_data(pdev);
+	pdata = pdev->dev.platform_data;
 	if (!pdata)
 		return -ENXIO;
 
-- 
1.7.2.3

