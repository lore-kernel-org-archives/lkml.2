Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2ADMlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:41:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2ADMlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:41:09 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 07/11] Staging: comedi: fix printk warning issue in dt2801.c
Date: Wed,  4 Jan 2012 18:10:02 +0530
Message-Id: <1325680806-10917-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up a printk warning found by the checkpatch.tool.
Convert printk to dev_<levels>.
Removes useless printk messages.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt2801.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 5cce1b5..9433712 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -389,7 +389,8 @@ static int dt2801_writecmd(struct comedi_device *dev, int command)
 		    ("dt2801: composite-error in dt2801_writecmd(), ignoring\n");
 	}
 	if (!(stat & DT_S_READY))
-		printk("dt2801: !ready in dt2801_writecmd(), ignoring\n");
+		printk
+		    ("dt2801: !ready in dt2801_writecmd(), ignoring\n");
 	outb_p(command, dev->iobase + DT2801_CMD);
 
 	return 0;
@@ -424,7 +425,7 @@ static int dt2801_reset(struct comedi_device *dev)
 			break;
 	} while (timeout--);
 	if (!timeout)
-		printk("dt2801: timeout 1 status=0x%02x\n", stat);
+		dev_dbg(dev->hw_dev, "dt2801: timeout 1 status=0x%02x\n", stat);
 
 	/* printk("dt2801: reading dummy\n"); */
 	/* dt2801_readdata(dev,&board_code); */
@@ -441,7 +442,7 @@ static int dt2801_reset(struct comedi_device *dev)
 			break;
 	} while (timeout--);
 	if (!timeout)
-		printk("dt2801: timeout 2 status=0x%02x\n", stat);
+		dev_dbg(dev->hw_dev, "dt2801: timeout 2 status=0x%02x\n", stat);
 
 	DPRINTK("dt2801: reading code\n");
 	dt2801_readdata(dev, &board_code);
@@ -539,17 +540,11 @@ static int dt2801_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (boardtypes[type].boardcode == board_code)
 			goto havetype;
 	}
-	printk("dt2801: unrecognized board code=0x%02x, contact author\n",
-	       board_code);
 	type = 0;
 
 havetype:
 	dev->board_ptr = boardtypes + type;
-	printk("dt2801: %s at port 0x%lx", boardtype.name, iobase);
-
 	n_ai_chans = probe_number_of_ai_chans(dev);
-	printk(" (ai channels = %d)", n_ai_chans);
-
 	ret = alloc_subdevices(dev, 4);
 	if (ret < 0)
 		goto out;
@@ -610,7 +605,6 @@ havetype:
 
 	ret = 0;
 out:
-	printk("\n");
 
 	return ret;
 }
@@ -627,12 +621,13 @@ static int dt2801_error(struct comedi_device *dev, int stat)
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

