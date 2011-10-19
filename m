Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1JSMGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:06:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41656 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1JSMF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:05:59 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 22/24] Staging: comedi: fix printk issue in das1800.c
Date: Wed, 19 Oct 2011 17:34:56 +0530
Message-Id: <1319025898-10864-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319025898-10864-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319025898-10864-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a printk
warning found by the checkpatch.pl tool
Converted printks to dev_printk.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   90 +++++++++++++-----------------
 1 files changed, 39 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..354ddc7 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -573,22 +573,23 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			devpriv->dma_bits |= DMA_CH7_CH5;
 			break;
 		default:
-			printk(" only supports dma channels 5 through 7\n"
-			       " Dual dma only allows the following combinations:\n"
-			       " dma 5,6 / 6,7 / or 7,5\n");
+			dev_err(dev->hw_dev, " only supports dma channels 5 through 7\n"
+				" Dual dma only allows the following combinations:\n"
+				" dma 5,6 / 6,7 / or 7,5\n");
 			return -EINVAL;
 			break;
 		}
 		if (request_dma(dma0, driver_das1800.driver_name)) {
-			printk(" failed to allocate dma channel %i\n", dma0);
+			dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
+				dma0);
 			return -EINVAL;
 		}
 		devpriv->dma0 = dma0;
 		devpriv->dma_current = dma0;
 		if (dma1) {
 			if (request_dma(dma1, driver_das1800.driver_name)) {
-				printk(" failed to allocate dma channel %i\n",
-				       dma1);
+				dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
+					dma1);
 				return -EINVAL;
 			}
 			devpriv->dma1 = dma1;
@@ -631,35 +632,31 @@ static int das1800_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
 		return -ENOMEM;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_das1800.driver_name,
-	       iobase);
 	if (irq) {
-		printk(", irq %u", irq);
+		dev_dbg(dev->hw_dev, "irq %u\n", irq);
 		if (dma0) {
-			printk(", dma %u", dma0);
+			dev_dbg(dev->hw_dev, "dma %u\n", dma0);
 			if (dma1)
-				printk(" and %u", dma1);
+				dev_dbg(dev->hw_dev, "and %u\n", dma1);
 		}
 	}
-	printk("\n");
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		dev_err(dev->hw_dev, "io base address required\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, DAS1800_SIZE, driver_das1800.driver_name)) {
-		printk
-		    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-		     iobase, iobase + DAS1800_SIZE - 1);
+		dev_err(dev->hw_dev, "I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
+			iobase, iobase + DAS1800_SIZE - 1);
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	board = das1800_probe(dev);
 	if (board < 0) {
-		printk(" unable to determine board type\n");
+		dev_err(dev->hw_dev, "unable to determine board type\n");
 		return -ENODEV;
 	}
 
@@ -671,9 +668,8 @@ static int das1800_attach(struct comedi_device *dev,
 		iobase2 = iobase + IOBASE2;
 		if (!request_region(iobase2, DAS1800_SIZE,
 				    driver_das1800.driver_name)) {
-			printk
-			    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-			     iobase2, iobase2 + DAS1800_SIZE - 1);
+			dev_err(dev->hw_dev, "I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
+				iobase2, iobase2 + DAS1800_SIZE - 1);
 			return -EIO;
 		}
 		devpriv->iobase2 = iobase2;
@@ -683,7 +679,8 @@ static int das1800_attach(struct comedi_device *dev,
 	if (irq) {
 		if (request_irq(irq, das1800_interrupt, 0,
 				driver_das1800.driver_name, dev)) {
-			printk(" unable to allocate irq %u\n", irq);
+			dev_err(dev->hw_dev, "unable to allocate irq %u\n",
+				irq);
 			return -EINVAL;
 		}
 	}
@@ -712,7 +709,7 @@ static int das1800_attach(struct comedi_device *dev,
 		devpriv->irq_dma_bits |= 0x38;
 		break;
 	default:
-		printk(" irq out of range\n");
+		dev_err(dev->hw_dev, "irq out of range\n");
 		return -EINVAL;
 		break;
 	}
@@ -813,9 +810,6 @@ static int das1800_detach(struct comedi_device *dev)
 		kfree(devpriv->ai_buf1);
 	}
 
-	printk("comedi%d: %s: remove\n", dev->minor,
-	       driver_das1800.driver_name);
-
 	return 0;
 };
 
@@ -833,69 +827,63 @@ static int das1800_probe(struct comedi_device *dev)
 	case 0x3:
 		if (board == das1801st_da || board == das1802st_da ||
 		    board == das1701st_da || board == das1702st_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st-da series\n");
+		dev_dbg(dev->hw_dev, "Board model (probed, not recommended): das-1800st-da series\n");
 		return das1801st;
 		break;
 	case 0x4:
 		if (board == das1802hr_da || board == das1702hr_da) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1802hr-da\n");
+		dev_dbg(dev->hw_dev, "Board model (probed, not recommended): das-1802hr-da\n");
 		return das1802hr;
 		break;
 	case 0x5:
 		if (board == das1801ao || board == das1802ao ||
 		    board == das1701ao || board == das1702ao) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800ao series\n");
+		dev_dbg(dev->hw_dev, "Board model (probed, not recommended): das-1800ao series\n");
 		return das1801ao;
 		break;
 	case 0x6:
 		if (board == das1802hr || board == das1702hr) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk(" Board model (probed, not recommended): das-1802hr\n");
+		dev_dbg(dev->hw_dev, "Board model (probed, not recommended): das-1802hr\n");
 		return das1802hr;
 		break;
 	case 0x7:
 		if (board == das1801st || board == das1802st ||
 		    board == das1701st || board == das1702st) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st series\n");
+		dev_dbg(dev->hw_dev, "Board model (probed, not recommended): das-1800st series\n");
 		return das1801st;
 		break;
 	case 0x8:
 		if (board == das1801hc || board == das1802hc) {
-			printk(" Board model: %s\n",
-			       das1800_boards[board].name);
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
 			return board;
 		}
-		printk
-		    (" Board model (probed, not recommended): das-1800hc series\n");
+		dev_dbg(dev->hw_dev, "Board model (probed, not recommended): das-1800hc series\n");
 		return das1801hc;
 		break;
 	default:
-		printk
-		    (" Board model: probe returned 0x%x (unknown, please report)\n",
-		     id);
+		dev_dbg(dev->hw_dev, "Board model: probe returned 0x%x (unknown, please report)\n",
+			id);
 		return board;
 		break;
 	}
-- 
1.7.6.4

