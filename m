Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2FNCNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:13:33 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:51959 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2FNCNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:13:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1339640010!6789519!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] staging: comedi: me4000: remove ISR_PDEBUG macro
Date: Wed, 13 Jun 2012 19:13:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131913.16240.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISR_PDEBUG macro is used to output trace messages in the isr
routine. This shouldn't be in a mainline driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/me4000.c |   22 +---------------------
 drivers/staging/comedi/drivers/me4000.h |    8 --------
 2 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 5b45146..657d2fa 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1451,12 +1451,8 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	int c = 0;
 	long lval;
 
-	ISR_PDEBUG("me4000_ai_isr() is executed\n");
-
-	if (!dev->attached) {
-		ISR_PDEBUG("me4000_ai_isr() premature interrupt\n");
+	if (!dev->attached)
 		return IRQ_NONE;
-	}
 
 	/* Reset all events */
 	s->async->events = 0;
@@ -1471,16 +1467,12 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 
 	if (inl(ai_context->irq_status_reg) &
 	    ME4000_IRQ_STATUS_BIT_AI_HF) {
-		ISR_PDEBUG
-		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
-
 		/* Read status register to find out what happened */
 		tmp = inl(ai_context->ctrl_reg);
 
 		if (!(tmp & ME4000_AI_STATUS_BIT_FF_DATA) &&
 		    !(tmp & ME4000_AI_STATUS_BIT_HF_DATA) &&
 		    (tmp & ME4000_AI_STATUS_BIT_EF_DATA)) {
-			ISR_PDEBUG("me4000_ai_isr(): Fifo full\n");
 			c = ME4000_AI_FIFO_COUNT;
 
 			/*
@@ -1500,8 +1492,6 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		} else if ((tmp & ME4000_AI_STATUS_BIT_FF_DATA)
 			   && !(tmp & ME4000_AI_STATUS_BIT_HF_DATA)
 			   && (tmp & ME4000_AI_STATUS_BIT_EF_DATA)) {
-			ISR_PDEBUG("me4000_ai_isr(): Fifo half full\n");
-
 			s->async->events |= COMEDI_CB_BLOCK;
 
 			c = ME4000_AI_FIFO_COUNT / 2;
@@ -1527,8 +1517,6 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			       "Undefined FIFO state\n", dev->minor);
 		}
 
-		ISR_PDEBUG("me4000_ai_isr(): Try to read %d values\n", c);
-
 		for (i = 0; i < c; i++) {
 			/* Read value from data fifo */
 			lval = inl(ai_context->data_reg) & 0xFFFF;
@@ -1555,7 +1543,6 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		}
 
 		/* Work is done, so reset the interrupt */
-		ISR_PDEBUG("me4000_ai_isr(): Reset fifo half full interrupt\n");
 		tmp |= ME4000_AI_CTRL_BIT_HF_IRQ_RESET;
 		outl(tmp, ai_context->ctrl_reg);
 		tmp &= ~ME4000_AI_CTRL_BIT_HF_IRQ_RESET;
@@ -1563,9 +1550,6 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	}
 
 	if (inl(ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
-		ISR_PDEBUG
-		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
-
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
 
 		/*
@@ -1593,16 +1577,12 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		}
 
 		/* Work is done, so reset the interrupt */
-		ISR_PDEBUG
-		    ("me4000_ai_isr(): Reset interrupt from sample counter\n");
 		tmp |= ME4000_AI_CTRL_BIT_SC_IRQ_RESET;
 		outl(tmp, ai_context->ctrl_reg);
 		tmp &= ~ME4000_AI_CTRL_BIT_SC_IRQ_RESET;
 		outl(tmp, ai_context->ctrl_reg);
 	}
 
-	ISR_PDEBUG("me4000_ai_isr(): Events = 0x%X\n", s->async->events);
-
 	if (s->async->events)
 		comedi_event(dev, s);
 
diff --git a/drivers/staging/comedi/drivers/me4000.h b/drivers/staging/comedi/drivers/me4000.h
index d9ee3fb..f87dd19 100644
--- a/drivers/staging/comedi/drivers/me4000.h
+++ b/drivers/staging/comedi/drivers/me4000.h
@@ -28,16 +28,8 @@
   Debug section
   ===========================================================================*/
 
-#undef ME4000_ISR_DEBUG		/*  Debug the interrupt service routine */
 #undef ME4000_DEBUG		/*  General purpose debug masseges */
 
-#ifdef ME4000_ISR_DEBUG
-#undef ISR_PDEBUG
-#define ISR_PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor,  ##args)
-#else
-#define ISR_PDEBUG(fmt, args...)	/*  no debugging, do nothing */
-#endif
-
 #ifdef ME4000_DEBUG
 #undef PDEBUG
 #define PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor,  ##args)
-- 
1.7.7

