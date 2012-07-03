Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2GCBMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:12:06 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:51277 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCBMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:12:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1341277922!13214552!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] staging: comedi: dmm32at: remove forward declarations 2
Date: Mon, 2 Jul 2012 18:11:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021811.57003.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the dmm32at_ns_to_timer() and dmm32at_setaitimer() functions
to remove the need for the remaining forward declarations.

Also, make dmm32at_setaitimer() static, it's only referenced in
this file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 100 +++++++++++++++----------------
 1 file changed, 48 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 9c3d322..c139eff 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -198,10 +198,6 @@ struct dmm32at_private {
  */
 #define devpriv ((struct dmm32at_private *)dev->private)
 
-/* prototypes for driver functions below */
-static int dmm32at_ns_to_timer(unsigned int *ns, int round);
-void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec);
-
 /*
  * "instructions" read/write data in "one-shot" or "software-triggered"
  * mode.
@@ -279,6 +275,23 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 	return n;
 }
 
+/* This function doesn't require a particular form, this is just
+ * what happens to be used in some of the drivers.  It should
+ * convert ns nanoseconds to a counter value suitable for programming
+ * the device.  Also, it should adjust ns so that it cooresponds to
+ * the actual time that the device will use. */
+static int dmm32at_ns_to_timer(unsigned int *ns, int round)
+{
+	/* trivial timer */
+	/* if your timing is done through two cascaded timers, the
+	 * i8253_cascade_ns_to_timer() function in 8253.h can be
+	 * very helpful.  There are also i8254_load() and i8254_mm_load()
+	 * which can be used to load values into the ubiquitous 8254 counters
+	 */
+
+	return *ns;
+}
+
 static int dmm32at_ai_cmdtest(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_cmd *cmd)
@@ -465,6 +478,37 @@ static int dmm32at_ai_cmdtest(struct comedi_device *dev,
 	return 0;
 }
 
+static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
+{
+	unsigned char lo1, lo2, hi2;
+	unsigned short both2;
+
+	/* based on 10mhz clock */
+	lo1 = 200;
+	both2 = nansec / 20000;
+	hi2 = (both2 & 0xff00) >> 8;
+	lo2 = both2 & 0x00ff;
+
+	/* set the counter frequency to 10mhz */
+	dmm_outb(dev, DMM32AT_CNTRDIO, 0);
+
+	/* get access to the clock regs */
+	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_CLKACC);
+
+	/* write the counter 1 control word and low byte to counter */
+	dmm_outb(dev, DMM32AT_CLKCT, DMM32AT_CLKCT1);
+	dmm_outb(dev, DMM32AT_CLK1, lo1);
+
+	/* write the counter 2 control word and low byte then to counter */
+	dmm_outb(dev, DMM32AT_CLKCT, DMM32AT_CLKCT2);
+	dmm_outb(dev, DMM32AT_CLK2, lo2);
+	dmm_outb(dev, DMM32AT_CLK2, hi2);
+
+	/* enable the ai conversion interrupt and the clock to start scans */
+	dmm_outb(dev, DMM32AT_INTCLOCK, DMM32AT_ADINT | DMM32AT_CLKSEL);
+
+}
+
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct comedi_cmd *cmd = &s->async->cmd;
@@ -591,23 +635,6 @@ static irqreturn_t dmm32at_isr(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-/* This function doesn't require a particular form, this is just
- * what happens to be used in some of the drivers.  It should
- * convert ns nanoseconds to a counter value suitable for programming
- * the device.  Also, it should adjust ns so that it cooresponds to
- * the actual time that the device will use. */
-static int dmm32at_ns_to_timer(unsigned int *ns, int round)
-{
-	/* trivial timer */
-	/* if your timing is done through two cascaded timers, the
-	 * i8253_cascade_ns_to_timer() function in 8253.h can be
-	 * very helpful.  There are also i8254_load() and i8254_mm_load()
-	 * which can be used to load values into the ubiquitous 8254 counters
-	 */
-
-	return *ns;
-}
-
 static int dmm32at_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -758,37 +785,6 @@ static int dmm32at_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
-{
-	unsigned char lo1, lo2, hi2;
-	unsigned short both2;
-
-	/* based on 10mhz clock */
-	lo1 = 200;
-	both2 = nansec / 20000;
-	hi2 = (both2 & 0xff00) >> 8;
-	lo2 = both2 & 0x00ff;
-
-	/* set the counter frequency to 10mhz */
-	dmm_outb(dev, DMM32AT_CNTRDIO, 0);
-
-	/* get access to the clock regs */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_CLKACC);
-
-	/* write the counter 1 control word and low byte to counter */
-	dmm_outb(dev, DMM32AT_CLKCT, DMM32AT_CLKCT1);
-	dmm_outb(dev, DMM32AT_CLK1, lo1);
-
-	/* write the counter 2 control word and low byte then to counter */
-	dmm_outb(dev, DMM32AT_CLKCT, DMM32AT_CLKCT2);
-	dmm_outb(dev, DMM32AT_CLK2, lo2);
-	dmm_outb(dev, DMM32AT_CLK2, hi2);
-
-	/* enable the ai conversion interrupt and the clock to start scans */
-	dmm_outb(dev, DMM32AT_INTCLOCK, DMM32AT_ADINT | DMM32AT_CLKSEL);
-
-}
-
 static int dmm32at_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
-- 
1.7.11

