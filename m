Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1CKViw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:38:52 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41566 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1CKVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=XEGRlPmyNJ5mwZogD/jTzpwfgbqj1QBYYPppeS/z17eBRWIRiYw50TqpnjE2TiS16x
         oEoyUdARRHWGrEP1v2iuarb6rqSfKPwrpqnu4veDWM1OOPyxqxhiLmhpDuzpM5HPtlXm
         2uBDbLUKP2jPZ+lEqtpJg4CbjC1bHhekmNhLY=
From: "=?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?=" <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnpol@2ka.mipt.ru,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>
Subject: [w1 PATCHES 3/3] Complete the 1-wire (w1) ds1wm driver search algo
Date: Fri, 11 Mar 2011 16:38:33 -0500
Message-Id: <1299879513-14884-4-git-send-email-dagenaisj@sonatest.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
References: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds multi-slave support of the w1 bus for the
ds1wm Synthesizable 1-Wire Bus Master.
Also many fixes and tweaks based on the rev3 of the datasheet
http://datasheets.maxim-ic.com/en/ds/DS1WM.pdf

Signed-off-by: Jean-François Dagenais <dagenaisj@sonatest.com>
---
:100644 100644 80b3b12... e3739df... M	drivers/w1/masters/Kconfig
:100644 100644 6b85e7f... 949d38f... M	drivers/w1/masters/ds1wm.c
 drivers/w1/masters/Kconfig |    2 +-
 drivers/w1/masters/ds1wm.c |  321 ++++++++++++++++++++++++++++++--------------
 2 files changed, 220 insertions(+), 103 deletions(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 80b3b12..e3739df 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -42,7 +42,7 @@ config W1_MASTER_MXC
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1 && ARM && HAVE_CLK
+	depends on W1
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 6b85e7f..949d38f 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -33,6 +33,7 @@
 #define DS1WM_INT	0x02	/* R/W interrupt status */
 #define DS1WM_INT_EN	0x03	/* R/W interrupt enable */
 #define DS1WM_CLKDIV	0x04	/* R/W 5 bits of divisor and pre-scale */
+#define DS1WM_CNTRL	0x05	/* R/W master control register (not used yet) */
 
 #define DS1WM_CMD_1W_RESET  (1 << 0)	/* force reset on 1-wire bus */
 #define DS1WM_CMD_SRA	    (1 << 1)	/* enable Search ROM accelerator mode */
@@ -56,6 +57,7 @@
 #define DS1WM_INTEN_ERSRF   (1 << 5)	/* enable rx shift register full int */
 #define DS1WM_INTEN_DQO	    (1 << 6)	/* enable direct bus driving ops */
 
+#define DS1WM_INTEN_NOT_IAS (~DS1WM_INTEN_IAS)	/* all but INTR active state */
 
 #define DS1WM_TIMEOUT (HZ * 5)
 
@@ -63,41 +65,50 @@ static struct {
 	unsigned long freq;
 	unsigned long divisor;
 } freq[] = {
-	{ 4000000, 0x8 },
-	{ 5000000, 0x2 },
-	{ 6000000, 0x5 },
-	{ 7000000, 0x3 },
-	{ 8000000, 0xc },
-	{ 10000000, 0x6 },
-	{ 12000000, 0x9 },
-	{ 14000000, 0x7 },
-	{ 16000000, 0x10 },
-	{ 20000000, 0xa },
-	{ 24000000, 0xd },
-	{ 28000000, 0xb },
-	{ 32000000, 0x14 },
-	{ 40000000, 0xe },
-	{ 48000000, 0x11 },
-	{ 56000000, 0xf },
-	{ 64000000, 0x18 },
-	{ 80000000, 0x12 },
-	{ 96000000, 0x15 },
-	{ 112000000, 0x13 },
-	{ 128000000, 0x1c },
+	{   1000000, 0x80 },
+	{   2000000, 0x84 },
+	{   3000000, 0x81 },
+	{   4000000, 0x88 },
+	{   5000000, 0x82 },
+	{   6000000, 0x85 },
+	{   7000000, 0x83 },
+	{   8000000, 0x8c },
+	{  10000000, 0x86 },
+	{  12000000, 0x89 },
+	{  14000000, 0x87 },
+	{  16000000, 0x90 },
+	{  20000000, 0x8a },
+	{  24000000, 0x8d },
+	{  28000000, 0x8b },
+	{  32000000, 0x94 },
+	{  40000000, 0x8e },
+	{  48000000, 0x91 },
+	{  56000000, 0x8f },
+	{  64000000, 0x98 },
+	{  80000000, 0x92 },
+	{  96000000, 0x95 },
+	{ 112000000, 0x93 },
+	{ 128000000, 0x9c },
+/* you can continue this table, consult the OPERATION - CLOCK DIVISOR
+   section of the ds1wm spec sheet. */
 };
 
 struct ds1wm_data {
-	void		__iomem *map;
-	int		bus_shift; /* # of shifts to calc register offsets */
+	void     __iomem *map;
+	int      bus_shift; /* # of shifts to calc register offsets */
 	struct platform_device *pdev;
-	struct mfd_cell	*cell;
-	int		irq;
-	int		active_high;
-	int		slave_present;
-	void		*reset_complete;
-	void		*read_complete;
-	void		*write_complete;
-	u8		read_byte; /* last byte received */
+	struct mfd_cell   *cell;
+	int      irq;
+	int      slave_present;
+	void     *reset_complete;
+	void     *read_complete;
+	void     *write_complete;
+	int      read_error;
+	/* last byte received */
+	u8       read_byte;
+	/* byte to write that makes all intr disabled, */
+	/* considering active_state (IAS) (optimization) */
+	u8       int_en_reg_none;
 };
 
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
@@ -115,23 +126,39 @@ static inline u8 ds1wm_read_register(struct ds1wm_data *ds1wm_data, u32 reg)
 static irqreturn_t ds1wm_isr(int isr, void *data)
 {
 	struct ds1wm_data *ds1wm_data = data;
-	u8 intr = ds1wm_read_register(ds1wm_data, DS1WM_INT);
+	u8 intr;
+	u8 inten = ds1wm_read_register(ds1wm_data, DS1WM_INT_EN);
+	/* if no bits are set in int enable register (except the IAS)
+	than go no further, reading the regs below has side effects */
+	if (!(inten & DS1WM_INTEN_NOT_IAS))
+		return IRQ_NONE;
 
-	ds1wm_data->slave_present = (intr & DS1WM_INT_PDR) ? 0 : 1;
+	ds1wm_write_register(ds1wm_data,
+		DS1WM_INT_EN, ds1wm_data->int_en_reg_none);
 
-	if ((intr & DS1WM_INT_PD) && ds1wm_data->reset_complete)
-		complete(ds1wm_data->reset_complete);
+	/* this read action clears the INTR and certain flags in ds1wm */
+	intr = ds1wm_read_register(ds1wm_data, DS1WM_INT);
 
-	if ((intr & DS1WM_INT_TSRE) && ds1wm_data->write_complete)
-		complete(ds1wm_data->write_complete);
+	ds1wm_data->slave_present = (intr & DS1WM_INT_PDR) ? 0 : 1;
 
+	if ((intr & DS1WM_INT_TSRE) && ds1wm_data->write_complete) {
+		inten &= ~DS1WM_INTEN_ETMT;
+		complete(ds1wm_data->write_complete);
+	}
 	if (intr & DS1WM_INT_RBF) {
+		/* this read clears the RBF flag */
 		ds1wm_data->read_byte = ds1wm_read_register(ds1wm_data,
-							    DS1WM_DATA);
+		DS1WM_DATA);
+		inten &= ~DS1WM_INTEN_ERBF;
 		if (ds1wm_data->read_complete)
 			complete(ds1wm_data->read_complete);
 	}
+	if ((intr & DS1WM_INT_PD) && ds1wm_data->reset_complete) {
+		inten &= ~DS1WM_INTEN_EPD;
+		complete(ds1wm_data->reset_complete);
+	}
 
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, inten);
 	return IRQ_HANDLED;
 }
 
@@ -142,33 +169,19 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 
 	ds1wm_data->reset_complete = &reset_done;
 
+	/* enable Presence detect only */
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, DS1WM_INTEN_EPD |
-		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
+	ds1wm_data->int_en_reg_none);
 
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_1W_RESET);
 
 	timeleft = wait_for_completion_timeout(&reset_done, DS1WM_TIMEOUT);
 	ds1wm_data->reset_complete = NULL;
 	if (!timeleft) {
-		dev_err(&ds1wm_data->pdev->dev, "reset failed\n");
+		dev_err(&ds1wm_data->pdev->dev, "reset failed, timed out\n");
 		return 1;
 	}
 
-	/* Wait for the end of the reset. According to the specs, the time
-	 * from when the interrupt is asserted to the end of the reset is:
-	 *     tRSTH  - tPDH  - tPDL - tPDI
-	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
-	 *
-	 * We'll wait a bit longer just to be sure.
-	 * Was udelay(500), but if it is going to busywait the cpu that long,
-	 * might as well come back later.
-	 */
-	msleep(1);
-
-	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
-		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
-		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
-
 	if (!ds1wm_data->slave_present) {
 		dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
 		return 1;
@@ -179,26 +192,47 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 
 static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
 {
+	unsigned long timeleft;
 	DECLARE_COMPLETION_ONSTACK(write_done);
 	ds1wm_data->write_complete = &write_done;
 
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
+	ds1wm_data->int_en_reg_none | DS1WM_INTEN_ETMT);
+
 	ds1wm_write_register(ds1wm_data, DS1WM_DATA, data);
 
-	wait_for_completion_timeout(&write_done, DS1WM_TIMEOUT);
+	timeleft = wait_for_completion_timeout(&write_done, DS1WM_TIMEOUT);
+
 	ds1wm_data->write_complete = NULL;
+	if (!timeleft) {
+		dev_err(&ds1wm_data->pdev->dev, "write failed, timed out\n");
+		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
 
-static int ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char write_data)
+static u8 ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char write_data)
 {
+	unsigned long timeleft;
+	u8 intEnable = DS1WM_INTEN_ERBF | ds1wm_data->int_en_reg_none;
 	DECLARE_COMPLETION_ONSTACK(read_done);
+
+	ds1wm_read_register(ds1wm_data, DS1WM_DATA);
+
 	ds1wm_data->read_complete = &read_done;
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, intEnable);
 
-	ds1wm_write(ds1wm_data, write_data);
-	wait_for_completion_timeout(&read_done, DS1WM_TIMEOUT);
-	ds1wm_data->read_complete = NULL;
+	ds1wm_write_register(ds1wm_data, DS1WM_DATA, write_data);
+	timeleft = wait_for_completion_timeout(&read_done, DS1WM_TIMEOUT);
 
+	ds1wm_data->read_complete = NULL;
+	if (!timeleft) {
+		dev_err(&ds1wm_data->pdev->dev, "read failed, timed out\n");
+		ds1wm_data->read_error = -ETIMEDOUT;
+		return 0xFF;
+	}
+	ds1wm_data->read_error = 0;
 	return ds1wm_data->read_byte;
 }
 
@@ -206,8 +240,8 @@ static int ds1wm_find_divisor(int gclk)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(freq); i++)
-		if (gclk <= freq[i].freq)
+	for (i = ARRAY_SIZE(freq)-1; i >= 0; --i)
+		if (gclk >= freq[i].freq)
 			return freq[i].divisor;
 
 	return 0;
@@ -222,6 +256,8 @@ static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
 
 	divisor = ds1wm_find_divisor(plat->clock_rate);
+	dev_dbg(&ds1wm_data->pdev->dev,
+		"found divisor 0x%x for clock %d\n", divisor, plat->clock_rate);
 	if (divisor == 0) {
 		dev_err(&ds1wm_data->pdev->dev,
 			"no suitable divisor for %dHz clock\n",
@@ -242,7 +278,7 @@ static void ds1wm_down(struct ds1wm_data *ds1wm_data)
 
 	/* Disable interrupts. */
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
-			     ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0);
+		ds1wm_data->int_en_reg_none);
 
 	if (ds1wm_data->cell->disable)
 		ds1wm_data->cell->disable(ds1wm_data->pdev);
@@ -279,41 +315,121 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 {
 	struct ds1wm_data *ds1wm_data = data;
 	int i;
-	unsigned long long rom_id;
-
-	/* XXX We need to iterate for multiple devices per the DS1WM docs.
-	 * See http://www.maxim-ic.com/appnotes.cfm/appnote_number/120. */
-	if (ds1wm_reset(ds1wm_data))
-		return;
-
-	ds1wm_write(ds1wm_data, search_type);
-	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
-
-	for (rom_id = 0, i = 0; i < 16; i++) {
-
-		unsigned char resp, r, d;
-
-		resp = ds1wm_read(ds1wm_data, 0x00);
-
-		r = ((resp & 0x02) >> 1) |
-		    ((resp & 0x08) >> 2) |
-		    ((resp & 0x20) >> 3) |
-		    ((resp & 0x80) >> 4);
-
-		d = ((resp & 0x01) >> 0) |
-		    ((resp & 0x04) >> 1) |
-		    ((resp & 0x10) >> 2) |
-		    ((resp & 0x40) >> 3);
-
-		rom_id |= (unsigned long long) r << (i * 4);
-
-	}
-	dev_dbg(&ds1wm_data->pdev->dev, "found 0x%08llX\n", rom_id);
-
-	ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
-	ds1wm_reset(ds1wm_data);
-
-	slave_found(master_dev, rom_id);
+	int ms_discrep_bit = -1;
+	u64 r = 0; /* holds the progress of the search */
+	u64 r_prime, d;
+	unsigned slaves_found = 0;
+	unsigned int pass = 0;
+
+	dev_dbg(&ds1wm_data->pdev->dev, "search begin\n");
+	while (true) {
+		++pass;
+		if (pass > 100) {
+			dev_dbg(&ds1wm_data->pdev->dev,
+				"too many attempts (100), search aborted\n");
+			return;
+		}
+
+		if (ds1wm_reset(ds1wm_data)) {
+			dev_dbg(&ds1wm_data->pdev->dev,
+				"pass: %d reset error (or no slaves)\n", pass);
+			break;
+		}
+
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d r : %0#18llx writing SEARCH_ROM\n", pass, r);
+		ds1wm_write(ds1wm_data, search_type);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d entering ASM\n", pass);
+		ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d begining nibble loop\n", pass);
+
+		r_prime = 0;
+		d = 0;
+		/* we work one nibble at a time */
+		/* each nibble is interleaved to form a byte */
+		for (i = 0; i < 16; i++) {
+
+			unsigned char resp, _r, _r_prime, _d;
+
+			_r = (r >> (4*i)) & 0xf;
+			_r = ((_r & 0x1) << 1) |
+			((_r & 0x2) << 2) |
+			((_r & 0x4) << 3) |
+			((_r & 0x8) << 4);
+
+			/* writes _r, then reads back: */
+			resp = ds1wm_read(ds1wm_data, _r);
+
+			if (ds1wm_data->read_error) {
+				dev_err(&ds1wm_data->pdev->dev,
+				"pass: %d nibble: %d read error\n", pass, i);
+				break;
+			}
+
+			_r_prime = ((resp & 0x02) >> 1) |
+			((resp & 0x08) >> 2) |
+			((resp & 0x20) >> 3) |
+			((resp & 0x80) >> 4);
+
+			_d = ((resp & 0x01) >> 0) |
+			((resp & 0x04) >> 1) |
+			((resp & 0x10) >> 2) |
+			((resp & 0x40) >> 3);
+
+			r_prime |= (unsigned long long) _r_prime << (i * 4);
+			d |= (unsigned long long) _d << (i * 4);
+
+		}
+		if (ds1wm_data->read_error) {
+			dev_err(&ds1wm_data->pdev->dev,
+				"pass: %d read error, retrying\n", pass);
+			break;
+		}
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d r\': %0#18llx d:%0#18llx\n",
+			pass, r_prime, d);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d nibble loop complete, exiting ASM\n", pass);
+		ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d resetting bus\n", pass);
+		ds1wm_reset(ds1wm_data);
+		if ((r_prime & ((u64)1 << 63)) && (d & ((u64)1 << 63))) {
+			dev_err(&ds1wm_data->pdev->dev,
+				"pass: %d bus error, retrying\n", pass);
+			continue; /* start over */
+		}
+
+
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d found %0#18llx\n", pass, r_prime);
+		slave_found(master_dev, r_prime);
+		++slaves_found;
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d complete, preparing next pass\n", pass);
+
+		/* any discrepency found which we already choose the
+		   '1' branch is now is now irrelevant we reveal the
+		   next branch with this: */
+		d &= ~r;
+		/* find last bit set, i.e. the most signif. bit set */
+		ms_discrep_bit = fls64(d) - 1;
+		dev_dbg(&ds1wm_data->pdev->dev,
+			"pass: %d new d:%0#18llx MS discrep bit:%d\n",
+			pass, d, ms_discrep_bit);
+
+		/* prev_ms_discrep_bit = ms_discrep_bit;
+		   prepare for next ROM search:		    */
+		if (ms_discrep_bit == -1)
+			break;
+
+		r = (r &  ~(~0ull << (ms_discrep_bit))) | 1 << ms_discrep_bit;
+	} /* end while true */
+	dev_dbg(&ds1wm_data->pdev->dev,
+		"pass: %d total: %d search done ms d bit pos: %d\n", pass,
+		slaves_found, ms_discrep_bit);
 }
 
 /* --------------------------------------------------------------------- */
@@ -370,15 +486,15 @@ static int ds1wm_probe(struct platform_device *pdev)
 		goto err1;
 	}
 	ds1wm_data->irq = res->start;
-	ds1wm_data->active_high = plat->active_high;
+	ds1wm_data->int_en_reg_none = (plat->active_high ? DS1WM_INTEN_IAS : 0);
 
 	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
 		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
 	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
 		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
-	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
-			  "ds1wm", ds1wm_data);
+	ret = request_irq(ds1wm_data->irq, ds1wm_isr,
+		IRQF_DISABLED | IRQF_SHARED, "ds1wm", ds1wm_data);
 	if (ret)
 		goto err1;
 
@@ -465,5 +581,6 @@ module_exit(ds1wm_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>, "
-	      "Matt Reimer <mreimer@vpop.net>");
+	"Matt Reimer <mreimer@vpop.net>,"
+	"Jean-Francois Dagenais <dagenaisj@sonatest.com>");
 MODULE_DESCRIPTION("DS1WM w1 busmaster driver");
-- 
1.7.4.1

