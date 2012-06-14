Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2FNCNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:13:07 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:7561 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNCNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:13:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1339639983!12351407!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] staging: comedi: me4000: remove inline port io wrappers
Date: Wed, 13 Jun 2012 19:12:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131912.55836.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the PORT_PDEBUG macro remove we can now remove the inline
port io wrappers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/me4000.c |  247 ++++++++++++-------------------
 1 files changed, 98 insertions(+), 149 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index ddb9384..5b45146 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -104,38 +104,6 @@ static int ai_write_chanlist(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_cmd *cmd);
 
-/*-----------------------------------------------------------------------------
-  Meilhaus inline functions
-  ---------------------------------------------------------------------------*/
-
-static inline void me4000_outb(struct comedi_device *dev, unsigned char value,
-			       unsigned long port)
-{
-	outb(value, port);
-}
-
-static inline void me4000_outl(struct comedi_device *dev, unsigned long value,
-			       unsigned long port)
-{
-	outl(value, port);
-}
-
-static inline unsigned long me4000_inl(struct comedi_device *dev,
-				       unsigned long port)
-{
-	unsigned long value;
-	value = inl(port);
-	return value;
-}
-
-static inline unsigned char me4000_inb(struct comedi_device *dev,
-				       unsigned long port)
-{
-	unsigned char value;
-	value = inb(port);
-	return value;
-}
-
 static const struct comedi_lrange me4000_ai_range = {
 	4,
 	{
@@ -611,56 +579,45 @@ static int reset_board(struct comedi_device *dev)
 	unsigned long icr;
 
 	/* Make a hardware reset */
-	icr = me4000_inl(dev, info->plx_regbase + PLX_ICR);
+	icr = inl(info->plx_regbase + PLX_ICR);
 	icr |= 0x40000000;
-	me4000_outl(dev, icr, info->plx_regbase + PLX_ICR);
+	outl(icr, info->plx_regbase + PLX_ICR);
 	icr &= ~0x40000000;
-	me4000_outl(dev, icr, info->plx_regbase + PLX_ICR);
+	outl(icr, info->plx_regbase + PLX_ICR);
 
 	/* 0x8000 to the DACs means an output voltage of 0V */
-	me4000_outl(dev, 0x8000,
-		    info->me4000_regbase + ME4000_AO_00_SINGLE_REG);
-	me4000_outl(dev, 0x8000,
-		    info->me4000_regbase + ME4000_AO_01_SINGLE_REG);
-	me4000_outl(dev, 0x8000,
-		    info->me4000_regbase + ME4000_AO_02_SINGLE_REG);
-	me4000_outl(dev, 0x8000,
-		    info->me4000_regbase + ME4000_AO_03_SINGLE_REG);
+	outl(0x8000, info->me4000_regbase + ME4000_AO_00_SINGLE_REG);
+	outl(0x8000, info->me4000_regbase + ME4000_AO_01_SINGLE_REG);
+	outl(0x8000, info->me4000_regbase + ME4000_AO_02_SINGLE_REG);
+	outl(0x8000, info->me4000_regbase + ME4000_AO_03_SINGLE_REG);
 
 	/* Set both stop bits in the analog input control register */
-	me4000_outl(dev,
-		    ME4000_AI_CTRL_BIT_IMMEDIATE_STOP | ME4000_AI_CTRL_BIT_STOP,
-		    info->me4000_regbase + ME4000_AI_CTRL_REG);
+	outl(ME4000_AI_CTRL_BIT_IMMEDIATE_STOP | ME4000_AI_CTRL_BIT_STOP,
+		info->me4000_regbase + ME4000_AI_CTRL_REG);
 
 	/* Set both stop bits in the analog output control register */
-	me4000_outl(dev,
-		    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
-		    info->me4000_regbase + ME4000_AO_00_CTRL_REG);
-	me4000_outl(dev,
-		    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
-		    info->me4000_regbase + ME4000_AO_01_CTRL_REG);
-	me4000_outl(dev,
-		    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
-		    info->me4000_regbase + ME4000_AO_02_CTRL_REG);
-	me4000_outl(dev,
-		    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
-		    info->me4000_regbase + ME4000_AO_03_CTRL_REG);
+	outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
+		info->me4000_regbase + ME4000_AO_00_CTRL_REG);
+	outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
+		info->me4000_regbase + ME4000_AO_01_CTRL_REG);
+	outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
+		info->me4000_regbase + ME4000_AO_02_CTRL_REG);
+	outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
+		info->me4000_regbase + ME4000_AO_03_CTRL_REG);
 
 	/* Enable interrupts on the PLX */
-	me4000_outl(dev, 0x43, info->plx_regbase + PLX_INTCSR);
+	outl(0x43, info->plx_regbase + PLX_INTCSR);
 
 	/* Set the adustment register for AO demux */
-	me4000_outl(dev, ME4000_AO_DEMUX_ADJUST_VALUE,
+	outl(ME4000_AO_DEMUX_ADJUST_VALUE,
 		    info->me4000_regbase + ME4000_AO_DEMUX_ADJUST_REG);
 
 	/*
 	 * Set digital I/O direction for port 0
 	 * to output on isolated versions
 	 */
-	if (!(me4000_inl(dev, info->me4000_regbase + ME4000_DIO_DIR_REG) & 0x1)) {
-		me4000_outl(dev, 0x1,
-			    info->me4000_regbase + ME4000_DIO_CTRL_REG);
-	}
+	if (!(inl(info->me4000_regbase + ME4000_DIO_DIR_REG) & 0x1))
+		outl(0x1, info->me4000_regbase + ME4000_DIO_CTRL_REG);
 
 	return 0;
 }
@@ -750,36 +707,34 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 	entry |= ME4000_AI_LIST_LAST_ENTRY;
 
 	/* Clear channel list, data fifo and both stop bits */
-	tmp = me4000_inl(dev, info->ai_context.ctrl_reg);
+	tmp = inl(info->ai_context.ctrl_reg);
 	tmp &= ~(ME4000_AI_CTRL_BIT_CHANNEL_FIFO |
 		 ME4000_AI_CTRL_BIT_DATA_FIFO |
 		 ME4000_AI_CTRL_BIT_STOP | ME4000_AI_CTRL_BIT_IMMEDIATE_STOP);
-	me4000_outl(dev, tmp, info->ai_context.ctrl_reg);
+	outl(tmp, info->ai_context.ctrl_reg);
 
 	/* Set the acquisition mode to single */
 	tmp &= ~(ME4000_AI_CTRL_BIT_MODE_0 | ME4000_AI_CTRL_BIT_MODE_1 |
 		 ME4000_AI_CTRL_BIT_MODE_2);
-	me4000_outl(dev, tmp, info->ai_context.ctrl_reg);
+	outl(tmp, info->ai_context.ctrl_reg);
 
 	/* Enable channel list and data fifo */
 	tmp |= ME4000_AI_CTRL_BIT_CHANNEL_FIFO | ME4000_AI_CTRL_BIT_DATA_FIFO;
-	me4000_outl(dev, tmp, info->ai_context.ctrl_reg);
+	outl(tmp, info->ai_context.ctrl_reg);
 
 	/* Generate channel list entry */
-	me4000_outl(dev, entry, info->ai_context.channel_list_reg);
+	outl(entry, info->ai_context.channel_list_reg);
 
 	/* Set the timer to maximum sample rate */
-	me4000_outl(dev, ME4000_AI_MIN_TICKS, info->ai_context.chan_timer_reg);
-	me4000_outl(dev, ME4000_AI_MIN_TICKS,
-		    info->ai_context.chan_pre_timer_reg);
+	outl(ME4000_AI_MIN_TICKS, info->ai_context.chan_timer_reg);
+	outl(ME4000_AI_MIN_TICKS, info->ai_context.chan_pre_timer_reg);
 
 	/* Start conversion by dummy read */
-	me4000_inl(dev, info->ai_context.start_reg);
+	inl(info->ai_context.start_reg);
 
 	/* Wait until ready */
 	udelay(10);
-	if (!
-	    (me4000_inl(dev, info->ai_context.status_reg) &
+	if (!(inl(info->ai_context.status_reg) &
 	     ME4000_AI_STATUS_BIT_EF_DATA)) {
 		printk(KERN_ERR
 		       "comedi%d: me4000: me4000_ai_insn_read(): "
@@ -788,7 +743,7 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 	}
 
 	/* Read value from data fifo */
-	lval = me4000_inl(dev, info->ai_context.data_reg) & 0xFFFF;
+	lval = inl(info->ai_context.data_reg) & 0xFFFF;
 	data[0] = lval ^ 0x8000;
 
 	return 1;
@@ -800,12 +755,12 @@ static int me4000_ai_cancel(struct comedi_device *dev,
 	unsigned long tmp;
 
 	/* Stop any running conversion */
-	tmp = me4000_inl(dev, info->ai_context.ctrl_reg);
+	tmp = inl(info->ai_context.ctrl_reg);
 	tmp &= ~(ME4000_AI_CTRL_BIT_STOP | ME4000_AI_CTRL_BIT_IMMEDIATE_STOP);
-	me4000_outl(dev, tmp, info->ai_context.ctrl_reg);
+	outl(tmp, info->ai_context.ctrl_reg);
 
 	/* Clear the control register */
-	me4000_outl(dev, 0x0, info->ai_context.ctrl_reg);
+	outl(0x0, info->ai_context.ctrl_reg);
 
 	return 0;
 }
@@ -960,18 +915,16 @@ static void ai_write_timer(struct comedi_device *dev,
 			   unsigned int init_ticks,
 			   unsigned int scan_ticks, unsigned int chan_ticks)
 {
-	me4000_outl(dev, init_ticks - 1,
-		    info->ai_context.scan_pre_timer_low_reg);
-	me4000_outl(dev, 0x0, info->ai_context.scan_pre_timer_high_reg);
+	outl(init_ticks - 1, info->ai_context.scan_pre_timer_low_reg);
+	outl(0x0, info->ai_context.scan_pre_timer_high_reg);
 
 	if (scan_ticks) {
-		me4000_outl(dev, scan_ticks - 1,
-			    info->ai_context.scan_timer_low_reg);
-		me4000_outl(dev, 0x0, info->ai_context.scan_timer_high_reg);
+		outl(scan_ticks - 1, info->ai_context.scan_timer_low_reg);
+		outl(0x0, info->ai_context.scan_timer_high_reg);
 	}
 
-	me4000_outl(dev, chan_ticks - 1, info->ai_context.chan_pre_timer_reg);
-	me4000_outl(dev, chan_ticks - 1, info->ai_context.chan_timer_reg);
+	outl(chan_ticks - 1, info->ai_context.chan_pre_timer_reg);
+	outl(chan_ticks - 1, info->ai_context.chan_timer_reg);
 }
 
 static int ai_prepare(struct comedi_device *dev,
@@ -987,7 +940,7 @@ static int ai_prepare(struct comedi_device *dev,
 	ai_write_timer(dev, init_ticks, scan_ticks, chan_ticks);
 
 	/* Reset control register */
-	me4000_outl(dev, tmp, info->ai_context.ctrl_reg);
+	outl(tmp, info->ai_context.ctrl_reg);
 
 	/* Start sources */
 	if ((cmd->start_src == TRIG_EXT &&
@@ -1020,12 +973,12 @@ static int ai_prepare(struct comedi_device *dev,
 
 	/* Stop triggers */
 	if (cmd->stop_src == TRIG_COUNT) {
-		me4000_outl(dev, cmd->chanlist_len * cmd->stop_arg,
+		outl(cmd->chanlist_len * cmd->stop_arg,
 			    info->ai_context.sample_counter_reg);
 		tmp |= ME4000_AI_CTRL_BIT_HF_IRQ | ME4000_AI_CTRL_BIT_SC_IRQ;
 	} else if (cmd->stop_src == TRIG_NONE &&
 		   cmd->scan_end_src == TRIG_COUNT) {
-		me4000_outl(dev, cmd->scan_end_arg,
+		outl(cmd->scan_end_arg,
 			    info->ai_context.sample_counter_reg);
 		tmp |= ME4000_AI_CTRL_BIT_HF_IRQ | ME4000_AI_CTRL_BIT_SC_IRQ;
 	} else {
@@ -1033,7 +986,7 @@ static int ai_prepare(struct comedi_device *dev,
 	}
 
 	/* Write the setup to the control register */
-	me4000_outl(dev, tmp, info->ai_context.ctrl_reg);
+	outl(tmp, info->ai_context.ctrl_reg);
 
 	/* Write the channel list */
 	ai_write_chanlist(dev, s, cmd);
@@ -1071,7 +1024,7 @@ static int ai_write_chanlist(struct comedi_device *dev,
 		else
 			entry |= ME4000_AI_LIST_INPUT_SINGLE_ENDED;
 
-		me4000_outl(dev, entry, info->ai_context.channel_list_reg);
+		outl(entry, info->ai_context.channel_list_reg);
 	}
 
 	return 0;
@@ -1103,7 +1056,7 @@ static int me4000_ai_do_cmd(struct comedi_device *dev,
 		return err;
 
 	/* Start acquistion by dummy read */
-	me4000_inl(dev, info->ai_context.start_reg);
+	inl(info->ai_context.start_reg);
 
 	return 0;
 }
@@ -1516,14 +1469,13 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	if (me4000_inl(dev,
-		       ai_context->irq_status_reg) &
+	if (inl(ai_context->irq_status_reg) &
 	    ME4000_IRQ_STATUS_BIT_AI_HF) {
 		ISR_PDEBUG
 		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
 
 		/* Read status register to find out what happened */
-		tmp = me4000_inl(dev, ai_context->ctrl_reg);
+		tmp = inl(ai_context->ctrl_reg);
 
 		if (!(tmp & ME4000_AI_STATUS_BIT_FF_DATA) &&
 		    !(tmp & ME4000_AI_STATUS_BIT_HF_DATA) &&
@@ -1538,7 +1490,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 			tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ |
 				 ME4000_AI_CTRL_BIT_SC_IRQ);
-			me4000_outl(dev, tmp, ai_context->ctrl_reg);
+			outl(tmp, ai_context->ctrl_reg);
 
 			s->async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 
@@ -1566,7 +1518,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 			tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 			tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ |
 				 ME4000_AI_CTRL_BIT_SC_IRQ);
-			me4000_outl(dev, tmp, ai_context->ctrl_reg);
+			outl(tmp, ai_context->ctrl_reg);
 
 			s->async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 
@@ -1590,7 +1542,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 				tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 				tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ |
 					 ME4000_AI_CTRL_BIT_SC_IRQ);
-				me4000_outl(dev, tmp, ai_context->ctrl_reg);
+				outl(tmp, ai_context->ctrl_reg);
 
 				s->async->events |= COMEDI_CB_OVERFLOW;
 
@@ -1605,13 +1557,12 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		/* Work is done, so reset the interrupt */
 		ISR_PDEBUG("me4000_ai_isr(): Reset fifo half full interrupt\n");
 		tmp |= ME4000_AI_CTRL_BIT_HF_IRQ_RESET;
-		me4000_outl(dev, tmp, ai_context->ctrl_reg);
+		outl(tmp, ai_context->ctrl_reg);
 		tmp &= ~ME4000_AI_CTRL_BIT_HF_IRQ_RESET;
-		me4000_outl(dev, tmp, ai_context->ctrl_reg);
+		outl(tmp, ai_context->ctrl_reg);
 	}
 
-	if (me4000_inl(dev,
-		       ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
+	if (inl(ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
 		ISR_PDEBUG
 		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
 
@@ -1621,10 +1572,10 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		 * Acquisition is complete, so stop
 		 * conversion and disable all interrupts
 		 */
-		tmp = me4000_inl(dev, ai_context->ctrl_reg);
+		tmp = inl(ai_context->ctrl_reg);
 		tmp |= ME4000_AI_CTRL_BIT_IMMEDIATE_STOP;
 		tmp &= ~(ME4000_AI_CTRL_BIT_HF_IRQ | ME4000_AI_CTRL_BIT_SC_IRQ);
-		me4000_outl(dev, tmp, ai_context->ctrl_reg);
+		outl(tmp, ai_context->ctrl_reg);
 
 		/* Poll data until fifo empty */
 		while (inl(ai_context->ctrl_reg) & ME4000_AI_STATUS_BIT_EF_DATA) {
@@ -1645,9 +1596,9 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		ISR_PDEBUG
 		    ("me4000_ai_isr(): Reset interrupt from sample counter\n");
 		tmp |= ME4000_AI_CTRL_BIT_SC_IRQ_RESET;
-		me4000_outl(dev, tmp, ai_context->ctrl_reg);
+		outl(tmp, ai_context->ctrl_reg);
 		tmp &= ~ME4000_AI_CTRL_BIT_SC_IRQ_RESET;
-		me4000_outl(dev, tmp, ai_context->ctrl_reg);
+		outl(tmp, ai_context->ctrl_reg);
 	}
 
 	ISR_PDEBUG("me4000_ai_isr(): Events = 0x%X\n", s->async->events);
@@ -1703,15 +1654,15 @@ static int me4000_ao_insn_write(struct comedi_device *dev,
 	}
 
 	/* Stop any running conversion */
-	tmp = me4000_inl(dev, info->ao_context[chan].ctrl_reg);
+	tmp = inl(info->ao_context[chan].ctrl_reg);
 	tmp |= ME4000_AO_CTRL_BIT_IMMEDIATE_STOP;
-	me4000_outl(dev, tmp, info->ao_context[chan].ctrl_reg);
+	outl(tmp, info->ao_context[chan].ctrl_reg);
 
 	/* Clear control register and set to single mode */
-	me4000_outl(dev, 0x0, info->ao_context[chan].ctrl_reg);
+	outl(0x0, info->ao_context[chan].ctrl_reg);
 
 	/* Write data value */
-	me4000_outl(dev, data[0], info->ao_context[chan].single_reg);
+	outl(data[0], info->ao_context[chan].single_reg);
 
 	/* Store in the mirror */
 	info->ao_context[chan].mirror = data[0];
@@ -1773,23 +1724,22 @@ static int me4000_dio_insn_bits(struct comedi_device *dev,
 		s->state |= data[0] & data[1];
 
 		/* Write out the new digital output lines */
-		me4000_outl(dev, (s->state >> 0) & 0xFF,
+		outl((s->state >> 0) & 0xFF,
 			    info->dio_context.port_0_reg);
-		me4000_outl(dev, (s->state >> 8) & 0xFF,
+		outl((s->state >> 8) & 0xFF,
 			    info->dio_context.port_1_reg);
-		me4000_outl(dev, (s->state >> 16) & 0xFF,
+		outl((s->state >> 16) & 0xFF,
 			    info->dio_context.port_2_reg);
-		me4000_outl(dev, (s->state >> 24) & 0xFF,
+		outl((s->state >> 24) & 0xFF,
 			    info->dio_context.port_3_reg);
 	}
 
 	/* On return, data[1] contains the value of
 	   the digital input and output lines. */
-	data[1] =
-	    ((me4000_inl(dev, info->dio_context.port_0_reg) & 0xFF) << 0) |
-	    ((me4000_inl(dev, info->dio_context.port_1_reg) & 0xFF) << 8) |
-	    ((me4000_inl(dev, info->dio_context.port_2_reg) & 0xFF) << 16) |
-	    ((me4000_inl(dev, info->dio_context.port_3_reg) & 0xFF) << 24);
+	data[1] = ((inl(info->dio_context.port_0_reg) & 0xFF) << 0) |
+		  ((inl(info->dio_context.port_1_reg) & 0xFF) << 8) |
+		  ((inl(info->dio_context.port_2_reg) & 0xFF) << 16) |
+		  ((inl(info->dio_context.port_3_reg) & 0xFF) << 24);
 
 	return 2;
 }
@@ -1821,7 +1771,7 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 	 * On the ME-4000 it is only possible to switch port wise (8 bit)
 	 */
 
-	tmp = me4000_inl(dev, info->dio_context.ctrl_reg);
+	tmp = inl(info->dio_context.ctrl_reg);
 
 	if (data[0] == INSN_CONFIG_DIO_OUTPUT) {
 		if (chan < 8) {
@@ -1835,7 +1785,7 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 			 * If one the first port is a fixed output
 			 * port and the second is a fixed input port.
 			 */
-			if (!me4000_inl(dev, info->dio_context.dir_reg))
+			if (!inl(info->dio_context.dir_reg))
 				return -ENODEV;
 
 			s->io_bits |= 0xFF00;
@@ -1862,7 +1812,7 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 			 * If one the first port is a fixed output
 			 * port and the second is a fixed input port.
 			 */
-			if (!me4000_inl(dev, info->dio_context.dir_reg))
+			if (!inl(info->dio_context.dir_reg))
 				return -ENODEV;
 
 			s->io_bits &= ~0xFF;
@@ -1885,7 +1835,7 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 		}
 	}
 
-	me4000_outl(dev, tmp, info->dio_context.ctrl_reg);
+	outl(tmp, info->dio_context.ctrl_reg);
 
 	return 1;
 }
@@ -1898,19 +1848,19 @@ static int cnt_reset(struct comedi_device *dev, unsigned int channel)
 {
 	switch (channel) {
 	case 0:
-		me4000_outb(dev, 0x30, info->cnt_context.ctrl_reg);
-		me4000_outb(dev, 0x00, info->cnt_context.counter_0_reg);
-		me4000_outb(dev, 0x00, info->cnt_context.counter_0_reg);
+		outb(0x30, info->cnt_context.ctrl_reg);
+		outb(0x00, info->cnt_context.counter_0_reg);
+		outb(0x00, info->cnt_context.counter_0_reg);
 		break;
 	case 1:
-		me4000_outb(dev, 0x70, info->cnt_context.ctrl_reg);
-		me4000_outb(dev, 0x00, info->cnt_context.counter_1_reg);
-		me4000_outb(dev, 0x00, info->cnt_context.counter_1_reg);
+		outb(0x70, info->cnt_context.ctrl_reg);
+		outb(0x00, info->cnt_context.counter_1_reg);
+		outb(0x00, info->cnt_context.counter_1_reg);
 		break;
 	case 2:
-		me4000_outb(dev, 0xB0, info->cnt_context.ctrl_reg);
-		me4000_outb(dev, 0x00, info->cnt_context.counter_2_reg);
-		me4000_outb(dev, 0x00, info->cnt_context.counter_2_reg);
+		outb(0xB0, info->cnt_context.ctrl_reg);
+		outb(0x00, info->cnt_context.counter_2_reg);
+		outb(0x00, info->cnt_context.counter_2_reg);
 		break;
 	default:
 		printk(KERN_ERR
@@ -1972,7 +1922,7 @@ static int cnt_config(struct comedi_device *dev, unsigned int channel,
 
 	/* Write the control word */
 	tmp |= 0x30;
-	me4000_outb(dev, tmp, info->cnt_context.ctrl_reg);
+	outb(tmp, info->cnt_context.ctrl_reg);
 
 	return 0;
 }
@@ -2041,21 +1991,21 @@ static int me4000_cnt_insn_read(struct comedi_device *dev,
 
 	switch (insn->chanspec) {
 	case 0:
-		tmp = me4000_inb(dev, info->cnt_context.counter_0_reg);
+		tmp = inb(info->cnt_context.counter_0_reg);
 		data[0] = tmp;
-		tmp = me4000_inb(dev, info->cnt_context.counter_0_reg);
+		tmp = inb(info->cnt_context.counter_0_reg);
 		data[0] |= tmp << 8;
 		break;
 	case 1:
-		tmp = me4000_inb(dev, info->cnt_context.counter_1_reg);
+		tmp = inb(info->cnt_context.counter_1_reg);
 		data[0] = tmp;
-		tmp = me4000_inb(dev, info->cnt_context.counter_1_reg);
+		tmp = inb(info->cnt_context.counter_1_reg);
 		data[0] |= tmp << 8;
 		break;
 	case 2:
-		tmp = me4000_inb(dev, info->cnt_context.counter_2_reg);
+		tmp = inb(info->cnt_context.counter_2_reg);
 		data[0] = tmp;
-		tmp = me4000_inb(dev, info->cnt_context.counter_2_reg);
+		tmp = inb(info->cnt_context.counter_2_reg);
 		data[0] |= tmp << 8;
 		break;
 	default:
@@ -2089,21 +2039,21 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 	switch (insn->chanspec) {
 	case 0:
 		tmp = data[0] & 0xFF;
-		me4000_outb(dev, tmp, info->cnt_context.counter_0_reg);
+		outb(tmp, info->cnt_context.counter_0_reg);
 		tmp = (data[0] >> 8) & 0xFF;
-		me4000_outb(dev, tmp, info->cnt_context.counter_0_reg);
+		outb(tmp, info->cnt_context.counter_0_reg);
 		break;
 	case 1:
 		tmp = data[0] & 0xFF;
-		me4000_outb(dev, tmp, info->cnt_context.counter_1_reg);
+		outb(tmp, info->cnt_context.counter_1_reg);
 		tmp = (data[0] >> 8) & 0xFF;
-		me4000_outb(dev, tmp, info->cnt_context.counter_1_reg);
+		outb(tmp, info->cnt_context.counter_1_reg);
 		break;
 	case 2:
 		tmp = data[0] & 0xFF;
-		me4000_outb(dev, tmp, info->cnt_context.counter_2_reg);
+		outb(tmp, info->cnt_context.counter_2_reg);
 		tmp = (data[0] >> 8) & 0xFF;
-		me4000_outb(dev, tmp, info->cnt_context.counter_2_reg);
+		outb(tmp, info->cnt_context.counter_2_reg);
 		break;
 	default:
 		printk(KERN_ERR
@@ -2207,10 +2157,9 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Check for optoisolated ME-4000 version. If one the first
 	 * port is a fixed output port and the second is a fixed input port.
 	 */
-	if (!me4000_inl(dev, info->dio_context.dir_reg)) {
+	if (!inl(info->dio_context.dir_reg)) {
 		s->io_bits |= 0xFF;
-		me4000_outl(dev, ME4000_DIO_CTRL_BIT_MODE_0,
-			    info->dio_context.dir_reg);
+		outl(ME4000_DIO_CTRL_BIT_MODE_0, info->dio_context.dir_reg);
 	}
 
     /*=========================================================================
-- 
1.7.7

