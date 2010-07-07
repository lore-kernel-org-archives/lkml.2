Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0GGPHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:07:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab0GGPGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100707111723.24979.32020.sendpatchset@ahunter-work.research.nokia.com>
References: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
	<20100707111723.24979.32020.sendpatchset@ahunter-work.research.nokia.com>
Date: Wed, 7 Jul 2010 11:06:01 -0400
Message-ID: <AANLkTinfDOlL7iKP4Qmb0J4xq_I_nNEnSbokCOkYmCSn@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] mmc: Add erase, secure erase, trim and secure trim 
	operations
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 7:17 AM, Adrian Hunter <adrian.hunter@nokia.com> wrote:
> From 7f01ad3c4be6ec09318176db12db66f353b526e0 Mon Sep 17 00:00:00 2001

> SD/MMC cards tend to support an erase operation.  In addition,
> eMMC v4.4 cards can support secure erase, trim and secure trim
> operations that are all variants of the basic erase command.

This is great. I am interested primarily in SD media.

Please forgive my naive perspective: it seems that with the features
enabled by this patchset and a filesystem that is capable of issuing
erase block commands, the wear-leveling on SD media will be improved
-- much like with CF TRIM commands. Do you also think that is the
case? I would be very interested in hearing your expert opinion on
this.

I have a couple comments regarding mostly the SD support introduced in
this patch. Patches 2..5 of 5 seem fine to me but I'm not sure I'm
qualified to add acks or reviewed-by's.

> +int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
> +             unsigned int arg)
> +{
> +       unsigned int rem, to = from + nr;
> +
> +       if (!(card->host->caps & MMC_CAP_ERASE) ||
> +           !(card->csd.cmdclass & CCC_ERASE))
> +               return -EOPNOTSUPP;
> +
> +       if (!card->erase_size)
> +               return -EOPNOTSUPP;
> +
> +       if (mmc_card_sd(card) && arg != MMC_ERASE_ARG)
> +               return -EOPNOTSUPP;
> +
> +       if ((arg & MMC_SECURE_ARGS) &&
> +           !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
> +               return -EOPNOTSUPP;
> +
> +       if ((arg & MMC_TRIM_ARGS) &&
> +           !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
> +               return -EOPNOTSUPP;
> +

> +int mmc_can_trim(struct mmc_card *card)
> +{
> +       if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN)
> +               return 1;
> +       return 0;
> +}
> +EXPORT_SYMBOL(mmc_can_trim);

It looks like mmc_can_trim(card) would return true when
mmc_card_sd(card) is true; but the mmc_erase function will return
-EOPNOTSUPP in such a case. I think that this results in the
mmc_blk_issue_discard_rq function (from 2/5) also returning
-EOPNOTSUPP whenever mmc_card_sd(card) is true:

>From 2/5:
+       if (mmc_can_trim(card))
+               arg = MMC_TRIM_ARG;
+       else
+               arg = MMC_ERASE_ARG;
+
+       err = mmc_erase(card, from, nr, arg);

Also, there is some duplication between the sec_feature_support
checking in mmc_erase and in the mmc_can* functions; If mmc_erase
could call the mmc_can_* functions then the the bit-checking logic
could be centralized.


> /*
> + * Fetch and process SD Status register.
> + */
> +static int mmc_read_ssr(struct mmc_card *card)
> +{

It looks like the conventional function prefix for SD-specific
functions in the rest of this file is mmc_sd_ ; 'mmc_read_ssr' ->
'mmc_sd_read_ssr'  or -> 'mmc_read_sd_sr' perhaps?

> +       ssr = kmalloc(64, GFP_KERNEL);

Why '64' instead of 'sizeof(*ssr)' ?

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
