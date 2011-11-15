Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1KOXdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:33:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757578Ab1KOXdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:33:17 -0500
From: Joe Perches <joe@perches.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Cliff Cai <cliff.cai@analog.com>, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>, Sascha Sommer <saschasommer@freenet.de>,
        Alex Dubov <oakad@yahoo.com>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Pierre Ossman <pierre@ossman.eu>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 3/4] mmc: Logging neatening
Date: Tue, 15 Nov 2011 15:32:07 -0800
Message-Id: <d2c1a76fea1844ae7ac3e7e17183fb39df19178e.1321398814.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1321398814.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce formats.
Align arguments.
Add pr_fmt, remove prefixes from format strings.
Neaten DBG uses, rearrange argument order.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/card/mmc_test.c    |   49 +++++-------
 drivers/mmc/core/core.c        |   52 ++++++------
 drivers/mmc/core/host.c        |    3 +-
 drivers/mmc/core/mmc.c         |   22 ++---
 drivers/mmc/core/mmc_ops.c     |    5 +-
 drivers/mmc/core/sd.c          |   25 +++---
 drivers/mmc/core/sdio_bus.c    |    2 +
 drivers/mmc/core/sdio_io.c     |   14 ++--
 drivers/mmc/core/sdio_irq.c    |   10 ++-
 drivers/mmc/host/at91_mci.c    |    3 +-
 drivers/mmc/host/au1xmmc.c     |   35 ++++----
 drivers/mmc/host/bfin_sdh.c    |    3 +-
 drivers/mmc/host/dw_mmc.c      |   16 ++--
 drivers/mmc/host/mmc_spi.c     |    9 +-
 drivers/mmc/host/mmci.c        |    3 +-
 drivers/mmc/host/mvsdio.c      |   33 ++++----
 drivers/mmc/host/omap_hsmmc.c  |   11 +--
 drivers/mmc/host/sdhci-pci.c   |   17 ++---
 drivers/mmc/host/sdhci-pxav3.c |    7 +-
 drivers/mmc/host/sdhci.c       |  175 ++++++++++++++++++---------------------
 drivers/mmc/host/sdricoh_cs.c  |   12 ++--
 drivers/mmc/host/tifm_sd.c     |    9 +-
 drivers/mmc/host/via-sdmmc.c   |   22 +++---
 drivers/mmc/host/vub300.c      |   54 ++++++-------
 drivers/mmc/host/wbsd.c        |    5 +-
 25 files changed, 277 insertions(+), 319 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index b038c4a..f079555 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -9,6 +9,8 @@
  * your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -251,8 +253,7 @@ static int mmc_test_wait_busy(struct mmc_test_card *test)
 		if (!busy && mmc_test_busy(&cmd)) {
 			busy = 1;
 			if (test->card->host->caps & MMC_CAP_WAIT_WHILE_BUSY)
-				pr_info("%s: Warning: Host did not "
-					"wait for busy state to end.\n",
+				pr_info("%s: Warning: Host did not wait for busy state to end\n",
 					mmc_hostname(test->card->host));
 		}
 	} while (mmc_test_busy(&cmd));
@@ -553,12 +554,11 @@ static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
 	rate = mmc_test_rate(bytes, &ts);
 	iops = mmc_test_rate(100, &ts); /* I/O ops per sec x 100 */
 
-	pr_info("%s: Transfer of %u sectors (%u%s KiB) took %lu.%09lu "
-			 "seconds (%u kB/s, %u KiB/s, %u.%02u IOPS)\n",
-			 mmc_hostname(test->card->host), sectors, sectors >> 1,
-			 (sectors & 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
-			 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024,
-			 iops / 100, iops % 100);
+	pr_info("%s: Transfer of %u sectors (%u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS)\n",
+		mmc_hostname(test->card->host), sectors, sectors >> 1,
+		(sectors & 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
+		(unsigned long)ts.tv_nsec, rate / 1000, rate / 1024,
+		iops / 100, iops % 100);
 
 	mmc_test_save_transfer_result(test, 1, sectors, ts, rate, iops);
 }
@@ -579,14 +579,12 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
 	rate = mmc_test_rate(tot, &ts);
 	iops = mmc_test_rate(count * 100, &ts); /* I/O ops per sec x 100 */
 
-	pr_info("%s: Transfer of %u x %u sectors (%u x %u%s KiB) took "
-			 "%lu.%09lu seconds (%u kB/s, %u KiB/s, "
-			 "%u.%02u IOPS, sg_len %d)\n",
-			 mmc_hostname(test->card->host), count, sectors, count,
-			 sectors >> 1, (sectors & 1 ? ".5" : ""),
-			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
-			 rate / 1000, rate / 1024, iops / 100, iops % 100,
-			 test->area.sg_len);
+	pr_info("%s: Transfer of %u x %u sectors (%u x %u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS, sg_len %d)\n",
+		mmc_hostname(test->card->host), count, sectors, count,
+		sectors >> 1, (sectors & 1 ? ".5" : ""),
+		(unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
+		rate / 1000, rate / 1024, iops / 100, iops % 100,
+		test->area.sg_len);
 
 	mmc_test_save_transfer_result(test, count, sectors, ts, rate, iops);
 }
@@ -1410,7 +1408,7 @@ static int mmc_test_multi_read_high(struct mmc_test_card *test)
 static int mmc_test_no_highmem(struct mmc_test_card *test)
 {
 	pr_info("%s: Highmem not configured - test skipped\n",
-	       mmc_hostname(test->card->host));
+		mmc_hostname(test->card->host));
 	return 0;
 }
 
@@ -1437,7 +1435,7 @@ static int mmc_test_area_map(struct mmc_test_card *test, unsigned long sz,
 	}
 	if (err)
 		pr_info("%s: Failed to map sg list\n",
-		       mmc_hostname(test->card->host));
+			mmc_hostname(test->card->host));
 	return err;
 }
 
@@ -2709,8 +2707,7 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 		if (mmc_test_cases[i].prepare) {
 			ret = mmc_test_cases[i].prepare(test);
 			if (ret) {
-				pr_info("%s: Result: Prepare "
-					"stage failed! (%d)\n",
+				pr_info("%s: Result: Prepare stage failed! (%d)\n",
 					mmc_hostname(test->card->host),
 					ret);
 				continue;
@@ -2747,13 +2744,11 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 				mmc_hostname(test->card->host));
 			break;
 		case RESULT_UNSUP_HOST:
-			pr_info("%s: Result: UNSUPPORTED "
-				"(by host)\n",
+			pr_info("%s: Result: UNSUPPORTED (by host)\n",
 				mmc_hostname(test->card->host));
 			break;
 		case RESULT_UNSUP_CARD:
-			pr_info("%s: Result: UNSUPPORTED "
-				"(by card)\n",
+			pr_info("%s: Result: UNSUPPORTED (by card)\n",
 				mmc_hostname(test->card->host));
 			break;
 		default:
@@ -2768,8 +2763,7 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 		if (mmc_test_cases[i].cleanup) {
 			ret = mmc_test_cases[i].cleanup(test);
 			if (ret) {
-				pr_info("%s: Warning: Cleanup "
-					"stage failed! (%d)\n",
+				pr_info("%s: Warning: Cleanup stage failed! (%d)\n",
 					mmc_hostname(test->card->host),
 					ret);
 			}
@@ -2778,8 +2772,7 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 
 	mmc_release_host(test->card->host);
 
-	pr_info("%s: Tests completed.\n",
-		mmc_hostname(test->card->host));
+	pr_info("%s: Tests completed\n", mmc_hostname(test->card->host));
 }
 
 static void mmc_test_free_result(struct mmc_card *card)
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 54d6a13..39e1311 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -10,6 +10,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -153,22 +156,22 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 		led_trigger_event(host->led, LED_OFF);
 
 		pr_debug("%s: req done (CMD%u): %d: %08x %08x %08x %08x\n",
-			mmc_hostname(host), cmd->opcode, err,
-			cmd->resp[0], cmd->resp[1],
-			cmd->resp[2], cmd->resp[3]);
+			 mmc_hostname(host), cmd->opcode, err,
+			 cmd->resp[0], cmd->resp[1],
+			 cmd->resp[2], cmd->resp[3]);
 
 		if (mrq->data) {
 			pr_debug("%s:     %d bytes transferred: %d\n",
-				mmc_hostname(host),
-				mrq->data->bytes_xfered, mrq->data->error);
+				 mmc_hostname(host),
+				 mrq->data->bytes_xfered, mrq->data->error);
 		}
 
 		if (mrq->stop) {
 			pr_debug("%s:     (CMD%u): %d: %08x %08x %08x %08x\n",
-				mmc_hostname(host), mrq->stop->opcode,
-				mrq->stop->error,
-				mrq->stop->resp[0], mrq->stop->resp[1],
-				mrq->stop->resp[2], mrq->stop->resp[3]);
+				 mmc_hostname(host), mrq->stop->opcode,
+				 mrq->stop->error,
+				 mrq->stop->resp[0], mrq->stop->resp[1],
+				 mrq->stop->resp[2], mrq->stop->resp[3]);
 		}
 
 		if (mrq->done)
@@ -193,12 +196,11 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 		 mrq->cmd->arg, mrq->cmd->flags);
 
 	if (mrq->data) {
-		pr_debug("%s:     blksz %d blocks %d flags %08x "
-			"tsac %d ms nsac %d\n",
-			mmc_hostname(host), mrq->data->blksz,
-			mrq->data->blocks, mrq->data->flags,
-			mrq->data->timeout_ns / 1000000,
-			mrq->data->timeout_clks);
+		pr_debug("%s:     blksz %d blocks %d flags %08x tsac %d ms nsac %d\n",
+			 mmc_hostname(host), mrq->data->blksz,
+			 mrq->data->blocks, mrq->data->flags,
+			 mrq->data->timeout_ns / 1000000,
+			 mrq->data->timeout_clks);
 	}
 
 	if (mrq->stop) {
@@ -842,8 +844,7 @@ static inline void mmc_set_ios(struct mmc_host *host)
 {
 	struct mmc_ios *ios = &host->ios;
 
-	pr_debug("%s: clock %uHz busmode %u powermode %u cs %u Vdd %u "
-		"width %u timing %u\n",
+	pr_debug("%s: clock %uHz busmode %u powermode %u cs %u Vdd %u width %u timing %u\n",
 		 mmc_hostname(host), ios->clock, ios->bus_mode,
 		 ios->power_mode, ios->chip_select, ios->vdd,
 		 ios->bus_width, ios->timing);
@@ -1310,8 +1311,7 @@ void mmc_power_off(struct mmc_host *host)
 				 notify_type, timeout);
 
 		if (err && err != -EBADMSG)
-			pr_err("Device failed to respond within %d poweroff "
-			       "time. Forcefully powering down the device\n",
+			pr_err("Device failed to respond within %d poweroff time. Forcefully powering down the device.\n",
 			       timeout);
 
 		/* Set the card state to no notification after the poweroff */
@@ -1642,8 +1642,8 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
 	if (err) {
-		pr_err("mmc_erase: group start error %d, "
-		       "status %#x\n", err, cmd.resp[0]);
+		pr_err("mmc_erase: group start error %d, status %#x\n",
+		       err, cmd.resp[0]);
 		err = -EIO;
 		goto out;
 	}
@@ -1688,7 +1688,7 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 		err = mmc_wait_for_cmd(card->host, &cmd, 0);
 		if (err || (cmd.resp[0] & 0xFDF92000)) {
 			pr_err("error %d requesting status %#x\n",
-				err, cmd.resp[0]);
+			       err, cmd.resp[0]);
 			err = -EIO;
 			goto out;
 		}
@@ -2245,7 +2245,7 @@ int mmc_flush_cache(struct mmc_card *card)
 				EXT_CSD_FLUSH_CACHE, 1, 0);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
-					mmc_hostname(card->host), err);
+			       mmc_hostname(card->host), err);
 	}
 
 	return err;
@@ -2275,9 +2275,9 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
 					EXT_CSD_CACHE_CTRL, enable, 0);
 		if (err)
 			pr_err("%s: cache %s error %d\n",
-					mmc_hostname(card->host),
-					enable ? "on" : "off",
-					err);
+			       mmc_hostname(card->host),
+			       enable ? "on" : "off",
+			       err);
 		else
 			card->ext_csd.cache_ctrl = enable;
 	}
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 835e86a..7f963c0 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -94,8 +94,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
 	unsigned long flags;
 
 	if (!freq) {
-		pr_debug("%s: frequency set to 0 in disable function, "
-			 "this means the clock is already disabled.\n",
+		pr_debug("%s: frequency set to 0 in disable function, this means the clock is already disabled\n",
 			 mmc_hostname(host));
 		return;
 	}
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index bbd7adb..f6db788 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -196,8 +196,8 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
 	 */
 	ext_csd = kmalloc(512, GFP_KERNEL);
 	if (!ext_csd) {
-		pr_err("%s: could not allocate a buffer to "
-			"receive the ext_csd.\n", mmc_hostname(card->host));
+		pr_err("%s: could not allocate a buffer to receive the ext_csd\n",
+		       mmc_hostname(card->host));
 		return -ENOMEM;
 	}
 
@@ -218,10 +218,8 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
 		 * stored in their CSD.
 		 */
 		if (card->csd.capacity == (4096 * 512)) {
-			pr_err("%s: unable to read EXT_CSD "
-				"on a possible high capacity card. "
-				"Card will be ignored.\n",
-				mmc_hostname(card->host));
+			pr_err("%s: unable to read EXT_CSD on a possible high capacity card. Card will be ignored.\n",
+			       mmc_hostname(card->host));
 		} else {
 			pr_warn("%s: unable to read EXT_CSD, performance might suffer\n",
 				mmc_hostname(card->host));
@@ -251,9 +249,9 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 	card->ext_csd.raw_ext_csd_structure = ext_csd[EXT_CSD_STRUCTURE];
 	if (card->csd.structure == 3) {
 		if (card->ext_csd.raw_ext_csd_structure > 2) {
-			pr_err("%s: unrecognised EXT_CSD structure "
-				"version %d\n", mmc_hostname(card->host),
-					card->ext_csd.raw_ext_csd_structure);
+			pr_err("%s: unrecognised EXT_CSD structure version %d\n",
+			       mmc_hostname(card->host),
+			       card->ext_csd.raw_ext_csd_structure);
 			err = -EINVAL;
 			goto out;
 		}
@@ -984,8 +982,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 			err = mmc_select_powerclass(card, ext_csd_bits[idx][0],
 						    ext_csd);
 			if (err)
-				pr_err("%s: power class selection to "
-				       "bus width %d failed\n",
+				pr_err("%s: power class selection to bus width %d failed\n",
 				       mmc_hostname(card->host),
 				       1 << bus_width);
 
@@ -1015,8 +1012,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 			err = mmc_select_powerclass(card, ext_csd_bits[idx][1],
 						    ext_csd);
 			if (err)
-				pr_err("%s: power class selection to "
-				       "bus width %d ddr %d failed\n",
+				pr_err("%s: power class selection to bus width %d ddr %d failed\n",
 				       mmc_hostname(card->host),
 				       1 << bus_width, ddr);
 
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 32deb3e..7c7388c 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -569,9 +569,8 @@ int mmc_send_hpi_cmd(struct mmc_card *card, u32 *status)
 
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
 	if (err) {
-		pr_warn("%s: error %d interrupting operation. "
-			"HPI command response %#x\n", mmc_hostname(card->host),
-			err, cmd.resp[0]);
+		pr_warn("%s: error %d interrupting operation. HPI command response %#x\n",
+			mmc_hostname(card->host), err, cmd.resp[0]);
 		return err;
 	}
 	if (status)
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 52a1563..1492b7b 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
@@ -283,9 +285,8 @@ static int mmc_read_switch(struct mmc_card *card)
 
 	status = kmalloc(64, GFP_KERNEL);
 	if (!status) {
-		pr_err("%s: could not allocate a buffer for "
-			"switch capabilities.\n",
-			mmc_hostname(card->host));
+		pr_err("%s: could not allocate a buffer for switch capabilities\n",
+		       mmc_hostname(card->host));
 		return -ENOMEM;
 	}
 
@@ -299,7 +300,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 			goto out;
 
-		pr_warn("%s: problem reading Bus Speed modes.\n",
+		pr_warn("%s: problem reading Bus Speed modes\n",
 			mmc_hostname(card->host));
 		err = 0;
 
@@ -381,8 +382,8 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 
 	status = kmalloc(64, GFP_KERNEL);
 	if (!status) {
-		pr_err("%s: could not allocate a buffer for "
-			"switch capabilities.\n", mmc_hostname(card->host));
+		pr_err("%s: could not allocate a buffer for switch capabilities\n",
+		       mmc_hostname(card->host));
 		return -ENOMEM;
 	}
 
@@ -391,7 +392,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 		goto out;
 
 	if ((status[16] & 0xF) != 1) {
-		pr_warn("%s: Problem switching card into high-speed mode!\n",
+		pr_warn("%s: problem switching card into high-speed mode!\n",
 			mmc_hostname(card->host));
 		err = 0;
 	} else {
@@ -456,7 +457,7 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[15] & 0xF) != drive_strength) {
-		pr_warn("%s: Problem setting drive strength!\n",
+		pr_warn("%s: problem setting drive strength!\n",
 			mmc_hostname(card->host));
 		return 0;
 	}
@@ -535,7 +536,7 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[16] & 0xF) != card->sd_bus_speed)
-		pr_warn("%s: Problem setting bus speed mode!\n",
+		pr_warn("%s: problem setting bus speed mode!\n",
 			mmc_hostname(card->host));
 	else {
 		mmc_set_timing(card->host, timing);
@@ -597,7 +598,7 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 		return err;
 
 	if (((status[15] >> 4) & 0x0F) != current_limit)
-		pr_warn("%s: Problem setting current limit!\n",
+		pr_warn("%s: problem setting current limit!\n",
 			mmc_hostname(card->host));
 
 	return 0;
@@ -619,8 +620,8 @@ static int mmc_sd_init_uhs_card(struct mmc_card *card)
 
 	status = kmalloc(64, GFP_KERNEL);
 	if (!status) {
-		pr_err("%s: could not allocate a buffer for "
-			"switch capabilities.\n", mmc_hostname(card->host));
+		pr_err("%s: could not allocate a buffer for switch capabilities\n",
+		       mmc_hostname(card->host));
 		return -ENOMEM;
 	}
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 3d82f12..57ce052 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -11,6 +11,8 @@
  * SDIO function driver model
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/export.h>
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 8f6f5ac..7c87732 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -9,6 +9,8 @@
  * your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -65,7 +67,7 @@ int sdio_enable_func(struct sdio_func *func)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Enabling device %s...\n", sdio_func_id(func));
+	pr_debug("Enabling device %s...\n", sdio_func_id(func));
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IOEx, 0, &reg);
 	if (ret)
@@ -90,12 +92,12 @@ int sdio_enable_func(struct sdio_func *func)
 			goto err;
 	}
 
-	pr_debug("SDIO: Enabled device %s\n", sdio_func_id(func));
+	pr_debug("Enabled device %s\n", sdio_func_id(func));
 
 	return 0;
 
 err:
-	pr_debug("SDIO: Failed to enable device %s\n", sdio_func_id(func));
+	pr_debug("Failed to enable device %s\n", sdio_func_id(func));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sdio_enable_func);
@@ -115,7 +117,7 @@ int sdio_disable_func(struct sdio_func *func)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Disabling device %s...\n", sdio_func_id(func));
+	pr_debug("Disabling device %s...\n", sdio_func_id(func));
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IOEx, 0, &reg);
 	if (ret)
@@ -127,12 +129,12 @@ int sdio_disable_func(struct sdio_func *func)
 	if (ret)
 		goto err;
 
-	pr_debug("SDIO: Disabled device %s\n", sdio_func_id(func));
+	pr_debug("Disabled device %s\n", sdio_func_id(func));
 
 	return 0;
 
 err:
-	pr_debug("SDIO: Failed to disable device %s\n", sdio_func_id(func));
+	pr_debug("Failed to disable device %s\n", sdio_func_id(func));
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(sdio_disable_func);
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index bc9e67a..533d0e5 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -13,6 +13,8 @@
  * your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
@@ -47,7 +49,7 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
 	if (ret) {
 		pr_debug("%s: error %d reading SDIO_CCCR_INTx\n",
-		       mmc_card_id(card), ret);
+			 mmc_card_id(card), ret);
 		return ret;
 	}
 
@@ -233,10 +235,10 @@ int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Enabling IRQ for %s...\n", sdio_func_id(func));
+	pr_debug("Enabling IRQ for %s...\n", sdio_func_id(func));
 
 	if (func->irq_handler) {
-		pr_debug("SDIO: IRQ for %s already in use.\n", sdio_func_id(func));
+		pr_debug("IRQ for %s already in use\n", sdio_func_id(func));
 		return -EBUSY;
 	}
 
@@ -276,7 +278,7 @@ int sdio_release_irq(struct sdio_func *func)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Disabling IRQ for %s...\n", sdio_func_id(func));
+	pr_debug("Disabling IRQ for %s...\n", sdio_func_id(func));
 
 	if (func->irq_handler) {
 		func->irq_handler = NULL;
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index f437c3e..d63f453 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -968,8 +968,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 		if (at91mci_is_mci1rev2xx())
 			mmc->caps |= MMC_CAP_4_BIT_DATA;
 		else
-			dev_warn(&pdev->dev, "4 wire bus mode not supported"
-				" - using 1 wire\n");
+			dev_warn(&pdev->dev, "4 wire bus mode not supported - using 1 wire\n");
 	}
 
 	host->buffer = dma_alloc_coherent(&pdev->dev, MCI_BUFSIZE,
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index dbd0c8a..cfd325d 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -32,6 +32,8 @@
  * (the low to high transition will not occur).
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -54,10 +56,11 @@
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DBG(fmt, idx, args...)	\
-	pr_debug("au1xmmc(%d): DEBUG: " fmt, idx, ##args)
+#define DBG(idx, fmt, ...)					\
+	pr_debug("(%d): DEBUG: " fmt, idx, ##__VA_ARGS__)
 #else
-#define DBG(fmt, idx, args...) do {} while (0)
+#define DBG(idx, fmt, ...)					\
+	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 /* Hardware definitions */
@@ -277,8 +280,7 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
 		mmccmd |= SD_CMD_RT_3;
 		break;
 	default:
-		pr_info("au1xmmc: unhandled response type %02x\n",
-			mmc_resp_type(cmd));
+		pr_info("unhandled response type %02x\n", mmc_resp_type(cmd));
 		return -EINVAL;
 	}
 
@@ -478,19 +480,19 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 			break;
 
 		if (status & SD_STATUS_RC) {
-			DBG("RX CRC Error [%d + %d].\n", host->pdev->id,
-					host->pio.len, count);
+			DBG(host->pdev->id, "RX CRC Error [%d + %d]\n",
+			    host->pio.len, count);
 			break;
 		}
 
 		if (status & SD_STATUS_RO) {
-			DBG("RX Overrun [%d + %d]\n", host->pdev->id,
-					host->pio.len, count);
+			DBG(host->pdev->id, "RX Overrun [%d + %d]\n",
+			    host->pio.len, count);
 			break;
 		}
 		else if (status & SD_STATUS_RU) {
-			DBG("RX Underrun [%d + %d]\n", host->pdev->id,
-					host->pio.len,	count);
+			DBG(host->pdev->id, "RX Underrun [%d + %d]\n",
+			    host->pio.len, count);
 			break;
 		}
 
@@ -835,8 +837,7 @@ static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 			au1xmmc_receive_pio(host);
 
 	} else if (status & 0x203F3C70) {
-			DBG("Unhandled status %8.8x\n", host->pdev->id,
-				status);
+			DBG(host->pdev->id, "Unhandled status %8.8x\n", status);
 	}
 
 	au_writel(status, HOST_STATUS(host));
@@ -1050,7 +1051,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	if (has_dbdma()) {
 		ret = au1xmmc_dbdma_init(host);
 		if (ret)
-			pr_info(DRIVER_NAME ": DBDMA init failed; using PIO\n");
+			pr_info("DBDMA init failed; using PIO\n");
 	}
 
 #ifdef CONFIG_LEDS_CLASS
@@ -1075,8 +1076,8 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, host);
 
-	pr_info(DRIVER_NAME ": MMC Controller %d set up at %8.8X"
-		" (mode=%s)\n", pdev->id, host->iobase,
+	pr_info("MMC Controller %d set up at %8.8X (mode=%s)\n",
+		pdev->id, host->iobase,
 		host->flags & HOST_F_DMA ? "dma" : "pio");
 
 	return 0;	/* all ok */
@@ -1206,7 +1207,7 @@ static int __init au1xmmc_init(void)
 		*/
 		memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
 		if (!memid)
-			pr_err("au1xmmc: cannot add memory dbdma\n");
+			pr_err("cannot add memory dbdma\n");
 	}
 	return platform_driver_register(&au1xmmc_driver);
 }
diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 0371bf5..780a1eb 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -162,8 +162,7 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 			host->sg_cpu[i].cfg = dma_cfg;
 			host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
 			host->sg_cpu[i].x_modify = 4;
-			dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, "
-				"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
+			dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
 				i, host->sg_cpu[i].start_addr,
 				host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,
 				host->sg_cpu[i].x_modify);
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 3aaeb08..5d34c01 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -554,8 +554,8 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot)
 			div = (host->bus_hz  / slot->clock) >> 1;
 
 		dev_info(&slot->mmc->class_dev,
-			 "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
-			 " div = %d)\n", slot->id, host->bus_hz, slot->clock,
+			 "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ div = %d)\n",
+			 slot->id, host->bus_hz, slot->clock,
 			 div ? ((host->bus_hz / div) >> 1) : host->bus_hz, div);
 
 		/* disable clock */
@@ -942,8 +942,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 					data->error = -ETIMEDOUT;
 				} else {
 					dev_err(&host->pdev->dev,
-						"data FIFO error "
-						"(status=%08x)\n",
+						"data FIFO error (status=%08x)\n",
 						status);
 					data->error = -EIO;
 				}
@@ -1776,8 +1775,8 @@ static void dw_mci_init_dma(struct dw_mci *host)
 
 	if (host->dma_ops->init) {
 		if (host->dma_ops->init(host)) {
-			dev_err(&host->pdev->dev, "%s: Unable to initialize "
-				"DMA Controller.\n", __func__);
+			dev_err(&host->pdev->dev, "%s: Unable to initialize DMA Controller\n",
+				__func__);
 			goto no_dma;
 		}
 	} else {
@@ -1985,9 +1984,8 @@ static int dw_mci_probe(struct platform_device *pdev)
 		   DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);
 	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE); /* Enable mci interrupt */
 
-	dev_info(&pdev->dev, "DW MMC controller at irq %d, "
-		 "%d bit host data width, "
-		 "%u deep fifo\n",
+	dev_info(&pdev->dev,
+	"DW MMC controller at irq %d, %d bit host data width, %u deep fifo\n",
 		 irq, width, fifo_size);
 	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
 		dev_info(&pdev->dev, "Internal DMAC interrupt fix enabled.\n");
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 92946b8..f77899f 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -860,9 +860,9 @@ mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
 
 		be16_to_cpus(&scratch->crc_val);
 		if (scratch->crc_val != crc) {
-			dev_dbg(&spi->dev, "read - crc error: crc_val=0x%04x, "
-					"computed=0x%04x len=%d\n",
-					scratch->crc_val, crc, t->len);
+			dev_dbg(&spi->dev,
+				"read - crc error: crc_val=0x%04x, computed=0x%04x len=%d\n",
+				scratch->crc_val, crc, t->len);
 			return -EILSEQ;
 		}
 	}
@@ -1253,8 +1253,7 @@ static void mmc_spi_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 				mres = spi_setup(host->spi);
 				if (mres < 0)
 					dev_dbg(&host->spi->dev,
-						"switch back to SPI mode 3"
-						" failed\n");
+						"switch back to SPI mode 3 failed\n");
 			}
 		}
 
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 0ea9935..33b3cd1 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1229,8 +1229,7 @@ static int __devinit mmci_probe(struct amba_device *dev,
 			host->mmc->ocr_avail = (u32) mask;
 			if (plat->ocr_mask)
 				dev_warn(&dev->dev,
-				 "Provided ocr_mask/setpower will not be used "
-				 "(using regulator instead)\n");
+"Provided ocr_mask/setpower will not be used (using regulator instead)\n");
 		}
 	}
 #endif
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 211a495..93012a0 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -84,9 +84,9 @@ static int mvsd_setup_data(struct mvsd_host *host, struct mmc_data *data)
 			hw_state = mvsd_read(MVSD_HW_STATE);
 			count++;
 		} while (!(hw_state & (1 << 13)));
-		dev_dbg(host->dev, "*** wait for FIFO_EMPTY bit "
-				   "(hw=0x%04x, count=%d, jiffies=%ld)\n",
-				   hw_state, count, jiffies - (t - HZ));
+		dev_dbg(host->dev,
+"*** wait for FIFO_EMPTY bit (hw=0x%04x, count=%d, jiffies=%ld)\n",
+			hw_state, count, jiffies - (t - HZ));
 	}
 
 	/* If timeout=0 then maximum timeout index is used. */
@@ -117,10 +117,9 @@ static int mvsd_setup_data(struct mvsd_host *host, struct mmc_data *data)
 		host->pio_size = data->blocks * data->blksz;
 		host->pio_ptr = sg_virt(data->sg);
 		if (!nodma)
-			pr_debug("%s: fallback to PIO for data "
-					  "at 0x%p size %d\n",
-					  mmc_hostname(host->mmc),
-					  host->pio_ptr, host->pio_size);
+			pr_debug("%s: fallback to PIO for data at 0x%p size %d\n",
+				 mmc_hostname(host->mmc),
+				 host->pio_ptr, host->pio_size);
 		return 1;
 	} else {
 		dma_addr_t phys_addr;
@@ -489,9 +488,9 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
 	if (irq_handled)
 		return IRQ_HANDLED;
 
-	pr_err("%s: unhandled interrupt status=0x%04x en=0x%04x "
-			"pio=%d\n", mmc_hostname(host->mmc), intr_status,
-			host->intr_en, host->pio_size);
+	pr_err("%s: unhandled interrupt status=0x%04x en=0x%04x pio=%d\n",
+	       mmc_hostname(host->mmc), intr_status,
+	       host->intr_en, host->pio_size);
 	return IRQ_NONE;
 }
 
@@ -505,13 +504,13 @@ static void mvsd_timeout_timer(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 	mrq = host->mrq;
 	if (mrq) {
-		pr_err("%s: Timeout waiting for hardware interrupt.\n",
-				mmc_hostname(host->mmc));
-		pr_err("%s: hw_state=0x%04x, intr_status=0x%04x "
-				"intr_en=0x%04x\n", mmc_hostname(host->mmc),
-				mvsd_read(MVSD_HW_STATE),
-				mvsd_read(MVSD_NOR_INTR_STATUS),
-				mvsd_read(MVSD_NOR_INTR_EN));
+		pr_err("%s: Timeout waiting for hardware interrupt\n",
+		       mmc_hostname(host->mmc));
+		pr_err("%s: hw_state=0x%04x, intr_status=0x%04x intr_en=0x%04x\n",
+		       mmc_hostname(host->mmc),
+		       mvsd_read(MVSD_HW_STATE),
+		       mvsd_read(MVSD_NOR_INTR_STATUS),
+		       mvsd_read(MVSD_NOR_INTR_EN));
 
 		host->mrq = NULL;
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1455bd6..dd5159b 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1264,9 +1264,8 @@ static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
 	host->reqs_blocked = 0;
 	if (mmc_slot(host).get_cover_state(host->dev, host->slot_id)) {
 		if (host->protect_card) {
-			pr_info("%s: cover is closed, "
-					 "card is now accessible\n",
-					 mmc_hostname(host->mmc));
+			pr_info("%s: cover is closed, card is now accessible\n",
+				mmc_hostname(host->mmc));
 			host->protect_card = 0;
 		}
 	} else {
@@ -1967,8 +1966,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 
 		if (host->got_dbclk)
 			if (clk_enable(host->dbclk) != 0)
-				dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
-							" clk failed\n");
+				dev_dbg(mmc_dev(host->mmc), "Enabling debounce clk failed\n");
 	}
 
 	/* Since we do only SG emulation, we can have as many segs
@@ -2169,8 +2167,7 @@ static int omap_hsmmc_suspend(struct device *dev)
 							host->slot_id);
 			if (ret) {
 				dev_dbg(mmc_dev(host->mmc),
-					"Unable to handle MMC board"
-					" level suspend\n");
+					"Unable to handle MMC board level suspend\n");
 				host->suspended = 0;
 				return ret;
 			}
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 6878a94..67c5751 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -460,8 +460,7 @@ static int jmicron_probe(struct sdhci_pci_chip *chip)
 
 		if (sd_dev) {
 			pci_dev_put(sd_dev);
-			dev_info(&chip->pdev->dev, "Refusing to bind to "
-				"secondary interface.\n");
+			dev_info(&chip->pdev->dev, "Refusing to bind to secondary interface\n");
 			return -ENODEV;
 		}
 	}
@@ -628,10 +627,10 @@ static int syskt_probe_slot(struct sdhci_pci_slot *slot)
 
 	u8 board_rev = readb(slot->host->ioaddr + SYSKT_BOARD_REV);
 	u8  chip_rev = readb(slot->host->ioaddr + SYSKT_CHIP_REV);
-	dev_info(&slot->chip->pdev->dev, "SysKonnect CardBus2SDIO, "
-					 "board rev %d.%d, chip rev %d.%d\n",
-					 board_rev >> 4, board_rev & 0xf,
-					 chip_rev >> 4,  chip_rev & 0xf);
+	dev_info(&slot->chip->pdev->dev,
+		 "SysKonnect CardBus2SDIO, board rev %d.%d, chip rev %d.%d\n",
+		 board_rev >> 4, board_rev & 0xf,
+		 chip_rev >> 4,  chip_rev & 0xf);
 	if (chip_rev >= 0x20)
 		slot->host->quirks |= SDHCI_QUIRK_FORCE_DMA;
 
@@ -925,8 +924,7 @@ static int sdhci_pci_enable_dma(struct sdhci_host *host)
 	if (((pdev->class & 0xFFFF00) == (PCI_CLASS_SYSTEM_SDHCI << 8)) &&
 		((pdev->class & 0x0000FF) != PCI_SDHCI_IFDMA) &&
 		(host->flags & SDHCI_USE_SDMA)) {
-		dev_warn(&pdev->dev, "Will use DMA mode even though HW "
-			"doesn't fully claim to support it.\n");
+		dev_warn(&pdev->dev, "Will use DMA mode even though HW doesn't fully claim to support it\n");
 	}
 
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1202,8 +1200,7 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	}
 
 	if (pci_resource_len(pdev, bar) != 0x100) {
-		dev_err(&pdev->dev, "Invalid iomem size. You may "
-			"experience problems.\n");
+		dev_err(&pdev->dev, "Invalid iomem size. You may experience problems.\n");
 	}
 
 	if ((pdev->class & 0x0000FF) == PCI_SDHCI_IFVENDOR) {
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 15673a7..0d8f061 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -82,11 +82,8 @@ static void pxav3_gen_init_74_clocks(struct sdhci_host *host, u8 power_mode)
 			&& power_mode == MMC_POWER_ON) {
 
 		dev_dbg(mmc_dev(host->mmc),
-				"%s: slot->power_mode = %d,"
-				"ios->power_mode = %d\n",
-				__func__,
-				pxa->power_mode,
-				power_mode);
+				"%s: slot->power_mode = %d, ios->power_mode = %d\n",
+				__func__, pxa->power_mode, power_mode);
 
 		/* set we want notice of when 74 clocks are sent */
 		tmp = readw(host->ioaddr + SD_CE_ATA_2);
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d146bff..d31c31d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -13,6 +13,8 @@
  *     - JMicron (hardware and technical support)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -32,8 +34,8 @@
 
 #define DRIVER_NAME "sdhci"
 
-#define DBG(f, x...) \
-	pr_debug(DRIVER_NAME " [%s()]: " f, __func__,## x)
+#define DBG(fmt, ...)						\
+	pr_debug("[%s()]: " fmt, __func__, ##__VA_ARGS__)
 
 #if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE) && \
 	defined(CONFIG_MMC_SDHCI_MODULE))
@@ -68,51 +70,51 @@ static inline int sdhci_runtime_pm_put(struct sdhci_host *host)
 
 static void sdhci_dumpregs(struct sdhci_host *host)
 {
-	pr_debug(DRIVER_NAME ": =========== REGISTER DUMP (%s)===========\n",
-		mmc_hostname(host->mmc));
-
-	pr_debug(DRIVER_NAME ": Sys addr: 0x%08x | Version:  0x%08x\n",
-		sdhci_readl(host, SDHCI_DMA_ADDRESS),
-		sdhci_readw(host, SDHCI_HOST_VERSION));
-	pr_debug(DRIVER_NAME ": Blk size: 0x%08x | Blk cnt:  0x%08x\n",
-		sdhci_readw(host, SDHCI_BLOCK_SIZE),
-		sdhci_readw(host, SDHCI_BLOCK_COUNT));
-	pr_debug(DRIVER_NAME ": Argument: 0x%08x | Trn mode: 0x%08x\n",
-		sdhci_readl(host, SDHCI_ARGUMENT),
-		sdhci_readw(host, SDHCI_TRANSFER_MODE));
-	pr_debug(DRIVER_NAME ": Present:  0x%08x | Host ctl: 0x%08x\n",
-		sdhci_readl(host, SDHCI_PRESENT_STATE),
-		sdhci_readb(host, SDHCI_HOST_CONTROL));
-	pr_debug(DRIVER_NAME ": Power:    0x%08x | Blk gap:  0x%08x\n",
-		sdhci_readb(host, SDHCI_POWER_CONTROL),
-		sdhci_readb(host, SDHCI_BLOCK_GAP_CONTROL));
-	pr_debug(DRIVER_NAME ": Wake-up:  0x%08x | Clock:    0x%08x\n",
-		sdhci_readb(host, SDHCI_WAKE_UP_CONTROL),
-		sdhci_readw(host, SDHCI_CLOCK_CONTROL));
-	pr_debug(DRIVER_NAME ": Timeout:  0x%08x | Int stat: 0x%08x\n",
-		sdhci_readb(host, SDHCI_TIMEOUT_CONTROL),
-		sdhci_readl(host, SDHCI_INT_STATUS));
-	pr_debug(DRIVER_NAME ": Int enab: 0x%08x | Sig enab: 0x%08x\n",
-		sdhci_readl(host, SDHCI_INT_ENABLE),
-		sdhci_readl(host, SDHCI_SIGNAL_ENABLE));
-	pr_debug(DRIVER_NAME ": AC12 err: 0x%08x | Slot int: 0x%08x\n",
-		sdhci_readw(host, SDHCI_ACMD12_ERR),
-		sdhci_readw(host, SDHCI_SLOT_INT_STATUS));
-	pr_debug(DRIVER_NAME ": Caps:     0x%08x | Caps_1:   0x%08x\n",
-		sdhci_readl(host, SDHCI_CAPABILITIES),
-		sdhci_readl(host, SDHCI_CAPABILITIES_1));
-	pr_debug(DRIVER_NAME ": Cmd:      0x%08x | Max curr: 0x%08x\n",
-		sdhci_readw(host, SDHCI_COMMAND),
-		sdhci_readl(host, SDHCI_MAX_CURRENT));
-	pr_debug(DRIVER_NAME ": Host ctl2: 0x%08x\n",
-		sdhci_readw(host, SDHCI_HOST_CONTROL2));
+	pr_debug("=========== REGISTER DUMP (%s)===========\n",
+		 mmc_hostname(host->mmc));
+
+	pr_debug("Sys addr: 0x%08x | Version:  0x%08x\n",
+		 sdhci_readl(host, SDHCI_DMA_ADDRESS),
+		 sdhci_readw(host, SDHCI_HOST_VERSION));
+	pr_debug("Blk size: 0x%08x | Blk cnt:  0x%08x\n",
+		 sdhci_readw(host, SDHCI_BLOCK_SIZE),
+		 sdhci_readw(host, SDHCI_BLOCK_COUNT));
+	pr_debug("Argument: 0x%08x | Trn mode: 0x%08x\n",
+		 sdhci_readl(host, SDHCI_ARGUMENT),
+		 sdhci_readw(host, SDHCI_TRANSFER_MODE));
+	pr_debug("Present:  0x%08x | Host ctl: 0x%08x\n",
+		 sdhci_readl(host, SDHCI_PRESENT_STATE),
+		 sdhci_readb(host, SDHCI_HOST_CONTROL));
+	pr_debug("Power:    0x%08x | Blk gap:  0x%08x\n",
+		 sdhci_readb(host, SDHCI_POWER_CONTROL),
+		 sdhci_readb(host, SDHCI_BLOCK_GAP_CONTROL));
+	pr_debug("Wake-up:  0x%08x | Clock:    0x%08x\n",
+		 sdhci_readb(host, SDHCI_WAKE_UP_CONTROL),
+		 sdhci_readw(host, SDHCI_CLOCK_CONTROL));
+	pr_debug("Timeout:  0x%08x | Int stat: 0x%08x\n",
+		 sdhci_readb(host, SDHCI_TIMEOUT_CONTROL),
+		 sdhci_readl(host, SDHCI_INT_STATUS));
+	pr_debug("Int enab: 0x%08x | Sig enab: 0x%08x\n",
+		 sdhci_readl(host, SDHCI_INT_ENABLE),
+		 sdhci_readl(host, SDHCI_SIGNAL_ENABLE));
+	pr_debug("AC12 err: 0x%08x | Slot int: 0x%08x\n",
+		 sdhci_readw(host, SDHCI_ACMD12_ERR),
+		 sdhci_readw(host, SDHCI_SLOT_INT_STATUS));
+	pr_debug("Caps:     0x%08x | Caps_1:   0x%08x\n",
+		 sdhci_readl(host, SDHCI_CAPABILITIES),
+		 sdhci_readl(host, SDHCI_CAPABILITIES_1));
+	pr_debug("Cmd:      0x%08x | Max curr: 0x%08x\n",
+		 sdhci_readw(host, SDHCI_COMMAND),
+		 sdhci_readl(host, SDHCI_MAX_CURRENT));
+	pr_debug("Host ctl2: 0x%08x\n",
+		 sdhci_readw(host, SDHCI_HOST_CONTROL2));
 
 	if (host->flags & SDHCI_USE_ADMA)
-		pr_debug(DRIVER_NAME ": ADMA Err: 0x%08x | ADMA Ptr: 0x%08x\n",
-		       readl(host->ioaddr + SDHCI_ADMA_ERROR),
-		       readl(host->ioaddr + SDHCI_ADMA_ADDRESS));
+		pr_debug("ADMA Err: 0x%08x | ADMA Ptr: 0x%08x\n",
+			 readl(host->ioaddr + SDHCI_ADMA_ERROR),
+			 readl(host->ioaddr + SDHCI_ADMA_ADDRESS));
 
-	pr_debug(DRIVER_NAME ": ===========================================\n");
+	pr_debug("===========================================\n");
 }
 
 /*****************************************************************************\
@@ -417,7 +419,7 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 			break;
 	}
 
-	DBG("PIO transfer complete.\n");
+	DBG("PIO transfer complete\n");
 }
 
 static char *sdhci_kmap_atomic(struct scatterlist *sg, unsigned long *flags)
@@ -745,9 +747,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 		if (unlikely(broken)) {
 			for_each_sg(data->sg, sg, data->sg_len, i) {
 				if (sg->length & 0x3) {
-					DBG("Reverting to PIO because of "
-						"transfer size (%d)\n",
-						sg->length);
+					DBG("Reverting to PIO because of transfer size (%d)\n",
+					    sg->length);
 					host->flags &= ~SDHCI_REQ_USE_DMA;
 					break;
 				}
@@ -780,8 +781,7 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 		if (unlikely(broken)) {
 			for_each_sg(data->sg, sg, data->sg_len, i) {
 				if (sg->offset & 0x3) {
-					DBG("Reverting to PIO because of "
-						"bad alignment\n");
+					DBG("Reverting to PIO because of bad alignment\n");
 					host->flags &= ~SDHCI_REQ_USE_DMA;
 					break;
 				}
@@ -972,8 +972,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
 		if (timeout == 0) {
-			pr_err("%s: Controller never released "
-				"inhibit bit(s).\n", mmc_hostname(host->mmc));
+			pr_err("%s: Controller never released inhibit bit(s)\n",
+			       mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			cmd->error = -EIO;
 			tasklet_schedule(&host->finish_tasklet);
@@ -1154,8 +1154,8 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
 		& SDHCI_CLOCK_INT_STABLE)) {
 		if (timeout == 0) {
-			pr_err("%s: Internal clock never "
-				"stabilised.\n", mmc_hostname(host->mmc));
+			pr_err("%s: Internal clock never stabilised\n",
+			       mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			return;
 		}
@@ -1592,8 +1592,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		if (!(ctrl & SDHCI_CTRL_VDD_180))
 			return 0;
 		else {
-			pr_info(DRIVER_NAME ": Switching to 3.3V "
-				"signalling voltage failed\n");
+			pr_info("Switching to 3.3V signalling voltage failed\n");
 			return -EIO;
 		}
 	} else if (!(ctrl & SDHCI_CTRL_VDD_180) &&
@@ -1651,8 +1650,7 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		pwr |= SDHCI_POWER_ON;
 		sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);
 
-		pr_info(DRIVER_NAME ": Switching to 1.8V signalling "
-			"voltage failed, retrying with S18R set to 0\n");
+		pr_info("Switching to 1.8V signalling voltage failed, retrying with S18R set to 0\n");
 		return -EAGAIN;
 	} else
 		/* No signal voltage switch required */
@@ -1774,10 +1772,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc)
 		spin_lock(&host->lock);
 
 		if (!host->tuning_done) {
-			pr_info(DRIVER_NAME ": Timeout waiting for "
-				"Buffer Read Ready interrupt during tuning "
-				"procedure, falling back to fixed sampling "
-				"clock\n");
+			pr_info("Timeout waiting for Buffer Read Ready interrupt during tuning procedure, falling back to fixed sampling clock\n");
 			ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 			ctrl &= ~SDHCI_CTRL_TUNED_CLK;
 			ctrl &= ~SDHCI_CTRL_EXEC_TUNING;
@@ -1804,9 +1799,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc)
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 	} else {
 		if (!(ctrl & SDHCI_CTRL_TUNED_CLK)) {
-			pr_info(DRIVER_NAME ": Tuning procedure"
-				" failed, falling back to fixed sampling"
-				" clock\n");
+			pr_info("Tuning procedure failed, falling back to fixed sampling clock\n");
 			err = -EIO;
 		}
 	}
@@ -2010,8 +2003,8 @@ static void sdhci_timeout_timer(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->mrq) {
-		pr_err("%s: Timeout waiting for hardware "
-			"interrupt.\n", mmc_hostname(host->mmc));
+		pr_err("%s: Timeout waiting for hardware interrupt\n",
+		       mmc_hostname(host->mmc));
 		sdhci_dumpregs(host);
 
 		if (host->data) {
@@ -2056,9 +2049,8 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 	BUG_ON(intmask == 0);
 
 	if (!host->cmd) {
-		pr_err("%s: Got command interrupt 0x%08x even "
-			"though no command operation was in progress.\n",
-			mmc_hostname(host->mmc), (unsigned)intmask);
+		pr_err("%s: Got command interrupt 0x%08x even though no command operation was in progress\n",
+		       mmc_hostname(host->mmc), (unsigned)intmask);
 		sdhci_dumpregs(host);
 		return;
 	}
@@ -2087,8 +2079,7 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 	 */
 	if (host->cmd->flags & MMC_RSP_BUSY) {
 		if (host->cmd->data)
-			DBG("Cannot wait for busy signal when also "
-				"doing a data transfer");
+			DBG("Cannot wait for busy signal when also doing a data transfer\n");
 		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
 			return;
 
@@ -2156,9 +2147,8 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 			}
 		}
 
-		pr_err("%s: Got data interrupt 0x%08x even "
-			"though no data operation was in progress.\n",
-			mmc_hostname(host->mmc), (unsigned)intmask);
+		pr_err("%s: Got data interrupt 0x%08x even though no data operation was in progress\n",
+		       mmc_hostname(host->mmc), (unsigned)intmask);
 		sdhci_dumpregs(host);
 
 		return;
@@ -2204,10 +2194,9 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 				~(SDHCI_DEFAULT_BOUNDARY_SIZE - 1)) +
 				SDHCI_DEFAULT_BOUNDARY_SIZE;
 			host->data->bytes_xfered = dmanow - dmastart;
-			DBG("%s: DMA base 0x%08x, transferred 0x%06x bytes,"
-				" next 0x%08x\n",
-				mmc_hostname(host->mmc), dmastart,
-				host->data->bytes_xfered, dmanow);
+			DBG("%s: DMA base 0x%08x, transferred 0x%06x bytes, next 0x%08x\n",
+			    mmc_hostname(host->mmc), dmastart,
+			    host->data->bytes_xfered, dmanow);
 			sdhci_writel(host, dmanow, SDHCI_DMA_ADDRESS);
 		}
 
@@ -2250,7 +2239,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	}
 
 	DBG("*** %s got interrupt: 0x%08x\n",
-		mmc_hostname(host->mmc), intmask);
+	    mmc_hostname(host->mmc), intmask);
 
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
 		u32 present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
@@ -2548,9 +2537,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	host->version = (host->version & SDHCI_SPEC_VER_MASK)
 				>> SDHCI_SPEC_VER_SHIFT;
 	if (host->version > SDHCI_SPEC_300) {
-		pr_err("%s: Unknown controller version (%d). "
-			"You may experience problems.\n", mmc_hostname(mmc),
-			host->version);
+		pr_err("%s: Unknown controller version (%d). You may experience problems.\n",
+		       mmc_hostname(mmc), host->version);
 	}
 
 	caps[0] = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ? host->caps :
@@ -2631,8 +2619,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->max_clk == 0 || host->quirks &
 			SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN) {
 		if (!host->ops->get_max_clock) {
-			pr_err("%s: Hardware doesn't specify base clock "
-			       "frequency.\n", mmc_hostname(mmc));
+			pr_err("%s: Hardware doesn't specify base clock frequency\n",
+			       mmc_hostname(mmc));
 			return -ENODEV;
 		}
 		host->max_clk = host->ops->get_max_clock(host);
@@ -2677,8 +2665,8 @@ int sdhci_add_host(struct sdhci_host *host)
 			host->timeout_clk = host->ops->get_timeout_clock(host);
 		} else if (!(host->quirks &
 				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)) {
-			pr_err("%s: Hardware doesn't specify timeout clock "
-			       "frequency.\n", mmc_hostname(mmc));
+			pr_err("%s: Hardware doesn't specify timeout clock frequency\n",
+			       mmc_hostname(mmc));
 			return -ENODEV;
 		}
 	}
@@ -2845,8 +2833,8 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
 
 	if (mmc->ocr_avail == 0) {
-		pr_err("%s: Hardware doesn't report any "
-			"support voltages.\n", mmc_hostname(mmc));
+		pr_err("%s: Hardware doesn't report any support voltages\n",
+		       mmc_hostname(mmc));
 		return -ENODEV;
 	}
 
@@ -2994,8 +2982,8 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 		host->flags |= SDHCI_DEVICE_DEAD;
 
 		if (host->mrq) {
-			pr_err("%s: Controller removed during "
-				" transfer!\n", mmc_hostname(host->mmc));
+			pr_err("%s: Controller removed during transfer!\n",
+			       mmc_hostname(host->mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
 			tasklet_schedule(&host->finish_tasklet);
@@ -3053,9 +3041,8 @@ EXPORT_SYMBOL_GPL(sdhci_free_host);
 
 static int __init sdhci_drv_init(void)
 {
-	pr_info(DRIVER_NAME
-		": Secure Digital Host Controller Interface driver\n");
-	pr_info(DRIVER_NAME ": Copyright(c) Pierre Ossman\n");
+	pr_info("Secure Digital Host Controller Interface driver\n");
+	pr_info("Copyright(c) Pierre Ossman\n");
 
 	return 0;
 }
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 7009f17..1e30245 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -310,8 +310,8 @@ static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	/* transfer data */
 	if (data && cmd->error == 0) {
-		dev_dbg(dev, "transfer: blksz %i blocks %i sg_len %i "
-			"sg length %i\n", data->blksz, data->blocks,
+		dev_dbg(dev, "transfer: blksz %i blocks %i sg_len %i sg length %i\n",
+			data->blksz, data->blocks,
 			data->sg_len, data->sg->length);
 
 		/* enter data reading mode */
@@ -330,8 +330,8 @@ static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
 			kunmap(page);
 			flush_dcache_page(page);
 			if (result) {
-				dev_err(dev, "sdricoh_request: cmd %i "
-					"block transfer failed\n", cmd->opcode);
+				dev_err(dev, "sdricoh_request: cmd %i block transfer failed\n",
+					cmd->opcode);
 				cmd->error = result;
 				break;
 			} else
@@ -476,8 +476,8 @@ static int sdricoh_pcmcia_probe(struct pcmcia_device *pcmcia_dev)
 {
 	struct pci_dev *pci_dev = NULL;
 
-	dev_info(&pcmcia_dev->dev, "Searching MMC controller for pcmcia device"
-		" %s %s ...\n", pcmcia_dev->prod_id[0], pcmcia_dev->prod_id[1]);
+	dev_info(&pcmcia_dev->dev, "Searching MMC controller for pcmcia device %s %s ...\n",
+		 pcmcia_dev->prod_id[0], pcmcia_dev->prod_id[1]);
 
 	/* search pci cardbus bridge that contains the mmc controller */
 	/* the io region is already claimed by yenta_socket... */
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 55d6c60..d432597 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -787,9 +787,9 @@ static void tifm_sd_abort(unsigned long data)
 {
 	struct tifm_sd *host = (struct tifm_sd*)data;
 
-	pr_err("%s : card failed to respond for a long period of time "
-	       "(%x, %x)\n",
-	       dev_name(&host->dev->dev), host->req->cmd->opcode, host->cmd_flags);
+	pr_err("%s : card failed to respond for a long period of time (%x, %x)\n",
+	       dev_name(&host->dev->dev),
+	       host->req->cmd->opcode, host->cmd_flags);
 
 	tifm_eject(host->dev);
 }
@@ -803,8 +803,7 @@ static void tifm_sd_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	spin_lock_irqsave(&sock->lock, flags);
 
-	dev_dbg(&sock->dev, "ios: clock = %u, vdd = %x, bus_mode = %x, "
-		"chip_select = %x, power_mode = %x, bus_width = %x\n",
+	dev_dbg(&sock->dev, "ios: clock = %u, vdd = %x, bus_mode = %x, chip_select = %x, power_mode = %x, bus_width = %x\n",
 		ios->clock, ios->vdd, ios->bus_mode, ios->chip_select,
 		ios->power_mode, ios->bus_width);
 
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 4b83c43..dc479b0 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -8,6 +8,8 @@
  * your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
@@ -838,8 +840,7 @@ static void via_sdc_cmd_isr(struct via_crdr_mmc_host *host, u16 intmask)
 	BUG_ON(intmask == 0);
 
 	if (!host->cmd) {
-		pr_err("%s: Got command interrupt 0x%x even "
-		       "though no command operation was in progress.\n",
+		pr_err("%s: Got command interrupt 0x%x even though no command operation was in progress\n",
 		       mmc_hostname(host->mmc), intmask);
 		return;
 	}
@@ -941,8 +942,8 @@ static void via_sdc_timeout(unsigned long ulongdata)
 	spin_lock_irqsave(&sdhost->lock, flags);
 
 	if (sdhost->mrq) {
-		pr_err("%s: Timeout waiting for hardware interrupt."
-		       "cmd:0x%x\n", mmc_hostname(sdhost->mmc),
+		pr_err("%s: Timeout waiting for hardware interrupt.cmd:0x%x\n",
+		       mmc_hostname(sdhost->mmc),
 		       sdhost->mrq->cmd->opcode);
 
 		if (sdhost->data) {
@@ -1091,8 +1092,7 @@ static int __devinit via_sd_probe(struct pci_dev *pcidev,
 	u8  gatt;
 	int ret;
 
-	pr_info(DRV_NAME
-		": VIA SDMMC controller found at %s [%04x:%04x] (rev %x)\n",
+	pr_info("VIA SDMMC controller found at %s [%04x:%04x] (rev %x)\n",
 		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device,
 		(int)pcidev->revision);
 
@@ -1192,8 +1192,8 @@ static void __devexit via_sd_remove(struct pci_dev *pcidev)
 	mmiowb();
 
 	if (sdhost->mrq) {
-		pr_err("%s: Controller removed during "
-			"transfer\n", mmc_hostname(sdhost->mmc));
+		pr_err("%s: Controller removed during transfer\n",
+		       mmc_hostname(sdhost->mmc));
 
 		/* make sure all DMA is stopped */
 		writel(VIA_CRDR_DMACTRL_SFTRST,
@@ -1225,8 +1225,7 @@ static void __devexit via_sd_remove(struct pci_dev *pcidev)
 	pci_release_regions(pcidev);
 	pci_disable_device(pcidev);
 
-	pr_info(DRV_NAME
-		": VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
+	pr_info("VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
 		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device);
 }
 
@@ -1339,8 +1338,7 @@ static struct pci_driver via_sd_driver = {
 
 static int __init via_sd_drv_init(void)
 {
-	pr_info(DRV_NAME ": VIA SD/MMC Card Reader driver "
-		"(C) 2008 VIA Technologies, Inc.\n");
+	pr_info("VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.\n");
 
 	return pci_register_driver(&via_sd_driver);
 }
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index e8f6e65..1908a25 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -35,6 +35,9 @@
  *             bits and driver data fields reflect that limit by using
  *             u8, u16, u32
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -1257,9 +1260,8 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 			}
 		} else {
 			dev_err(&vub300->udev->dev,
-				"not enough memory for xfer buffer to send"
-				" INTERRUPT_PSEUDOCODE for %s %s\n", fw->data,
-				vub300->vub_name);
+				"not enough memory for xfer buffer to send INTERRUPT_PSEUDOCODE for %s %s\n",
+				fw->data, vub300->vub_name);
 			strncpy(vub300->vub_name,
 				"SDIO interrupt pseudocode download failed",
 				sizeof(vub300->vub_name));
@@ -1304,9 +1306,8 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 			}
 		} else {
 			dev_err(&vub300->udev->dev,
-				"not enough memory for xfer buffer to send"
-				" TRANSFER_PSEUDOCODE for %s %s\n", fw->data,
-				vub300->vub_name);
+				"not enough memory for xfer buffer to send TRANSFER_PSEUDOCODE for %s %s\n",
+				fw->data, vub300->vub_name);
 			strncpy(vub300->vub_name,
 				"SDIO transfer pseudocode download failed",
 				sizeof(vub300->vub_name));
@@ -2002,11 +2003,11 @@ static void __set_clock_speed(struct vub300_mmc_host *vub300, u8 buf[8],
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x00, 0x00, buf, buf_array_size, HZ);
 	if (retval != 8) {
-		dev_err(&vub300->udev->dev, "SET_CLOCK_SPEED"
-			" %dkHz failed with retval=%d\n", kHzClock, retval);
+		dev_err(&vub300->udev->dev, "SET_CLOCK_SPEED %dkHz failed with retval=%d\n",
+			kHzClock, retval);
 	} else {
-		dev_dbg(&vub300->udev->dev, "SET_CLOCK_SPEED"
-			" %dkHz\n", kHzClock);
+		dev_dbg(&vub300->udev->dev, "SET_CLOCK_SPEED %dkHz\n",
+			kHzClock);
 	}
 }
 
@@ -2251,8 +2252,7 @@ static int vub300_probe(struct usb_interface *interface,
 					endpoint->bEndpointAddress;
 			} else {
 				dev_warn(&vub300->udev->dev,
-					 "ignoring"
-					 " unexpected bulk_in endpoint");
+					 "ignoring unexpected bulk_in endpoint\n");
 			}
 		} else if (usb_endpoint_is_bulk_out(endpoint)) {
 			if (!vub300->cmnd_out_ep) {
@@ -2263,20 +2263,18 @@ static int vub300_probe(struct usb_interface *interface,
 					endpoint->bEndpointAddress;
 			} else {
 				dev_warn(&vub300->udev->dev,
-					 "ignoring"
-					 " unexpected bulk_out endpoint");
+					 "ignoring unexpected bulk_out endpoint\n");
 			}
 		} else {
 			dev_warn(&vub300->udev->dev,
-				 "vub300 ignoring EndPoint(%d) %02X", i,
-				 endpoint->bEndpointAddress);
+				 "vub300 ignoring EndPoint(%d) %02X\n",
+				 i, endpoint->bEndpointAddress);
 		}
 	}
 	if (vub300->cmnd_res_ep && vub300->cmnd_out_ep &&
 	    vub300->data_inp_ep && vub300->data_out_ep) {
 		dev_info(&vub300->udev->dev,
-			 "vub300 %s packets"
-			 " using EndPoints %02X %02X %02X %02X\n",
+			 "vub300 %s packets using EndPoints %02X %02X %02X %02X\n",
 			 vub300->large_usb_packets ? "LARGE" : "SMALL",
 			 vub300->cmnd_out_ep, vub300->cmnd_res_ep,
 			 vub300->data_out_ep, vub300->data_inp_ep);
@@ -2341,13 +2339,11 @@ static int vub300_probe(struct usb_interface *interface,
 	add_timer(&vub300->inactivity_timer);
 	if (vub300->card_present)
 		dev_info(&vub300->udev->dev,
-			 "USB vub300 remote SDIO host controller[%d]"
-			 "connected with SD/SDIO card inserted\n",
+			 "USB vub300 remote SDIO host controller[%d]connected with SD/SDIO card inserted\n",
 			 interface_to_InterfaceNumber(interface));
 	else
 		dev_info(&vub300->udev->dev,
-			 "USB vub300 remote SDIO host controller[%d]"
-			 "connected with no SD/SDIO card inserted\n",
+			 "USB vub300 remote SDIO host controller[%d]connected with no SD/SDIO card inserted\n",
 			 interface_to_InterfaceNumber(interface));
 	mmc_add_host(mmc);
 	return 0;
@@ -2381,8 +2377,8 @@ static void vub300_disconnect(struct usb_interface *interface)
 			vub300->interface = NULL;
 			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
-			pr_info("USB vub300 remote SDIO host controller[%d]"
-				" now disconnected", ifnum);
+			pr_info("USB remote SDIO host controller[%d] now disconnected\n",
+				ifnum);
 			return;
 		}
 	}
@@ -2448,29 +2444,29 @@ static int __init vub300_init(void)
 {				/* NOT irq */
 	int result;
 
-	pr_info("VUB300 Driver rom wait states = %02X irqpoll timeout = %04X",
+	pr_info("Driver rom wait states = %02X irqpoll timeout = %04X\n",
 		firmware_rom_wait_states, 0x0FFFF & firmware_irqpoll_timeout);
 	cmndworkqueue = create_singlethread_workqueue("kvub300c");
 	if (!cmndworkqueue) {
-		pr_err("not enough memory for the REQUEST workqueue");
+		pr_err("not enough memory for the REQUEST workqueue\n");
 		result = -ENOMEM;
 		goto out1;
 	}
 	pollworkqueue = create_singlethread_workqueue("kvub300p");
 	if (!pollworkqueue) {
-		pr_err("not enough memory for the IRQPOLL workqueue");
+		pr_err("not enough memory for the IRQPOLL workqueue\n");
 		result = -ENOMEM;
 		goto out2;
 	}
 	deadworkqueue = create_singlethread_workqueue("kvub300d");
 	if (!deadworkqueue) {
-		pr_err("not enough memory for the EXPIRED workqueue");
+		pr_err("not enough memory for the EXPIRED workqueue\n");
 		result = -ENOMEM;
 		goto out3;
 	}
 	result = usb_register(&vub300_driver);
 	if (result) {
-		pr_err("usb_register failed. Error number %d", result);
+		pr_err("usb_register failed. Error number %d\n", result);
 		goto out4;
 	}
 	return 0;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index deaed8c..7536b50 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -721,9 +721,8 @@ static void wbsd_finish_data(struct wbsd_host *host, struct mmc_data *data)
 		 * Any leftover data?
 		 */
 		if (count) {
-			pr_err("%s: Incomplete DMA transfer. "
-				"%d bytes left.\n",
-				mmc_hostname(host->mmc), count);
+			pr_err("%s: Incomplete DMA transfer. %d bytes left.\n",
+			       mmc_hostname(host->mmc), count);
 
 			if (!data->error)
 				data->error = -EIO;
-- 
1.7.6.405.gc1be0

