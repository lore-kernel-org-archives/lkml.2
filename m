Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2FUC0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:26:01 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:50966 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2FUCZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:25:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1340245557!22786093!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/12] staging: comedi: s626: remove forward declarations 4
Date: Wed, 20 Jun 2012 19:25:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201925.50000.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the DAC functions up to remove the need for the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 488 +++++++++++++++++-----------------
 1 file changed, 240 insertions(+), 248 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 5fcb43a..3cdb293 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -213,12 +213,6 @@ static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int gruop,
 static int s626_dio_clear_irq(struct comedi_device *dev);
 static int s626_ns_to_timer(int *nanosec, int round_mode);
 
-/* internal routines */
-static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
-			 uint8_t DacData);
-static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata);
-static void SendDAC(struct comedi_device *dev, uint32_t val);
-
 /*  COUNTER OBJECT ------------------------------------------------ */
 struct enc_private {
 	/*  Pointers to functions that differ for A and B counters: */
@@ -552,6 +546,246 @@ static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr)
 	return rtnval;
 }
 
+/* ***********  DAC FUNCTIONS *********** */
+
+/*  Slot 0 base settings. */
+#define VECT0	(XSD2 | RSD3 | SIB_A2)
+/*  Slot 0 always shifts in  0xFF and store it to  FB_BUFFER2. */
+
+/*  TrimDac LogicalChan-to-PhysicalChan mapping table. */
+static uint8_t trimchan[] = { 10, 9, 8, 3, 2, 7, 6, 1, 0, 5, 4 };
+
+/*  TrimDac LogicalChan-to-EepromAdrs mapping table. */
+static uint8_t trimadrs[] = { 0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63 };
+
+/* Private helper function: Transmit serial data to DAC via Audio
+ * channel 2.  Assumes: (1) TSL2 slot records initialized, and (2)
+ * Dacpol contains valid target image.
+ */
+static void SendDAC(struct comedi_device *dev, uint32_t val)
+{
+
+	/* START THE SERIAL CLOCK RUNNING ------------- */
+
+	/* Assert DAC polarity control and enable gating of DAC serial clock
+	 * and audio bit stream signals.  At this point in time we must be
+	 * assured of being in time slot 0.  If we are not in slot 0, the
+	 * serial clock and audio stream signals will be disabled; this is
+	 * because the following DEBIwrite statement (which enables signals
+	 * to be passed through the gate array) would execute before the
+	 * trailing edge of WS1/WS3 (which turns off the signals), thus
+	 * causing the signals to be inactive during the DAC write.
+	 */
+	DEBIwrite(dev, LP_DACPOL, devpriv->Dacpol);
+
+	/* TRANSFER OUTPUT DWORD VALUE INTO A2'S OUTPUT FIFO ---------------- */
+
+	/* Copy DAC setpoint value to DAC's output DMA buffer. */
+
+	/* WR7146( (uint32_t)devpriv->pDacWBuf, val ); */
+	*devpriv->pDacWBuf = val;
+
+	/* enab the output DMA transfer.  This will cause the DMAC to copy
+	 * the DAC's data value to A2's output FIFO.  The DMA transfer will
+	 * then immediately terminate because the protection address is
+	 * reached upon transfer of the first DWORD value.
+	 */
+	MC_ENABLE(P_MC1, MC1_A2OUT);
+
+	/*  While the DMA transfer is executing ... */
+
+	/* Reset Audio2 output FIFO's underflow flag (along with any other
+	 * FIFO underflow/overflow flags).  When set, this flag will
+	 * indicate that we have emerged from slot 0.
+	 */
+	WR7146(P_ISR, ISR_AFOU);
+
+	/* Wait for the DMA transfer to finish so that there will be data
+	 * available in the FIFO when time slot 1 tries to transfer a DWORD
+	 * from the FIFO to the output buffer register.  We test for DMA
+	 * Done by polling the DMAC enable flag; this flag is automatically
+	 * cleared when the transfer has finished.
+	 */
+	while ((RR7146(P_MC1) & MC1_A2OUT) != 0)
+		;
+
+	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
+
+	/* FIFO data is now available, so we enable execution of time slots
+	 * 1 and higher by clearing the EOS flag in slot 0.  Note that SD3
+	 * will be shifted in and stored in FB_BUFFER2 for end-of-slot-list
+	 * detection.
+	 */
+	SETVECT(0, XSD2 | RSD3 | SIB_A2);
+
+	/* Wait for slot 1 to execute to ensure that the Packet will be
+	 * transmitted.  This is detected by polling the Audio2 output FIFO
+	 * underflow flag, which will be set when slot 1 execution has
+	 * finished transferring the DAC's data DWORD from the output FIFO
+	 * to the output buffer register.
+	 */
+	while ((RR7146(P_SSR) & SSR_AF2_OUT) == 0)
+		;
+
+	/* Set up to trap execution at slot 0 when the TSL sequencer cycles
+	 * back to slot 0 after executing the EOS in slot 5.  Also,
+	 * simultaneously shift out and in the 0x00 that is ALWAYS the value
+	 * stored in the last byte to be shifted out of the FIFO's DWORD
+	 * buffer register.
+	 */
+	SETVECT(0, XSD2 | XFIFO_2 | RSD2 | SIB_A2 | EOS);
+
+	/* WAIT FOR THE TRANSACTION TO FINISH ----------------------- */
+
+	/* Wait for the TSL to finish executing all time slots before
+	 * exiting this function.  We must do this so that the next DAC
+	 * write doesn't start, thereby enabling clock/chip select signals:
+	 *
+	 * 1. Before the TSL sequence cycles back to slot 0, which disables
+	 *    the clock/cs signal gating and traps slot // list execution.
+	 *    we have not yet finished slot 5 then the clock/cs signals are
+	 *    still gated and we have not finished transmitting the stream.
+	 *
+	 * 2. While slots 2-5 are executing due to a late slot 0 trap.  In
+	 *    this case, the slot sequence is currently repeating, but with
+	 *    clock/cs signals disabled.  We must wait for slot 0 to trap
+	 *    execution before setting up the next DAC setpoint DMA transfer
+	 *    and enabling the clock/cs signals.  To detect the end of slot 5,
+	 *    we test for the FB_BUFFER2 MSB contents to be equal to 0xFF.  If
+	 *    the TSL has not yet finished executing slot 5 ...
+	 */
+	if ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0) {
+		/* The trap was set on time and we are still executing somewhere
+		 * in slots 2-5, so we now wait for slot 0 to execute and trap
+		 * TSL execution.  This is detected when FB_BUFFER2 MSB changes
+		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
+		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
+		 */
+		while ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0)
+			;
+	}
+	/* Either (1) we were too late setting the slot 0 trap; the TSL
+	 * sequencer restarted slot 0 before we could set the EOS trap flag,
+	 * or (2) we were not late and execution is now trapped at slot 0.
+	 * In either case, we must now change slot 0 so that it will store
+	 * value 0xFF (instead of 0x00) to FB_BUFFER2 next time it executes.
+	 * In order to do this, we reprogram slot 0 so that it will shift in
+	 * SD3, which is driven only by a pull-up resistor.
+	 */
+	SETVECT(0, RSD3 | SIB_A2 | EOS);
+
+	/* Wait for slot 0 to execute, at which time the TSL is setup for
+	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
+	 * from 0x00 to 0xFF.
+	 */
+	while ((RR7146(P_FB_BUFFER2) & 0xFF000000) == 0)
+		;
+}
+
+/*  Private helper function: Write setpoint to an application DAC channel. */
+static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata)
+{
+	register uint16_t signmask;
+	register uint32_t WSImage;
+
+	/*  Adjust DAC data polarity and set up Polarity Control Register */
+	/*  image. */
+	signmask = 1 << chan;
+	if (dacdata < 0) {
+		dacdata = -dacdata;
+		devpriv->Dacpol |= signmask;
+	} else
+		devpriv->Dacpol &= ~signmask;
+
+	/*  Limit DAC setpoint value to valid range. */
+	if ((uint16_t) dacdata > 0x1FFF)
+		dacdata = 0x1FFF;
+
+	/* Set up TSL2 records (aka "vectors") for DAC update.  Vectors V2
+	 * and V3 transmit the setpoint to the target DAC.  V4 and V5 send
+	 * data to a non-existent TrimDac channel just to keep the clock
+	 * running after sending data to the target DAC.  This is necessary
+	 * to eliminate the clock glitch that would otherwise occur at the
+	 * end of the target DAC's serial data stream.  When the sequence
+	 * restarts at V0 (after executing V5), the gate array automatically
+	 * disables gating for the DAC clock and all DAC chip selects.
+	 */
+
+	WSImage = (chan & 2) ? WS1 : WS2;
+	/* Choose DAC chip select to be asserted. */
+	SETVECT(2, XSD2 | XFIFO_1 | WSImage);
+	/* Slot 2: Transmit high data byte to target DAC. */
+	SETVECT(3, XSD2 | XFIFO_0 | WSImage);
+	/* Slot 3: Transmit low data byte to target DAC. */
+	SETVECT(4, XSD2 | XFIFO_3 | WS3);
+	/* Slot 4: Transmit to non-existent TrimDac channel to keep clock */
+	SETVECT(5, XSD2 | XFIFO_2 | WS3 | EOS);
+	/* Slot 5: running after writing target DAC's low data byte. */
+
+	/*  Construct and transmit target DAC's serial packet:
+	 * ( A10D DDDD ),( DDDD DDDD ),( 0x0F ),( 0x00 ) where A is chan<0>,
+	 * and D<12:0> is the DAC setpoint.  Append a WORD value (that writes
+	 * to a  non-existent TrimDac channel) that serves to keep the clock
+	 * running after the packet has been sent to the target DAC.
+	 */
+	SendDAC(dev, 0x0F000000
+		/* Continue clock after target DAC data (write to non-existent trimdac). */
+		| 0x00004000
+		/* Address the two main dual-DAC devices (TSL's chip select enables
+		 * target device). */
+		| ((uint32_t) (chan & 1) << 15)
+		/*  Address the DAC channel within the  device. */
+		| (uint32_t) dacdata);	/*  Include DAC setpoint data. */
+
+}
+
+static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
+			 uint8_t DacData)
+{
+	uint32_t chan;
+
+	/*  Save the new setpoint in case the application needs to read it back later. */
+	devpriv->TrimSetpoint[LogicalChan] = (uint8_t) DacData;
+
+	/*  Map logical channel number to physical channel number. */
+	chan = (uint32_t) trimchan[LogicalChan];
+
+	/* Set up TSL2 records for TrimDac write operation.  All slots shift
+	 * 0xFF in from pulled-up SD3 so that the end of the slot sequence
+	 * can be detected.
+	 */
+
+	SETVECT(2, XSD2 | XFIFO_1 | WS3);
+	/* Slot 2: Send high uint8_t to target TrimDac. */
+	SETVECT(3, XSD2 | XFIFO_0 | WS3);
+	/* Slot 3: Send low uint8_t to target TrimDac. */
+	SETVECT(4, XSD2 | XFIFO_3 | WS1);
+	/* Slot 4: Send NOP high uint8_t to DAC0 to keep clock running. */
+	SETVECT(5, XSD2 | XFIFO_2 | WS1 | EOS);
+	/* Slot 5: Send NOP low  uint8_t to DAC0. */
+
+	/* Construct and transmit target DAC's serial packet:
+	 * ( 0000 AAAA ), ( DDDD DDDD ),( 0x00 ),( 0x00 ) where A<3:0> is the
+	 * DAC channel's address, and D<7:0> is the DAC setpoint.  Append a
+	 * WORD value (that writes a channel 0 NOP command to a non-existent
+	 * main DAC channel) that serves to keep the clock running after the
+	 * packet has been sent to the target DAC.
+	 */
+
+	/*  Address the DAC channel within the trimdac device. */
+	SendDAC(dev, ((uint32_t) chan << 8)
+		| (uint32_t) DacData);	/*  Include DAC setpoint data. */
+}
+
+static void LoadTrimDACs(struct comedi_device *dev)
+{
+	register uint8_t i;
+
+	/*  Copy TrimDac setpoint values from EEPROM to TrimDacs. */
+	for (i = 0; i < ARRAY_SIZE(trimchan); i++)
+		WriteTrimDAC(dev, i, I2Cread(dev, trimadrs[i]));
+}
+
 static unsigned int s626_ai_reg_to_uint(int data)
 {
 	unsigned int tempdata;
@@ -1938,248 +2172,6 @@ static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
 	/*   k->SetEnable(dev,k,(uint16_t)(enab != 0)); */
 }
 
-/* ***********  DAC FUNCTIONS *********** */
-
-/*  Slot 0 base settings. */
-#define VECT0	(XSD2 | RSD3 | SIB_A2)
-/*  Slot 0 always shifts in  0xFF and store it to  FB_BUFFER2. */
-
-/*  TrimDac LogicalChan-to-PhysicalChan mapping table. */
-static uint8_t trimchan[] = { 10, 9, 8, 3, 2, 7, 6, 1, 0, 5, 4 };
-
-/*  TrimDac LogicalChan-to-EepromAdrs mapping table. */
-static uint8_t trimadrs[] = { 0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63 };
-
-static void LoadTrimDACs(struct comedi_device *dev)
-{
-	register uint8_t i;
-
-	/*  Copy TrimDac setpoint values from EEPROM to TrimDacs. */
-	for (i = 0; i < ARRAY_SIZE(trimchan); i++)
-		WriteTrimDAC(dev, i, I2Cread(dev, trimadrs[i]));
-}
-
-static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
-			 uint8_t DacData)
-{
-	uint32_t chan;
-
-	/*  Save the new setpoint in case the application needs to read it back later. */
-	devpriv->TrimSetpoint[LogicalChan] = (uint8_t) DacData;
-
-	/*  Map logical channel number to physical channel number. */
-	chan = (uint32_t) trimchan[LogicalChan];
-
-	/* Set up TSL2 records for TrimDac write operation.  All slots shift
-	 * 0xFF in from pulled-up SD3 so that the end of the slot sequence
-	 * can be detected.
-	 */
-
-	SETVECT(2, XSD2 | XFIFO_1 | WS3);
-	/* Slot 2: Send high uint8_t to target TrimDac. */
-	SETVECT(3, XSD2 | XFIFO_0 | WS3);
-	/* Slot 3: Send low uint8_t to target TrimDac. */
-	SETVECT(4, XSD2 | XFIFO_3 | WS1);
-	/* Slot 4: Send NOP high uint8_t to DAC0 to keep clock running. */
-	SETVECT(5, XSD2 | XFIFO_2 | WS1 | EOS);
-	/* Slot 5: Send NOP low  uint8_t to DAC0. */
-
-	/* Construct and transmit target DAC's serial packet:
-	 * ( 0000 AAAA ), ( DDDD DDDD ),( 0x00 ),( 0x00 ) where A<3:0> is the
-	 * DAC channel's address, and D<7:0> is the DAC setpoint.  Append a
-	 * WORD value (that writes a channel 0 NOP command to a non-existent
-	 * main DAC channel) that serves to keep the clock running after the
-	 * packet has been sent to the target DAC.
-	 */
-
-	/*  Address the DAC channel within the trimdac device. */
-	SendDAC(dev, ((uint32_t) chan << 8)
-		| (uint32_t) DacData);	/*  Include DAC setpoint data. */
-}
-
-/*  Private helper function: Write setpoint to an application DAC channel. */
-
-static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata)
-{
-	register uint16_t signmask;
-	register uint32_t WSImage;
-
-	/*  Adjust DAC data polarity and set up Polarity Control Register */
-	/*  image. */
-	signmask = 1 << chan;
-	if (dacdata < 0) {
-		dacdata = -dacdata;
-		devpriv->Dacpol |= signmask;
-	} else
-		devpriv->Dacpol &= ~signmask;
-
-	/*  Limit DAC setpoint value to valid range. */
-	if ((uint16_t) dacdata > 0x1FFF)
-		dacdata = 0x1FFF;
-
-	/* Set up TSL2 records (aka "vectors") for DAC update.  Vectors V2
-	 * and V3 transmit the setpoint to the target DAC.  V4 and V5 send
-	 * data to a non-existent TrimDac channel just to keep the clock
-	 * running after sending data to the target DAC.  This is necessary
-	 * to eliminate the clock glitch that would otherwise occur at the
-	 * end of the target DAC's serial data stream.  When the sequence
-	 * restarts at V0 (after executing V5), the gate array automatically
-	 * disables gating for the DAC clock and all DAC chip selects.
-	 */
-
-	WSImage = (chan & 2) ? WS1 : WS2;
-	/* Choose DAC chip select to be asserted. */
-	SETVECT(2, XSD2 | XFIFO_1 | WSImage);
-	/* Slot 2: Transmit high data byte to target DAC. */
-	SETVECT(3, XSD2 | XFIFO_0 | WSImage);
-	/* Slot 3: Transmit low data byte to target DAC. */
-	SETVECT(4, XSD2 | XFIFO_3 | WS3);
-	/* Slot 4: Transmit to non-existent TrimDac channel to keep clock */
-	SETVECT(5, XSD2 | XFIFO_2 | WS3 | EOS);
-	/* Slot 5: running after writing target DAC's low data byte. */
-
-	/*  Construct and transmit target DAC's serial packet:
-	 * ( A10D DDDD ),( DDDD DDDD ),( 0x0F ),( 0x00 ) where A is chan<0>,
-	 * and D<12:0> is the DAC setpoint.  Append a WORD value (that writes
-	 * to a  non-existent TrimDac channel) that serves to keep the clock
-	 * running after the packet has been sent to the target DAC.
-	 */
-	SendDAC(dev, 0x0F000000
-		/* Continue clock after target DAC data (write to non-existent trimdac). */
-		| 0x00004000
-		/* Address the two main dual-DAC devices (TSL's chip select enables
-		 * target device). */
-		| ((uint32_t) (chan & 1) << 15)
-		/*  Address the DAC channel within the  device. */
-		| (uint32_t) dacdata);	/*  Include DAC setpoint data. */
-
-}
-
-/* Private helper function: Transmit serial data to DAC via Audio
- * channel 2.  Assumes: (1) TSL2 slot records initialized, and (2)
- * Dacpol contains valid target image.
- */
-
-static void SendDAC(struct comedi_device *dev, uint32_t val)
-{
-
-	/* START THE SERIAL CLOCK RUNNING ------------- */
-
-	/* Assert DAC polarity control and enable gating of DAC serial clock
-	 * and audio bit stream signals.  At this point in time we must be
-	 * assured of being in time slot 0.  If we are not in slot 0, the
-	 * serial clock and audio stream signals will be disabled; this is
-	 * because the following DEBIwrite statement (which enables signals
-	 * to be passed through the gate array) would execute before the
-	 * trailing edge of WS1/WS3 (which turns off the signals), thus
-	 * causing the signals to be inactive during the DAC write.
-	 */
-	DEBIwrite(dev, LP_DACPOL, devpriv->Dacpol);
-
-	/* TRANSFER OUTPUT DWORD VALUE INTO A2'S OUTPUT FIFO ---------------- */
-
-	/* Copy DAC setpoint value to DAC's output DMA buffer. */
-
-	/* WR7146( (uint32_t)devpriv->pDacWBuf, val ); */
-	*devpriv->pDacWBuf = val;
-
-	/* enab the output DMA transfer.  This will cause the DMAC to copy
-	 * the DAC's data value to A2's output FIFO.  The DMA transfer will
-	 * then immediately terminate because the protection address is
-	 * reached upon transfer of the first DWORD value.
-	 */
-	MC_ENABLE(P_MC1, MC1_A2OUT);
-
-	/*  While the DMA transfer is executing ... */
-
-	/* Reset Audio2 output FIFO's underflow flag (along with any other
-	 * FIFO underflow/overflow flags).  When set, this flag will
-	 * indicate that we have emerged from slot 0.
-	 */
-	WR7146(P_ISR, ISR_AFOU);
-
-	/* Wait for the DMA transfer to finish so that there will be data
-	 * available in the FIFO when time slot 1 tries to transfer a DWORD
-	 * from the FIFO to the output buffer register.  We test for DMA
-	 * Done by polling the DMAC enable flag; this flag is automatically
-	 * cleared when the transfer has finished.
-	 */
-	while ((RR7146(P_MC1) & MC1_A2OUT) != 0)
-		;
-
-	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
-
-	/* FIFO data is now available, so we enable execution of time slots
-	 * 1 and higher by clearing the EOS flag in slot 0.  Note that SD3
-	 * will be shifted in and stored in FB_BUFFER2 for end-of-slot-list
-	 * detection.
-	 */
-	SETVECT(0, XSD2 | RSD3 | SIB_A2);
-
-	/* Wait for slot 1 to execute to ensure that the Packet will be
-	 * transmitted.  This is detected by polling the Audio2 output FIFO
-	 * underflow flag, which will be set when slot 1 execution has
-	 * finished transferring the DAC's data DWORD from the output FIFO
-	 * to the output buffer register.
-	 */
-	while ((RR7146(P_SSR) & SSR_AF2_OUT) == 0)
-		;
-
-	/* Set up to trap execution at slot 0 when the TSL sequencer cycles
-	 * back to slot 0 after executing the EOS in slot 5.  Also,
-	 * simultaneously shift out and in the 0x00 that is ALWAYS the value
-	 * stored in the last byte to be shifted out of the FIFO's DWORD
-	 * buffer register.
-	 */
-	SETVECT(0, XSD2 | XFIFO_2 | RSD2 | SIB_A2 | EOS);
-
-	/* WAIT FOR THE TRANSACTION TO FINISH ----------------------- */
-
-	/* Wait for the TSL to finish executing all time slots before
-	 * exiting this function.  We must do this so that the next DAC
-	 * write doesn't start, thereby enabling clock/chip select signals:
-	 *
-	 * 1. Before the TSL sequence cycles back to slot 0, which disables
-	 *    the clock/cs signal gating and traps slot // list execution.
-	 *    we have not yet finished slot 5 then the clock/cs signals are
-	 *    still gated and we have not finished transmitting the stream.
-	 *
-	 * 2. While slots 2-5 are executing due to a late slot 0 trap.  In
-	 *    this case, the slot sequence is currently repeating, but with
-	 *    clock/cs signals disabled.  We must wait for slot 0 to trap
-	 *    execution before setting up the next DAC setpoint DMA transfer
-	 *    and enabling the clock/cs signals.  To detect the end of slot 5,
-	 *    we test for the FB_BUFFER2 MSB contents to be equal to 0xFF.  If
-	 *    the TSL has not yet finished executing slot 5 ...
-	 */
-	if ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0) {
-		/* The trap was set on time and we are still executing somewhere
-		 * in slots 2-5, so we now wait for slot 0 to execute and trap
-		 * TSL execution.  This is detected when FB_BUFFER2 MSB changes
-		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
-		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
-		 */
-		while ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0)
-			;
-	}
-	/* Either (1) we were too late setting the slot 0 trap; the TSL
-	 * sequencer restarted slot 0 before we could set the EOS trap flag,
-	 * or (2) we were not late and execution is now trapped at slot 0.
-	 * In either case, we must now change slot 0 so that it will store
-	 * value 0xFF (instead of 0x00) to FB_BUFFER2 next time it executes.
-	 * In order to do this, we reprogram slot 0 so that it will shift in
-	 * SD3, which is driven only by a pull-up resistor.
-	 */
-	SETVECT(0, RSD3 | SIB_A2 | EOS);
-
-	/* Wait for slot 0 to execute, at which time the TSL is setup for
-	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
-	 * from 0x00 to 0xFF.
-	 */
-	while ((RR7146(P_FB_BUFFER2) & 0xFF000000) == 0)
-		;
-}
-
 static void WriteMISC2(struct comedi_device *dev, uint16_t NewImage)
 {
 	DEBIwrite(dev, LP_MISC1, MISC1_WENABLE);	/*  enab writes to */
-- 
1.7.11

