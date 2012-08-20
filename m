Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab2HTTxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:53:34 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:24210 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2HTTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:53:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1345492389!7969587!49
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] staging: comedi: comedi_bond: remove private printk macros
Date: Mon, 20 Aug 2012 12:53:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201253.20453.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the macros LOG_MSG, DEBUG, WARNING, and ERROR. Convert
the printk's into dev_printk format.

The DEBUG macro is not being used in the file so the module
parameter 'debug' can also be removed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 48 +++++++++++-----------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 6829910..1ca939c 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -65,20 +65,6 @@ Configuration Options:
 #  define STR(x) STR1(x)
 #endif
 
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "If true, print extra cryptic debugging output useful"
-		 "only to developers.");
-
-#define LOG_MSG(x...) printk(KERN_INFO MODULE_NAME": "x)
-#define DEBUG(x...)							\
-	do {								\
-		if (debug)						\
-			printk(KERN_DEBUG MODULE_NAME": DEBUG: "x);	\
-	} while (0)
-#define WARNING(x...)  printk(KERN_WARNING MODULE_NAME ": WARNING: "x)
-#define ERROR(x...)  printk(KERN_ERR MODULE_NAME ": INTERNAL ERROR: "x)
-
 struct BondedDevice {
 	struct comedi_device *dev;
 	unsigned minor;
@@ -228,15 +214,18 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 		struct BondedDevice *bdev = NULL;
 
 		if (minor < 0 || minor >= COMEDI_NUM_BOARD_MINORS) {
-			ERROR("Minor %d is invalid!\n", minor);
+			dev_err(dev->class_dev,
+				"Minor %d is invalid!\n", minor);
 			return 0;
 		}
 		if (minor == dev->minor) {
-			ERROR("Cannot bond this driver to itself!\n");
+			dev_err(dev->class_dev,
+				"Cannot bond this driver to itself!\n");
 			return 0;
 		}
 		if (devs_opened[minor]) {
-			ERROR("Minor %d specified more than once!\n", minor);
+			dev_err(dev->class_dev,
+				"Minor %d specified more than once!\n", minor);
 			return 0;
 		}
 
@@ -246,7 +235,8 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 		d = devs_opened[minor] = comedi_open(file);
 
 		if (!d) {
-			ERROR("Minor %u could not be opened\n", minor);
+			dev_err(dev->class_dev,
+				"Minor %u could not be opened\n", minor);
 			return 0;
 		}
 
@@ -255,14 +245,14 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 							     sdev + 1)) > -1) {
 			nchans = comedi_get_n_channels(d, sdev);
 			if (nchans <= 0) {
-				ERROR("comedi_get_n_channels() returned %d "
-				      "on minor %u subdev %d!\n",
-				      nchans, minor, sdev);
+				dev_err(dev->class_dev,
+					"comedi_get_n_channels() returned %d on minor %u subdev %d!\n",
+					nchans, minor, sdev);
 				return 0;
 			}
 			bdev = kmalloc(sizeof(*bdev), GFP_KERNEL);
 			if (!bdev) {
-				ERROR("Out of memory.\n");
+				dev_err(dev->class_dev, "Out of memory\n");
 				return 0;
 			}
 			bdev->dev = d;
@@ -285,8 +275,8 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 			    Realloc(devpriv->devs,
 				    ++devpriv->ndevs * sizeof(bdev), tmp);
 			if (!devpriv->devs) {
-				ERROR("Could not allocate memory. "
-				      "Out of memory?");
+				dev_err(dev->class_dev,
+					"Could not allocate memory. Out of memory?\n");
 				return 0;
 			}
 
@@ -306,7 +296,7 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (!devpriv->nchans) {
-		ERROR("No channels found!\n");
+		dev_err(dev->class_dev, "No channels found!\n");
 		return 0;
 	}
 
@@ -320,8 +310,6 @@ static int bonding_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int ret;
 
-	LOG_MSG("comedi%d\n", dev->minor);
-
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret)
 		return ret;
@@ -348,9 +336,9 @@ static int bonding_attach(struct comedi_device *dev,
 	s->insn_bits = bonding_dio_insn_bits;
 	s->insn_config = bonding_dio_insn_config;
 
-	LOG_MSG("attached with %u DIO channels coming from %u different "
-		"subdevices all bonded together.  "
-		"John Lennon would be proud!\n",
+	dev_info(dev->class_dev,
+		"%s: %s attached, %u channels from %u devices\n",
+		dev->driver->driver_name, dev->board_name,
 		devpriv->nchans, devpriv->ndevs);
 
 	return 1;
-- 
1.7.11

