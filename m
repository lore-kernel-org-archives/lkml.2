Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0HXKbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:31:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:29599 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0HXKbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:31:07 -0400
Message-ID: <4C739F55.8030301@nokia.com>
Date: Tue, 24 Aug 2010 13:30:45 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Fleming <matt@console-pimps.org>, Chris Ball <cjb@laptop.org>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>	<AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>	<m3pqxbsibq.fsf@pullcord.laptop.org>	<20100823204829.GB6510@console-pimps.org> <20100823142816.59b12253.akpm@linux-foundation.org>
In-Reply-To: <20100823142816.59b12253.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Aug 2010 10:30:37.0464 (UTC) FILETIME=[64641180:01CB4377]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 23 Aug 2010 21:48:29 +0100
> Matt Fleming <matt@console-pimps.org> wrote:
> 
>> On Sat, Aug 21, 2010 at 06:37:45PM -0400, Chris Ball wrote:
>>> Hi,
>>>
>>>    > Hm is there some problem with this patch or has the processing of
>>>    > it simply stalled? When I read the thread I cannot see Hanumaths
>>>    > answers on the list but it looks mainly like the patch is OK and
>>>    > there is some chit-chat.
>>>    > 
>>>    > Can it be picked up? Everyone is going to need DDR MMC for their
>>>    > eMMCs soon-ish.
>>>
>>> I'd like to dedicate more time to mmc/.  Do you think it'd be useful
>>> for me to catch all the patches sent to linux-mmc@ into a public Git
>>> tree, and periodically report on what went upstream via akpm and
>>> what's still waiting?
>> It's possible Andrew has a reason that hasn't been picked up yet.
>>
> 
> Kyungmin Park's questions didn't seem adequately answered and the
> discussion kind of died.
> 
> I updated the patch and merged it, but I'd like the outstanding
> question(s) resolved.  ie: why do we add MMC_DDR_MODE, set it in
> brq.data.flags and then never use it?

I am not able to test DDR mode but it look to me that the patch
should be changed.  Here is a fix:

>From 8253aa16b1ab15974a3ba8f33566fe8e2cca29e6 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 24 Aug 2010 13:20:26 +0300
Subject: [PATCH] mmc: Fix Dual Data Rate (DDR) support

The DDR support patch needs the following fixes:

- The block driver does not need to know about DDR, any more
than it needs to know about bus width.
- Not only the card must be switched to DDR mode.  The host
controller must also be configured, which is done through
the 'set_ios()' function.
- Do not set the DDR mode state until after the switch command
is successful.
- Setting block length is not supported in DDR mode.  Make that
a core function and change the other place it is used (mmc_test)
also.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c    |   19 +++----------------
 drivers/mmc/card/mmc_test.c |   12 +-----------
 drivers/mmc/core/bus.c      |    6 ++++--
 drivers/mmc/core/core.c     |   28 ++++++++++++++++++++++++++--
 drivers/mmc/core/core.h     |    1 +
 drivers/mmc/core/mmc.c      |   21 +++++++++++----------
 include/linux/mmc/core.h    |    3 ++-
 include/linux/mmc/host.h    |    5 +++++
 8 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 24f39d7..1ec93bb 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -373,8 +373,6 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 			readcmd = MMC_READ_SINGLE_BLOCK;
 			writecmd = MMC_WRITE_BLOCK;
 		}
-		if (mmc_card_ddr_mode(card))
-			brq.data.flags |= MMC_DDR_MODE;
 		if (rq_data_dir(req) == READ) {
 			brq.cmd.opcode = readcmd;
 			brq.data.flags |= MMC_DATA_READ;
@@ -652,26 +650,15 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 static int
 mmc_blk_set_blksize(struct mmc_blk_data *md, struct mmc_card *card)
 {
-	struct mmc_command cmd;
 	int err;
 
-	/*
-	 * Block-addressed and ddr mode supported cards
-	 * ignore MMC_SET_BLOCKLEN.
-	 */
-	if (mmc_card_blockaddr(card) || mmc_card_ddr_mode(card))
-		return 0;
-
 	mmc_claim_host(card->host);
-	cmd.opcode = MMC_SET_BLOCKLEN;
-	cmd.arg = 512;
-	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
-	err = mmc_wait_for_cmd(card->host, &cmd, 5);
+	err = mmc_set_blocklen(card, 512);
 	mmc_release_host(card->host);
 
 	if (err) {
-		printk(KERN_ERR "%s: unable to set block size to %d: %d\n",
-			md->disk->disk_name, cmd.arg, err);
+		printk(KERN_ERR "%s: unable to set block size to 512: %d\n",
+			md->disk->disk_name, err);
 		return -EINVAL;
 	}
 
diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 5dd8576..f80b759 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -100,17 +100,7 @@ struct mmc_test_card {
  */
 static int mmc_test_set_blksize(struct mmc_test_card *test, unsigned size)
 {
-	struct mmc_command cmd;
-	int ret;
-
-	cmd.opcode = MMC_SET_BLOCKLEN;
-	cmd.arg = size;
-	cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
-	ret = mmc_wait_for_cmd(test->card->host, &cmd, 0);
-	if (ret)
-		return ret;
-
-	return 0;
+	return mmc_set_blocklen(test->card, size);
 }
 
 /*
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 7cd9749..dc36f39 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -254,14 +254,16 @@ int mmc_add_card(struct mmc_card *card)
 	}
 
 	if (mmc_host_is_spi(card->host)) {
-		printk(KERN_INFO "%s: new %s%s card on SPI\n",
+		printk(KERN_INFO "%s: new %s%s%s card on SPI\n",
 			mmc_hostname(card->host),
 			mmc_card_highspeed(card) ? "high speed " : "",
+			mmc_card_ddr_mode(card) ? "DDR " : "",
 			type);
 	} else {
-		printk(KERN_INFO "%s: new %s%s card at address %04x\n",
+		printk(KERN_INFO "%s: new %s%s%s card at address %04x\n",
 			mmc_hostname(card->host),
 			mmc_card_highspeed(card) ? "high speed " : "",
+			mmc_card_ddr_mode(card) ? "DDR " : "",
 			type, card->rca);
 	}
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 5db49b1..8519480 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -650,14 +650,23 @@ void mmc_set_bus_mode(struct mmc_host *host, unsigned int mode)
 }
 
 /*
- * Change data bus width of a host.
+ * Change data bus width and DDR mode of a host.
  */
-void mmc_set_bus_width(struct mmc_host *host, unsigned int width)
+void mmc_set_bus_width_ddr(struct mmc_host *host, unsigned int width, int ddr)
 {
 	host->ios.bus_width = width;
+	host->ios.ddr = ddr ? MMC_DDR_MODE : MMC_SDR_MODE;
 	mmc_set_ios(host);
 }
 
+/*
+ * Change data bus width of a host.
+ */
+void mmc_set_bus_width(struct mmc_host *host, unsigned int width)
+{
+	mmc_set_bus_width_ddr(host, width, 0);
+}
+
 /**
  * mmc_vdd_to_ocrbitnum - Convert a voltage to the OCR bit number
  * @vdd:	voltage (mV)
@@ -1397,6 +1406,21 @@ int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 }
 EXPORT_SYMBOL(mmc_erase_group_aligned);
 
+int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen)
+{
+	struct mmc_command cmd;
+
+	if (mmc_card_blockaddr(card) || mmc_card_ddr_mode(card))
+		return 0;
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+	cmd.opcode = MMC_SET_BLOCKLEN;
+	cmd.arg = blocklen;
+	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
+	return mmc_wait_for_cmd(card->host, &cmd, 5);
+}
+EXPORT_SYMBOL(mmc_set_blocklen);
+
 void mmc_rescan(struct work_struct *work)
 {
 	struct mmc_host *host =
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 9d9eef5..68150c9 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -35,6 +35,7 @@ void mmc_set_chip_select(struct mmc_host *host, int mode);
 void mmc_set_clock(struct mmc_host *host, unsigned int hz);
 void mmc_set_bus_mode(struct mmc_host *host, unsigned int mode);
 void mmc_set_bus_width(struct mmc_host *host, unsigned int width);
+void mmc_set_bus_width_ddr(struct mmc_host *host, unsigned int width, int ddr);
 u32 mmc_select_voltage(struct mmc_host *host, u32 ocr);
 void mmc_set_timing(struct mmc_host *host, unsigned int timing);
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index dcfc921..998c0d3 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -375,7 +375,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	struct mmc_card *oldcard)
 {
 	struct mmc_card *card;
-	int err;
+	int err, ddr = 0;
 	u32 cid[4];
 	unsigned int max_dtr;
 
@@ -518,32 +518,32 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	mmc_set_clock(host, max_dtr);
 
 	/*
-	 * Activate DDR50 mode (if supported).
+	 * Indicate DDR mode (if supported).
 	 */
 	if (mmc_card_highspeed(card)) {
 		if ((card->ext_csd.card_type & EXT_CSD_CARD_TYPE_DDR_1_8V)
 			&& (host->caps & (MMC_CAP_1_8V_DDR)))
-				mmc_card_set_ddr_mode(card);
+				ddr = 1;
 		else if ((card->ext_csd.card_type & EXT_CSD_CARD_TYPE_DDR_1_2V)
 			&& (host->caps & (MMC_CAP_1_2V_DDR)))
-				mmc_card_set_ddr_mode(card);
+				ddr = 1;
 	}
 
 	/*
-	 * Activate wide bus (if supported).
+	 * Activate wide bus and DDR (if supported).
 	 */
 	if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
 	    (host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA))) {
 		unsigned ext_csd_bit, bus_width;
 
 		if (host->caps & MMC_CAP_8_BIT_DATA) {
-			if (mmc_card_ddr_mode(card))
+			if (ddr)
 				ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_8;
 			else
 				ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
 			bus_width = MMC_BUS_WIDTH_8;
 		} else {
-			if (mmc_card_ddr_mode(card))
+			if (ddr)
 				ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_4;
 			else
 				ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
@@ -557,12 +557,13 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 			goto free_card;
 
 		if (err) {
-			printk(KERN_WARNING "%s: switch to bus width %d "
+			printk(KERN_WARNING "%s: switch to bus width %d ddr %d "
 			       "failed\n", mmc_hostname(card->host),
-			       1 << bus_width);
+			       1 << bus_width, ddr);
 			err = 0;
 		} else {
-			mmc_set_bus_width(card->host, bus_width);
+			mmc_card_set_ddr_mode(card);
+			mmc_set_bus_width_ddr(card->host, bus_width, ddr);
 		}
 	}
 
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 17bb4c2..64e013f 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -109,7 +109,6 @@ struct mmc_data {
 #define MMC_DATA_WRITE	(1 << 8)
 #define MMC_DATA_READ	(1 << 9)
 #define MMC_DATA_STREAM	(1 << 10)
-#define MMC_DDR_MODE    (1 << 11)
 
 	unsigned int		bytes_xfered;
 
@@ -154,6 +153,8 @@ extern int mmc_can_secure_erase_trim(struct mmc_card *card);
 extern int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 				   unsigned int nr);
 
+extern int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen);
+
 extern void mmc_set_data_timeout(struct mmc_data *, const struct mmc_card *);
 extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 09dbb90..aa1a747 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -50,6 +50,11 @@ struct mmc_ios {
 #define MMC_TIMING_LEGACY	0
 #define MMC_TIMING_MMC_HS	1
 #define MMC_TIMING_SD_HS	2
+
+	unsigned char	ddr;			/* dual data rate used */
+
+#define MMC_SDR_MODE		0
+#define MMC_DDR_MODE		1
 };
 
 struct mmc_host_ops {
-- 
1.6.3.3
