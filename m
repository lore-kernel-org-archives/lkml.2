Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0JRIQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:16:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54558 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0JRIQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:16:33 -0400
Date: Mon, 18 Oct 2010 10:16:26 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: torvalds@linux-foundation.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH for 2.6.36] mxc_nand: do not depend on disabling the irq in
	the interrupt handler
Message-ID: <20101018081626.GI28242@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:10:04 up 106 days, 23:20, 24 users,  load average: 3.23, 3.08,
	1.56
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch reverts the driver to enabling/disabling the NFC interrupt
mask rather than enabling/disabling the system interrupt. This cleans
up the driver so that it doesn't rely on interrupts being disabled
within the interrupt handler.
For i.MX21 we keep the current behaviour, that is calling
enable_irq/disable_irq_nosync to enable/disable interrupts.
This patch is based on earlier work by John Ogness.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: John Ogness <john.ogness@linutronix.de>
Tested-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---

Hi Linus,

I now it's late but please apply this patch for 2.6.36. It was sent some
times to the lists but got lost. Without it the i.MX NAND driver is
nonfuntional.

Sascha

 drivers/mtd/nand/mxc_nand.c |   92 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index b2828e8..214b03a 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -30,6 +30,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/completion.h>
 
 #include <asm/mach/flash.h>
 #include <mach/mxc_nand.h>
@@ -151,7 +153,7 @@ struct mxc_nand_host {
 	int			irq;
 	int			eccsize;
 
-	wait_queue_head_t	irq_waitq;
+	struct completion	op_completion;
 
 	uint8_t			*data_buf;
 	unsigned int		buf_start;
@@ -164,6 +166,7 @@ struct mxc_nand_host {
 	void			(*send_read_id)(struct mxc_nand_host *);
 	uint16_t		(*get_dev_status)(struct mxc_nand_host *);
 	int			(*check_int)(struct mxc_nand_host *);
+	void			(*irq_control)(struct mxc_nand_host *, int);
 };
 
 /* OOB placement block for use with hardware ecc generation */
@@ -216,9 +219,12 @@ static irqreturn_t mxc_nfc_irq(int irq, void *dev_id)
 {
 	struct mxc_nand_host *host = dev_id;
 
-	disable_irq_nosync(irq);
+	if (!host->check_int(host))
+		return IRQ_NONE;
 
-	wake_up(&host->irq_waitq);
+	host->irq_control(host, 0);
+
+	complete(&host->op_completion);
 
 	return IRQ_HANDLED;
 }
@@ -245,11 +251,54 @@ static int check_int_v1_v2(struct mxc_nand_host *host)
 	if (!(tmp & NFC_V1_V2_CONFIG2_INT))
 		return 0;
 
-	writew(tmp & ~NFC_V1_V2_CONFIG2_INT, NFC_V1_V2_CONFIG2);
+	if (!cpu_is_mx21())
+		writew(tmp & ~NFC_V1_V2_CONFIG2_INT, NFC_V1_V2_CONFIG2);
 
 	return 1;
 }
 
+/*
+ * It has been observed that the i.MX21 cannot read the CONFIG2:INT bit
+ * if interrupts are masked (CONFIG1:INT_MSK is set). To handle this, the
+ * driver can enable/disable the irq line rather than simply masking the
+ * interrupts.
+ */
+static void irq_control_mx21(struct mxc_nand_host *host, int activate)
+{
+	if (activate)
+		enable_irq(host->irq);
+	else
+		disable_irq_nosync(host->irq);
+}
+
+static void irq_control_v1_v2(struct mxc_nand_host *host, int activate)
+{
+	uint16_t tmp;
+
+	tmp = readw(NFC_V1_V2_CONFIG1);
+
+	if (activate)
+		tmp &= ~NFC_V1_V2_CONFIG1_INT_MSK;
+	else
+		tmp |= NFC_V1_V2_CONFIG1_INT_MSK;
+
+	writew(tmp, NFC_V1_V2_CONFIG1);
+}
+
+static void irq_control_v3(struct mxc_nand_host *host, int activate)
+{
+	uint32_t tmp;
+
+	tmp = readl(NFC_V3_CONFIG2);
+
+	if (activate)
+		tmp &= ~NFC_V3_CONFIG2_INT_MSK;
+	else
+		tmp |= NFC_V3_CONFIG2_INT_MSK;
+
+	writel(tmp, NFC_V3_CONFIG2);
+}
+
 /* This function polls the NANDFC to wait for the basic operation to
  * complete by checking the INT bit of config2 register.
  */
@@ -259,10 +308,9 @@ static void wait_op_done(struct mxc_nand_host *host, int useirq)
 
 	if (useirq) {
 		if (!host->check_int(host)) {
-
-			enable_irq(host->irq);
-
-			wait_event(host->irq_waitq, host->check_int(host));
+			INIT_COMPLETION(host->op_completion);
+			host->irq_control(host, 1);
+			wait_for_completion(&host->op_completion);
 		}
 	} else {
 		while (max_retries-- > 0) {
@@ -799,6 +847,7 @@ static void preset_v3(struct mtd_info *mtd)
 		NFC_V3_CONFIG2_2CMD_PHASES |
 		NFC_V3_CONFIG2_SPAS(mtd->oobsize >> 1) |
 		NFC_V3_CONFIG2_ST_CMD(0x70) |
+		NFC_V3_CONFIG2_INT_MSK |
 		NFC_V3_CONFIG2_NUM_ADDR_PHASE0;
 
 	if (chip->ecc.mode == NAND_ECC_HW)
@@ -1024,6 +1073,10 @@ static int __init mxcnd_probe(struct platform_device *pdev)
 		host->send_read_id = send_read_id_v1_v2;
 		host->get_dev_status = get_dev_status_v1_v2;
 		host->check_int = check_int_v1_v2;
+		if (cpu_is_mx21())
+			host->irq_control = irq_control_mx21;
+		else
+			host->irq_control = irq_control_v1_v2;
 	}
 
 	if (nfc_is_v21()) {
@@ -1062,6 +1115,7 @@ static int __init mxcnd_probe(struct platform_device *pdev)
 		host->send_read_id = send_read_id_v3;
 		host->check_int = check_int_v3;
 		host->get_dev_status = get_dev_status_v3;
+		host->irq_control = irq_control_v3;
 		oob_smallpage = &nandv2_hw_eccoob_smallpage;
 		oob_largepage = &nandv2_hw_eccoob_largepage;
 	} else
@@ -1093,14 +1147,34 @@ static int __init mxcnd_probe(struct platform_device *pdev)
 		this->options |= NAND_USE_FLASH_BBT;
 	}
 
-	init_waitqueue_head(&host->irq_waitq);
+	init_completion(&host->op_completion);
 
 	host->irq = platform_get_irq(pdev, 0);
 
+	/*
+	 * mask the interrupt. For i.MX21 explicitely call
+	 * irq_control_v1_v2 to use the mask bit. We can't call
+	 * disable_irq_nosync() for an interrupt we do not own yet.
+	 */
+	if (cpu_is_mx21())
+		irq_control_v1_v2(host, 0);
+	else
+		host->irq_control(host, 0);
+
 	err = request_irq(host->irq, mxc_nfc_irq, IRQF_DISABLED, DRIVER_NAME, host);
 	if (err)
 		goto eirq;
 
+	host->irq_control(host, 0);
+
+	/*
+	 * Now that the interrupt is disabled make sure the interrupt
+	 * mask bit is cleared on i.MX21. Otherwise we can't read
+	 * the interrupt status bit on this machine.
+	 */
+	if (cpu_is_mx21())
+		irq_control_v1_v2(host, 1);
+
 	/* first scan to find the device and get the page size */
 	if (nand_scan_ident(mtd, 1, NULL)) {
 		err = -ENXIO;
-- 
1.7.2.3

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
