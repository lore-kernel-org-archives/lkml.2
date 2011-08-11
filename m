Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1HKUVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:21:49 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:50919 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751351Ab1HKUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:21:46 -0400
From: Joe Perches <joe@perches.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Manuel Lauss <manuel.lauss@gmail.com>, Pavel Pisa <ppisa@pikron.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        Ben Dooks <ben-linux@fluff.org>, Chris Ball <cjb@laptop.org>,
        Alex Dubov <oakad@yahoo.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Pierre Ossman <pierre@ossman.eu>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] mmc: Use pr_<level>, add and use mmc_<level>
Date: Thu, 11 Aug 2011 13:21:24 -0700
Message-Id: <1441985db03ab10b067332f7d4b75b607921441b.1313094012.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use current logging styles.

Add an mmc_printk function to reduce overall size
by centralizing the mmc_hostname use.

Because pr_fmt(fmt) KBUILD_MODNAME is used,
some logging prefixes are changed.
For instance from "SDIO:" to "mmc_core:"

Add macros for mmc_err, mmc_warn, and mmc_info.
Convert printks with mmc_hostname to mmc_<level>.

Whitespace neatening around pr_<level>.
Convert printk(KERN_DEBUG to pr_debug(
Convert direct uses of DBG macros to pr_debug.
Convert direct uses of DBGF to DBG.
Coalesce long format strings.
Add a few missing newlines to logging messages.

$ size drivers/mmc/built-in.o*
   text	   data	    bss	    dec	    hex	filename
  92530	   1608	    204	  94342	  17086	drivers/mmc/built-in.o.minimal.new
  94229	   1608	    204	  96041	  17729	drivers/mmc/built-in.o.minimal.old
 291831	   5152	  77344	 374327	  5b637	drivers/mmc/built-in.o.allyesconfig.new
 293616	   5152	  78128	 376896	  5c040	drivers/mmc/built-in.o.allyesconfig.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/card/block.c        |   31 +++---
 drivers/mmc/card/mmc_test.c     |   86 +++++++---------
 drivers/mmc/card/queue.c        |    9 +-
 drivers/mmc/card/sdio_uart.c    |   25 +++--
 drivers/mmc/core/bus.c          |   26 ++---
 drivers/mmc/core/core.c         |   99 ++++++++++--------
 drivers/mmc/core/host.c         |    8 +-
 drivers/mmc/core/mmc.c          |   57 ++++-------
 drivers/mmc/core/mmc_ops.c      |    7 +-
 drivers/mmc/core/sd.c           |   71 ++++---------
 drivers/mmc/core/sdio.c         |   11 +--
 drivers/mmc/core/sdio_bus.c     |    6 +-
 drivers/mmc/core/sdio_cis.c     |   10 +-
 drivers/mmc/core/sdio_io.c      |   14 ++-
 drivers/mmc/core/sdio_irq.c     |   26 +++---
 drivers/mmc/host/at91_mci.c     |   48 +++++----
 drivers/mmc/host/au1xmmc.c      |   34 +++---
 drivers/mmc/host/dw_mmc.c       |    2 +-
 drivers/mmc/host/imxmmc.c       |    4 +-
 drivers/mmc/host/mmci.c         |    8 +-
 drivers/mmc/host/msm_sdcc.c     |  103 +++++++++----------
 drivers/mmc/host/mvsdio.c       |   40 ++++----
 drivers/mmc/host/mxcmmc.c       |    4 +-
 drivers/mmc/host/omap.c         |   15 ++--
 drivers/mmc/host/omap_hsmmc.c   |   17 ++--
 drivers/mmc/host/pxamci.c       |   12 ++-
 drivers/mmc/host/s3cmci.c       |    9 +-
 drivers/mmc/host/sdhci.c        |  215 ++++++++++++++++----------------------
 drivers/mmc/host/tifm_sd.c      |   28 ++----
 drivers/mmc/host/tmio_mmc.c     |    4 +-
 drivers/mmc/host/tmio_mmc_pio.c |   77 +++++++-------
 drivers/mmc/host/via-sdmmc.c    |   32 +++----
 drivers/mmc/host/vub300.c       |   17 ++--
 drivers/mmc/host/wbsd.c         |   85 +++++++---------
 include/linux/mmc/host.h        |   14 +++
 35 files changed, 584 insertions(+), 670 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1ff5486..e9e3eac 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -17,6 +17,9 @@
  * Author:  Andrew Christian
  *          28 May 2002
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/moduleparam.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -566,13 +569,13 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
 	case -EILSEQ:
 		/* response crc error, retry the r/w cmd */
 		pr_err("%s: %s sending %s command, card status %#x\n",
-			req->rq_disk->disk_name, "response CRC error",
-			name, status);
+		       req->rq_disk->disk_name, "response CRC error",
+		       name, status);
 		return ERR_RETRY;
 
 	case -ETIMEDOUT:
 		pr_err("%s: %s sending %s command, card status %#x\n",
-			req->rq_disk->disk_name, "timed out", name, status);
+		       req->rq_disk->disk_name, "timed out", name, status);
 
 		/* If the status cmd initially failed, retry the r/w cmd */
 		if (!status_valid)
@@ -873,7 +876,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 		do {
 			int err = get_card_status(card, &status, 5);
 			if (err) {
-				printk(KERN_ERR "%s: error %d requesting status\n",
+				pr_err("%s: error %d requesting status\n",
 				       req->rq_disk->disk_name, err);
 				return MMC_BLK_CMD_ERR;
 			}
@@ -896,8 +899,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
 		if (rq_data_dir(req) == READ) {
 			if (brq->data.blocks > 1) {
 				/* Redo read one sector at a time */
-				pr_warning("%s: retrying using single block read\n",
-					   req->rq_disk->disk_name);
+				pr_warn("%s: retrying using single block read\n",
+					req->rq_disk->disk_name);
 				return MMC_BLK_RETRY_SINGLE;
 			}
 			return MMC_BLK_DATA_ERR;
@@ -1092,7 +1095,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				 * erros returned by host.
 				 * If this happen it's a bug.
 				 */
-				printk(KERN_ERR "%s BUG rq_tot %d d_xfer %d\n",
+				pr_err("%s BUG rq_tot %d d_xfer %d\n",
 				       __func__, blk_rq_bytes(req),
 				       brq->data.bytes_xfered);
 				rqc = NULL;
@@ -1371,9 +1374,9 @@ static int mmc_blk_alloc_part(struct mmc_card *card,
 
 	string_get_size((u64)get_capacity(part_md->disk) << 9, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
-	printk(KERN_INFO "%s: %s %s partition %u %s\n",
-	       part_md->disk->disk_name, mmc_card_id(card),
-	       mmc_card_name(card), part_md->part_type, cap_str);
+	pr_info("%s: %s %s partition %u %s\n",
+		part_md->disk->disk_name, mmc_card_id(card),
+		mmc_card_name(card), part_md->part_type, cap_str);
 	return 0;
 }
 
@@ -1412,8 +1415,8 @@ mmc_blk_set_blksize(struct mmc_blk_data *md, struct mmc_card *card)
 	mmc_release_host(card->host);
 
 	if (err) {
-		printk(KERN_ERR "%s: unable to set block size to 512: %d\n",
-			md->disk->disk_name, err);
+		pr_err("%s: unable to set block size to 512: %d\n",
+		       md->disk->disk_name, err);
 		return -EINVAL;
 	}
 
@@ -1514,7 +1517,7 @@ static int mmc_blk_probe(struct mmc_card *card)
 
 	string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
-	printk(KERN_INFO "%s: %s %s %s %s\n",
+	pr_info("%s: %s %s %s %s\n",
 		md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
 		cap_str, md->read_only ? "(ro)" : "");
 
@@ -1606,7 +1609,7 @@ static int __init mmc_blk_init(void)
 	int res;
 
 	if (perdev_minors != CONFIG_MMC_BLOCK_MINORS)
-		pr_info("mmcblk: using %d minors per device\n", perdev_minors);
+		pr_info("using %d minors per device\n", perdev_minors);
 
 	max_devices = 256 / perdev_minors;
 
diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 006a5e9..3d67b5b 100644
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
@@ -250,9 +252,8 @@ static int mmc_test_wait_busy(struct mmc_test_card *test)
 		if (!busy && mmc_test_busy(&cmd)) {
 			busy = 1;
 			if (test->card->host->caps & MMC_CAP_WAIT_WHILE_BUSY)
-				printk(KERN_INFO "%s: Warning: Host did not "
-					"wait for busy state to end.\n",
-					mmc_hostname(test->card->host));
+				mmc_info(test->card->host,
+					 "Warning: Host did not wait for busy state to end\n");
 		}
 	} while (mmc_test_busy(&cmd));
 
@@ -552,12 +553,12 @@ static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
 	rate = mmc_test_rate(bytes, &ts);
 	iops = mmc_test_rate(100, &ts); /* I/O ops per sec x 100 */
 
-	printk(KERN_INFO "%s: Transfer of %u sectors (%u%s KiB) took %lu.%09lu "
-			 "seconds (%u kB/s, %u KiB/s, %u.%02u IOPS)\n",
-			 mmc_hostname(test->card->host), sectors, sectors >> 1,
-			 (sectors & 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
-			 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024,
-			 iops / 100, iops % 100);
+	mmc_info(test->card->host,
+		 "Transfer of %u sectors (%u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS)\n",
+		 sectors, sectors >> 1,
+		 (sectors & 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
+		 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024,
+		 iops / 100, iops % 100);
 
 	mmc_test_save_transfer_result(test, 1, sectors, ts, rate, iops);
 }
@@ -578,14 +579,13 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
 	rate = mmc_test_rate(tot, &ts);
 	iops = mmc_test_rate(count * 100, &ts); /* I/O ops per sec x 100 */
 
-	printk(KERN_INFO "%s: Transfer of %u x %u sectors (%u x %u%s KiB) took "
-			 "%lu.%09lu seconds (%u kB/s, %u KiB/s, "
-			 "%u.%02u IOPS, sg_len %d)\n",
-			 mmc_hostname(test->card->host), count, sectors, count,
-			 sectors >> 1, (sectors & 1 ? ".5" : ""),
-			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
-			 rate / 1000, rate / 1024, iops / 100, iops % 100,
-			 test->area.sg_len);
+	mmc_info(test->card->host,
+		 "Transfer of %u x %u sectors (%u x %u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS, sg_len %d)\n",
+		 count, sectors, count,
+		 sectors >> 1, (sectors & 1 ? ".5" : ""),
+		 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
+		 rate / 1000, rate / 1024, iops / 100, iops % 100,
+		 test->area.sg_len);
 
 	mmc_test_save_transfer_result(test, count, sectors, ts, rate, iops);
 }
@@ -1408,8 +1408,7 @@ static int mmc_test_multi_read_high(struct mmc_test_card *test)
 
 static int mmc_test_no_highmem(struct mmc_test_card *test)
 {
-	printk(KERN_INFO "%s: Highmem not configured - test skipped\n",
-	       mmc_hostname(test->card->host));
+	mmc_info(test->card->host, "Highmem not configured - test skipped\n");
 	return 0;
 }
 
@@ -1435,8 +1434,7 @@ static int mmc_test_area_map(struct mmc_test_card *test, unsigned long sz,
 				      t->max_seg_sz, &t->sg_len, min_sg_len);
 	}
 	if (err)
-		printk(KERN_INFO "%s: Failed to map sg list\n",
-		       mmc_hostname(test->card->host));
+		mmc_info(test->card->host, "Failed to map sg list\n");
 	return err;
 }
 
@@ -2135,7 +2133,7 @@ static int mmc_test_rw_multiple(struct mmc_test_card *test,
 
 	return ret;
  err:
-	printk(KERN_INFO "[%s] error\n", __func__);
+	pr_info("[%s] error\n", __func__);
 	return ret;
 }
 
@@ -2149,7 +2147,7 @@ static int mmc_test_rw_multiple_size(struct mmc_test_card *test,
 
 	if (rw->do_nonblock_req &&
 	    ((!pre_req && post_req) || (pre_req && !post_req))) {
-		printk(KERN_INFO "error: only one of pre/post is defined\n");
+		pr_info("error: only one of pre/post is defined\n");
 		return -EINVAL;
 	}
 
@@ -2660,8 +2658,8 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 {
 	int i, ret;
 
-	printk(KERN_INFO "%s: Starting tests of card %s...\n",
-		mmc_hostname(test->card->host), mmc_card_id(test->card));
+	mmc_info(test->card->host, "Starting tests of card %s...\n",
+		 mmc_card_id(test->card));
 
 	mmc_claim_host(test->card->host);
 
@@ -2671,17 +2669,15 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 		if (testcase && ((i + 1) != testcase))
 			continue;
 
-		printk(KERN_INFO "%s: Test case %d. %s...\n",
-			mmc_hostname(test->card->host), i + 1,
-			mmc_test_cases[i].name);
+		mmc_info(test->card->host, "Test case %d. %s...\n",
+			 i + 1, mmc_test_cases[i].name);
 
 		if (mmc_test_cases[i].prepare) {
 			ret = mmc_test_cases[i].prepare(test);
 			if (ret) {
-				printk(KERN_INFO "%s: Result: Prepare "
-					"stage failed! (%d)\n",
-					mmc_hostname(test->card->host),
-					ret);
+				mmc_info(test->card->host,
+					 "Result: Prepare stage failed! (%d)\n",
+					 ret);
 				continue;
 			}
 		}
@@ -2708,26 +2704,19 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 		ret = mmc_test_cases[i].run(test);
 		switch (ret) {
 		case RESULT_OK:
-			printk(KERN_INFO "%s: Result: OK\n",
-				mmc_hostname(test->card->host));
+			mmc_info(test->card->host, "Result: OK\n");
 			break;
 		case RESULT_FAIL:
-			printk(KERN_INFO "%s: Result: FAILED\n",
-				mmc_hostname(test->card->host));
+			mmc_info(test->card->host, "Result: FAILED\n");
 			break;
 		case RESULT_UNSUP_HOST:
-			printk(KERN_INFO "%s: Result: UNSUPPORTED "
-				"(by host)\n",
-				mmc_hostname(test->card->host));
+			mmc_info(test->card->host, "Result: UNSUPPORTED (by host)\n");
 			break;
 		case RESULT_UNSUP_CARD:
-			printk(KERN_INFO "%s: Result: UNSUPPORTED "
-				"(by card)\n",
-				mmc_hostname(test->card->host));
+			mmc_info(test->card->host, "Result: UNSUPPORTED (by card)\n");
 			break;
 		default:
-			printk(KERN_INFO "%s: Result: ERROR (%d)\n",
-				mmc_hostname(test->card->host), ret);
+			mmc_info(test->card->host, "Result: ERROR (%d)\n", ret);
 		}
 
 		/* Save the result */
@@ -2737,18 +2726,15 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
 		if (mmc_test_cases[i].cleanup) {
 			ret = mmc_test_cases[i].cleanup(test);
 			if (ret) {
-				printk(KERN_INFO "%s: Warning: Cleanup "
-					"stage failed! (%d)\n",
-					mmc_hostname(test->card->host),
-					ret);
+				mmc_info(test->card->host, "Warning: Cleanup stage failed! (%d)\n",
+					 ret);
 			}
 		}
 	}
 
 	mmc_release_host(test->card->host);
 
-	printk(KERN_INFO "%s: Tests completed.\n",
-		mmc_hostname(test->card->host));
+	mmc_info(test->card->host, "Tests completed\n");
 }
 
 static void mmc_test_free_result(struct mmc_card *card)
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 45fb362..ede697c 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -9,6 +9,9 @@
  * published by the Free Software Foundation.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
@@ -197,14 +200,12 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 		if (bouncesz > 512) {
 			mqrq_cur->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
 			if (!mqrq_cur->bounce_buf) {
-				printk(KERN_WARNING "%s: unable to "
-					"allocate bounce cur buffer\n",
+				pr_warn("%s: unable to allocate bounce cur buffer\n",
 					mmc_card_name(card));
 			}
 			mqrq_prev->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
 			if (!mqrq_prev->bounce_buf) {
-				printk(KERN_WARNING "%s: unable to "
-					"allocate bounce prev buffer\n",
+				pr_warn("%s: unable to allocate bounce prev buffer\n",
 					mmc_card_name(card));
 				kfree(mqrq_cur->bounce_buf);
 				mqrq_cur->bounce_buf = NULL;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index c8c9edb..071f1f3 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -26,6 +26,8 @@
  * concurrent access to the same port.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -1082,8 +1084,8 @@ static int sdio_uart_probe(struct sdio_func *func,
 		return -ENOMEM;
 
 	if (func->class == SDIO_CLASS_UART) {
-		printk(KERN_WARNING "%s: need info on UART class basic setup\n",
-		       sdio_func_id(func));
+		pr_warn("%s: need info on UART class basic setup\n",
+			sdio_func_id(func));
 		kfree(port);
 		return -ENOSYS;
 	} else if (func->class == SDIO_CLASS_GPS) {
@@ -1101,25 +1103,24 @@ static int sdio_uart_probe(struct sdio_func *func,
 				break;
 		}
 		if (!tpl) {
-			printk(KERN_WARNING
-       "%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
-			       sdio_func_id(func));
+			pr_warn("%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
+				sdio_func_id(func));
 			kfree(port);
 			return -EINVAL;
 		}
-		printk(KERN_DEBUG "%s: Register ID = 0x%02x, Exp ID = 0x%02x\n",
-		       sdio_func_id(func), tpl->data[2], tpl->data[3]);
+		pr_debug("%s: Register ID = 0x%02x, Exp ID = 0x%02x\n",
+			 sdio_func_id(func), tpl->data[2], tpl->data[3]);
 		port->regs_offset = (tpl->data[4] << 0) |
 				    (tpl->data[5] << 8) |
 				    (tpl->data[6] << 16);
-		printk(KERN_DEBUG "%s: regs offset = 0x%x\n",
-		       sdio_func_id(func), port->regs_offset);
+		pr_debug("%s: regs offset = 0x%x\n",
+			 sdio_func_id(func), port->regs_offset);
 		port->uartclk = tpl->data[7] * 115200;
 		if (port->uartclk == 0)
 			port->uartclk = 115200;
-		printk(KERN_DEBUG "%s: clk %d baudcode %u 4800-div %u\n",
-		       sdio_func_id(func), port->uartclk,
-		       tpl->data[7], tpl->data[8] | (tpl->data[9] << 8));
+		pr_debug("%s: clk %d baudcode %u 4800-div %u\n",
+			 sdio_func_id(func), port->uartclk,
+			 tpl->data[7], tpl->data[8] | (tpl->data[9] << 8));
 	} else {
 		kfree(port);
 		return -EINVAL;
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 393d817..80cf61d 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -295,18 +295,16 @@ int mmc_add_card(struct mmc_card *card)
 	}
 
 	if (mmc_host_is_spi(card->host)) {
-		printk(KERN_INFO "%s: new %s%s%s card on SPI\n",
-			mmc_hostname(card->host),
-			mmc_card_highspeed(card) ? "high speed " : "",
-			mmc_card_ddr_mode(card) ? "DDR " : "",
-			type);
+		mmc_info(card->host, "new %s%s%s card on SPI\n",
+			 mmc_card_highspeed(card) ? "high speed " : "",
+			 mmc_card_ddr_mode(card) ? "DDR " : "",
+			 type);
 	} else {
-		printk(KERN_INFO "%s: new %s%s%s card at address %04x\n",
-			mmc_hostname(card->host),
-			mmc_sd_card_uhs(card) ? "ultra high speed " :
-			(mmc_card_highspeed(card) ? "high speed " : ""),
-			mmc_card_ddr_mode(card) ? "DDR " : "",
-			type, card->rca);
+		mmc_info(card->host, "new %s%s%s card at address %04x\n",
+			 mmc_sd_card_uhs(card) ? "ultra high speed " :
+			 mmc_card_highspeed(card) ? "high speed " : "",
+			 mmc_card_ddr_mode(card) ? "DDR " : "",
+			 type, card->rca);
 	}
 
 #ifdef CONFIG_DEBUG_FS
@@ -334,11 +332,9 @@ void mmc_remove_card(struct mmc_card *card)
 
 	if (mmc_card_present(card)) {
 		if (mmc_host_is_spi(card->host)) {
-			printk(KERN_INFO "%s: SPI card removed\n",
-				mmc_hostname(card->host));
+			mmc_info(card->host, "SPI card removed\n");
 		} else {
-			printk(KERN_INFO "%s: card %04x removed\n",
-				mmc_hostname(card->host), card->rca);
+			mmc_info(card->host, "card %04x removed\n", card->rca);
 		}
 		device_del(&card->dev);
 	}
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 89bdeae..b03d1d5 100644
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
@@ -102,8 +105,8 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 	}
 
 	if (err && cmd->retries) {
-		pr_debug("%s: req failed (CMD%u): %d, retrying...\n",
-			mmc_hostname(host), cmd->opcode, err);
+		mmc_dbg(host, "req failed (CMD%u): %d, retrying...\n",
+			cmd->opcode, err);
 
 		cmd->retries--;
 		cmd->error = 0;
@@ -111,20 +114,19 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 	} else {
 		led_trigger_event(host->led, LED_OFF);
 
-		pr_debug("%s: req done (CMD%u): %d: %08x %08x %08x %08x\n",
-			mmc_hostname(host), cmd->opcode, err,
+		mmc_dbg(host, "req done (CMD%u): %d: %08x %08x %08x %08x\n",
+			cmd->opcode, err,
 			cmd->resp[0], cmd->resp[1],
 			cmd->resp[2], cmd->resp[3]);
 
 		if (mrq->data) {
-			pr_debug("%s:     %d bytes transferred: %d\n",
-				mmc_hostname(host),
+			mmc_dbg(host, "    %d bytes transferred: %d\n",
 				mrq->data->bytes_xfered, mrq->data->error);
 		}
 
 		if (mrq->stop) {
-			pr_debug("%s:     (CMD%u): %d: %08x %08x %08x %08x\n",
-				mmc_hostname(host), mrq->stop->opcode,
+			mmc_dbg(host, "    (CMD%u): %d: %08x %08x %08x %08x\n",
+				mrq->stop->opcode,
 				mrq->stop->error,
 				mrq->stop->resp[0], mrq->stop->resp[1],
 				mrq->stop->resp[2], mrq->stop->resp[3]);
@@ -147,23 +149,20 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 	struct scatterlist *sg;
 #endif
 
-	pr_debug("%s: starting CMD%u arg %08x flags %08x\n",
-		 mmc_hostname(host), mrq->cmd->opcode,
-		 mrq->cmd->arg, mrq->cmd->flags);
+	mmc_dbg(host, "starting CMD%u arg %08x flags %08x\n",
+		mrq->cmd->opcode, mrq->cmd->arg, mrq->cmd->flags);
 
 	if (mrq->data) {
-		pr_debug("%s:     blksz %d blocks %d flags %08x "
-			"tsac %d ms nsac %d\n",
-			mmc_hostname(host), mrq->data->blksz,
+		mmc_dbg(host, "    blksz %d blocks %d flags %08x tsac %d ms nsac %d\n",
+			mrq->data->blksz,
 			mrq->data->blocks, mrq->data->flags,
 			mrq->data->timeout_ns / 1000000,
 			mrq->data->timeout_clks);
 	}
 
 	if (mrq->stop) {
-		pr_debug("%s:     CMD%u arg %08x flags %08x\n",
-			 mmc_hostname(host), mrq->stop->opcode,
-			 mrq->stop->arg, mrq->stop->flags);
+		mmc_dbg(host, "    CMD%u arg %08x flags %08x\n",
+			mrq->stop->opcode, mrq->stop->arg, mrq->stop->flags);
 	}
 
 	WARN_ON(!host->claimed);
@@ -488,8 +487,7 @@ int mmc_host_enable(struct mmc_host *host)
 		host->en_dis_recurs = 0;
 
 		if (err) {
-			pr_debug("%s: enable error %d\n",
-				 mmc_hostname(host), err);
+			mmc_dbg(host, "enable error %d\n", err);
 			return err;
 		}
 	}
@@ -508,8 +506,7 @@ static int mmc_host_do_disable(struct mmc_host *host, int lazy)
 		host->en_dis_recurs = 0;
 
 		if (err < 0) {
-			pr_debug("%s: disable error %d\n",
-				 mmc_hostname(host), err);
+			mmc_dbg(host, "disable error %d\n", err);
 			return err;
 		}
 		if (err > 0) {
@@ -712,11 +709,10 @@ static inline void mmc_set_ios(struct mmc_host *host)
 {
 	struct mmc_ios *ios = &host->ios;
 
-	pr_debug("%s: clock %uHz busmode %u powermode %u cs %u Vdd %u "
-		"width %u timing %u\n",
-		 mmc_hostname(host), ios->clock, ios->bus_mode,
-		 ios->power_mode, ios->chip_select, ios->vdd,
-		 ios->bus_width, ios->timing);
+	mmc_dbg(host, "clock %uHz busmode %u powermode %u cs %u Vdd %u width %u timing %u\n",
+		ios->clock, ios->bus_mode,
+		ios->power_mode, ios->chip_select, ios->vdd,
+		ios->bus_width, ios->timing);
 
 	if (ios->clock > 0)
 		mmc_set_ungated(host);
@@ -1018,8 +1014,7 @@ u32 mmc_select_voltage(struct mmc_host *host, u32 ocr)
 		host->ios.vdd = bit;
 		mmc_set_ios(host);
 	} else {
-		pr_warning("%s: host doesn't support card's voltages\n",
-				mmc_hostname(host));
+		mmc_warn(host, "host doesn't support card's voltages\n");
 		ocr = 0;
 	}
 
@@ -1451,8 +1446,8 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
 	if (err) {
-		printk(KERN_ERR "mmc_erase: group start error %d, "
-		       "status %#x\n", err, cmd.resp[0]);
+		pr_err("mmc_erase: group start error %d, status %#x\n",
+		       err, cmd.resp[0]);
 		err = -EINVAL;
 		goto out;
 	}
@@ -1466,7 +1461,7 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
 	if (err) {
-		printk(KERN_ERR "mmc_erase: group end error %d, status %#x\n",
+		pr_err("mmc_erase: group end error %d, status %#x\n",
 		       err, cmd.resp[0]);
 		err = -EINVAL;
 		goto out;
@@ -1479,7 +1474,7 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	cmd.cmd_timeout_ms = mmc_erase_timeout(card, arg, qty);
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
 	if (err) {
-		printk(KERN_ERR "mmc_erase: erase error %d, status %#x\n",
+		pr_err("mmc_erase: erase error %d, status %#x\n",
 		       err, cmd.resp[0]);
 		err = -EIO;
 		goto out;
@@ -1496,8 +1491,8 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 		/* Do not retry else we can't see errors */
 		err = mmc_wait_for_cmd(card->host, &cmd, 0);
 		if (err || (cmd.resp[0] & 0xFDF92000)) {
-			printk(KERN_ERR "error %d requesting status %#x\n",
-				err, cmd.resp[0]);
+			pr_err("error %d requesting status %#x\n",
+			       err, cmd.resp[0]);
 			err = -EIO;
 			goto out;
 		}
@@ -1680,8 +1675,8 @@ unsigned int mmc_calc_max_discard(struct mmc_card *card)
 	} else if (max_discard < card->erase_size) {
 		max_discard = 0;
 	}
-	pr_debug("%s: calculated max. discard sectors %u for timeout %u ms\n",
-		 mmc_hostname(host), max_discard, host->max_discard_to);
+	mmc_dbg(host, "calculated max. discard sectors %u for timeout %u ms\n",
+		max_discard, host->max_discard_to);
 	return max_discard;
 }
 EXPORT_SYMBOL(mmc_calc_max_discard);
@@ -1705,8 +1700,8 @@ static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
 	host->f_init = freq;
 
 #ifdef CONFIG_MMC_DEBUG
-	pr_info("%s: %s: trying to init card at %u Hz\n",
-		mmc_hostname(host), __func__, host->f_init);
+	mmc_info(host, "%s: trying to init card at %u Hz\n",
+		 __func__, host->f_init);
 #endif
 	mmc_power_up(host);
 
@@ -1834,7 +1829,7 @@ int mmc_power_save_host(struct mmc_host *host)
 	int ret = 0;
 
 #ifdef CONFIG_MMC_DEBUG
-	pr_info("%s: %s: powering down\n", mmc_hostname(host), __func__);
+	mmc_info(host, "%s: powering down\n", __func__);
 #endif
 
 	mmc_bus_get(host);
@@ -1860,7 +1855,7 @@ int mmc_power_restore_host(struct mmc_host *host)
 	int ret;
 
 #ifdef CONFIG_MMC_DEBUG
-	pr_info("%s: %s: powering up\n", mmc_hostname(host), __func__);
+	mmc_info(host, "%s: powering up\n", __func__);
 #endif
 
 	mmc_bus_get(host);
@@ -1991,9 +1986,8 @@ int mmc_resume_host(struct mmc_host *host)
 		BUG_ON(!host->bus_ops->resume);
 		err = host->bus_ops->resume(host);
 		if (err) {
-			printk(KERN_WARNING "%s: error %d during resume "
-					    "(card was removed?)\n",
-					    mmc_hostname(host), err);
+			mmc_warn(host, "error %d during resume (card was removed?)\n",
+				 err);
 			err = 0;
 		}
 	}
@@ -2053,6 +2047,25 @@ int mmc_pm_notify(struct notifier_block *notify_block,
 }
 #endif
 
+int mmc_printk(const char *level, const struct mmc_host *host,
+	       const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = printk("%s%s: %pV", level, mmc_hostname(host), &vaf);
+
+	va_end(args);
+
+	return r;
+}
+
 static int __init mmc_init(void)
 {
 	int ret;
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index b29d3e8..6c47500 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -68,9 +68,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
 	unsigned long flags;
 
 	if (!freq) {
-		pr_debug("%s: frequency set to 0 in disable function, "
-			 "this means the clock is already disabled.\n",
-			 mmc_hostname(host));
+		mmc_dbg(host, "frequency set to 0 in disable function, this means the clock is already disabled\n");
 		return;
 	}
 	/*
@@ -101,7 +99,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
 		/* This will set host->ios.clock to 0 */
 		mmc_gate_clock(host);
 		spin_lock_irqsave(&host->clk_lock, flags);
-		pr_debug("%s: gated MCI clock\n", mmc_hostname(host));
+		mmc_dbg(host, "gated MCI clock\n");
 	}
 	spin_unlock_irqrestore(&host->clk_lock, flags);
 	mutex_unlock(&host->clk_gate_mutex);
@@ -136,7 +134,7 @@ void mmc_host_clk_ungate(struct mmc_host *host)
 		spin_unlock_irqrestore(&host->clk_lock, flags);
 		mmc_ungate_clock(host);
 		spin_lock_irqsave(&host->clk_lock, flags);
-		pr_debug("%s: ungated MCI clock\n", mmc_hostname(host));
+		mmc_dbg(host, "ungated MCI clock\n");
 	}
 	host->clk_requests++;
 	spin_unlock_irqrestore(&host->clk_lock, flags);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index aa7d1d7..c13ab71 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -101,8 +101,8 @@ static int mmc_decode_cid(struct mmc_card *card)
 		break;
 
 	default:
-		printk(KERN_ERR "%s: card has unknown MMCA version %d\n",
-			mmc_hostname(card->host), card->csd.mmca_vsn);
+		mmc_err(card->host, "card has unknown MMCA version %d\n",
+			card->csd.mmca_vsn);
 		return -EINVAL;
 	}
 
@@ -135,8 +135,8 @@ static int mmc_decode_csd(struct mmc_card *card)
 	 */
 	csd->structure = UNSTUFF_BITS(resp, 126, 2);
 	if (csd->structure == 0) {
-		printk(KERN_ERR "%s: unrecognised CSD structure version %d\n",
-			mmc_hostname(card->host), csd->structure);
+		mmc_err(card->host, "unrecognised CSD structure version %d\n",
+			csd->structure);
 		return -EINVAL;
 	}
 
@@ -195,8 +195,7 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
 	 */
 	ext_csd = kmalloc(512, GFP_KERNEL);
 	if (!ext_csd) {
-		printk(KERN_ERR "%s: could not allocate a buffer to "
-			"receive the ext_csd.\n", mmc_hostname(card->host));
+		mmc_err(card->host, "could not allocate a buffer to receive the ext_csd\n");
 		return -ENOMEM;
 	}
 
@@ -217,15 +216,9 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
 		 * stored in their CSD.
 		 */
 		if (card->csd.capacity == (4096 * 512)) {
-			printk(KERN_ERR "%s: unable to read EXT_CSD "
-				"on a possible high capacity card. "
-				"Card will be ignored.\n",
-				mmc_hostname(card->host));
+			mmc_err(card->host, "unable to read EXT_CSD on a possible high capacity card. Card will be ignored.\n");
 		} else {
-			printk(KERN_WARNING "%s: unable to read "
-				"EXT_CSD, performance might "
-				"suffer.\n",
-				mmc_hostname(card->host));
+			mmc_warn(card->host, "unable to read EXT_CSD, performance might suffer.\n");
 			err = 0;
 		}
 	} else
@@ -250,9 +243,8 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 	card->ext_csd.raw_ext_csd_structure = ext_csd[EXT_CSD_STRUCTURE];
 	if (card->csd.structure == 3) {
 		if (card->ext_csd.raw_ext_csd_structure > 2) {
-			printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
-				"version %d\n", mmc_hostname(card->host),
-					card->ext_csd.raw_ext_csd_structure);
+			mmc_err(card->host, "unrecognised EXT_CSD structure version %d\n",
+				card->ext_csd.raw_ext_csd_structure);
 			err = -EINVAL;
 			goto out;
 		}
@@ -260,8 +252,8 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 
 	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
 	if (card->ext_csd.rev > 5) {
-		printk(KERN_ERR "%s: unrecognised EXT_CSD revision %d\n",
-			mmc_hostname(card->host), card->ext_csd.rev);
+		mmc_err(card->host, "unrecognised EXT_CSD revision %d\n",
+			card->ext_csd.rev);
 		err = -EINVAL;
 		goto out;
 	}
@@ -306,9 +298,7 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		break;
 	default:
 		/* MMC v4 spec says this cannot happen */
-		printk(KERN_WARNING "%s: card is mmc v4 but doesn't "
-			"support any high-speed modes.\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "card is mmc v4 but doesn't support any high-speed modes\n");
 	}
 
 	card->ext_csd.raw_s_a_timeout = ext_csd[EXT_CSD_S_A_TIMEOUT];
@@ -716,8 +706,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 			goto free_card;
 
 		if (err) {
-			printk(KERN_WARNING "%s: switch to highspeed failed\n",
-			       mmc_hostname(card->host));
+			mmc_warn(card->host, "switch to highspeed failed\n");
 			err = 0;
 		} else {
 			mmc_card_set_highspeed(card);
@@ -809,9 +798,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 					 0);
 		}
 		if (err) {
-			printk(KERN_WARNING "%s: switch to bus width %d ddr %d "
-				"failed\n", mmc_hostname(card->host),
-				1 << bus_width, ddr);
+			mmc_warn(card->host, "switch to bus width %d ddr %d failed\n",
+				 1 << bus_width, ddr);
 			goto free_card;
 		} else if (ddr) {
 			/*
@@ -952,8 +940,8 @@ static int mmc_sleep(struct mmc_host *host)
 	if (card && card->ext_csd.rev >= 3) {
 		err = mmc_card_sleepawake(host, 1);
 		if (err < 0)
-			pr_debug("%s: Error %d while putting card into sleep",
-				 mmc_hostname(host), err);
+			mmc_dbg(host, "Error %d while putting card into sleep\n",
+				err);
 	}
 
 	return err;
@@ -967,8 +955,8 @@ static int mmc_awake(struct mmc_host *host)
 	if (card && card->ext_csd.rev >= 3) {
 		err = mmc_card_sleepawake(host, 0);
 		if (err < 0)
-			pr_debug("%s: Error %d while awaking sleeping card",
-				 mmc_hostname(host), err);
+			mmc_dbg(host, "Error %d while awaking sleeping card\n",
+				err);
 	}
 
 	return err;
@@ -1038,9 +1026,7 @@ int mmc_attach_mmc(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		printk(KERN_WARNING "%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		mmc_warn(host, "card claims to support voltages below the defined range. These will be ignored.\n");
 		ocr &= ~0x7F;
 	}
 
@@ -1077,8 +1063,7 @@ remove_card:
 err:
 	mmc_detach_bus(host);
 
-	printk(KERN_ERR "%s: error %d whilst initialising MMC card\n",
-		mmc_hostname(host), err);
+	mmc_err(host, "error %d whilst initialising MMC card\n", err);
 
 	return err;
 }
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 845ce7c..ef47cad 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -414,8 +414,8 @@ int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 			return -EBADMSG;
 	} else {
 		if (status & 0xFDFFA000)
-			printk(KERN_WARNING "%s: unexpected status %#x after "
-			       "switch", mmc_hostname(card->host), status);
+			mmc_warn(card->host, "unexpected status %#x after switch\n",
+				 status);
 		if (status & R1_SWITCH_ERROR)
 			return -EBADMSG;
 	}
@@ -476,8 +476,7 @@ mmc_send_bus_test(struct mmc_card *card, struct mmc_host *host, u8 opcode,
 	else if (len == 4)
 		test_buf = testdata_4bit;
 	else {
-		printk(KERN_ERR "%s: Invalid bus_width %d\n",
-		       mmc_hostname(host), len);
+		mmc_err(host, "Invalid bus_width %d\n", len);
 		kfree(data_buf);
 		return -EINVAL;
 	}
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 633975f..c258be0 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -163,8 +163,8 @@ static int mmc_decode_csd(struct mmc_card *card)
 		csd->erase_size = 1;
 		break;
 	default:
-		printk(KERN_ERR "%s: unrecognised CSD structure version %d\n",
-			mmc_hostname(card->host), csd_struct);
+		mmc_err(card->host, "unrecognised CSD structure version %d\n",
+			csd_struct);
 		return -EINVAL;
 	}
 
@@ -187,8 +187,8 @@ static int mmc_decode_scr(struct mmc_card *card)
 
 	scr_struct = UNSTUFF_BITS(resp, 60, 4);
 	if (scr_struct != 0) {
-		printk(KERN_ERR "%s: unrecognised SCR structure version %d\n",
-			mmc_hostname(card->host), scr_struct);
+		mmc_err(card->host, "unrecognised SCR structure version %d\n",
+			scr_struct);
 		return -EINVAL;
 	}
 
@@ -218,8 +218,7 @@ static int mmc_read_ssr(struct mmc_card *card)
 	u32 *ssr;
 
 	if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
-		printk(KERN_WARNING "%s: card lacks mandatory SD Status "
-			"function.\n", mmc_hostname(card->host));
+		mmc_warn(card->host, "card lacks mandatory SD Status function\n");
 		return 0;
 	}
 
@@ -229,8 +228,7 @@ static int mmc_read_ssr(struct mmc_card *card)
 
 	err = mmc_app_sd_status(card, ssr);
 	if (err) {
-		printk(KERN_WARNING "%s: problem reading SD Status "
-			"register.\n", mmc_hostname(card->host));
+		mmc_warn(card->host, "problem reading SD Status register\n");
 		err = 0;
 		goto out;
 	}
@@ -253,8 +251,7 @@ static int mmc_read_ssr(struct mmc_card *card)
 			card->ssr.erase_offset = eo * 1000;
 		}
 	} else {
-		printk(KERN_WARNING "%s: SD Status: Invalid Allocation Unit "
-			"size.\n", mmc_hostname(card->host));
+		mmc_warn(card->host, "SD Status: Invalid Allocation Unit size\n");
 	}
 out:
 	kfree(ssr);
@@ -273,9 +270,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		return 0;
 
 	if (!(card->csd.cmdclass & CCC_SWITCH)) {
-		printk(KERN_WARNING "%s: card lacks mandatory switch "
-			"function, performance might suffer.\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "card lacks mandatory switch function, performance might suffer\n");
 		return 0;
 	}
 
@@ -283,9 +278,7 @@ static int mmc_read_switch(struct mmc_card *card)
 
 	status = kmalloc(64, GFP_KERNEL);
 	if (!status) {
-		printk(KERN_ERR "%s: could not allocate a buffer for "
-			"switch capabilities.\n",
-			mmc_hostname(card->host));
+		mmc_err(card->host, "could not allocate a buffer for switch capabilities\n");
 		return -ENOMEM;
 	}
 
@@ -299,8 +292,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 			goto out;
 
-		printk(KERN_WARNING "%s: problem reading Bus Speed modes.\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "problem reading Bus Speed modes\n");
 		err = 0;
 
 		goto out;
@@ -319,9 +311,7 @@ static int mmc_read_switch(struct mmc_card *card)
 			if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 				goto out;
 
-			printk(KERN_WARNING "%s: problem reading "
-				"Driver Strength.\n",
-				mmc_hostname(card->host));
+			mmc_warn(card->host, "problem reading Driver Strength\n");
 			err = 0;
 
 			goto out;
@@ -339,9 +329,7 @@ static int mmc_read_switch(struct mmc_card *card)
 			if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 				goto out;
 
-			printk(KERN_WARNING "%s: problem reading "
-				"Current Limit.\n",
-				mmc_hostname(card->host));
+			mmc_warn(card->host, "problem reading Current Limit\n");
 			err = 0;
 
 			goto out;
@@ -383,8 +371,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 
 	status = kmalloc(64, GFP_KERNEL);
 	if (!status) {
-		printk(KERN_ERR "%s: could not allocate a buffer for "
-			"switch capabilities.\n", mmc_hostname(card->host));
+		mmc_err(card->host, "could not allocate a buffer for switch capabilities\n");
 		return -ENOMEM;
 	}
 
@@ -393,9 +380,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 		goto out;
 
 	if ((status[16] & 0xF) != 1) {
-		printk(KERN_WARNING "%s: Problem switching card "
-			"into high-speed mode!\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "Problem switching card into high-speed mode!\n");
 		err = 0;
 	} else {
 		err = 1;
@@ -459,8 +444,7 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[15] & 0xF) != drive_strength) {
-		printk(KERN_WARNING "%s: Problem setting drive strength!\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "Problem setting drive strength!\n");
 		return 0;
 	}
 
@@ -519,8 +503,7 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[16] & 0xF) != bus_speed)
-		printk(KERN_WARNING "%s: Problem setting bus speed mode!\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "Problem setting bus speed mode!\n");
 	else {
 		mmc_set_timing(card->host, timing);
 		mmc_set_clock(card->host, card->sw_caps.uhs_max_dtr);
@@ -581,8 +564,7 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 		return err;
 
 	if (((status[15] >> 4) & 0x0F) != current_limit)
-		printk(KERN_WARNING "%s: Problem setting current limit!\n",
-			mmc_hostname(card->host));
+		mmc_warn(card->host, "Problem setting current limit!\n");
 
 	return 0;
 }
@@ -603,8 +585,7 @@ static int mmc_sd_init_uhs_card(struct mmc_card *card)
 
 	status = kmalloc(64, GFP_KERNEL);
 	if (!status) {
-		printk(KERN_ERR "%s: could not allocate a buffer for "
-			"switch capabilities.\n", mmc_hostname(card->host));
+		mmc_err(card->host, "could not allocate a buffer for switch capabilities\n");
 		return -ENOMEM;
 	}
 
@@ -827,10 +808,7 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 			ro = host->ops->get_ro(host);
 
 		if (ro < 0) {
-			printk(KERN_WARNING "%s: host does not "
-				"support reading read-only "
-				"switch. assuming write-enable.\n",
-				mmc_hostname(host));
+			mmc_warn(host, "host does not support reading read-only switch. assuming write-enable.\n");
 		} else if (ro > 0) {
 			mmc_card_set_readonly(card);
 		}
@@ -1142,17 +1120,13 @@ int mmc_attach_sd(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		printk(KERN_WARNING "%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		mmc_warn(host, "card claims to support voltages below the defined range. These will be ignored.\n");
 		ocr &= ~0x7F;
 	}
 
 	if ((ocr & MMC_VDD_165_195) &&
 	    !(host->ocr_avail_sd & MMC_VDD_165_195)) {
-		printk(KERN_WARNING "%s: SD card claims to support the "
-		       "incompletely defined 'low voltage range'. This "
-		       "will be ignored.\n", mmc_hostname(host));
+		mmc_warn(host, "SD card claims to support the incompletely defined 'low voltage range'. This will be ignored.\n");
 		ocr &= ~MMC_VDD_165_195;
 	}
 
@@ -1189,8 +1163,7 @@ remove_card:
 err:
 	mmc_detach_bus(host);
 
-	printk(KERN_ERR "%s: error %d whilst initialising SD card\n",
-		mmc_hostname(host), err);
+	mmc_err(host, "error %d whilst initialising SD card\n", err);
 
 	return err;
 }
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 262fff0..0241e6d 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -112,8 +112,8 @@ static int sdio_read_cccr(struct mmc_card *card)
 	cccr_vsn = data & 0x0f;
 
 	if (cccr_vsn > SDIO_CCCR_REV_1_20) {
-		printk(KERN_ERR "%s: unrecognised CCCR structure version %d\n",
-			mmc_hostname(card->host), cccr_vsn);
+		mmc_err(card->host, "unrecognised CCCR structure version %d\n",
+			cccr_vsn);
 		return -EINVAL;
 	}
 
@@ -778,9 +778,7 @@ int mmc_attach_sdio(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		printk(KERN_WARNING "%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		mmc_warn(host, "card claims to support voltages below the defined range. These will be ignored.\n");
 		ocr &= ~0x7F;
 	}
 
@@ -875,8 +873,7 @@ remove:
 err:
 	mmc_detach_bus(host);
 
-	printk(KERN_ERR "%s: error %d whilst initialising SDIO card\n",
-		mmc_hostname(host), err);
+	mmc_err(host, "error %d whilst initialising SDIO card\n", err);
 
 	return err;
 }
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index e4e6822..ef65c0d 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -11,6 +11,8 @@
  * SDIO function driver model
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -173,8 +175,8 @@ static int sdio_bus_remove(struct device *dev)
 	drv->remove(func);
 
 	if (func->irq_handler) {
-		printk(KERN_WARNING "WARNING: driver %s did not remove "
-			"its interrupt handler!\n", drv->name);
+		pr_warn("WARNING: driver %s did not remove its interrupt handler!\n",
+			drv->name);
 		sdio_claim_host(func);
 		sdio_release_irq(func);
 		sdio_release_host(func);
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 541bdb8..23a894a 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -132,8 +132,8 @@ static int cis_tpl_parse(struct mmc_card *card, struct sdio_func *func,
 			ret = -EINVAL;
 		}
 		if (ret && ret != -EILSEQ && ret != -ENOENT) {
-			printk(KERN_ERR "%s: bad %s tuple 0x%02x (%u bytes)\n",
-			       mmc_hostname(card->host), tpl_descr, code, size);
+			mmc_err(card->host, "bad %s tuple 0x%02x (%u bytes)\n",
+			       tpl_descr, code, size);
 		}
 	} else {
 		/* unknown tuple */
@@ -313,10 +313,8 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
 
 			if (ret == -ENOENT) {
 				/* warn about unknown tuples */
-				printk(KERN_WARNING "%s: queuing unknown"
-				       " CIS tuple 0x%02x (%u bytes)\n",
-				       mmc_hostname(card->host),
-				       tpl_code, tpl_link);
+				mmc_warn(card->host, "queuing unknown CIS tuple 0x%02x (%u bytes)\n",
+					 tpl_code, tpl_link);
 			}
 
 			/* keep on analyzing tuples */
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 0f687cd..8c3a08f 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -9,6 +9,8 @@
  * your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio.h>
@@ -64,7 +66,7 @@ int sdio_enable_func(struct sdio_func *func)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Enabling device %s...\n", sdio_func_id(func));
+	pr_debug("Enabling device %s...\n", sdio_func_id(func));
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IOEx, 0, &reg);
 	if (ret)
@@ -89,12 +91,12 @@ int sdio_enable_func(struct sdio_func *func)
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
@@ -114,7 +116,7 @@ int sdio_disable_func(struct sdio_func *func)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Disabling device %s...\n", sdio_func_id(func));
+	pr_debug("Disabling device %s...\n", sdio_func_id(func));
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IOEx, 0, &reg);
 	if (ret)
@@ -126,12 +128,12 @@ int sdio_disable_func(struct sdio_func *func)
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
index 03ead02..8dd2dcf 100644
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
@@ -45,8 +47,8 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
 	if (ret) {
-		printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
-		       mmc_card_id(card), ret);
+		pr_debug("%s: error %d reading SDIO_CCCR_INTx\n",
+			 mmc_card_id(card), ret);
 		return ret;
 	}
 
@@ -55,16 +57,15 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 		if (pending & (1 << i)) {
 			func = card->sdio_func[i - 1];
 			if (!func) {
-				printk(KERN_WARNING "%s: pending IRQ for "
-					"non-existent function\n",
+				pr_warn("%s: pending IRQ for non-existent function\n",
 					mmc_card_id(card));
 				ret = -EINVAL;
 			} else if (func->irq_handler) {
 				func->irq_handler(func);
 				count++;
 			} else {
-				printk(KERN_WARNING "%s: pending IRQ with no handler\n",
-				       sdio_func_id(func));
+				pr_warn("%s: pending IRQ with no handler\n",
+					sdio_func_id(func));
 				ret = -EINVAL;
 			}
 		}
@@ -95,8 +96,8 @@ static int sdio_irq_thread(void *_host)
 	period = (host->caps & MMC_CAP_SDIO_IRQ) ?
 		MAX_SCHEDULE_TIMEOUT : idle_period;
 
-	pr_debug("%s: IRQ thread started (poll period = %lu jiffies)\n",
-		 mmc_hostname(host), period);
+	mmc_dbg(host, "IRQ thread started (poll period = %lu jiffies)\n",
+		period);
 
 	do {
 		/*
@@ -155,8 +156,7 @@ static int sdio_irq_thread(void *_host)
 	if (host->caps & MMC_CAP_SDIO_IRQ)
 		host->ops->enable_sdio_irq(host, 0);
 
-	pr_debug("%s: IRQ thread exiting with code %d\n",
-		 mmc_hostname(host), ret);
+	mmc_dbg(host, "IRQ thread exiting with code %d\n", ret);
 
 	return ret;
 }
@@ -233,10 +233,10 @@ int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Enabling IRQ for %s...\n", sdio_func_id(func));
+	pr_debug("Enabling IRQ for %s...\n", sdio_func_id(func));
 
 	if (func->irq_handler) {
-		pr_debug("SDIO: IRQ for %s already in use.\n", sdio_func_id(func));
+		pr_debug("IRQ for %s already in use.\n", sdio_func_id(func));
 		return -EBUSY;
 	}
 
@@ -276,7 +276,7 @@ int sdio_release_irq(struct sdio_func *func)
 	BUG_ON(!func);
 	BUG_ON(!func->card);
 
-	pr_debug("SDIO: Disabling IRQ for %s...\n", sdio_func_id(func));
+	pr_debug("Disabling IRQ for %s...\n", sdio_func_id(func));
 
 	if (func->irq_handler) {
 		func->irq_handler = NULL;
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index a4aa3af..6bb03cc 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -53,6 +53,8 @@
      Gets the status of the write protect pin, if available.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -373,7 +375,7 @@ static void at91_mci_update_bytes_xfered(struct at91mci_host *host)
 		if (data->flags & MMC_DATA_WRITE) {
 			/* card is in IDLE mode now */
 			pr_debug("-> bytes_xfered %d, total_length = %d\n",
-				data->bytes_xfered, host->total_length);
+				 data->bytes_xfered, host->total_length);
 			data->bytes_xfered = data->blksz * data->blocks;
 		}
 	}
@@ -451,7 +453,8 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
 		at91_mci_write(host, AT91_MCI_CMDR, AT91_MCI_OPDCMD);
 		while (!(at91_mci_read(host, AT91_MCI_SR) & AT91_MCI_CMDRDY)) {
 			/* spin */
-			pr_debug("Clearing: SR = %08X\n", at91_mci_read(host, AT91_MCI_SR));
+			pr_debug("Clearing: SR = %08X\n",
+				 at91_mci_read(host, AT91_MCI_SR));
 		}
 	}
 
@@ -519,7 +522,8 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
 	 * Set the arguments and send the command
 	 */
 	pr_debug("Sending command %d as %08X, arg = %08X, blocks = %d, length = %d (MR = %08X)\n",
-		cmd->opcode, cmdr, cmd->arg, blocks, block_length, at91_mci_read(host, AT91_MCI_MR));
+		 cmd->opcode, cmdr, cmd->arg, blocks, block_length,
+		 at91_mci_read(host, AT91_MCI_MR));
 
 	if (!data) {
 		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_TXTDIS | ATMEL_PDC_RXTDIS);
@@ -583,7 +587,8 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
 
 				at91_mci_sg_to_dma(host, data);
 
-				pr_debug("Transmitting %d bytes\n", host->total_length);
+				pr_debug("Transmitting %d bytes\n",
+					 host->total_length);
 
 				at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
 				at91_mci_write(host, ATMEL_PDC_TCR, (data->blksz & 0x3) ?
@@ -675,7 +680,7 @@ static void at91_mci_completed_command(struct at91mci_host *host, unsigned int s
 			}
 
 			pr_debug("Error detected and set to %d/%d (cmd = %d, retries = %d)\n",
-				cmd->error, data ? data->error : 0,
+				 cmd->error, data ? data->error : 0,
 				 cmd->opcode, cmd->retries);
 		}
 	}
@@ -725,15 +730,15 @@ static void at91_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		else
 			clkdiv = (at91_master_clock / ios->clock) / 2;
 
-		pr_debug("clkdiv = %d. mcck = %ld\n", clkdiv,
-			at91_master_clock / (2 * (clkdiv + 1)));
+		pr_debug("clkdiv = %d. mcck = %ld\n",
+			 clkdiv, at91_master_clock / (2 * (clkdiv + 1)));
 	}
 	if (ios->bus_width == MMC_BUS_WIDTH_4 && host->board->wire4) {
-		pr_debug("MMC: Setting controller bus width to 4\n");
+		pr_debug("Setting controller bus width to 4\n");
 		at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) | AT91_MCI_SDCBUS);
 	}
 	else {
-		pr_debug("MMC: Setting controller bus width to 1\n");
+		pr_debug("Setting controller bus width to 1\n");
 		at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
 	}
 
@@ -778,23 +783,23 @@ static irqreturn_t at91_mci_irq(int irq, void *devid)
 		completed = 1;
 
 		if (int_status & AT91_MCI_UNRE)
-			pr_debug("MMC: Underrun error\n");
+			pr_debug("Underrun error\n");
 		if (int_status & AT91_MCI_OVRE)
-			pr_debug("MMC: Overrun error\n");
+			pr_debug("Overrun error\n");
 		if (int_status & AT91_MCI_DTOE)
-			pr_debug("MMC: Data timeout\n");
+			pr_debug("Data timeout\n");
 		if (int_status & AT91_MCI_DCRCE)
-			pr_debug("MMC: CRC error in data\n");
+			pr_debug("CRC error in data\n");
 		if (int_status & AT91_MCI_RTOE)
-			pr_debug("MMC: Response timeout\n");
+			pr_debug("Response timeout\n");
 		if (int_status & AT91_MCI_RENDE)
-			pr_debug("MMC: Response end bit error\n");
+			pr_debug("Response end bit error\n");
 		if (int_status & AT91_MCI_RCRCE)
-			pr_debug("MMC: Response CRC error\n");
+			pr_debug("Response CRC error\n");
 		if (int_status & AT91_MCI_RDIRE)
-			pr_debug("MMC: Response direction error\n");
+			pr_debug("Response direction error\n");
 		if (int_status & AT91_MCI_RINDE)
-			pr_debug("MMC: Response index error\n");
+			pr_debug("Response index error\n");
 	} else {
 		/* Only continue processing if no errors */
 
@@ -877,8 +882,7 @@ static irqreturn_t at91_mmc_det_irq(int irq, void *_host)
 	 */
 	if (present != host->present) {
 		host->present = present;
-		pr_debug("%s: card %s\n", mmc_hostname(host->mmc),
-			present ? "insert" : "remove");
+		mmc_dbg("card %s\n", present ? "insert" : "remove");
 		if (!present) {
 			pr_debug("****** Resetting SD-card bus width ******\n");
 			at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
@@ -906,8 +910,8 @@ static void at91_mci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 {
 	struct at91mci_host *host = mmc_priv(mmc);
 
-	pr_debug("%s: sdio_irq %c : %s\n", mmc_hostname(host->mmc),
-		host->board->slot_b ? 'B':'A', enable ? "enable" : "disable");
+	mmc_dbg(host->mmc, "sdio_irq %c : %s\n",
+		host->board->slot_b ? 'B' : 'A', enable ? "enable" : "disable");
 	at91_mci_write(host, enable ? AT91_MCI_IER : AT91_MCI_IDR,
 		host->board->slot_b ? AT91_MCI_SDIOIRQB : AT91_MCI_SDIOIRQA);
 
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index ef72e87..cb3f278 100644
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
@@ -54,10 +56,10 @@
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DBG(fmt, idx, args...)	\
-	printk(KERN_DEBUG "au1xmmc(%d): DEBUG: " fmt, idx, ##args)
+#define DBG(fmt, args...)					\
+	pr_debug("(%d): DEBUG: " fmt, host->pdev->id, ##args)
 #else
-#define DBG(fmt, idx, args...) do {} while (0)
+#define DBG(fmt, args...) no_printk(fmt, ##args)
 #endif
 
 /* Hardware definitions */
@@ -268,8 +270,7 @@ static int au1xmmc_send_command(struct au1xmmc_host *host, int wait,
 		mmccmd |= SD_CMD_RT_3;
 		break;
 	default:
-		printk(KERN_INFO "au1xmmc: unhandled response type %02x\n",
-			mmc_resp_type(cmd));
+		pr_info("unhandled response type %02x\n", mmc_resp_type(cmd));
 		return -EINVAL;
 	}
 
@@ -471,19 +472,19 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 			break;
 
 		if (status & SD_STATUS_RC) {
-			DBG("RX CRC Error [%d + %d].\n", host->pdev->id,
-					host->pio.len, count);
+			DBG("RX CRC Error [%d + %d]\n",
+			    host->pio.len, count);
 			break;
 		}
 
 		if (status & SD_STATUS_RO) {
-			DBG("RX Overrun [%d + %d]\n", host->pdev->id,
-					host->pio.len, count);
+			DBG("RX Overrun [%d + %d]\n",
+			    host->pdev->id, host->pio.len, count);
 			break;
 		}
 		else if (status & SD_STATUS_RU) {
-			DBG("RX Underrun [%d + %d]\n", host->pdev->id,
-					host->pio.len,	count);
+			DBG("RX Underrun [%d + %d]\n",
+			    host->pdev->id, host->pio.len, count);
 			break;
 		}
 
@@ -828,8 +829,7 @@ static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 			au1xmmc_receive_pio(host);
 
 	} else if (status & 0x203F3C70) {
-			DBG("Unhandled status %8.8x\n", host->pdev->id,
-				status);
+			DBG("Unhandled status %08x\n", status);
 	}
 
 	au_writel(status, HOST_STATUS(host));
@@ -1031,7 +1031,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 #ifdef CONFIG_SOC_AU1200
 	ret = au1xmmc_dbdma_init(host);
 	if (ret)
-		printk(KERN_INFO DRIVER_NAME ": DBDMA init failed; using PIO\n");
+		pr_info("DBDMA init failed; using PIO\n");
 #endif
 
 #ifdef CONFIG_LEDS_CLASS
@@ -1056,8 +1056,8 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, host);
 
-	printk(KERN_INFO DRIVER_NAME ": MMC Controller %d set up at %8.8X"
-		" (mode=%s)\n", pdev->id, host->iobase,
+	pr_info("MMC Controller %d set up at %08X (mode=%s)\n",
+		pdev->id, host->iobase,
 		host->flags & HOST_F_DMA ? "dma" : "pio");
 
 	return 0;	/* all ok */
@@ -1188,7 +1188,7 @@ static int __init au1xmmc_init(void)
 	 */
 	memid = au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
 	if (!memid)
-		printk(KERN_ERR "au1xmmc: cannot add memory dbdma dev\n");
+		pr_err("cannot add memory dbdma dev\n");
 #endif
 	return platform_driver_register(&au1xmmc_driver);
 }
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 77f0b6b..820cdb7 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1673,7 +1673,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 
 	host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
 	if (IS_ERR(host->vmmc)) {
-		printk(KERN_INFO "%s: no vmmc regulator found\n", mmc_hostname(mmc));
+		mmc_info(mmc, "no vmmc regulator found\n");
 		host->vmmc = NULL;
 	} else
 		regulator_enable(host->vmmc);
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 881f7ba..97fca89 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
@@ -942,7 +944,7 @@ static int __init imxmci_probe(struct platform_device *pdev)
 	int ret = 0, irq;
 	u16 rev_no;
 
-	printk(KERN_INFO "i.MX mmc driver\n");
+	pr_info("i.MX mmc driver\n");
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 56e9a41..d9e2fb4 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -8,6 +8,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -464,9 +467,8 @@ static void mmci_get_next_data(struct mmci_host *host, struct mmc_data *data)
 	struct mmci_host_next *next = &host->next_data;
 
 	if (data->host_cookie && data->host_cookie != next->cookie) {
-		printk(KERN_WARNING "[%s] invalid cookie: data->host_cookie %d"
-		       " host->next_data.cookie %d\n",
-		       __func__, data->host_cookie, host->next_data.cookie);
+		pr_warn("[%s] invalid cookie: data->host_cookie %d host->next_data.cookie %d\n",
+			__func__, data->host_cookie, host->next_data.cookie);
 		data->host_cookie = 0;
 	}
 
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index a4c865a..a11c346 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -141,16 +143,15 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
 	/* Reset the controller */
 	ret = clk_reset(host->clk, CLK_RESET_ASSERT);
 	if (ret)
-		pr_err("%s: Clock assert failed at %u Hz with err %d\n",
-				mmc_hostname(host->mmc), host->clk_rate, ret);
+		mmc_err(host->mmc, "Clock assert failed at %u Hz with err %d\n",
+			host->clk_rate, ret);
 
 	ret = clk_reset(host->clk, CLK_RESET_DEASSERT);
 	if (ret)
-		pr_err("%s: Clock deassert failed at %u Hz with err %d\n",
-				mmc_hostname(host->mmc), host->clk_rate, ret);
+		mmc_err(host->mmc, "Clock deassert failed at %u Hz with err %d\n",
+			host->clk_rate, ret);
 
-	pr_info("%s: Controller has been re-initialiazed\n",
-			mmc_hostname(host->mmc));
+	mmc_info(host->mmc, "Controller has been re-initialiazed\n");
 
 	/* Restore the contoller state */
 	writel(host->pwr, host->base + MMCIPOWER);
@@ -158,8 +159,8 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
 	writel(mci_mask0, host->base + MMCIMASK0);
 	ret = clk_set_rate(host->clk, host->clk_rate);
 	if (ret)
-		pr_err("%s: Failed to set clk rate %u Hz (%d)\n",
-				mmc_hostname(host->mmc), host->clk_rate, ret);
+		mmc_err(host->mmc, "Failed to set clk rate %u Hz (%d)\n",
+			host->clk_rate, ret);
 }
 
 static void
@@ -241,7 +242,7 @@ msmsdcc_dma_complete_tlet(unsigned long data)
 	WARN_ON(!mrq->data);
 
 	if (!(host->dma.result & DMOV_RSLT_VALID)) {
-		pr_err("msmsdcc: Invalid DataMover result\n");
+		pr_err("Invalid DataMover result\n");
 		goto out;
 	}
 
@@ -250,11 +251,11 @@ msmsdcc_dma_complete_tlet(unsigned long data)
 	} else {
 		/* Error or flush  */
 		if (host->dma.result & DMOV_RSLT_ERROR)
-			pr_err("%s: DMA error (0x%.8x)\n",
-			       mmc_hostname(host->mmc), host->dma.result);
+			mmc_err(host->mmc, "DMA error (0x%.8x)\n",
+				host->dma.result);
 		if (host->dma.result & DMOV_RSLT_FLUSH)
-			pr_err("%s: DMA channel flushed (0x%.8x)\n",
-			       mmc_hostname(host->mmc), host->dma.result);
+			mmc_err(host->mmc, "DMA channel flushed (0x%.8x)\n",
+				host->dma.result);
 
 		pr_err("Flush data: %.8x %.8x %.8x %.8x %.8x %.8x\n",
 		       err.flush[0], err.flush[1], err.flush[2],
@@ -388,8 +389,7 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 	n = dma_map_sg(mmc_dev(host->mmc), host->dma.sg,
 			host->dma.num_ents, host->dma.dir);
 	if (n == 0) {
-		printk(KERN_ERR "%s: Unable to map in all sg elements\n",
-			mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Unable to map in all sg elements\n");
 		host->dma.sg = NULL;
 		host->dma.num_ents = 0;
 		return -ENOMEM;
@@ -474,8 +474,7 @@ msmsdcc_start_command_deferred(struct msmsdcc_host *host,
 		*c |= MCI_CSPM_MCIABORT;
 
 	if (host->curr.cmd != NULL) {
-		printk(KERN_ERR "%s: Overlapping command requests\n",
-			mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Overlapping command requests\n");
 	}
 	host->curr.cmd = cmd;
 }
@@ -570,24 +569,23 @@ msmsdcc_data_err(struct msmsdcc_host *host, struct mmc_data *data,
 		 unsigned int status)
 {
 	if (status & MCI_DATACRCFAIL) {
-		pr_err("%s: Data CRC error\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Data CRC error\n");
 		pr_err("%s: opcode 0x%.8x\n", __func__,
 		       data->mrq->cmd->opcode);
 		pr_err("%s: blksz %d, blocks %d\n", __func__,
 		       data->blksz, data->blocks);
 		data->error = -EILSEQ;
 	} else if (status & MCI_DATATIMEOUT) {
-		pr_err("%s: Data timeout\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Data timeout\n");
 		data->error = -ETIMEDOUT;
 	} else if (status & MCI_RXOVERRUN) {
-		pr_err("%s: RX overrun\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "RX overrun\n");
 		data->error = -EIO;
 	} else if (status & MCI_TXUNDERRUN) {
-		pr_err("%s: TX underrun\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "TX underrun\n");
 		data->error = -EIO;
 	} else {
-		pr_err("%s: Unknown error (0x%.8x)\n",
-		       mmc_hostname(host->mmc), status);
+		mmc_err(host->mmc, "Unknown error (0x%.8x)\n", status);
 		data->error = -EIO;
 	}
 }
@@ -741,7 +739,7 @@ static void msmsdcc_do_cmdirq(struct msmsdcc_host *host, uint32_t status)
 		cmd->error = -ETIMEDOUT;
 	} else if (status & MCI_CMDCRCFAIL &&
 		   cmd->flags & MMC_RSP_CRC) {
-		pr_err("%s: Command CRC error\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Command CRC error\n");
 		cmd->error = -EILSEQ;
 	}
 
@@ -948,8 +946,7 @@ static void msmsdcc_setup_gpio(struct msmsdcc_host *host, bool enable)
 			rc = gpio_request(curr->gpio[i].no,
 						curr->gpio[i].name);
 			if (rc) {
-				pr_err("%s: gpio_request(%d, %s) failed %d\n",
-					mmc_hostname(host->mmc),
+				mmc_err(host->mmc, "gpio_request(%d, %s) failed %d\n",
 					curr->gpio[i].no,
 					curr->gpio[i].name, rc);
 				goto free_gpios;
@@ -984,8 +981,8 @@ msmsdcc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		if (ios->clock != host->clk_rate) {
 			rc = clk_set_rate(host->clk, ios->clock);
 			if (rc < 0)
-				pr_err("%s: Error setting clock rate (%d)\n",
-				       mmc_hostname(host->mmc), rc);
+				mmc_err(host->mmc, "Error setting clock rate (%d)\n",
+					rc);
 			else
 				host->clk_rate = ios->clock;
 		}
@@ -1072,8 +1069,8 @@ msmsdcc_check_status(unsigned long data)
 	status = host->plat->status(mmc_dev(host->mmc));
 	host->eject = !status;
 	if (status ^ host->oldstat) {
-		pr_info("%s: Slot status change detected (%d -> %d)\n",
-			mmc_hostname(host->mmc), host->oldstat, status);
+		mmc_info(host->mmc, "Slot status change detected (%d -> %d)\n",
+			 host->oldstat, status);
 		if (status)
 			mmc_detect_change(host->mmc, (5 * HZ) / 2);
 		else
@@ -1092,7 +1089,7 @@ msmsdcc_platform_status_irq(int irq, void *dev_id)
 {
 	struct msmsdcc_host *host = dev_id;
 
-	printk(KERN_DEBUG "%s: %d\n", __func__, irq);
+	pr_debug("%s: %d\n", __func__, irq);
 	msmsdcc_check_status((unsigned long) host);
 	return IRQ_HANDLED;
 }
@@ -1102,8 +1099,7 @@ msmsdcc_status_notify_cb(int card_present, void *dev_id)
 {
 	struct msmsdcc_host *host = dev_id;
 
-	printk(KERN_DEBUG "%s: card_present %d\n", mmc_hostname(host->mmc),
-	       card_present);
+	mmc_dbg(host->mmc, "card_present %d\n", card_present);
 	msmsdcc_check_status((unsigned long) host);
 }
 
@@ -1294,15 +1290,14 @@ msmsdcc_probe(struct platform_device *pdev)
 				  DRIVER_NAME " (slot)",
 				  host);
 		if (ret) {
-			pr_err("%s: Unable to get slot IRQ %d (%d)\n",
-			       mmc_hostname(mmc), host->stat_irq, ret);
+			mmc_err(mmc, "Unable to get slot IRQ %d (%d)\n",
+				host->stat_irq, ret);
 			goto clk_disable;
 		}
 	} else if (plat->register_status_notify) {
 		plat->register_status_notify(msmsdcc_status_notify_cb, host);
 	} else if (!plat->status)
-		pr_err("%s: No card detect facilities available\n",
-		       mmc_hostname(mmc));
+		mmc_err(mmc, "No card detect facilities available\n");
 	else {
 		init_timer(&host->timer);
 		host->timer.data = (unsigned long)host;
@@ -1333,28 +1328,26 @@ msmsdcc_probe(struct platform_device *pdev)
 	mmc_set_drvdata(pdev, mmc);
 	mmc_add_host(mmc);
 
-	pr_info("%s: Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
-		mmc_hostname(mmc), (unsigned long long)memres->start,
-		(unsigned int) cmd_irqres->start,
-		(unsigned int) host->stat_irq, host->dma.channel);
-	pr_info("%s: 4 bit data mode %s\n", mmc_hostname(mmc),
-		(mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled"));
-	pr_info("%s: MMC clock %u -> %u Hz, PCLK %u Hz\n",
-		mmc_hostname(mmc), msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
-	pr_info("%s: Slot eject status = %d\n", mmc_hostname(mmc), host->eject);
-	pr_info("%s: Power save feature enable = %d\n",
-		mmc_hostname(mmc), msmsdcc_pwrsave);
+	mmc_info(mmc, "Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
+		 (unsigned long long)memres->start,
+		 (unsigned int) cmd_irqres->start,
+		 (unsigned int) host->stat_irq, host->dma.channel);
+	mmc_info(mmc, "4 bit data mode %s\n",
+		 mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled");
+	mmc_info(mmc, "MMC clock %u -> %u Hz, PCLK %u Hz\n",
+		 msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
+	mmc_info(mmc, "Slot eject status = %d\n", host->eject);
+	mmc_info(mmc, "Power save feature enable = %d\n", msmsdcc_pwrsave);
 
 	if (host->dma.channel != -1) {
-		pr_info("%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
-			mmc_hostname(mmc), host->dma.nc, host->dma.nc_busaddr);
-		pr_info("%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
-			mmc_hostname(mmc), host->dma.cmd_busaddr,
-			host->dma.cmdptr_busaddr);
+		mmc_info(mmc, "DM non-cached buffer at %p, dma_addr 0x%.8x\n",
+			 host->dma.nc, host->dma.nc_busaddr);
+		mmc_info(mmc, "DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
+			 host->dma.cmd_busaddr, host->dma.cmdptr_busaddr);
 	} else
-		pr_info("%s: PIO transfer enabled\n", mmc_hostname(mmc));
+		mmc_info(mmc, "PIO transfer enabled\n");
 	if (host->timer.function)
-		pr_info("%s: Polling status mode enabled\n", mmc_hostname(mmc));
+		mmc_info(mmc, "Polling status mode enabled\n");
 
 	return 0;
  cmd_irq_free:
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index a5bf60e..4800248 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -9,6 +9,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -117,10 +119,8 @@ static int mvsd_setup_data(struct mvsd_host *host, struct mmc_data *data)
 		host->pio_size = data->blocks * data->blksz;
 		host->pio_ptr = sg_virt(data->sg);
 		if (!nodma)
-			printk(KERN_DEBUG "%s: fallback to PIO for data "
-					  "at 0x%p size %d\n",
-					  mmc_hostname(host->mmc),
-					  host->pio_ptr, host->pio_size);
+			mmc_dbg(host->mmc, "fallback to PIO for data at 0x%p size %d\n",
+				host->pio_ptr, host->pio_size);
 		return 1;
 	} else {
 		dma_addr_t phys_addr;
@@ -471,8 +471,8 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
 		if (mrq->data)
 			err_status = mvsd_finish_data(host, mrq->data, err_status);
 		if (err_status) {
-			printk(KERN_ERR "%s: unhandled error status %#04x\n",
-					mmc_hostname(host->mmc), err_status);
+			mmc_err(host->mmc, "unhandled error status %#04x\n",
+				err_status);
 			cmd->error = -ENOMSG;
 		}
 
@@ -489,9 +489,8 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
 	if (irq_handled)
 		return IRQ_HANDLED;
 
-	printk(KERN_ERR "%s: unhandled interrupt status=0x%04x en=0x%04x "
-			"pio=%d\n", mmc_hostname(host->mmc), intr_status,
-			host->intr_en, host->pio_size);
+	mmc_err(host->mmc, "unhandled interrupt status=0x%04x en=0x%04x pio=%d\n",
+		intr_status, host->intr_en, host->pio_size);
 	return IRQ_NONE;
 }
 
@@ -505,13 +504,11 @@ static void mvsd_timeout_timer(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 	mrq = host->mrq;
 	if (mrq) {
-		printk(KERN_ERR "%s: Timeout waiting for hardware interrupt.\n",
-				mmc_hostname(host->mmc));
-		printk(KERN_ERR "%s: hw_state=0x%04x, intr_status=0x%04x "
-				"intr_en=0x%04x\n", mmc_hostname(host->mmc),
-				mvsd_read(MVSD_HW_STATE),
-				mvsd_read(MVSD_NOR_INTR_STATUS),
-				mvsd_read(MVSD_NOR_INTR_EN));
+		mmc_err(host->mmc, "Timeout waiting for hardware interrupt\n");
+		mmc_err(host->mmc, "hw_state=0x%04x, intr_status=0x%04x intr_en=0x%04x\n",
+			mvsd_read(MVSD_HW_STATE),
+			mvsd_read(MVSD_NOR_INTR_STATUS),
+			mvsd_read(MVSD_NOR_INTR_EN));
 
 		host->mrq = NULL;
 
@@ -762,7 +759,7 @@ static int __init mvsd_probe(struct platform_device *pdev)
 
 	ret = request_irq(irq, mvsd_irq, 0, DRIVER_NAME, host);
 	if (ret) {
-		printk(KERN_ERR "%s: cannot assign irq %d\n", DRIVER_NAME, irq);
+		pr_err("cannot assign irq %d\n", irq);
 		goto out;
 	} else
 		host->irq = irq;
@@ -802,13 +799,12 @@ static int __init mvsd_probe(struct platform_device *pdev)
 	if (ret)
 		goto out;
 
-	printk(KERN_NOTICE "%s: %s driver initialized, ",
-			   mmc_hostname(mmc), DRIVER_NAME);
+	pr_notice("driver initialized, ");
 	if (host->gpio_card_detect)
-		printk("using GPIO %d for card detection\n",
-		       host->gpio_card_detect);
+		pr_cont("using GPIO %d for card detection\n",
+			host->gpio_card_detect);
 	else
-		printk("lacking card detect (fall back to polling)\n");
+		pr_cont("lacking card detect (fall back to polling)\n");
 	return 0;
 
 out:
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 14aa213..926d5e8 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -17,6 +17,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
@@ -842,7 +844,7 @@ static int mxcmci_probe(struct platform_device *pdev)
 	int ret = 0, irq;
 	dma_cap_mask_t mask;
 
-	printk(KERN_INFO "i.MX SDHC driver\n");
+	pr_info("i.MX SDHC driver\n");
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index a6c3290..1978f29 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -692,18 +692,19 @@ mmc_omap_xfer_data(struct mmc_omap_host *host, int write)
 
 static inline void mmc_omap_report_irq(u16 status)
 {
-	static const char *mmc_omap_status_bits[] = {
+	static const char * const mmc_omap_status_bits[] = {
 		"EOC", "CD", "CB", "BRS", "EOFB", "DTO", "DCRC", "CTO",
 		"CCRC", "CRW", "AF", "AE", "OCRB", "CIRQ", "CERR"
 	};
-	int i, c = 0;
+	int i;
+	bool printed = false;
 
 	for (i = 0; i < ARRAY_SIZE(mmc_omap_status_bits); i++)
 		if (status & (1 << i)) {
-			if (c)
-				printk(" ");
-			printk("%s", mmc_omap_status_bits[i]);
-			c++;
+			pr_cont("%s%s",
+				printed ? " " : "",
+				mmc_omap_status_bits[i]);
+			printed = true;
 		}
 }
 
@@ -743,7 +744,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 		dev_dbg(mmc_dev(host->mmc), "MMC IRQ %04x (CMD %d): ",
 			status, cmd);
 		mmc_omap_report_irq(status);
-		printk("\n");
+		pr_cont("\n");
 #endif
 		if (host->total_bytes_left) {
 			if ((status & OMAP_MMC_STAT_A_FULL) ||
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 21e4a79..8f60404 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -15,6 +15,8 @@
  * kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -429,7 +431,7 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_host *host)
 		} else {
 			if (!(mmc_slot(host).ocr_mask & ocr_value)) {
 				pr_err("MMC%d ocrmask %x is not supported\n",
-					host->id, mmc_slot(host).ocr_mask);
+				       host->id, mmc_slot(host).ocr_mask);
 				mmc_slot(host).ocr_mask = 0;
 				return -EINVAL;
 			}
@@ -1264,16 +1266,12 @@ static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
 	host->reqs_blocked = 0;
 	if (mmc_slot(host).get_cover_state(host->dev, host->slot_id)) {
 		if (host->protect_card) {
-			printk(KERN_INFO "%s: cover is closed, "
-					 "card is now accessible\n",
-					 mmc_hostname(host->mmc));
+			mmc_info(host->mmc, "cover is closed, card is now accessible\n");
 			host->protect_card = 0;
 		}
 	} else {
 		if (!host->protect_card) {
-			printk(KERN_INFO "%s: cover is open, "
-					 "card is now inaccessible\n",
-					 mmc_hostname(host->mmc));
+			mmc_info(host->mmc, "cover is open, card is now inaccessible\n");
 			host->protect_card = 1;
 		}
 	}
@@ -1422,9 +1420,8 @@ static int omap_hsmmc_pre_dma_transfer(struct omap_hsmmc_host *host,
 
 	if (!next && data->host_cookie &&
 	    data->host_cookie != host->next_data.cookie) {
-		printk(KERN_WARNING "[%s] invalid cookie: data->host_cookie %d"
-		       " host->next_data.cookie %d\n",
-		       __func__, data->host_cookie, host->next_data.cookie);
+		pr_warn("[%s] invalid cookie: data->host_cookie %d host->next_data.cookie %d\n",
+			__func__, data->host_cookie, host->next_data.cookie);
 		data->host_cookie = 0;
 	}
 
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 7257738..8acdc4c 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -16,6 +16,9 @@
  *	1 and 3 byte data transfers not supported
  *	max block length up to 1023
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
@@ -327,7 +330,8 @@ static int pxamci_cmd_done(struct pxamci_host *host, unsigned int stat)
 		 */
 		if (cpu_is_pxa27x() &&
 		    (cmd->flags & MMC_RSP_136 && cmd->resp[0] & 0x80000000))
-			pr_debug("ignoring CRC from command %d - *risky*\n", cmd->opcode);
+			pr_debug("ignoring CRC from command %d - *risky*\n",
+				 cmd->opcode);
 		else
 			cmd->error = -EILSEQ;
 	}
@@ -399,7 +403,7 @@ static irqreturn_t pxamci_irq(int irq, void *devid)
 	if (ireg) {
 		unsigned stat = readl(host->base + MMC_STAT);
 
-		pr_debug("PXAMCI: irq %08x stat %08x\n", ireg, stat);
+		pr_debug("irq %08x stat %08x\n", ireg, stat);
 
 		if (ireg & END_CMD_RES)
 			handled |= pxamci_cmd_done(host, stat);
@@ -558,8 +562,8 @@ static void pxamci_dma_irq(int dma, void *devid)
 	if (dcsr & DCSR_ENDINTR) {
 		writel(BUF_PART_FULL, host->base + MMC_PRTBUF);
 	} else {
-		printk(KERN_ERR "%s: DMA error on channel %d (DCSR=%#x)\n",
-		       mmc_hostname(host->mmc), dma, dcsr);
+		mmc_err(host->mmc, "DMA error on channel %d (DCSR=%#x)\n",
+			dma, dcsr);
 		host->data->error = -EIO;
 		pxamci_data_done(host, 0);
 	}
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index a04f87d..ef11def 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
@@ -247,7 +249,7 @@ static void s3cmci_check_sdio_irq(struct s3cmci_host *host)
 {
 	if (host->sdio_irqen) {
 		if (gpio_get_value(S3C2410_GPE(8)) == 0) {
-			printk(KERN_DEBUG "%s: signalling irq\n", __func__);
+			pr_debug("%s: signalling irq\n", __func__);
 			mmc_signal_sdio_irq(host->mmc);
 		}
 	}
@@ -344,7 +346,7 @@ static void s3cmci_disable_irq(struct s3cmci_host *host, bool transfer)
 
 	local_irq_save(flags);
 
-	//printk(KERN_DEBUG "%s: transfer %d\n", __func__, transfer);
+	//pr_debug("%s: transfer %d\n", __func__, transfer);
 
 	host->irq_disabled = transfer;
 
@@ -983,7 +985,8 @@ static int s3cmci_setup_data(struct s3cmci_host *host, struct mmc_data *data)
 		 * one block being transferred. */
 
 		if (data->blocks > 1) {
-			pr_warning("%s: can't do non-word sized block transfers (blksz %d)\n", __func__, data->blksz);
+			pr_warn("%s: can't do non-word sized block transfers (blksz %d)\n",
+				__func__, data->blksz);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c31a334..f28b568 100644
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
@@ -30,8 +32,8 @@
 
 #define DRIVER_NAME "sdhci"
 
-#define DBG(f, x...) \
-	pr_debug(DRIVER_NAME " [%s()]: " f, __func__,## x)
+#define DBG(fmt, ...)						\
+	pr_debug("[%s()]: " fmt, __func__, ##__VA_ARGS__)
 
 #if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE) && \
 	defined(CONFIG_MMC_SDHCI_MODULE))
@@ -51,51 +53,51 @@ static void sdhci_tuning_timer(unsigned long data);
 
 static void sdhci_dumpregs(struct sdhci_host *host)
 {
-	printk(KERN_DEBUG DRIVER_NAME ": =========== REGISTER DUMP (%s)===========\n",
-		mmc_hostname(host->mmc));
-
-	printk(KERN_DEBUG DRIVER_NAME ": Sys addr: 0x%08x | Version:  0x%08x\n",
-		sdhci_readl(host, SDHCI_DMA_ADDRESS),
-		sdhci_readw(host, SDHCI_HOST_VERSION));
-	printk(KERN_DEBUG DRIVER_NAME ": Blk size: 0x%08x | Blk cnt:  0x%08x\n",
-		sdhci_readw(host, SDHCI_BLOCK_SIZE),
-		sdhci_readw(host, SDHCI_BLOCK_COUNT));
-	printk(KERN_DEBUG DRIVER_NAME ": Argument: 0x%08x | Trn mode: 0x%08x\n",
-		sdhci_readl(host, SDHCI_ARGUMENT),
-		sdhci_readw(host, SDHCI_TRANSFER_MODE));
-	printk(KERN_DEBUG DRIVER_NAME ": Present:  0x%08x | Host ctl: 0x%08x\n",
-		sdhci_readl(host, SDHCI_PRESENT_STATE),
-		sdhci_readb(host, SDHCI_HOST_CONTROL));
-	printk(KERN_DEBUG DRIVER_NAME ": Power:    0x%08x | Blk gap:  0x%08x\n",
-		sdhci_readb(host, SDHCI_POWER_CONTROL),
-		sdhci_readb(host, SDHCI_BLOCK_GAP_CONTROL));
-	printk(KERN_DEBUG DRIVER_NAME ": Wake-up:  0x%08x | Clock:    0x%08x\n",
-		sdhci_readb(host, SDHCI_WAKE_UP_CONTROL),
-		sdhci_readw(host, SDHCI_CLOCK_CONTROL));
-	printk(KERN_DEBUG DRIVER_NAME ": Timeout:  0x%08x | Int stat: 0x%08x\n",
-		sdhci_readb(host, SDHCI_TIMEOUT_CONTROL),
-		sdhci_readl(host, SDHCI_INT_STATUS));
-	printk(KERN_DEBUG DRIVER_NAME ": Int enab: 0x%08x | Sig enab: 0x%08x\n",
-		sdhci_readl(host, SDHCI_INT_ENABLE),
-		sdhci_readl(host, SDHCI_SIGNAL_ENABLE));
-	printk(KERN_DEBUG DRIVER_NAME ": AC12 err: 0x%08x | Slot int: 0x%08x\n",
-		sdhci_readw(host, SDHCI_ACMD12_ERR),
-		sdhci_readw(host, SDHCI_SLOT_INT_STATUS));
-	printk(KERN_DEBUG DRIVER_NAME ": Caps:     0x%08x | Caps_1:   0x%08x\n",
-		sdhci_readl(host, SDHCI_CAPABILITIES),
-		sdhci_readl(host, SDHCI_CAPABILITIES_1));
-	printk(KERN_DEBUG DRIVER_NAME ": Cmd:      0x%08x | Max curr: 0x%08x\n",
-		sdhci_readw(host, SDHCI_COMMAND),
-		sdhci_readl(host, SDHCI_MAX_CURRENT));
-	printk(KERN_DEBUG DRIVER_NAME ": Host ctl2: 0x%08x\n",
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
-		printk(KERN_DEBUG DRIVER_NAME ": ADMA Err: 0x%08x | ADMA Ptr: 0x%08x\n",
-		       readl(host->ioaddr + SDHCI_ADMA_ERROR),
-		       readl(host->ioaddr + SDHCI_ADMA_ADDRESS));
+		pr_debug("ADMA Err: 0x%08x | ADMA Ptr: 0x%08x\n",
+			 readl(host->ioaddr + SDHCI_ADMA_ERROR),
+			 readl(host->ioaddr + SDHCI_ADMA_ADDRESS));
 
-	printk(KERN_DEBUG DRIVER_NAME ": ===========================================\n");
+	pr_debug("===========================================\n");
 }
 
 /*****************************************************************************\
@@ -180,8 +182,8 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 	/* hw clears the bit when it's done */
 	while (sdhci_readb(host, SDHCI_SOFTWARE_RESET) & mask) {
 		if (timeout == 0) {
-			printk(KERN_ERR "%s: Reset 0x%x never completed.\n",
-				mmc_hostname(host->mmc), (int)mask);
+			mmc_err(host->mmc, "Reset 0x%x never completed\n",
+				(int)mask);
 			sdhci_dumpregs(host);
 			return;
 		}
@@ -394,7 +396,7 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 			break;
 	}
 
-	DBG("PIO transfer complete.\n");
+	DBG("PIO transfer complete\n");
 }
 
 static char *sdhci_kmap_atomic(struct scatterlist *sg, unsigned long *flags)
@@ -656,8 +658,8 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 	}
 
 	if (count >= 0xF) {
-		printk(KERN_WARNING "%s: Too large timeout requested for CMD%d!\n",
-		       mmc_hostname(host->mmc), cmd->opcode);
+		mmc_warn(host->mmc, "Too large timeout requested for CMD%d!\n",
+			 cmd->opcode);
 		count = 0xE;
 	}
 
@@ -724,9 +726,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
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
@@ -759,8 +760,7 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 		if (unlikely(broken)) {
 			for_each_sg(data->sg, sg, data->sg_len, i) {
 				if (sg->offset & 0x3) {
-					DBG("Reverting to PIO because of "
-						"bad alignment\n");
+					DBG("Reverting to PIO because of bad alignment\n");
 					host->flags &= ~SDHCI_REQ_USE_DMA;
 					break;
 				}
@@ -951,8 +951,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
 		if (timeout == 0) {
-			printk(KERN_ERR "%s: Controller never released "
-				"inhibit bit(s).\n", mmc_hostname(host->mmc));
+			mmc_err(host->mmc, "Controller never released inhibit bit(s)\n");
 			sdhci_dumpregs(host);
 			cmd->error = -EIO;
 			tasklet_schedule(&host->finish_tasklet);
@@ -973,8 +972,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	sdhci_set_transfer_mode(host, cmd);
 
 	if ((cmd->flags & MMC_RSP_136) && (cmd->flags & MMC_RSP_BUSY)) {
-		printk(KERN_ERR "%s: Unsupported response type!\n",
-			mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Unsupported response type!\n");
 		cmd->error = -EINVAL;
 		tasklet_schedule(&host->finish_tasklet);
 		return;
@@ -1123,8 +1121,7 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
 		& SDHCI_CLOCK_INT_STABLE)) {
 		if (timeout == 0) {
-			printk(KERN_ERR "%s: Internal clock never "
-				"stabilised.\n", mmc_hostname(host->mmc));
+			mmc_err(host->mmc, "Internal clock never stabilised\n");
 			sdhci_dumpregs(host);
 			return;
 		}
@@ -1530,8 +1527,7 @@ static int sdhci_start_signal_voltage_switch(struct mmc_host *mmc,
 		if (!(ctrl & SDHCI_CTRL_VDD_180))
 			return 0;
 		else {
-			printk(KERN_INFO DRIVER_NAME ": Switching to 3.3V "
-				"signalling voltage failed\n");
+			pr_info("Switching to 3.3V signalling voltage failed\n");
 			return -EIO;
 		}
 	} else if (!(ctrl & SDHCI_CTRL_VDD_180) &&
@@ -1589,8 +1585,7 @@ static int sdhci_start_signal_voltage_switch(struct mmc_host *mmc,
 		pwr |= SDHCI_POWER_ON;
 		sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);
 
-		printk(KERN_INFO DRIVER_NAME ": Switching to 1.8V signalling "
-			"voltage failed, retrying with S18R set to 0\n");
+		pr_info("Switching to 1.8V signalling voltage failed, retrying with S18R set to 0\n");
 		return -EAGAIN;
 	} else
 		/* No signal voltage switch required */
@@ -1696,10 +1691,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc)
 		spin_lock(&host->lock);
 
 		if (!host->tuning_done) {
-			printk(KERN_INFO DRIVER_NAME ": Timeout waiting for "
-				"Buffer Read Ready interrupt during tuning "
-				"procedure, falling back to fixed sampling "
-				"clock\n");
+			pr_info("Timeout waiting for Buffer Read Ready interrupt during tuning procedure, falling back to fixed sampling clock\n");
 			ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 			ctrl &= ~SDHCI_CTRL_TUNED_CLK;
 			ctrl &= ~SDHCI_CTRL_EXEC_TUNING;
@@ -1726,9 +1718,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc)
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 	} else {
 		if (!(ctrl & SDHCI_CTRL_TUNED_CLK)) {
-			printk(KERN_INFO DRIVER_NAME ": Tuning procedure"
-				" failed, falling back to fixed sampling"
-				" clock\n");
+			pr_info("Tuning procedure failed, falling back to fixed sampling clock\n");
 			err = -EIO;
 		}
 	}
@@ -1830,10 +1820,8 @@ static void sdhci_tasklet_card(unsigned long param)
 
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
-			printk(KERN_ERR "%s: Card removed during transfer!\n",
-				mmc_hostname(host->mmc));
-			printk(KERN_ERR "%s: Resetting controller.\n",
-				mmc_hostname(host->mmc));
+			mmc_err(host->mmc, "Card removed during transfer!\n");
+			mmc_err(host->mmc, "Resetting controller\n");
 
 			sdhci_reset(host, SDHCI_RESET_CMD);
 			sdhci_reset(host, SDHCI_RESET_DATA);
@@ -1922,8 +1910,7 @@ static void sdhci_timeout_timer(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->mrq) {
-		printk(KERN_ERR "%s: Timeout waiting for hardware "
-			"interrupt.\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Timeout waiting for hardware interrupt\n");
 		sdhci_dumpregs(host);
 
 		if (host->data) {
@@ -1968,9 +1955,8 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 	BUG_ON(intmask == 0);
 
 	if (!host->cmd) {
-		printk(KERN_ERR "%s: Got command interrupt 0x%08x even "
-			"though no command operation was in progress.\n",
-			mmc_hostname(host->mmc), (unsigned)intmask);
+		mmc_err(host->mmc, "Got command interrupt 0x%08x even though no command operation was in progress\n",
+			(unsigned)intmask);
 		sdhci_dumpregs(host);
 		return;
 	}
@@ -1999,8 +1985,7 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 	 */
 	if (host->cmd->flags & MMC_RSP_BUSY) {
 		if (host->cmd->data)
-			DBG("Cannot wait for busy signal when also "
-				"doing a data transfer");
+			DBG("Cannot wait for busy signal when also doing a data transfer\n");
 		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
 			return;
 
@@ -2068,9 +2053,8 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 			}
 		}
 
-		printk(KERN_ERR "%s: Got data interrupt 0x%08x even "
-			"though no data operation was in progress.\n",
-			mmc_hostname(host->mmc), (unsigned)intmask);
+		mmc_err(host->mmc, "Got data interrupt 0x%08x even though no data operation was in progress\n",
+			(unsigned)intmask);
 		sdhci_dumpregs(host);
 
 		return;
@@ -2085,7 +2069,7 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
 			!= MMC_BUS_TEST_R)
 		host->data->error = -EILSEQ;
 	else if (intmask & SDHCI_INT_ADMA_ERROR) {
-		printk(KERN_ERR "%s: ADMA error\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "ADMA error\n");
 		sdhci_show_adma_error(host);
 		host->data->error = -EIO;
 	}
@@ -2116,10 +2100,9 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
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
 
@@ -2154,8 +2137,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 		goto out;
 	}
 
-	DBG("*** %s got interrupt: 0x%08x\n",
-		mmc_hostname(host->mmc), intmask);
+	DBG("*** %s got interrupt: 0x%08x\n", mmc_hostname(host->mmc), intmask);
 
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
 		u32 present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
@@ -2199,8 +2181,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	intmask &= ~SDHCI_INT_ERROR;
 
 	if (intmask & SDHCI_INT_BUS_POWER) {
-		printk(KERN_ERR "%s: Card is consuming too much power!\n",
-			mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "Card is consuming too much power!\n");
 		sdhci_writel(host, SDHCI_INT_BUS_POWER, SDHCI_INT_STATUS);
 	}
 
@@ -2212,8 +2193,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	intmask &= ~SDHCI_INT_CARD_INT;
 
 	if (intmask) {
-		printk(KERN_ERR "%s: Unexpected interrupt 0x%08x.\n",
-			mmc_hostname(host->mmc), intmask);
+		mmc_err(host->mmc, "Unexpected interrupt 0x%08x\n", intmask);
 		sdhci_dumpregs(host);
 
 		sdhci_writel(host, intmask, SDHCI_INT_STATUS);
@@ -2368,8 +2348,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	host->version = (host->version & SDHCI_SPEC_VER_MASK)
 				>> SDHCI_SPEC_VER_SHIFT;
 	if (host->version > SDHCI_SPEC_300) {
-		printk(KERN_ERR "%s: Unknown controller version (%d). "
-			"You may experience problems.\n", mmc_hostname(mmc),
+		mmc_err(mmc, "Unknown controller version (%d). You may experience problems.\n",
 			host->version);
 	}
 
@@ -2405,9 +2384,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma) {
 			if (host->ops->enable_dma(host)) {
-				printk(KERN_WARNING "%s: No suitable DMA "
-					"available. Falling back to PIO.\n",
-					mmc_hostname(mmc));
+				mmc_warn(mmc, "No suitable DMA available. Falling back to PIO.\n");
 				host->flags &=
 					~(SDHCI_USE_SDMA | SDHCI_USE_ADMA);
 			}
@@ -2425,9 +2402,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		if (!host->adma_desc || !host->align_buffer) {
 			kfree(host->adma_desc);
 			kfree(host->align_buffer);
-			printk(KERN_WARNING "%s: Unable to allocate ADMA "
-				"buffers. Falling back to standard DMA.\n",
-				mmc_hostname(mmc));
+			mmc_warn(mmc, "Unable to allocate ADMA buffers. Falling back to standard DMA.\n");
 			host->flags &= ~SDHCI_USE_ADMA;
 		}
 	}
@@ -2453,9 +2428,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->max_clk == 0 || host->quirks &
 			SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN) {
 		if (!host->ops->get_max_clock) {
-			printk(KERN_ERR
-			       "%s: Hardware doesn't specify base clock "
-			       "frequency.\n", mmc_hostname(mmc));
+			mmc_err(mmc, "Hardware doesn't specify base clock frequency\n");
 			return -ENODEV;
 		}
 		host->max_clk = host->ops->get_max_clock(host);
@@ -2468,9 +2441,7 @@ int sdhci_add_host(struct sdhci_host *host)
 			host->timeout_clk = host->ops->get_timeout_clock(host);
 		} else if (!(host->quirks &
 				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)) {
-			printk(KERN_ERR
-			       "%s: Hardware doesn't specify timeout clock "
-			       "frequency.\n", mmc_hostname(mmc));
+			mmc_err(mmc, "Hardware doesn't specify timeout clock frequency\n");
 			return -ENODEV;
 		}
 	}
@@ -2660,8 +2631,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
 
 	if (mmc->ocr_avail == 0) {
-		printk(KERN_ERR "%s: Hardware doesn't report any "
-			"support voltages.\n", mmc_hostname(mmc));
+		mmc_err(mmc, "Hardware doesn't report any support voltages\n");
 		return -ENODEV;
 	}
 
@@ -2708,8 +2678,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->max_blk_size = (caps[0] & SDHCI_MAX_BLOCK_MASK) >>
 				SDHCI_MAX_BLOCK_SHIFT;
 		if (mmc->max_blk_size >= 3) {
-			printk(KERN_WARNING "%s: Invalid maximum block size, "
-				"assuming 512 bytes\n", mmc_hostname(mmc));
+			mmc_warn(mmc, "Invalid maximum block size, assuming 512 bytes\n");
 			mmc->max_blk_size = 0;
 		}
 	}
@@ -2747,7 +2716,7 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
 	if (IS_ERR(host->vmmc)) {
-		printk(KERN_INFO "%s: no vmmc regulator found\n", mmc_hostname(mmc));
+		mmc_info(mmc, "no vmmc regulator found\n");
 		host->vmmc = NULL;
 	} else {
 		regulator_enable(host->vmmc);
@@ -2776,10 +2745,10 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	mmc_add_host(mmc);
 
-	printk(KERN_INFO "%s: SDHCI controller on %s [%s] using %s\n",
-		mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
-		(host->flags & SDHCI_USE_ADMA) ? "ADMA" :
-		(host->flags & SDHCI_USE_SDMA) ? "DMA" : "PIO");
+	mmc_info(mmc, "SDHCI controller on %s [%s] using %s\n",
+		 host->hw_name, dev_name(mmc_dev(mmc)),
+		 (host->flags & SDHCI_USE_ADMA) ? "ADMA" :
+		 (host->flags & SDHCI_USE_SDMA) ? "DMA" : "PIO");
 
 	sdhci_enable_card_detection(host);
 
@@ -2809,8 +2778,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 		host->flags |= SDHCI_DEVICE_DEAD;
 
 		if (host->mrq) {
-			printk(KERN_ERR "%s: Controller removed during "
-				" transfer!\n", mmc_hostname(host->mmc));
+			mmc_err(host->mmc, "Controller removed during transfer!\n");
 
 			host->mrq->cmd->error = -ENOMEDIUM;
 			tasklet_schedule(&host->finish_tasklet);
@@ -2868,9 +2836,8 @@ EXPORT_SYMBOL_GPL(sdhci_free_host);
 
 static int __init sdhci_drv_init(void)
 {
-	printk(KERN_INFO DRIVER_NAME
-		": Secure Digital Host Controller Interface driver\n");
-	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Pierre Ossman\n");
+	pr_info("Secure Digital Host Controller Interface driver\n");
+	pr_info("Copyright(c) Pierre Ossman\n");
 
 	return 0;
 }
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 457c26e..b6b3425 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -631,8 +631,7 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	}
 
 	if (host->req) {
-		printk(KERN_ERR "%s : unfinished request detected\n",
-		       dev_name(&sock->dev));
+		dev_err(&sock->dev, "unfinished request detected\n");
 		mrq->cmd->error = -ETIMEDOUT;
 		goto err_out;
 	}
@@ -671,8 +670,7 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 					    r_data->flags & MMC_DATA_WRITE
 					    ? PCI_DMA_TODEVICE
 					    : PCI_DMA_FROMDEVICE)) {
-				printk(KERN_ERR "%s : scatterlist map failed\n",
-				       dev_name(&sock->dev));
+				dev_err(&sock->dev, "scatterlist map failed\n");
 				mrq->cmd->error = -ENOMEM;
 				goto err_out;
 			}
@@ -683,8 +681,7 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 						   ? PCI_DMA_TODEVICE
 						   : PCI_DMA_FROMDEVICE);
 			if (host->sg_len < 1) {
-				printk(KERN_ERR "%s : scatterlist map failed\n",
-				       dev_name(&sock->dev));
+				dev_err(&sock->dev, "scatterlist map failed\n");
 				tifm_unmap_sg(sock, &host->bounce_buf, 1,
 					      r_data->flags & MMC_DATA_WRITE
 					      ? PCI_DMA_TODEVICE
@@ -747,8 +744,7 @@ static void tifm_sd_end_cmd(unsigned long data)
 	host->req = NULL;
 
 	if (!mrq) {
-		printk(KERN_ERR " %s : no request to complete?\n",
-		       dev_name(&sock->dev));
+		dev_err(&sock->dev, "no request to complete?\n");
 		spin_unlock_irqrestore(&sock->lock, flags);
 		return;
 	}
@@ -786,10 +782,8 @@ static void tifm_sd_abort(unsigned long data)
 {
 	struct tifm_sd *host = (struct tifm_sd*)data;
 
-	printk(KERN_ERR
-	       "%s : card failed to respond for a long period of time "
-	       "(%x, %x)\n",
-	       dev_name(&host->dev->dev), host->req->cmd->opcode, host->cmd_flags);
+	dev_err(&host->dev->dev, "card failed to respond for a long period of time (%x, %x)\n",
+		host->req->cmd->opcode, host->cmd_flags);
 
 	tifm_eject(host->dev);
 }
@@ -905,8 +899,7 @@ static int tifm_sd_initialize_host(struct tifm_sd *host)
 	}
 
 	if (rc) {
-		printk(KERN_ERR "%s : controller failed to reset\n",
-		       dev_name(&sock->dev));
+		dev_err(&sock->dev, "controller failed to reset\n");
 		return -ENODEV;
 	}
 
@@ -931,9 +924,7 @@ static int tifm_sd_initialize_host(struct tifm_sd *host)
 	}
 
 	if (rc) {
-		printk(KERN_ERR
-		       "%s : card not ready - probe failed on initialization\n",
-		       dev_name(&sock->dev));
+		dev_err(&sock->dev, "card not ready - probe failed on initialization\n");
 		return -ENODEV;
 	}
 
@@ -953,8 +944,7 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 
 	if (!(TIFM_SOCK_STATE_OCCUPIED
 	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
-		printk(KERN_WARNING "%s : card gone, unexpectedly\n",
-		       dev_name(&sock->dev));
+		dev_warn(&sock->dev, "card gone, unexpectedly\n");
 		return rc;
 	}
 
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 8d185de..ce6a315 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -95,8 +95,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *pdev)
 	if (ret)
 		goto host_remove;
 
-	pr_info("%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-		(unsigned long)host->ctl, irq);
+	mmc_info(host->mmc, "at 0x%08lx irq %d\n",
+		 (unsigned long)host->ctl, irq);
 
 	return 0;
 
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index 1f16357..6cfe727 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/highmem.h>
@@ -80,41 +82,40 @@ static int tmio_mmc_next_sg(struct tmio_mmc_host *host)
 
 #ifdef CONFIG_MMC_DEBUG
 
-#define STATUS_TO_TEXT(a, status, i) \
-	do { \
-		if (status & TMIO_STAT_##a) { \
-			if (i++) \
-				printk(" | "); \
-			printk(#a); \
-		} \
-	} while (0)
+#define STATUS_TO_TEXT(a, status, printed)			\
+do {								\
+	if (status & TMIO_STAT_##a) {				\
+		pr_cont("%s%s", printed ? " | " : "", #a);	\
+		printed = true;					\
+	}							\
+} while (0)
 
 static void pr_debug_status(u32 status)
 {
-	int i = 0;
-	printk(KERN_DEBUG "status: %08x = ", status);
-	STATUS_TO_TEXT(CARD_REMOVE, status, i);
-	STATUS_TO_TEXT(CARD_INSERT, status, i);
-	STATUS_TO_TEXT(SIGSTATE, status, i);
-	STATUS_TO_TEXT(WRPROTECT, status, i);
-	STATUS_TO_TEXT(CARD_REMOVE_A, status, i);
-	STATUS_TO_TEXT(CARD_INSERT_A, status, i);
-	STATUS_TO_TEXT(SIGSTATE_A, status, i);
-	STATUS_TO_TEXT(CMD_IDX_ERR, status, i);
-	STATUS_TO_TEXT(STOPBIT_ERR, status, i);
-	STATUS_TO_TEXT(ILL_FUNC, status, i);
-	STATUS_TO_TEXT(CMD_BUSY, status, i);
-	STATUS_TO_TEXT(CMDRESPEND, status, i);
-	STATUS_TO_TEXT(DATAEND, status, i);
-	STATUS_TO_TEXT(CRCFAIL, status, i);
-	STATUS_TO_TEXT(DATATIMEOUT, status, i);
-	STATUS_TO_TEXT(CMDTIMEOUT, status, i);
-	STATUS_TO_TEXT(RXOVERFLOW, status, i);
-	STATUS_TO_TEXT(TXUNDERRUN, status, i);
-	STATUS_TO_TEXT(RXRDY, status, i);
-	STATUS_TO_TEXT(TXRQ, status, i);
-	STATUS_TO_TEXT(ILL_ACCESS, status, i);
-	printk("\n");
+	bool printed = false;
+	pr_debug("status: %08x = ", status);
+	STATUS_TO_TEXT(CARD_REMOVE, status, printed);
+	STATUS_TO_TEXT(CARD_INSERT, status, printed);
+	STATUS_TO_TEXT(SIGSTATE, status, printed);
+	STATUS_TO_TEXT(WRPROTECT, status, printed);
+	STATUS_TO_TEXT(CARD_REMOVE_A, status, printed);
+	STATUS_TO_TEXT(CARD_INSERT_A, status, printed);
+	STATUS_TO_TEXT(SIGSTATE_A, status, printed);
+	STATUS_TO_TEXT(CMD_IDX_ERR, status, printed);
+	STATUS_TO_TEXT(STOPBIT_ERR, status, printed);
+	STATUS_TO_TEXT(ILL_FUNC, status, printed);
+	STATUS_TO_TEXT(CMD_BUSY, status, printed);
+	STATUS_TO_TEXT(CMDRESPEND, status, printed);
+	STATUS_TO_TEXT(DATAEND, status, printed);
+	STATUS_TO_TEXT(CRCFAIL, status, printed);
+	STATUS_TO_TEXT(DATATIMEOUT, status, printed);
+	STATUS_TO_TEXT(CMDTIMEOUT, status, printed);
+	STATUS_TO_TEXT(RXOVERFLOW, status, printed);
+	STATUS_TO_TEXT(TXUNDERRUN, status, printed);
+	STATUS_TO_TEXT(RXRDY, status, printed);
+	STATUS_TO_TEXT(TXRQ, status, printed);
+	STATUS_TO_TEXT(ILL_ACCESS, status, printed);
+	pr_cont("\n");
 }
 
 #else
@@ -566,8 +567,8 @@ irqreturn_t tmio_mmc_irq(int irq, void *devid)
 		sd_ctrl_write16(host, CTL_SDIO_STATUS, sdio_status & ~TMIO_SDIO_MASK_ALL);
 
 		if (sdio_ireg && !host->sdio_irq_enabled) {
-			pr_warning("tmio_mmc: Spurious SDIO IRQ, disabling! 0x%04x 0x%04x 0x%04x\n",
-				   sdio_status, sdio_irq_mask, sdio_ireg);
+			pr_warn("Spurious SDIO IRQ, disabling! 0x%04x 0x%04x 0x%04x\n",
+				sdio_status, sdio_irq_mask, sdio_ireg);
 			tmio_mmc_enable_sdio_irq(mmc, 0);
 			goto out;
 		}
@@ -622,8 +623,8 @@ irqreturn_t tmio_mmc_irq(int irq, void *devid)
 		goto out;
 	}
 
-	pr_warning("tmio_mmc: Spurious irq, disabling! "
-		"0x%08x 0x%08x 0x%08x\n", status, irq_mask, ireg);
+	pr_warn("Spurious irq, disabling! 0x%08x 0x%08x 0x%08x\n",
+		status, irq_mask, ireg);
 	pr_debug_status(status);
 	tmio_mmc_disable_mmc_irqs(host, status & ~irq_mask);
 
@@ -645,8 +646,8 @@ static int tmio_mmc_start_data(struct tmio_mmc_host *host,
 		int blksz_2bytes = pdata->flags & TMIO_MMC_BLKSZ_2BYTES;
 
 		if (data->blksz < 2 || (data->blksz < 4 && !blksz_2bytes)) {
-			pr_err("%s: %d byte block unsupported in 4 bit mode\n",
-			       mmc_hostname(host->mmc), data->blksz);
+			mmc_err(host->mmc, "%d byte block unsupported in 4 bit mode\n",
+				data->blksz);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 4dfe2c0..20a5c42 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -8,6 +8,8 @@
  * your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/highmem.h>
@@ -582,7 +584,7 @@ static void via_sdc_send_command(struct via_crdr_mmc_host *host,
 		cmdctrl |= VIA_CRDR_SDCTRL_RSP_R3;
 		break;
 	default:
-		pr_err("%s: cmd->flag is not valid\n", mmc_hostname(host->mmc));
+		mmc_err(host->mmc, "cmd->flag is not valid\n");
 		break;
 	}
 
@@ -837,9 +839,8 @@ static void via_sdc_cmd_isr(struct via_crdr_mmc_host *host, u16 intmask)
 	BUG_ON(intmask == 0);
 
 	if (!host->cmd) {
-		pr_err("%s: Got command interrupt 0x%x even "
-		       "though no command operation was in progress.\n",
-		       mmc_hostname(host->mmc), intmask);
+		mmc_err(host->mmc, "Got command interrupt 0x%x even though no command operation was in progress\n",
+			intmask);
 		return;
 	}
 
@@ -916,8 +917,7 @@ static irqreturn_t via_sdc_isr(int irq, void *dev_id)
 
 	sd_status &= ~(VIA_CRDR_SDSTS_CMD_MASK | VIA_CRDR_SDSTS_DATA_MASK);
 	if (sd_status) {
-		pr_err("%s: Unexpected interrupt 0x%x\n",
-		       mmc_hostname(sdhost->mmc), sd_status);
+		mmc_err(sdhost->mmc, "Unexpected interrupt 0x%x\n", sd_status);
 		writew(sd_status, addrbase + VIA_CRDR_SDSTATUS);
 	}
 
@@ -940,9 +940,8 @@ static void via_sdc_timeout(unsigned long ulongdata)
 	spin_lock_irqsave(&sdhost->lock, flags);
 
 	if (sdhost->mrq) {
-		pr_err("%s: Timeout waiting for hardware interrupt."
-		       "cmd:0x%x\n", mmc_hostname(sdhost->mmc),
-		       sdhost->mrq->cmd->opcode);
+		mmc_err(sdhost->mmc, "Timeout waiting for hardware interrupt. cmd:0x%x\n",
+			sdhost->mrq->cmd->opcode);
 
 		if (sdhost->data) {
 			writel(VIA_CRDR_DMACTRL_SFTRST,
@@ -1004,8 +1003,7 @@ static void via_sdc_card_detect(struct work_struct *work)
 	status = readw(addrbase + VIA_CRDR_SDSTATUS);
 	if (!(status & VIA_CRDR_SDSTS_SLOTG)) {
 		if (host->mrq) {
-			pr_err("%s: Card removed during transfer!\n",
-			       mmc_hostname(host->mmc));
+			mmc_err(host->mmc, "Card removed during transfer!\n");
 			host->mrq->cmd->error = -ENOMEDIUM;
 			tasklet_schedule(&host->finish_tasklet);
 		}
@@ -1090,8 +1088,7 @@ static int __devinit via_sd_probe(struct pci_dev *pcidev,
 	u8  gatt;
 	int ret;
 
-	pr_info(DRV_NAME
-		": VIA SDMMC controller found at %s [%04x:%04x] (rev %x)\n",
+	pr_info("VIA SDMMC controller found at %s [%04x:%04x] (rev %x)\n",
 		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device,
 		(int)pcidev->revision);
 
@@ -1191,8 +1188,7 @@ static void __devexit via_sd_remove(struct pci_dev *pcidev)
 	mmiowb();
 
 	if (sdhost->mrq) {
-		printk(KERN_ERR "%s: Controller removed during "
-			"transfer\n", mmc_hostname(sdhost->mmc));
+		mmc_err(sdhost->mmc, "Controller removed during transfer\n");
 
 		/* make sure all DMA is stopped */
 		writel(VIA_CRDR_DMACTRL_SFTRST,
@@ -1224,8 +1220,7 @@ static void __devexit via_sd_remove(struct pci_dev *pcidev)
 	pci_release_regions(pcidev);
 	pci_disable_device(pcidev);
 
-	pr_info(DRV_NAME
-		": VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
+	pr_info("VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
 		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device);
 }
 
@@ -1338,8 +1333,7 @@ static struct pci_driver via_sd_driver = {
 
 static int __init via_sd_drv_init(void)
 {
-	pr_info(DRV_NAME ": VIA SD/MMC Card Reader driver "
-		"(C) 2008 VIA Technologies, Inc.\n");
+	pr_info("VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.\n");
 
 	return pci_register_driver(&via_sd_driver);
 }
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index e8f6e65..f219d18 100644
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
@@ -2381,8 +2384,8 @@ static void vub300_disconnect(struct usb_interface *interface)
 			vub300->interface = NULL;
 			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
-			pr_info("USB vub300 remote SDIO host controller[%d]"
-				" now disconnected", ifnum);
+			pr_info("USB vub300 remote SDIO host controller[%d] now disconnected\n",
+				ifnum);
 			return;
 		}
 	}
@@ -2448,29 +2451,29 @@ static int __init vub300_init(void)
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
index 62e5a4d..3766fb4 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -22,6 +22,8 @@
  * - On APIC systems the FIFO empty interrupt is sometimes lost.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -43,10 +45,8 @@
 
 #define DRIVER_NAME "wbsd"
 
-#define DBG(x...) \
-	pr_debug(DRIVER_NAME ": " x)
-#define DBGF(f, x...) \
-	pr_debug(DRIVER_NAME " [%s()]: " f, __func__ , ##x)
+#define DBG(fmt, ...)						\
+	pr_debug("[%s()]: " fmt, __func__ , ##__VA_ARGS__)
 
 /*
  * Device resources
@@ -194,7 +194,7 @@ static void wbsd_reset(struct wbsd_host *host)
 {
 	u8 setup;
 
-	printk(KERN_ERR "%s: Resetting chip\n", mmc_hostname(host->mmc));
+	mmc_err(host->mmc, "Resetting chip\n");
 
 	/*
 	 * Soft reset of chip (SD/MMC part).
@@ -721,9 +721,8 @@ static void wbsd_finish_data(struct wbsd_host *host, struct mmc_data *data)
 		 * Any leftover data?
 		 */
 		if (count) {
-			printk(KERN_ERR "%s: Incomplete DMA transfer. "
-				"%d bytes left.\n",
-				mmc_hostname(host->mmc), count);
+			mmc_err(host->mmc, "Incomplete DMA transfer. %d bytes left.\n",
+				count);
 
 			if (!data->error)
 				data->error = -EIO;
@@ -803,9 +802,8 @@ static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 		default:
 #ifdef CONFIG_MMC_DEBUG
-			printk(KERN_WARNING "%s: Data command %d is not "
-				"supported by this controller.\n",
-				mmc_hostname(host->mmc), cmd->opcode);
+			mmc_warn(host->mmc, "Data command %d is not supported by this controller\n",
+				 cmd->opcode);
 #endif
 			cmd->error = -EINVAL;
 
@@ -965,7 +963,7 @@ static void wbsd_reset_ignore(unsigned long data)
 
 	BUG_ON(host == NULL);
 
-	DBG("Resetting card detection ignore\n");
+	pr_debug("Resetting card detection ignore\n");
 
 	spin_lock_bh(&host->lock);
 
@@ -1019,18 +1017,17 @@ static void wbsd_tasklet_card(unsigned long param)
 
 	if (csr & WBSD_CARDPRESENT) {
 		if (!(host->flags & WBSD_FCARD_PRESENT)) {
-			DBG("Card inserted\n");
+			pr_debug("Card inserted\n");
 			host->flags |= WBSD_FCARD_PRESENT;
 
 			delay = 500;
 		}
 	} else if (host->flags & WBSD_FCARD_PRESENT) {
-		DBG("Card removed\n");
+		pr_debug("Card removed\n");
 		host->flags &= ~WBSD_FCARD_PRESENT;
 
 		if (host->mrq) {
-			printk(KERN_ERR "%s: Card removed during transfer!\n",
-				mmc_hostname(host->mmc));
+			mmc_err(host->mmc, "Card removed during transfer!\n");
 			wbsd_reset(host);
 
 			host->mrq->cmd->error = -ENOMEDIUM;
@@ -1095,7 +1092,7 @@ static void wbsd_tasklet_crc(unsigned long param)
 	if (!data)
 		goto end;
 
-	DBGF("CRC error\n");
+	DBG("CRC error\n");
 
 	data->error = -EILSEQ;
 
@@ -1119,7 +1116,7 @@ static void wbsd_tasklet_timeout(unsigned long param)
 	if (!data)
 		goto end;
 
-	DBGF("Timeout\n");
+	DBG("Timeout\n");
 
 	data->error = -ETIMEDOUT;
 
@@ -1326,8 +1323,8 @@ static int __devinit wbsd_scan(struct wbsd_host *host)
 			}
 
 			if (id != 0xFFFF) {
-				DBG("Unknown hardware (id %x) found at %x\n",
-					id, config_ports[i]);
+				pr_debug("Unknown hardware (id %x) found at %x\n",
+					 id, config_ports[i]);
 			}
 		}
 
@@ -1429,8 +1426,7 @@ free:
 	free_dma(dma);
 
 err:
-	printk(KERN_WARNING DRIVER_NAME ": Unable to allocate DMA %d. "
-		"Falling back on FIFO.\n", dma);
+	pr_warn("Unable to allocate DMA %d. Falling back on FIFO.\n", dma);
 }
 
 static void wbsd_release_dma(struct wbsd_host *host)
@@ -1664,9 +1660,7 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 	ret = wbsd_scan(host);
 	if (ret) {
 		if (pnp && (ret == -ENODEV)) {
-			printk(KERN_WARNING DRIVER_NAME
-				": Unable to confirm device presence. You may "
-				"experience lock-ups.\n");
+			pr_warn("Unable to confirm device presence. You may experience lock-ups.\n");
 		} else {
 			wbsd_free_mmc(dev);
 			return ret;
@@ -1688,10 +1682,7 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	if (pnp) {
 		if ((host->config != 0) && !wbsd_chip_validate(host)) {
-			printk(KERN_WARNING DRIVER_NAME
-				": PnP active but chip not configured! "
-				"You probably have a buggy BIOS. "
-				"Configuring chip manually.\n");
+			pr_warn("PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	} else
@@ -1720,17 +1711,17 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 
 	mmc_add_host(mmc);
 
-	printk(KERN_INFO "%s: W83L51xD", mmc_hostname(mmc));
+	mmc_info(mmc, "W83L51xD");
 	if (host->chip_id != 0)
-		printk(" id %x", (int)host->chip_id);
-	printk(" at 0x%x irq %d", (int)host->base, (int)host->irq);
+		pr_cont(" id %x", (int)host->chip_id);
+	pr_cont(" at 0x%x irq %d", (int)host->base, (int)host->irq);
 	if (host->dma >= 0)
-		printk(" dma %d", (int)host->dma);
+		pr_cont(" dma %d", (int)host->dma);
 	else
-		printk(" FIFO");
+		pr_cont(" FIFO");
 	if (pnp)
-		printk(" PnP");
-	printk("\n");
+		pr_cont(" PnP");
+	pr_cont("\n");
 
 	return 0;
 }
@@ -1796,7 +1787,7 @@ wbsd_pnp_probe(struct pnp_dev *pnpdev, const struct pnp_device_id *dev_id)
 	else
 		dma = -1;
 
-	DBGF("PnP resources: port %3x irq %d dma %d\n", io, irq, dma);
+	DBG("PnP resources: port %3x irq %d dma %d\n", io, irq, dma);
 
 	return wbsd_init(&pnpdev->dev, io, irq, dma, 1);
 }
@@ -1840,7 +1831,7 @@ static int wbsd_platform_suspend(struct platform_device *dev,
 	if (mmc == NULL)
 		return 0;
 
-	DBGF("Suspending...\n");
+	DBG("Suspending...\n");
 
 	host = mmc_priv(mmc);
 
@@ -1861,7 +1852,7 @@ static int wbsd_platform_resume(struct platform_device *dev)
 	if (mmc == NULL)
 		return 0;
 
-	DBGF("Resuming...\n");
+	DBG("Resuming...\n");
 
 	host = mmc_priv(mmc);
 
@@ -1885,7 +1876,7 @@ static int wbsd_pnp_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
 	if (mmc == NULL)
 		return 0;
 
-	DBGF("Suspending...\n");
+	DBG("Suspending...\n");
 
 	host = mmc_priv(mmc);
 
@@ -1900,7 +1891,7 @@ static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
 	if (mmc == NULL)
 		return 0;
 
-	DBGF("Resuming...\n");
+	DBG("Resuming...\n");
 
 	host = mmc_priv(mmc);
 
@@ -1909,10 +1900,7 @@ static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
 	 */
 	if (host->config != 0) {
 		if (!wbsd_chip_validate(host)) {
-			printk(KERN_WARNING DRIVER_NAME
-				": PnP active but chip not configured! "
-				"You probably have a buggy BIOS. "
-				"Configuring chip manually.\n");
+			pr_warn("PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	}
@@ -1973,9 +1961,8 @@ static int __init wbsd_drv_init(void)
 {
 	int result;
 
-	printk(KERN_INFO DRIVER_NAME
-		": Winbond W83L51xD SD/MMC card interface driver\n");
-	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Pierre Ossman\n");
+	pr_info("Winbond W83L51xD SD/MMC card interface driver\n");
+	pr_info("Copyright(c) Pierre Ossman\n");
 
 #ifdef CONFIG_PNP
 
@@ -2023,7 +2010,7 @@ static void __exit wbsd_drv_exit(void)
 		platform_driver_unregister(&wbsd_driver);
 	}
 
-	DBG("unloaded\n");
+	pr_debug("unloaded\n");
 }
 
 module_init(wbsd_drv_init);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0f83858..a381fb5 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -396,4 +396,18 @@ static inline int mmc_host_cmd23(struct mmc_host *host)
 {
 	return host->caps & MMC_CAP_CMD23;
 }
+
+__attribute__((format (printf, 3, 4)))
+int mmc_printk(const char *level, const struct mmc_host *host,
+	       const char *fmt, ...);
+
+#define mmc_err(host, fmt, ...)					\
+	mmc_printk(KERN_ERR, host, fmt, ##__VA_ARGS__)
+#define mmc_warn(host, fmt, ...)				\
+	mmc_printk(KERN_WARNING, host, fmt, ##__VA_ARGS__)
+#define mmc_info(host, fmt, ...)				\
+	mmc_printk(KERN_INFO, host, fmt, ##__VA_ARGS__)
+#define mmc_dbg(host, fmt, ...)					\
+	pr_debug("%s: " fmt, mmc_hostname(host), ##__VA_ARGS__)
+
 #endif /* LINUX_MMC_HOST_H */
-- 
1.7.6.405.gc1be0

