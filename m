Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2ABNKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:10:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2ABNKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:10:32 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu, jj@chaosbits.net,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/6] Staging: comedi: fix printk warning issue in dt2801.c
Date: Mon,  2 Jan 2012 18:39:58 +0530
Message-Id: <1325509801-20036-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a printk warning issue found by the checkpatch.pl
tool.
Convert printk messages to dev_<levels> and removes useless printk
messages.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt2801.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 5cce1b5..9f07365 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -424,7 +424,8 @@ static int dt2801_reset(struct comedi_device *dev)
 			break;
 	} while (timeout--);
 	if (!timeout)
-		printk("dt2801: timeout 1 status=0x%02x\n", stat);
+		dev_dbg(dev->hw_dev, "dt2801: timeout 1 status=0x%02x\n",
+			stat);
 
 	/* printk("dt2801: reading dummy\n"); */
 	/* dt2801_readdata(dev,&board_code); */
@@ -441,7 +442,8 @@ static int dt2801_reset(struct comedi_device *dev)
 			break;
 	} while (timeout--);
 	if (!timeout)
-		printk("dt2801: timeout 2 status=0x%02x\n", stat);
+		dev_dbg(dev->hw_dev, "dt2801: timeout 2 status=0x%02x\n",
+			stat);
 
 	DPRINTK("dt2801: reading code\n");
 	dt2801_readdata(dev, &board_code);
@@ -521,10 +523,8 @@ static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int n_ai_chans;
 
 	iobase = it->options[0];
-	if (!request_region(iobase, DT2801_IOSIZE, "dt2801")) {
-		comedi_error(dev, "I/O port conflict");
+	if (!request_region(iobase, DT2801_IOSIZE, "dt2801"))
 		return -EIO;
-	}
 	dev->iobase = iobase;
 
 	/* do some checking */
@@ -539,16 +539,13 @@ static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (boardtypes[type].boardcode == board_code)
 			goto havetype;
 	}
-	printk("dt2801: unrecognized board code=0x%02x, contact author\n",
-	       board_code);
+	dev_warn(dev->hw_dev, "dt2801: unrecognized board code=0x%02x, contact author\n",
+		 board_code);
 	type = 0;
 
 havetype:
 	dev->board_ptr = boardtypes + type;
-	printk("dt2801: %s at port 0x%lx", boardtype.name, iobase);
-
 	n_ai_chans = probe_number_of_ai_chans(dev);
-	printk(" (ai channels = %d)", n_ai_chans);
 
 	ret = alloc_subdevices(dev, 4);
 	if (ret < 0)
@@ -610,7 +607,6 @@ havetype:
 
 	ret = 0;
 out:
-	printk("\n");
 
 	return ret;
 }
@@ -627,12 +623,13 @@ static int dt2801_error(struct comedi_device *dev, int stat)
 {
 	if (stat < 0) {
 		if (stat == -ETIME)
-			printk("dt2801: timeout\n");
+			dev_err(dev->hw_dev, "dt2801: timeout\n");
 		else
-			printk("dt2801: error %d\n", stat);
+			dev_err(dev->hw_dev, "dt2801: error %d\n", stat);
 		return stat;
 	}
-	printk("dt2801: error status 0x%02x, resetting...\n", stat);
+	dev_err(dev->hw_dev, "dt2801: error status 0x%02x, resetting...\n",
+		stat);
 
 	dt2801_reset(dev);
 	dt2801_reset(dev);
-- 
1.7.0.4

