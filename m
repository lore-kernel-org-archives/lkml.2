Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2F3AiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:38:24 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:38508 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2F3AiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:38:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1341016701!24772034!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/10] staging: comedi: ni_670x: change printk's to cleaned up dev_printk's
Date: Fri, 29 Jun 2012 17:38:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291738.18431.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all the prink's in this file to dev_prink's.

Change the INFO message in ni_670x_find_device into a dev_warn().
This message is only displayed if a matching device was not found.
A warning is more appropriate here than info.

Consolidate the attach messages into one dev_info() output after
the successful attach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index d53d20c..c9c72c5 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -217,7 +217,7 @@ static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot)
 			}
 		}
 	}
-	printk(KERN_INFO "no device found\n");
+	dev_warn(dev->class_dev, "no device found\n");
 	mite_list_devices();
 	return -EIO;
 }
@@ -231,8 +231,6 @@ static int ni_670x_attach(struct comedi_device *dev,
 	int ret;
 	int i;
 
-	printk(KERN_INFO "comedi%d: ni_670x: ", dev->minor);
-
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
@@ -245,12 +243,11 @@ static int ni_670x_attach(struct comedi_device *dev,
 
 	ret = mite_setup(devpriv->mite);
 	if (ret < 0) {
-		printk(KERN_WARNING "error setting up mite\n");
+		dev_warn(dev->class_dev, "error setting up mite\n");
 		return ret;
 	}
 	dev->board_name = thisboard->name;
 	dev->irq = mite_irq(devpriv->mite);
-	printk(KERN_INFO " %s", dev->board_name);
 
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
@@ -295,7 +292,8 @@ static int ni_670x_attach(struct comedi_device *dev,
 	/* Config of ao registers */
 	writel(0x00, devpriv->mite->daq_io_addr + AO_CONTROL_OFFSET);
 
-	printk(KERN_INFO "attached\n");
+	dev_info(dev->class_dev, "%s: %s attached\n",
+		dev->driver->driver_name, dev->board_name);
 
 	return 1;
 }
-- 
1.7.11

