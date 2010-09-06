Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0IFCRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 22:17:25 -0400
Received: from bosmailout20.eigbox.net ([66.96.187.20]:43487 "EHLO
	bosmailout20.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab0IFCRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 22:17:24 -0400
X-Greylist: delayed 2139 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Sep 2010 22:17:24 EDT
X-EN-OrigOutIP: 10.20.18.12
X-EN-IMPSID: 3DdZ1f0010FdZ9W01DdZiH
Message-ID: <4C8445CF.8020406@yahoo.es>
Date: Mon, 06 Sep 2010 09:37:19 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Chris Ball <cjb@laptop.org>, Matt Fleming <matt@console-pimps.org>,
        Pierre Ossman <pierre@ossman.eu>, Ben Nizette <bn@niasdigital.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] mmc: Make ID freq configurable
References: <4C80187D.9000304@yahoo.es> <20100905201448.GA22819@console-pimps.org> <20100905204336.GA23574@void.printf.net> <20100905212218.GA23622@console-pimps.org>
In-Reply-To: <20100905212218.GA23622@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 202.70.59.41
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt, Chris,

Thanks both for reviewing.

I never noticed that the host wasn't released because my f_min was low enough
so that all frequencies would be tried. But yes, you're both right.

Before somebody else makes the remark: "unsigned freqs[]" can be declared as
const.

Below, I changed the order of the if/else/else, and whenever no more frequencies
can be tried, it will release the host before branching out.

Hein Tibosch

---

mmc-make-id-freq-configurable.patch (v5)

In the latest releases of the mmc driver, the freq during initialization
is set to a fixed 400 Khz. This was reportedly too fast for several
users. As there doesn't seem to be an ideal frequency which-works-for-all,
Pierre suggested to let the driver try several frequencies.

This patch implements that idea. It will try mmc-initialization using
several frequencies from an array 400, 300, 200 and 100.
I submitted it earlier but it's now adapted to and tested with kernel
2.6.36-rc3.

In case SDIO is detected but turns out broken, it'll still try to detect
SDMEM, also at different freqs.


Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Reviewed-and-Tested-by: Chris Ball <cjb@laptop.org>

---
diff -Nurp a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c	2010-08-29 23:36:04.000000000 +0800
+++ b/drivers/mmc/core/core.c	2010-09-06 09:16:35.000000000 +0800
@@ -907,12 +907,7 @@ static void mmc_power_up(struct mmc_host
 	 */
 	mmc_delay(10);

-	if (host->f_min > 400000) {
-		pr_warning("%s: Minimum clock frequency too high for "
-				"identification mode\n", mmc_hostname(host));
-		host->ios.clock = host->f_min;
-	} else
-		host->ios.clock = 400000;
+	host->ios.clock = host->f_init;

 	host->ios.power_mode = MMC_POWER_ON;
 	mmc_set_ios(host);
@@ -1404,6 +1399,8 @@ void mmc_rescan(struct work_struct *work
 	u32 ocr;
 	int err;
 	unsigned long flags;
+	int i;
+	const unsigned freqs[] = { 400000, 300000, 200000, 100000 };

 	spin_lock_irqsave(&host->lock, flags);

@@ -1443,55 +1440,70 @@ void mmc_rescan(struct work_struct *work
 	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
 		goto out;

-	mmc_claim_host(host);
+	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
+		mmc_claim_host(host);

-	mmc_power_up(host);
-	sdio_reset(host);
-	mmc_go_idle(host);
+		if (freqs[i] >= host->f_min)
+			host->f_init = freqs[i];
+		else if (!i || freqs[i-1] > host->f_min)
+			host->f_init = host->f_min;
+		else {
+			mmc_release_host(host);
+			goto out;
+		}
+		pr_info("%s: %s: trying to init card at %u Hz\n",
+			mmc_hostname(host), __func__, host->f_init);

-	mmc_send_if_cond(host, host->ocr_avail);
+		mmc_power_up(host);
+		sdio_reset(host);
+		mmc_go_idle(host);

-	/*
-	 * First we search for SDIO...
-	 */
-	err = mmc_send_io_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_sdio(host, ocr)) {
-			mmc_claim_host(host);
-			/* try SDMEM (but not MMC) even if SDIO is broken */
-			if (mmc_send_app_op_cond(host, 0, &ocr))
-				goto out_fail;
+		mmc_send_if_cond(host, host->ocr_avail);
+
+		/*
+		 * First we search for SDIO...
+		 */
+		err = mmc_send_io_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_sdio(host, ocr)) {
+				mmc_claim_host(host);
+				/*
+				 * Try SDMEM (but not MMC) even if SDIO
+				 * is broken.
+				*/
+				if (mmc_send_app_op_cond(host, 0, &ocr))
+					goto out_fail;
+
+				if (mmc_attach_sd(host, ocr))
+					mmc_power_off(host);
+			}
+			goto out;
+		}

+		/*
+		 * ...then normal SD...
+		 */
+		err = mmc_send_app_op_cond(host, 0, &ocr);
+		if (!err) {
 			if (mmc_attach_sd(host, ocr))
 				mmc_power_off(host);
+			goto out;
 		}
-		goto out;
-	}
-
-	/*
-	 * ...then normal SD...
-	 */
-	err = mmc_send_app_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_sd(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}

-	/*
-	 * ...and finally MMC.
-	 */
-	err = mmc_send_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_mmc(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}
+		/*
+		 * ...and finally MMC.
+		 */
+		err = mmc_send_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_mmc(host, ocr))
+				mmc_power_off(host);
+			goto out;
+		}

 out_fail:
-	mmc_release_host(host);
-	mmc_power_off(host);
-
+		mmc_release_host(host);
+		mmc_power_off(host);
+	}
 out:
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
diff -Nurp a/include/linux/mmc/host.h b/include/linux/mmc/host.h
--- a/include/linux/mmc/host.h	2010-08-29 23:36:04.000000000 +0800
+++ b/include/linux/mmc/host.h	2010-09-03 05:16:21.000000000 +0800
@@ -123,6 +123,7 @@ struct mmc_host {
 	const struct mmc_host_ops *ops;
 	unsigned int		f_min;
 	unsigned int		f_max;
+	unsigned int		f_init;
 	u32			ocr_avail;
 	struct notifier_block	pm_notify;

--


