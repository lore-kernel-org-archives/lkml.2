Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0ICXZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:25:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245Ab0ICXZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:25:49 -0400
Date: Fri, 3 Sep 2010 16:25:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Ball <cjb@laptop.org>
Cc: Hein_Tibosch <hein_tibosch@yahoo.es>, Pierre Ossman <pierre@ossman.eu>,
        Ben Nizette <bn@niasdigital.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v4] mmc: Make ID freq configurable
Message-Id: <20100903162504.e72f91c6.akpm@linux-foundation.org>
In-Reply-To: <20100903014757.GA23012@void.printf.net>
References: <4C80187D.9000304@yahoo.es>
	<20100903014757.GA23012@void.printf.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 02:47:57 +0100
Chris Ball <cjb@laptop.org> wrote:

> > -	mmc_send_if_cond(host, host->ocr_avail);
> > +		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
> 
> Need a loglevel here, and an mmc_hostname.  Something like:
> 
>                 pr_info("%s: %s: trying to init card at %u Hz\n",
>                         mmc_hostname(host), __func__, host->f_init);
> 
> > +		mmc_power_up(host);
> > +		sdio_reset(host);
> > +		mmc_go_idle(host);
> > 
> > -	/*
> > -	 * First we search for SDIO...
> > -	 */
> > -	err = mmc_send_io_op_cond(host, 0, &ocr);
> > -	if (!err) {
> > -		if (mmc_attach_sdio(host, ocr)) {
> > -			mmc_claim_host(host);
> > -			/* try SDMEM (but not MMC) even if SDIO is broken */
> > -			if (mmc_send_app_op_cond(host, 0, &ocr))
> > -				goto out_fail;
> > +		mmc_send_if_cond(host, host->ocr_avail);
> > +
> > +		/*
> > +		 * First we search for SDIO...
> > +		 */
> > +		err = mmc_send_io_op_cond(host, 0, &ocr);
> > +		if (!err) {
> > +			if (mmc_attach_sdio(host, ocr)) {
> > +				mmc_claim_host(host);
> > +				/* try SDMEM (but not MMC) even if SDIO is broken */
> 
> This breaks 80-chars, so:
> 
>                                 /*
>                                  * Try SDMEM (but not MMC) even if SDIO
>                                  * is broken.
>                                  */

yup.

--- a/drivers/mmc/core/core.c~mmc-make-id-freq-configurable-checkpatch-fixes
+++ a/drivers/mmc/core/core.c
@@ -1450,7 +1450,9 @@ void mmc_rescan(struct work_struct *work
 		else
 			host->f_init = host->f_min;
 
-		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
+		pr_info("%s: %s: trying to init card at %u Hz\n",
+			mmc_hostname(host), __func__, host->f_init);
+
 		mmc_power_up(host);
 		sdio_reset(host);
 		mmc_go_idle(host);
@@ -1464,7 +1466,10 @@ void mmc_rescan(struct work_struct *work
 		if (!err) {
 			if (mmc_attach_sdio(host, ocr)) {
 				mmc_claim_host(host);
-				/* try SDMEM (but not MMC) even if SDIO is broken */
+				/*
+				 * Try SDMEM (but not MMC) even if SDIO is
+				 * broken.
+				 */
 				if (mmc_send_app_op_cond(host, 0, &ocr))
 					goto out_fail;
 
diff -puN include/linux/mmc/host.h~mmc-make-id-freq-configurable-checkpatch-fixes include/linux/mmc/host.h
_

