Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab2FUC1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:27:34 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:18865 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2FUC1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:27:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1340245651!6381186!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/12] staging: comedi: s626: remove private DEBUG macro
Date: Wed, 20 Jun 2012 19:27:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201927.26157.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private DEBUG macro defined in this driver outputs a lot
of function tracing noise. This information might be useful
when first developing the driver but should not be in the
mainlined code.

If any of this is needed in the future it should be added back
using the proper dev_printk interface.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 209 +---------------------------------
 drivers/staging/comedi/drivers/s626.h |   6 -
 2 files changed, 3 insertions(+), 212 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 50656a7..779ae7a 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -376,7 +376,6 @@ static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr)
 			 /* Byte1 = EEPROM internal target address. */
 			 | I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not sent. */
 		/*  Abort function and declare error if handshake failed. */
-		DEBUG("I2Cread: error handshake I2Cread  a\n");
 		return 0;
 	}
 	/*  Execute EEPROM read. */
@@ -394,7 +393,6 @@ static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr)
 			 |I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not  sent. */
 
 		/*  Abort function and declare error if handshake failed. */
-		DEBUG("I2Cread: error handshake I2Cread b\n");
 		return 0;
 	}
 	/*  Return copy of EEPROM value. */
@@ -653,7 +651,6 @@ static void LoadTrimDACs(struct comedi_device *dev)
 static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k)
 {
 	register uint32_t value;
-	/* DEBUG FIXME DEBUG("ReadLatch: Read Latch enter\n"); */
 
 	/*  Latch counts and fetch LSW of latched counts value. */
 	value = (uint32_t) DEBIread(dev, k->MyLatchLsw);
@@ -661,8 +658,6 @@ static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k)
 	/*  Fetch MSW of latched counts and combine with LSW. */
 	value |= ((uint32_t) DEBIread(dev, k->MyLatchLsw + 2) << 16);
 
-	/*  DEBUG FIXME DEBUG("ReadLatch: Read Latch exit\n"); */
-
 	/*  Return latched counts. */
 	return value;
 }
@@ -674,21 +669,16 @@ static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k)
 static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 			   uint16_t value)
 {
-	DEBUG("SetLatchSource: SetLatchSource enter 3550\n");
 	DEBIreplace(dev, k->MyCRB,
 		    (uint16_t) (~(CRBMSK_INTCTRL | CRBMSK_LATCHSRC)),
 		    (uint16_t) (value << CRBBIT_LATCHSRC));
-
-	DEBUG("SetLatchSource: SetLatchSource exit\n");
 }
 
 /*  Write value into counter preload register. */
 static void Preload(struct comedi_device *dev, struct enc_private *k,
 		    uint32_t value)
 {
-	DEBUG("Preload: preload enter\n");
-	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw), (uint16_t) value);	/*  Write value to preload register. */
-	DEBUG("Preload: preload step 1\n");
+	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw), (uint16_t) value);
 	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw + 2),
 		  (uint16_t) (value >> 16));
 }
@@ -719,8 +709,6 @@ static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
 	/* select dio bank */
 	group = chan / 16;
 	bitmask = 1 << (chan - (16 * group));
-	DEBUG("s626_dio_set_irq: enable interrupt on dio channel %d group %d\n",
-	      chan - (16 * group), group);
 
 	/* set channel to capture positive edge */
 	status = DEBIread(dev,
@@ -758,10 +746,6 @@ static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
 static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int group,
 			      unsigned int mask)
 {
-	DEBUG
-	    ("s626_dio_reset_irq: disable  interrupt on dio channel %d group %d\n",
-	     mask, group);
-
 	/* disable edge capture write command */
 	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
 
@@ -805,8 +789,6 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	uint8_t group;
 	uint16_t irqbit;
 
-	DEBUG("s626_irq_handler: interrupt request received!!!\n");
-
 	if (dev->attached == 0)
 		return IRQ_NONE;
 	/*  lock to avoid race with comedi_poll */
@@ -824,14 +806,8 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	/* clear interrupt */
 	writel(irqtype, devpriv->base_addr + P_ISR);
 
-	/* do somethings */
-	DEBUG("s626_irq_handler: interrupt type %d\n", irqtype);
-
 	switch (irqtype) {
 	case IRQ_RPS1:		/*  end_of_scan occurs */
-
-		DEBUG("s626_irq_handler: RPS1 irq detected\n");
-
 		/*  manage ai subdevice */
 		s = dev->subdevices;
 		cmd = &(s->async->cmd);
@@ -854,9 +830,6 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 			if (cfc_write_to_buffer(s, tempdata) == 0)
 				printk
 				    ("s626_irq_handler: cfc_write_to_buffer error!\n");
-
-			DEBUG("s626_irq_handler: ai channel %d acquired: %d\n",
-			      i, tempdata);
 		}
 
 		/* end of scan occurs */
@@ -877,23 +850,12 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 			irqstatus = 0;
 		}
 
-		if (devpriv->ai_cmd_running && cmd->scan_begin_src == TRIG_EXT) {
-			DEBUG
-			    ("s626_irq_handler: enable interrupt on dio channel %d\n",
-			     cmd->scan_begin_arg);
-
+		if (devpriv->ai_cmd_running && cmd->scan_begin_src == TRIG_EXT)
 			s626_dio_set_irq(dev, cmd->scan_begin_arg);
-
-			DEBUG("s626_irq_handler: External trigger is set!!!\n");
-		}
 		/*  tell comedi that data is there */
-		DEBUG("s626_irq_handler: events %d\n", s->async->events);
 		comedi_event(dev, s);
 		break;
 	case IRQ_GPIO3:	/* check dio and conter interrupt */
-
-		DEBUG("s626_irq_handler: GPIO3 irq detected\n");
-
 		/*  manage ai subdevice */
 		s = dev->subdevices;
 		cmd = &(s->async->cmd);
@@ -913,36 +875,18 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 			/* check if interrupt is generated from dio channels */
 			if (irqbit) {
 				s626_dio_reset_irq(dev, group, irqbit);
-				DEBUG
-				    ("s626_irq_handler: check interrupt on dio group %d %d\n",
-				     group, i);
 				if (devpriv->ai_cmd_running) {
 					/* check if interrupt is an ai acquisition start trigger */
 					if ((irqbit >> (cmd->start_arg -
 							(16 * group)))
 					    == 1 && cmd->start_src == TRIG_EXT) {
-						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
-						     cmd->start_arg);
-
 						/*  Start executing the RPS program. */
 						MC_ENABLE(P_MC1, MC1_ERPS1);
 
-						DEBUG
-						    ("s626_irq_handler: acquisition start triggered!!!\n");
-
 						if (cmd->scan_begin_src ==
 						    TRIG_EXT) {
-							DEBUG
-							    ("s626_ai_cmd: enable interrupt on dio channel %d\n",
-							     cmd->
-							     scan_begin_arg);
-
 							s626_dio_set_irq(dev,
 									 cmd->scan_begin_arg);
-
-							DEBUG
-							    ("s626_irq_handler: External scan trigger is set!!!\n");
 						}
 					}
 					if ((irqbit >> (cmd->scan_begin_arg -
@@ -950,33 +894,16 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    == 1
 					    && cmd->scan_begin_src ==
 					    TRIG_EXT) {
-						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
-						     cmd->scan_begin_arg);
-
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
 						MC_ENABLE(P_MC2, MC2_ADC_RPS);
 
-						DEBUG
-						    ("s626_irq_handler: scan triggered!!! %d\n",
-						     devpriv->ai_sample_count);
 						if (cmd->convert_src ==
 						    TRIG_EXT) {
-
-							DEBUG
-							    ("s626_ai_cmd: enable interrupt on dio channel %d group %d\n",
-							     cmd->convert_arg -
-							     (16 * group),
-							     group);
-
 							devpriv->ai_convert_count
 							    = cmd->chanlist_len;
 
 							s626_dio_set_irq(dev,
 									 cmd->convert_arg);
-
-							DEBUG
-							    ("s626_irq_handler: External convert trigger is set!!!\n");
 						}
 
 						if (cmd->convert_src ==
@@ -992,32 +919,15 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 							(16 * group)))
 					    == 1
 					    && cmd->convert_src == TRIG_EXT) {
-						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
-						     cmd->convert_arg);
-
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
 						MC_ENABLE(P_MC2, MC2_ADC_RPS);
 
-						DEBUG
-						    ("s626_irq_handler: adc convert triggered!!!\n");
-
 						devpriv->ai_convert_count--;
 
 						if (devpriv->ai_convert_count >
 						    0) {
-
-							DEBUG
-							    ("s626_ai_cmd: enable interrupt on dio channel %d group %d\n",
-							     cmd->convert_arg -
-							     (16 * group),
-							     group);
-
 							s626_dio_set_irq(dev,
 									 cmd->convert_arg);
-
-							DEBUG
-							    ("s626_irq_handler: External trigger is set!!!\n");
 						}
 					}
 				}
@@ -1029,44 +939,31 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 		irqbit = DEBIread(dev, LP_RDMISC2);
 
 		/* check interrupt on counters */
-		DEBUG("s626_irq_handler: check counters interrupt %d\n",
-		      irqbit);
-
 		if (irqbit & IRQ_COINT1A) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 1A overflow\n");
 			k = &encpriv[0];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT2A) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 2A overflow\n");
 			k = &encpriv[1];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT3A) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 3A overflow\n");
 			k = &encpriv[2];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT1B) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 1B overflow\n");
 			k = &encpriv[3];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT2B) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 2B overflow\n");
 			k = &encpriv[4];
 
 			/* clear interrupt capture flag */
@@ -1078,34 +975,23 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					k->SetEnable(dev, k, CLKENAB_INDEX);
 
 				if (cmd->convert_src == TRIG_TIMER) {
-					DEBUG
-					    ("s626_irq_handler: conver timer trigger!!! %d\n",
-					     devpriv->ai_convert_count);
-
 					/*  Trigger ADC scan loop start by setting RPS Signal 0. */
 					MC_ENABLE(P_MC2, MC2_ADC_RPS);
 				}
 			}
 		}
 		if (irqbit & IRQ_COINT3B) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 3B overflow\n");
 			k = &encpriv[5];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 
 			if (cmd->scan_begin_src == TRIG_TIMER) {
-				DEBUG
-				    ("s626_irq_handler: scan timer trigger!!!\n");
-
 				/*  Trigger ADC scan loop start by setting RPS Signal 0. */
 				MC_ENABLE(P_MC2, MC2_ADC_RPS);
 			}
 
 			if (cmd->convert_src == TRIG_TIMER) {
-				DEBUG
-				    ("s626_irq_handler: convert timer trigger is set\n");
 				k = &encpriv[4];
 				devpriv->ai_convert_count = cmd->chanlist_len;
 				k->SetEnable(dev, k, CLKENAB_ALWAYS);
@@ -1116,8 +1002,6 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	/* enable interrupt */
 	writel(irqstatus, devpriv->base_addr + P_IER);
 
-	DEBUG("s626_irq_handler: exit interrupt service routine.\n");
-
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 	return IRQ_HANDLED;
 }
@@ -1146,7 +1030,6 @@ static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 	/*  Construct RPS program in RPSBuf DMA buffer */
 
 	if (cmd != NULL && cmd->scan_begin_src != TRIG_FOLLOW) {
-		DEBUG("ResetADC: scan_begin pause inserted\n");
 		/*  Wait for Start trigger. */
 		*pRPS++ = RPS_PAUSE | RPS_SIGADC;
 		*pRPS++ = RPS_CLRSIGNAL | RPS_SIGADC;
@@ -1236,7 +1119,6 @@ static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 		}
 
 		if (cmd != NULL && cmd->convert_src != TRIG_NOW) {
-			DEBUG("ResetADC: convert pause inserted\n");
 			/*  Wait for Start trigger. */
 			*pRPS++ = RPS_PAUSE | RPS_SIGADC;
 			*pRPS++ = RPS_CLRSIGNAL | RPS_SIGADC;
@@ -1268,7 +1150,6 @@ static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 			break;	/*  Exit poll list processing loop. */
 		}
 	}
-	DEBUG("ResetADC: ADC items %d\n", devpriv->AdcItems);
 
 	/* VERSION 2.01 CHANGE: DELAY CHANGED FROM 250NS to 2US.  Allow the
 	 * ADC to stabilize for 2 microseconds before starting the final
@@ -1305,7 +1186,6 @@ static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 
 	/* invoke interrupt */
 	if (devpriv->ai_cmd_running == 1) {
-		DEBUG("ResetADC: insert irq in ADC RPS task\n");
 		*pRPS++ = RPS_IRQ;
 	}
 	/*  Restart RPS program at its beginning. */
@@ -1329,8 +1209,6 @@ static int s626_ai_insn_config(struct comedi_device *dev,
 /*   register uint8_t	i; */
 /*   register int32_t	*readaddr; */
 
-/*   DEBUG("as626_ai_rinsn: ai_rinsn enter\n");  */
-
 /*   Trigger ADC scan loop start by setting RPS Signal 0. */
 /*   MC_ENABLE( P_MC2, MC2_ADC_RPS ); */
 
@@ -1346,11 +1224,9 @@ static int s626_ai_insn_config(struct comedi_device *dev,
 /*  Convert ADC data to 16-bit integer values and copy to application buffer. */
 /*   for ( i = 0; i < devpriv->AdcItems; i++ ) { */
 /*     *data = s626_ai_reg_to_uint( *readaddr++ ); */
-/*     DEBUG("s626_ai_rinsn: data %d\n",*data); */
 /*     data++; */
 /*   } */
 
-/*   DEBUG("s626_ai_rinsn: ai_rinsn escape\n"); */
 /*   return i; */
 /* } */
 
@@ -1370,8 +1246,6 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 	 * corresponding interrupt to be generated if enabled
 	 */
 
-	DEBUG("s626_ai_insn_read: entering\n");
-
 	/* Convert application's ADC specification into form
 	 *  appropriate for register programming.
 	 */
@@ -1448,8 +1322,6 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 	if (n != 0)
 		data[n - 1] = s626_ai_reg_to_uint(RR7146(P_FB_BUFFER1));
 
-	DEBUG("s626_ai_insn_read: samples %d, data %d\n", n, data[n - 1]);
-
 	return n;
 }
 
@@ -1476,15 +1348,11 @@ static int s626_ai_inttrig(struct comedi_device *dev,
 	if (trignum != 0)
 		return -EINVAL;
 
-	DEBUG("s626_ai_inttrig: trigger adc start...");
-
 	/*  Start executing the RPS program. */
 	MC_ENABLE(P_MC1, MC1_ERPS1);
 
 	s->async->inttrig = NULL;
 
-	DEBUG(" done\n");
-
 	return 1;
 }
 
@@ -1559,8 +1427,6 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct enc_private *k;
 	int tick;
 
-	DEBUG("s626_ai_cmd: entering command function\n");
-
 	if (devpriv->ai_cmd_running) {
 		printk(KERN_ERR "s626_ai_cmd: Another ai_cmd is running %d\n",
 		       dev->minor);
@@ -1580,12 +1446,8 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_cmd_running = 0;
 
 	/*  test if cmd is valid */
-	if (cmd == NULL) {
-		DEBUG("s626_ai_cmd: NULL command\n");
+	if (cmd == NULL)
 		return -EINVAL;
-	} else {
-		DEBUG("s626_ai_cmd: command received!!!\n");
-	}
 
 	if (dev->irq == 0) {
 		comedi_error(dev,
@@ -1609,18 +1471,11 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* load timer value and enable interrupt */
 		s626_timer_load(dev, k, tick);
 		k->SetEnable(dev, k, CLKENAB_ALWAYS);
-
-		DEBUG("s626_ai_cmd: scan trigger timer is set with value %d\n",
-		      tick);
-
 		break;
 	case TRIG_EXT:
 		/*  set the digital line and interrupt for scan trigger */
 		if (cmd->start_src != TRIG_EXT)
 			s626_dio_set_irq(dev, cmd->scan_begin_arg);
-
-		DEBUG("s626_ai_cmd: External scan trigger is set!!!\n");
-
 		break;
 	}
 
@@ -1636,19 +1491,12 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* load timer value and enable interrupt */
 		s626_timer_load(dev, k, tick);
 		k->SetEnable(dev, k, CLKENAB_INDEX);
-
-		DEBUG
-		    ("s626_ai_cmd: convert trigger timer is set with value %d\n",
-		     tick);
 		break;
 	case TRIG_EXT:
 		/*  set the digital line and interrupt for convert trigger */
 		if (cmd->scan_begin_src != TRIG_EXT
 		    && cmd->start_src == TRIG_EXT)
 			s626_dio_set_irq(dev, cmd->convert_arg);
-
-		DEBUG("s626_ai_cmd: External convert trigger is set!!!\n");
-
 		break;
 	}
 
@@ -1675,15 +1523,12 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/*  Start executing the RPS program. */
 		MC_ENABLE(P_MC1, MC1_ERPS1);
 
-		DEBUG("s626_ai_cmd: ADC triggered\n");
 		s->async->inttrig = NULL;
 		break;
 	case TRIG_EXT:
 		/* configure DIO channel for acquisition trigger */
 		s626_dio_set_irq(dev, cmd->start_arg);
 
-		DEBUG("s626_ai_cmd: External start trigger is set!!!\n");
-
 		s->async->inttrig = NULL;
 		break;
 	case TRIG_INT:
@@ -1694,8 +1539,6 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* enable interrupt */
 	writel(IRQ_GPIO3 | IRQ_RPS1, devpriv->base_addr + P_IER);
 
-	DEBUG("s626_ai_cmd: command function terminated\n");
-
 	return 0;
 }
 
@@ -1938,7 +1781,6 @@ static void s626_dio_init(struct comedi_device *dev)
 		DEBIwrite(dev, diopriv->WRDOut, 0);	/*  Program all outputs */
 		/*  to inactive state. */
 	}
-	DEBUG("s626_dio_init: DIO initialized\n");
 }
 
 /* DIO devices are slightly special.  Although it is possible to
@@ -2023,8 +1865,6 @@ static int s626_enc_insn_config(struct comedi_device *dev,
 	uint16_t enab = CLKENAB_ALWAYS;
 	struct enc_private *k = &encpriv[CR_CHAN(insn->chanspec)];
 
-	DEBUG("s626_enc_insn_config: encoder config\n");
-
 	/*   (data==NULL) ? (Preloadvalue=0) : (Preloadvalue=data[0]); */
 
 	k->SetMode(dev, k, Setup, TRUE);
@@ -2044,14 +1884,9 @@ static int s626_enc_insn_read(struct comedi_device *dev,
 	int n;
 	struct enc_private *k = &encpriv[CR_CHAN(insn->chanspec)];
 
-	DEBUG("s626_enc_insn_read: encoder read channel %d\n",
-	      CR_CHAN(insn->chanspec));
-
 	for (n = 0; n < insn->n; n++)
 		data[n] = ReadLatch(dev, k);
 
-	DEBUG("s626_enc_insn_read: encoder sample %d\n", data[n]);
-
 	return n;
 }
 
@@ -2062,9 +1897,6 @@ static int s626_enc_insn_write(struct comedi_device *dev,
 
 	struct enc_private *k = &encpriv[CR_CHAN(insn->chanspec)];
 
-	DEBUG("s626_enc_insn_write: encoder write channel %d\n",
-	      CR_CHAN(insn->chanspec));
-
 	/*  Set the preload register */
 	Preload(dev, k, data[0]);
 
@@ -2074,8 +1906,6 @@ static int s626_enc_insn_write(struct comedi_device *dev,
 	k->PulseIndex(dev, k);
 	k->SetLoadTrig(dev, k, 2);
 
-	DEBUG("s626_enc_insn_write: End encoder write\n");
-
 	return 1;
 }
 
@@ -2093,7 +1923,6 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 	void *vbptr;
 	dma_addr_t vpptr;
 
-	DEBUG("CloseDMAB: Entering S626DRV_CloseDMAB():\n");
 	if (pdma == NULL)
 		return;
 	/* find the matching allocation from the board struct */
@@ -2104,9 +1933,6 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 		pci_free_consistent(devpriv->pdev, bsize, vbptr, vpptr);
 		pdma->LogicalBase = NULL;
 		pdma->PhysicalBase = 0;
-
-		DEBUG("CloseDMAB(): Logical=%p, bsize=%d, Physical=0x%x\n",
-		      vbptr, bsize, (uint32_t) vpptr);
 	}
 }
 
@@ -2337,7 +2163,6 @@ static void SetMode_B(struct comedi_device *dev, struct enc_private *k,
 static void SetEnable_A(struct comedi_device *dev, struct enc_private *k,
 			uint16_t enab)
 {
-	DEBUG("SetEnable_A: SetEnable_A enter 3541\n");
 	DEBIreplace(dev, k->MyCRB,
 		    (uint16_t) (~(CRBMSK_INTCTRL | CRBMSK_CLKENAB_A)),
 		    (uint16_t) (enab << CRBBIT_CLKENAB_A));
@@ -2506,7 +2331,6 @@ static uint16_t GetIntSrc_B(struct comedi_device *dev, struct enc_private *k)
 
 /* static void SetIndexSrc(struct comedi_device *dev, struct enc_private *k, uint16_t value )  */
 /* { */
-/*   DEBUG("SetIndexSrc: set index src enter 3700\n"); */
 /*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) & ~STDMSK_INDXSRC ) | ( (value != 0) << STDBIT_INDXSRC ) ), FALSE ); */
 /* } */
 
@@ -2521,11 +2345,8 @@ static void PulseIndex_A(struct comedi_device *dev, struct enc_private *k)
 {
 	register uint16_t cra;
 
-	DEBUG("PulseIndex_A: pulse index enter\n");
-
 	cra = DEBIread(dev, k->MyCRA);	/*  Pulse index. */
 	DEBIwrite(dev, k->MyCRA, (uint16_t) (cra ^ CRAMSK_INDXPOL_A));
-	DEBUG("PulseIndex_A: pulse index step1\n");
 	DEBIwrite(dev, k->MyCRA, cra);
 }
 
@@ -2653,8 +2474,6 @@ static void CountersInit(struct comedi_device *dev)
 		k->ResetCapFlags(dev, k);
 		k->SetEnable(dev, k, CLKENAB_ALWAYS);
 	}
-	DEBUG("CountersInit: counters initialized\n");
-
 }
 
 static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
@@ -2722,7 +2541,6 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		writel(MC1_SOFT_RESET, devpriv->base_addr + P_MC1);
 
 		/* DMA FIXME DMA// */
-		DEBUG("s626_attach: DMA ALLOCATION\n");
 
 		/* adc buffer allocation */
 		devpriv->allocatedBuf = 0;
@@ -2737,11 +2555,6 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		devpriv->ANABuf.PhysicalBase = appdma;
 
-		DEBUG
-		    ("s626_attach: AllocDMAB ADC Logical=%p, bsize=%d, Physical=0x%x\n",
-		     devpriv->ANABuf.LogicalBase, DMABUF_SIZE,
-		     (uint32_t) devpriv->ANABuf.PhysicalBase);
-
 		devpriv->allocatedBuf++;
 
 		devpriv->RPSBuf.LogicalBase =
@@ -2754,11 +2567,6 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		devpriv->RPSBuf.PhysicalBase = appdma;
 
-		DEBUG
-		    ("s626_attach: AllocDMAB RPS Logical=%p, bsize=%d, Physical=0x%x\n",
-		     devpriv->RPSBuf.LogicalBase, DMABUF_SIZE,
-		     (uint32_t) devpriv->RPSBuf.PhysicalBase);
-
 		devpriv->allocatedBuf++;
 
 	}
@@ -2786,9 +2594,6 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	DEBUG("s626_attach: -- it opts  %d,%d --\n",
-	      it->options[0], it->options[1]);
-
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
 	dev->read_subdev = s;
@@ -2887,11 +2692,6 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		       | DEBI_CFG_INTEL);	/*  Intel-compatible */
 		/*  local bus (DEBI */
 		/*  never times out). */
-		DEBUG("s626_attach: %d debi init -- %d\n",
-		      DEBI_CFG_SLAVE16 | (DEBI_TOUT << DEBI_CFG_TOUT_BIT) |
-		      DEBI_SWAP | DEBI_CFG_INTEL,
-		      DEBI_CFG_INTEL | DEBI_CFG_TOQ | DEBI_CFG_INCQ |
-		      DEBI_CFG_16Q);
 
 		/* DEBI INIT S626 WR7146( P_DEBICFG, DEBI_CFG_INTEL | DEBI_CFG_TOQ */
 		/* | DEBI_CFG_INCQ| DEBI_CFG_16Q); //end */
@@ -3128,9 +2928,6 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*  writel(IRQ_GPIO3 | IRQ_RPS1,devpriv->base_addr+P_IER); */
 	}
 
-	DEBUG("s626_attach: comedi%d s626 attached %04x\n", dev->minor,
-	      (uint32_t) devpriv->base_addr);
-
 	return 1;
 }
 
diff --git a/drivers/staging/comedi/drivers/s626.h b/drivers/staging/comedi/drivers/s626.h
index 2d1afec..82de03f 100644
--- a/drivers/staging/comedi/drivers/s626.h
+++ b/drivers/staging/comedi/drivers/s626.h
@@ -62,12 +62,6 @@
    comedi_do_insn(cf,&insn); // executing configuration
 */
 
-#ifdef _DEBUG_
-#define DEBUG(...);        printk(__VA_ARGS__);
-#else
-#define DEBUG(...)
-#endif
-
 #if !defined(TRUE)
 #define TRUE    (1)
 #endif
-- 
1.7.11

