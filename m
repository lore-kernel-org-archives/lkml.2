Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2FUCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:25:26 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:50358 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2FUCZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:25:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1340245522!13127417!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/12] staging: comedi: s626: remove forward declarations 2
Date: Wed, 20 Jun 2012 19:25:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201925.16536.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the DEBI* i/o functions up to remove the need for the
forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 143 +++++++++++++++++-----------------
 1 file changed, 70 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 0886806..1efa2f0 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -220,9 +220,6 @@ static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr);
 static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val);
 static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata);
 static void SendDAC(struct comedi_device *dev, uint32_t val);
-static void DEBItransfer(struct comedi_device *dev);
-static uint16_t DEBIread(struct comedi_device *dev, uint16_t addr);
-static void DEBIwrite(struct comedi_device *dev, uint16_t addr, uint16_t wdata);
 
 /*  COUNTER OBJECT ------------------------------------------------ */
 struct enc_private {
@@ -426,6 +423,76 @@ static const struct comedi_lrange s626_range_table = { 2, {
 							   }
 };
 
+/*  Execute a DEBI transfer.  This must be called from within a */
+/*  critical section. */
+static void DEBItransfer(struct comedi_device *dev)
+{
+	/*  Initiate upload of shadow RAM to DEBI control register. */
+	MC_ENABLE(P_MC2, MC2_UPLD_DEBI);
+
+	/*  Wait for completion of upload from shadow RAM to DEBI control */
+	/*  register. */
+	while (!MC_TEST(P_MC2, MC2_UPLD_DEBI))
+		;
+
+	/*  Wait until DEBI transfer is done. */
+	while (RR7146(P_PSR) & PSR_DEBI_S)
+		;
+}
+
+/*  Initialize the DEBI interface for all transfers. */
+
+static uint16_t DEBIread(struct comedi_device *dev, uint16_t addr)
+{
+	uint16_t retval;
+
+	/*  Set up DEBI control register value in shadow RAM. */
+	WR7146(P_DEBICMD, DEBI_CMD_RDWORD | addr);
+
+	/*  Execute the DEBI transfer. */
+	DEBItransfer(dev);
+
+	/*  Fetch target register value. */
+	retval = (uint16_t) RR7146(P_DEBIAD);
+
+	/*  Return register value. */
+	return retval;
+}
+
+/*  Write a value to a gate array register. */
+static void DEBIwrite(struct comedi_device *dev, uint16_t addr, uint16_t wdata)
+{
+
+	/*  Set up DEBI control register value in shadow RAM. */
+	WR7146(P_DEBICMD, DEBI_CMD_WRWORD | addr);
+	WR7146(P_DEBIAD, wdata);
+
+	/*  Execute the DEBI transfer. */
+	DEBItransfer(dev);
+}
+
+/* Replace the specified bits in a gate array register.  Imports: mask
+ * specifies bits that are to be preserved, wdata is new value to be
+ * or'd with the masked original.
+ */
+static void DEBIreplace(struct comedi_device *dev, uint16_t addr, uint16_t mask,
+			uint16_t wdata)
+{
+
+	/*  Copy target gate array register into P_DEBIAD register. */
+	WR7146(P_DEBICMD, DEBI_CMD_RDWORD | addr);
+	/* Set up DEBI control reg value in shadow RAM. */
+	DEBItransfer(dev);	/*  Execute the DEBI Read transfer. */
+
+	/*  Write back the modified image. */
+	WR7146(P_DEBICMD, DEBI_CMD_WRWORD | addr);
+	/* Set up DEBI control reg value in shadow  RAM. */
+
+	WR7146(P_DEBIAD, wdata | ((uint16_t) RR7146(P_DEBIAD) & mask));
+	/* Modify the register image. */
+	DEBItransfer(dev);	/*  Execute the DEBI Write transfer. */
+}
+
 static unsigned int s626_ai_reg_to_uint(int data)
 {
 	unsigned int tempdata;
@@ -2123,76 +2190,6 @@ static void WriteMISC2(struct comedi_device *dev, uint16_t NewImage)
 	DEBIwrite(dev, LP_MISC1, MISC1_WDISABLE);	/*  Disable writes to MISC2. */
 }
 
-/*  Initialize the DEBI interface for all transfers. */
-
-static uint16_t DEBIread(struct comedi_device *dev, uint16_t addr)
-{
-	uint16_t retval;
-
-	/*  Set up DEBI control register value in shadow RAM. */
-	WR7146(P_DEBICMD, DEBI_CMD_RDWORD | addr);
-
-	/*  Execute the DEBI transfer. */
-	DEBItransfer(dev);
-
-	/*  Fetch target register value. */
-	retval = (uint16_t) RR7146(P_DEBIAD);
-
-	/*  Return register value. */
-	return retval;
-}
-
-/*  Execute a DEBI transfer.  This must be called from within a */
-/*  critical section. */
-static void DEBItransfer(struct comedi_device *dev)
-{
-	/*  Initiate upload of shadow RAM to DEBI control register. */
-	MC_ENABLE(P_MC2, MC2_UPLD_DEBI);
-
-	/*  Wait for completion of upload from shadow RAM to DEBI control */
-	/*  register. */
-	while (!MC_TEST(P_MC2, MC2_UPLD_DEBI))
-		;
-
-	/*  Wait until DEBI transfer is done. */
-	while (RR7146(P_PSR) & PSR_DEBI_S)
-		;
-}
-
-/*  Write a value to a gate array register. */
-static void DEBIwrite(struct comedi_device *dev, uint16_t addr, uint16_t wdata)
-{
-
-	/*  Set up DEBI control register value in shadow RAM. */
-	WR7146(P_DEBICMD, DEBI_CMD_WRWORD | addr);
-	WR7146(P_DEBIAD, wdata);
-
-	/*  Execute the DEBI transfer. */
-	DEBItransfer(dev);
-}
-
-/* Replace the specified bits in a gate array register.  Imports: mask
- * specifies bits that are to be preserved, wdata is new value to be
- * or'd with the masked original.
- */
-static void DEBIreplace(struct comedi_device *dev, uint16_t addr, uint16_t mask,
-			uint16_t wdata)
-{
-
-	/*  Copy target gate array register into P_DEBIAD register. */
-	WR7146(P_DEBICMD, DEBI_CMD_RDWORD | addr);
-	/* Set up DEBI control reg value in shadow RAM. */
-	DEBItransfer(dev);	/*  Execute the DEBI Read transfer. */
-
-	/*  Write back the modified image. */
-	WR7146(P_DEBICMD, DEBI_CMD_WRWORD | addr);
-	/* Set up DEBI control reg value in shadow  RAM. */
-
-	WR7146(P_DEBIAD, wdata | ((uint16_t) RR7146(P_DEBIAD) & mask));
-	/* Modify the register image. */
-	DEBItransfer(dev);	/*  Execute the DEBI Write transfer. */
-}
-
 static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 		      size_t bsize)
 {
-- 
1.7.11

