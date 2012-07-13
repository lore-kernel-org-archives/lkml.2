Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2GMAqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:46:44 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:9562 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab2GMAqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:46:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1342140401!12848307!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] staging: comedi: dt282x: remove the outw wrapper macros
Date: Thu, 12 Jul 2012 17:46:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207121746.38097.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros 'update_dacsr', 'update_adcsr', and 'update_supcsr' all use
the 'devpriv' macro which uses a local variable of a specific name and
yeilds a pointer derived from that name. They are also just wrappers
around simple 'outw' calls. Remove the macros.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt282x.c | 55 +++++++++++++++++----------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 4af3343..1f0b40e 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -255,11 +255,8 @@ struct dt282x_private {
  *    Some useless abstractions
  */
 #define chan_to_DAC(a)	((a)&1)
-#define update_dacsr(a)	outw(devpriv->dacsr|(a), dev->iobase+DT2821_DACSR)
-#define update_adcsr(a)	outw(devpriv->adcsr|(a), dev->iobase+DT2821_ADCSR)
 #define mux_busy() (inw(dev->iobase+DT2821_ADCSR)&DT2821_MUXBUSY)
 #define ad_done() (inw(dev->iobase+DT2821_ADCSR)&DT2821_ADDONE)
-#define update_supcsr(a) outw(devpriv->supcsr|(a), dev->iobase+DT2821_SUPCSR)
 
 /*
  *    danger! macro abuse... a is the expression to wait on, and b is
@@ -317,7 +314,7 @@ static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
 	int i;
 	struct comedi_subdevice *s = dev->subdevices + 1;
 
-	update_supcsr(DT2821_CLRDMADNE);
+	outw(devpriv->supcsr | DT2821_CLRDMADNE, dev->iobase + DT2821_SUPCSR);
 
 	if (!s->async->prealloc_buf) {
 		printk(KERN_ERR "async->data disappeared.  dang!\n");
@@ -350,7 +347,7 @@ static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 	int ret;
 	struct comedi_subdevice *s = dev->subdevices;
 
-	update_supcsr(DT2821_CLRDMADNE);
+	outw(devpriv->supcsr | DT2821_CLRDMADNE, dev->iobase + DT2821_SUPCSR);
 
 	if (!s->async->prealloc_buf) {
 		printk(KERN_ERR "async->data disappeared.  dang!\n");
@@ -387,7 +384,7 @@ static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 	/* XXX probably wrong */
 	if (!devpriv->ntrig) {
 		devpriv->supcsr &= ~(DT2821_DDMA);
-		update_supcsr(0);
+		outw(devpriv->supcsr, dev->iobase + DT2821_SUPCSR);
 	}
 #endif
 	/* restart the channel */
@@ -513,7 +510,8 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 			s->async->events |= COMEDI_CB_EOA;
 		} else {
 			if (supcsr & DT2821_SCDN)
-				update_supcsr(DT2821_STRIG);
+				outw(devpriv->supcsr | DT2821_STRIG,
+					dev->iobase + DT2821_SUPCSR);
 		}
 		handled = 1;
 	}
@@ -534,7 +532,8 @@ static void dt282x_load_changain(struct comedi_device *dev, int n,
 	for (i = 0; i < n; i++) {
 		chan = CR_CHAN(chanlist[i]);
 		range = CR_RANGE(chanlist[i]);
-		update_adcsr((range << 4) | (chan));
+		outw(devpriv->adcsr | (range << 4) | chan,
+			dev->iobase + DT2821_ADCSR);
 	}
 	outw(n - 1, dev->iobase + DT2821_CHANCSR);
 }
@@ -553,15 +552,16 @@ static int dt282x_ai_insn_read(struct comedi_device *dev,
 
 	/* XXX should we really be enabling the ad clock here? */
 	devpriv->adcsr = DT2821_ADCLK;
-	update_adcsr(0);
+	outw(devpriv->adcsr, dev->iobase + DT2821_ADCSR);
 
 	dt282x_load_changain(dev, 1, &insn->chanspec);
 
-	update_supcsr(DT2821_PRLD);
+	outw(devpriv->supcsr | DT2821_PRLD, dev->iobase + DT2821_SUPCSR);
 	wait_for(!mux_busy(), comedi_error(dev, "timeout\n"); return -ETIME;);
 
 	for (i = 0; i < insn->n; i++) {
-		update_supcsr(DT2821_STRIG);
+		outw(devpriv->supcsr | DT2821_STRIG,
+			dev->iobase + DT2821_SUPCSR);
 		wait_for(ad_done(), comedi_error(dev, "timeout\n");
 			 return -ETIME;);
 
@@ -718,7 +718,8 @@ static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* external trigger */
 		devpriv->supcsr = DT2821_ERRINTEN | DT2821_DS0 | DT2821_DS1;
 	}
-	update_supcsr(DT2821_CLRDMADNE | DT2821_BUFFB | DT2821_ADCINIT);
+	outw(devpriv->supcsr | DT2821_CLRDMADNE | DT2821_BUFFB | DT2821_ADCINIT,
+		dev->iobase + DT2821_SUPCSR);
 
 	devpriv->ntrig = cmd->stop_arg * cmd->scan_end_arg;
 	devpriv->nread = devpriv->ntrig;
@@ -729,7 +730,7 @@ static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (devpriv->ntrig) {
 		prep_ai_dma(dev, 1, 0);
 		devpriv->supcsr |= DT2821_DDMA;
-		update_supcsr(0);
+		outw(devpriv->supcsr, dev->iobase + DT2821_SUPCSR);
 	}
 
 	devpriv->adcsr = 0;
@@ -737,16 +738,17 @@ static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	dt282x_load_changain(dev, cmd->chanlist_len, cmd->chanlist);
 
 	devpriv->adcsr = DT2821_ADCLK | DT2821_IADDONE;
-	update_adcsr(0);
+	outw(devpriv->adcsr, dev->iobase + DT2821_ADCSR);
 
-	update_supcsr(DT2821_PRLD);
+	outw(devpriv->supcsr | DT2821_PRLD, dev->iobase + DT2821_SUPCSR);
 	wait_for(!mux_busy(), comedi_error(dev, "timeout\n"); return -ETIME;);
 
 	if (cmd->scan_begin_src == TRIG_FOLLOW) {
-		update_supcsr(DT2821_STRIG);
+		outw(devpriv->supcsr | DT2821_STRIG,
+			dev->iobase + DT2821_SUPCSR);
 	} else {
 		devpriv->supcsr |= DT2821_XTRIG;
-		update_supcsr(0);
+		outw(devpriv->supcsr, dev->iobase + DT2821_SUPCSR);
 	}
 
 	return 0;
@@ -766,10 +768,10 @@ static int dt282x_ai_cancel(struct comedi_device *dev,
 	dt282x_disable_dma(dev);
 
 	devpriv->adcsr = 0;
-	update_adcsr(0);
+	outw(devpriv->adcsr, dev->iobase + DT2821_ADCSR);
 
 	devpriv->supcsr = 0;
-	update_supcsr(DT2821_ADCINIT);
+	outw(devpriv->supcsr | DT2821_ADCINIT, dev->iobase + DT2821_SUPCSR);
 
 	return 0;
 }
@@ -845,11 +847,11 @@ static int dt282x_ao_insn_write(struct comedi_device *dev,
 			d ^= (1 << (boardtype.dabits - 1));
 	}
 
-	update_dacsr(0);
+	outw(devpriv->dacsr, dev->iobase + DT2821_DACSR);
 
 	outw(d, dev->iobase + DT2821_DADAT);
 
-	update_supcsr(DT2821_DACON);
+	outw(devpriv->supcsr | DT2821_DACON, dev->iobase + DT2821_SUPCSR);
 
 	return 1;
 }
@@ -972,7 +974,7 @@ static int dt282x_ao_inttrig(struct comedi_device *dev,
 	}
 	prep_ao_dma(dev, 1, size);
 
-	update_supcsr(DT2821_STRIG);
+	outw(devpriv->supcsr | DT2821_STRIG, dev->iobase + DT2821_SUPCSR);
 	s->async->inttrig = NULL;
 
 	return 1;
@@ -993,7 +995,8 @@ static int dt282x_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	dt282x_disable_dma(dev);
 
 	devpriv->supcsr = DT2821_ERRINTEN | DT2821_DS1 | DT2821_DDMA;
-	update_supcsr(DT2821_CLRDMADNE | DT2821_BUFFB | DT2821_DACINIT);
+	outw(devpriv->supcsr | DT2821_CLRDMADNE | DT2821_BUFFB | DT2821_DACINIT,
+		dev->iobase + DT2821_SUPCSR);
 
 	devpriv->ntrig = cmd->stop_arg * cmd->chanlist_len;
 	devpriv->nread = devpriv->ntrig;
@@ -1005,7 +1008,7 @@ static int dt282x_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	outw(timer, dev->iobase + DT2821_TMRCTR);
 
 	devpriv->dacsr = DT2821_SSEL | DT2821_DACLK | DT2821_IDARDY;
-	update_dacsr(0);
+	outw(devpriv->dacsr, dev->iobase + DT2821_DACSR);
 
 	s->async->inttrig = dt282x_ao_inttrig;
 
@@ -1018,10 +1021,10 @@ static int dt282x_ao_cancel(struct comedi_device *dev,
 	dt282x_disable_dma(dev);
 
 	devpriv->dacsr = 0;
-	update_dacsr(0);
+	outw(devpriv->dacsr, dev->iobase + DT2821_DACSR);
 
 	devpriv->supcsr = 0;
-	update_supcsr(DT2821_DACINIT);
+	outw(devpriv->supcsr | DT2821_DACINIT, dev->iobase + DT2821_SUPCSR);
 
 	return 0;
 }
-- 
1.7.11

