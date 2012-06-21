Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2FUC1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:27:04 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:32954 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2FUC1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:27:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1340245620!6480432!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/12] staging: comedi: s626: remove forward declarations 7
Date: Wed, 20 Jun 2012 19:26:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201926.56951.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move up the remaining functions needed to remove the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 185 ++++++++++++++++------------------
 1 file changed, 85 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d7d72ac1..50656a7 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -230,16 +230,6 @@ struct enc_private {
 
 #define encpriv ((struct enc_private *)(dev->subdevices+5)->private)
 
-static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
-			    int tick);
-static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k);
-static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
-			   uint16_t value);
-static void Preload(struct comedi_device *dev, struct enc_private *k,
-		    uint32_t value);
-
-/*  Counter objects constructor. */
-
 /*  Counter overflow/index event flag masks for RDMISC2. */
 #define INDXMASK(C)		(1 << (((C) > 2) ? ((C) * 2 - 1) : ((C) * 2 +  4)))
 #define OVERMASK(C)		(1 << (((C) > 2) ? ((C) * 2 + 5) : ((C) * 2 + 10)))
@@ -652,6 +642,57 @@ static void LoadTrimDACs(struct comedi_device *dev)
 		WriteTrimDAC(dev, i, I2Cread(dev, trimadrs[i]));
 }
 
+/* ******  COUNTER FUNCTIONS  ******* */
+/* All counter functions address a specific counter by means of the
+ * "Counter" argument, which is a logical counter number.  The Counter
+ * argument may have any of the following legal values: 0=0A, 1=1A,
+ * 2=2A, 3=0B, 4=1B, 5=2B.
+ */
+
+/*  Read a counter's output latch. */
+static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k)
+{
+	register uint32_t value;
+	/* DEBUG FIXME DEBUG("ReadLatch: Read Latch enter\n"); */
+
+	/*  Latch counts and fetch LSW of latched counts value. */
+	value = (uint32_t) DEBIread(dev, k->MyLatchLsw);
+
+	/*  Fetch MSW of latched counts and combine with LSW. */
+	value |= ((uint32_t) DEBIread(dev, k->MyLatchLsw + 2) << 16);
+
+	/*  DEBUG FIXME DEBUG("ReadLatch: Read Latch exit\n"); */
+
+	/*  Return latched counts. */
+	return value;
+}
+
+/* Return/set a counter pair's latch trigger source.  0: On read
+ * access, 1: A index latches A, 2: B index latches B, 3: A overflow
+ * latches B.
+ */
+static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
+			   uint16_t value)
+{
+	DEBUG("SetLatchSource: SetLatchSource enter 3550\n");
+	DEBIreplace(dev, k->MyCRB,
+		    (uint16_t) (~(CRBMSK_INTCTRL | CRBMSK_LATCHSRC)),
+		    (uint16_t) (value << CRBBIT_LATCHSRC));
+
+	DEBUG("SetLatchSource: SetLatchSource exit\n");
+}
+
+/*  Write value into counter preload register. */
+static void Preload(struct comedi_device *dev, struct enc_private *k,
+		    uint32_t value)
+{
+	DEBUG("Preload: preload enter\n");
+	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw), (uint16_t) value);	/*  Write value to preload register. */
+	DEBUG("Preload: preload step 1\n");
+	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw + 2),
+		  (uint16_t) (value >> 16));
+}
+
 static unsigned int s626_ai_reg_to_uint(int data)
 {
 	unsigned int tempdata;
@@ -1475,6 +1516,40 @@ static int s626_ns_to_timer(int *nanosec, int round_mode)
 	return divider - 1;
 }
 
+static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
+			    int tick)
+{
+	uint16_t Setup = (LOADSRC_INDX << BF_LOADSRC) |	/*  Preload upon */
+	    /*  index. */
+	    (INDXSRC_SOFT << BF_INDXSRC) |	/*  Disable hardware index. */
+	    (CLKSRC_TIMER << BF_CLKSRC) |	/*  Operating mode is Timer. */
+	    (CLKPOL_POS << BF_CLKPOL) |	/*  Active high clock. */
+	    (CNTDIR_DOWN << BF_CLKPOL) |	/*  Count direction is Down. */
+	    (CLKMULT_1X << BF_CLKMULT) |	/*  Clock multiplier is 1x. */
+	    (CLKENAB_INDEX << BF_CLKENAB);
+	uint16_t valueSrclatch = LATCHSRC_A_INDXA;
+	/*   uint16_t enab=CLKENAB_ALWAYS; */
+
+	k->SetMode(dev, k, Setup, FALSE);
+
+	/*  Set the preload register */
+	Preload(dev, k, tick);
+
+	/*  Software index pulse forces the preload register to load */
+	/*  into the counter */
+	k->SetLoadTrig(dev, k, 0);
+	k->PulseIndex(dev, k);
+
+	/* set reload on counter overflow */
+	k->SetLoadTrig(dev, k, 1);
+
+	/* set interrupt on overflow */
+	k->SetIntSrc(dev, k, INTSRC_OVER);
+
+	SetLatchSource(dev, k, valueSrclatch);
+	/*   k->SetEnable(dev,k,(uint16_t)(enab != 0)); */
+}
+
 /*  TO COMPLETE  */
 static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
@@ -2004,40 +2079,6 @@ static int s626_enc_insn_write(struct comedi_device *dev,
 	return 1;
 }
 
-static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
-			    int tick)
-{
-	uint16_t Setup = (LOADSRC_INDX << BF_LOADSRC) |	/*  Preload upon */
-	    /*  index. */
-	    (INDXSRC_SOFT << BF_INDXSRC) |	/*  Disable hardware index. */
-	    (CLKSRC_TIMER << BF_CLKSRC) |	/*  Operating mode is Timer. */
-	    (CLKPOL_POS << BF_CLKPOL) |	/*  Active high clock. */
-	    (CNTDIR_DOWN << BF_CLKPOL) |	/*  Count direction is Down. */
-	    (CLKMULT_1X << BF_CLKMULT) |	/*  Clock multiplier is 1x. */
-	    (CLKENAB_INDEX << BF_CLKENAB);
-	uint16_t valueSrclatch = LATCHSRC_A_INDXA;
-	/*   uint16_t enab=CLKENAB_ALWAYS; */
-
-	k->SetMode(dev, k, Setup, FALSE);
-
-	/*  Set the preload register */
-	Preload(dev, k, tick);
-
-	/*  Software index pulse forces the preload register to load */
-	/*  into the counter */
-	k->SetLoadTrig(dev, k, 0);
-	k->PulseIndex(dev, k);
-
-	/* set reload on counter overflow */
-	k->SetLoadTrig(dev, k, 1);
-
-	/* set interrupt on overflow */
-	k->SetIntSrc(dev, k, INTSRC_OVER);
-
-	SetLatchSource(dev, k, valueSrclatch);
-	/*   k->SetEnable(dev,k,(uint16_t)(enab != 0)); */
-}
-
 static void WriteMISC2(struct comedi_device *dev, uint16_t NewImage)
 {
 	DEBIwrite(dev, LP_MISC1, MISC1_WENABLE);	/*  enab writes to */
@@ -2069,36 +2110,8 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 	}
 }
 
-/* ******  COUNTER FUNCTIONS  ******* */
-/* All counter functions address a specific counter by means of the
- * "Counter" argument, which is a logical counter number.  The Counter
- * argument may have any of the following legal values: 0=0A, 1=1A,
- * 2=2A, 3=0B, 4=1B, 5=2B.
- */
-
-/* Forward declarations for functions that are common to both A and B counters: */
-
 /* ******  PRIVATE COUNTER FUNCTIONS ****** */
 
-/*  Read a counter's output latch. */
-
-static uint32_t ReadLatch(struct comedi_device *dev, struct enc_private *k)
-{
-	register uint32_t value;
-	/* DEBUG FIXME DEBUG("ReadLatch: Read Latch enter\n"); */
-
-	/*  Latch counts and fetch LSW of latched counts value. */
-	value = (uint32_t) DEBIread(dev, k->MyLatchLsw);
-
-	/*  Fetch MSW of latched counts and combine with LSW. */
-	value |= ((uint32_t) DEBIread(dev, k->MyLatchLsw + 2) << 16);
-
-	/*  DEBUG FIXME DEBUG("ReadLatch: Read Latch exit\n"); */
-
-	/*  Return latched counts. */
-	return value;
-}
-
 /*  Reset a counter's index and overflow event capture flags. */
 
 static void ResetCapFlags_A(struct comedi_device *dev, struct enc_private *k)
@@ -2348,22 +2361,6 @@ static uint16_t GetEnable_B(struct comedi_device *dev, struct enc_private *k)
 	return (DEBIread(dev, k->MyCRB) >> CRBBIT_CLKENAB_B) & 1;
 }
 
-/* Return/set a counter pair's latch trigger source.  0: On read
- * access, 1: A index latches A, 2: B index latches B, 3: A overflow
- * latches B.
- */
-
-static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
-			   uint16_t value)
-{
-	DEBUG("SetLatchSource: SetLatchSource enter 3550\n");
-	DEBIreplace(dev, k->MyCRB,
-		    (uint16_t) (~(CRBMSK_INTCTRL | CRBMSK_LATCHSRC)),
-		    (uint16_t) (value << CRBBIT_LATCHSRC));
-
-	DEBUG("SetLatchSource: SetLatchSource exit\n");
-}
-
 /*
  * static uint16_t GetLatchSource(struct comedi_device *dev, struct enc_private *k )
  * {
@@ -2541,18 +2538,6 @@ static void PulseIndex_B(struct comedi_device *dev, struct enc_private *k)
 	DEBIwrite(dev, k->MyCRB, crb);
 }
 
-/*  Write value into counter preload register. */
-
-static void Preload(struct comedi_device *dev, struct enc_private *k,
-		    uint32_t value)
-{
-	DEBUG("Preload: preload enter\n");
-	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw), (uint16_t) value);	/*  Write value to preload register. */
-	DEBUG("Preload: preload step 1\n");
-	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw + 2),
-		  (uint16_t) (value >> 16));
-}
-
 static struct enc_private enc_private_data[] = {
 	{
 		.GetEnable	= GetEnable_A,
-- 
1.7.11

