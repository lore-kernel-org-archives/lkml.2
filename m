Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2FUC0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:26:20 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:51408 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab2FUC0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:26:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1340245577!13127470!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/12] staging: comedi: s626: remove forward declarations 5
Date: Wed, 20 Jun 2012 19:26:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201926.12261.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the irq set/reset/clear and ns_to_timer helper functions
up to remove the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 224 +++++++++++++++++-----------------
 1 file changed, 109 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 3cdb293..cc18bf0 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -207,12 +207,6 @@ static struct dio_private *dio_private_word[]={
 #define devpriv ((struct s626_private *)dev->private)
 #define diopriv ((struct dio_private *)s->private)
 
-static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan);
-static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int gruop,
-			      unsigned int mask);
-static int s626_dio_clear_irq(struct comedi_device *dev);
-static int s626_ns_to_timer(int *nanosec, int round_mode);
-
 /*  COUNTER OBJECT ------------------------------------------------ */
 struct enc_private {
 	/*  Pointers to functions that differ for A and B counters: */
@@ -803,6 +797,87 @@ static unsigned int s626_ai_reg_to_uint(int data)
 /*   return 0; */
 /* } */
 
+static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
+{
+	unsigned int group;
+	unsigned int bitmask;
+	unsigned int status;
+
+	/* select dio bank */
+	group = chan / 16;
+	bitmask = 1 << (chan - (16 * group));
+	DEBUG("s626_dio_set_irq: enable interrupt on dio channel %d group %d\n",
+	      chan - (16 * group), group);
+
+	/* set channel to capture positive edge */
+	status = DEBIread(dev,
+			  ((struct dio_private *)(dev->subdevices + 2 +
+						  group)->private)->RDEdgSel);
+	DEBIwrite(dev,
+		  ((struct dio_private *)(dev->subdevices + 2 +
+					  group)->private)->WREdgSel,
+		  bitmask | status);
+
+	/* enable interrupt on selected channel */
+	status = DEBIread(dev,
+			  ((struct dio_private *)(dev->subdevices + 2 +
+						  group)->private)->RDIntSel);
+	DEBIwrite(dev,
+		  ((struct dio_private *)(dev->subdevices + 2 +
+					  group)->private)->WRIntSel,
+		  bitmask | status);
+
+	/* enable edge capture write command */
+	DEBIwrite(dev, LP_MISC1, MISC1_EDCAP);
+
+	/* enable edge capture on selected channel */
+	status = DEBIread(dev,
+			  ((struct dio_private *)(dev->subdevices + 2 +
+						  group)->private)->RDCapSel);
+	DEBIwrite(dev,
+		  ((struct dio_private *)(dev->subdevices + 2 +
+					  group)->private)->WRCapSel,
+		  bitmask | status);
+
+	return 0;
+}
+
+static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int group,
+			      unsigned int mask)
+{
+	DEBUG
+	    ("s626_dio_reset_irq: disable  interrupt on dio channel %d group %d\n",
+	     mask, group);
+
+	/* disable edge capture write command */
+	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
+
+	/* enable edge capture on selected channel */
+	DEBIwrite(dev,
+		  ((struct dio_private *)(dev->subdevices + 2 +
+					  group)->private)->WRCapSel, mask);
+
+	return 0;
+}
+
+static int s626_dio_clear_irq(struct comedi_device *dev)
+{
+	unsigned int group;
+
+	/* disable edge capture write command */
+	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
+
+	for (group = 0; group < S626_DIO_BANKS; group++) {
+		/* clear pending events and interrupt */
+		DEBIwrite(dev,
+			  ((struct dio_private *)(dev->subdevices + 2 +
+						  group)->private)->WRCapSel,
+			  0xffff);
+	}
+
+	return 0;
+}
+
 static irqreturn_t s626_irq_handler(int irq, void *d)
 {
 	struct comedi_device *dev = d;
@@ -1500,6 +1575,34 @@ static int s626_ai_inttrig(struct comedi_device *dev,
 	return 1;
 }
 
+/* This function doesn't require a particular form, this is just what
+ * happens to be used in some of the drivers.  It should convert ns
+ * nanoseconds to a counter value suitable for programming the device.
+ * Also, it should adjust ns so that it cooresponds to the actual time
+ * that the device will use. */
+static int s626_ns_to_timer(int *nanosec, int round_mode)
+{
+	int divider, base;
+
+	base = 500;		/* 2MHz internal clock */
+
+	switch (round_mode) {
+	case TRIG_ROUND_NEAREST:
+	default:
+		divider = (*nanosec + base / 2) / base;
+		break;
+	case TRIG_ROUND_DOWN:
+		divider = (*nanosec) / base;
+		break;
+	case TRIG_ROUND_UP:
+		divider = (*nanosec + base - 1) / base;
+		break;
+	}
+
+	*nanosec = base * divider;
+	return divider - 1;
+}
+
 /*  TO COMPLETE  */
 static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
@@ -1832,34 +1935,6 @@ static int s626_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	return 0;
 }
 
-/* This function doesn't require a particular form, this is just what
- * happens to be used in some of the drivers.  It should convert ns
- * nanoseconds to a counter value suitable for programming the device.
- * Also, it should adjust ns so that it cooresponds to the actual time
- * that the device will use. */
-static int s626_ns_to_timer(int *nanosec, int round_mode)
-{
-	int divider, base;
-
-	base = 500;		/* 2MHz internal clock */
-
-	switch (round_mode) {
-	case TRIG_ROUND_NEAREST:
-	default:
-		divider = (*nanosec + base / 2) / base;
-		break;
-	case TRIG_ROUND_DOWN:
-		divider = (*nanosec) / base;
-		break;
-	case TRIG_ROUND_UP:
-		divider = (*nanosec + base - 1) / base;
-		break;
-	}
-
-	*nanosec = base * divider;
-	return divider - 1;
-}
-
 static int s626_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
@@ -1980,87 +2055,6 @@ static int s626_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
-{
-	unsigned int group;
-	unsigned int bitmask;
-	unsigned int status;
-
-	/* select dio bank */
-	group = chan / 16;
-	bitmask = 1 << (chan - (16 * group));
-	DEBUG("s626_dio_set_irq: enable interrupt on dio channel %d group %d\n",
-	      chan - (16 * group), group);
-
-	/* set channel to capture positive edge */
-	status = DEBIread(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->RDEdgSel);
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WREdgSel,
-		  bitmask | status);
-
-	/* enable interrupt on selected channel */
-	status = DEBIread(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->RDIntSel);
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WRIntSel,
-		  bitmask | status);
-
-	/* enable edge capture write command */
-	DEBIwrite(dev, LP_MISC1, MISC1_EDCAP);
-
-	/* enable edge capture on selected channel */
-	status = DEBIread(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->RDCapSel);
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WRCapSel,
-		  bitmask | status);
-
-	return 0;
-}
-
-static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int group,
-			      unsigned int mask)
-{
-	DEBUG
-	    ("s626_dio_reset_irq: disable  interrupt on dio channel %d group %d\n",
-	     mask, group);
-
-	/* disable edge capture write command */
-	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
-
-	/* enable edge capture on selected channel */
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WRCapSel, mask);
-
-	return 0;
-}
-
-static int s626_dio_clear_irq(struct comedi_device *dev)
-{
-	unsigned int group;
-
-	/* disable edge capture write command */
-	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
-
-	for (group = 0; group < S626_DIO_BANKS; group++) {
-		/* clear pending events and interrupt */
-		DEBIwrite(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->WRCapSel,
-			  0xffff);
-	}
-
-	return 0;
-}
-
 /* Now this function initializes the value of the counter (data[0])
    and set the subdevice. To complete with trigger and interrupt
    configuration */
-- 
1.7.11

