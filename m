Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab0E1Vv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:51:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab0E1Vvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:51:55 -0400
Date: Fri, 28 May 2010 14:51:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 2/2] mmc: implement SD-combo (IO+mem) support
Message-Id: <20100528145150.5257af9f.akpm@linux-foundation.org>
In-Reply-To: <2-1000-12432-1274803827-7569@rere.qmqm.pl>
References: <1-1000-12432-1274803827-7569@rere.qmqm.pl>
	<2-1000-12432-1274803827-7569@rere.qmqm.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 18:10:28 +0200 (CEST)
Micha__ Miros__aw <mirq-linux@rere.qmqm.pl> wrote:

> ---

There's really nothing at all to be said?  I don't even know what
"SD-combo" _is_.  Help us out here!

Why do we need this patch?  What happens if we don't have it?  Where's
the value to our users?  etcetera.


>
> ...
>
> @@ -144,10 +145,10 @@ static int sdio_enable_wide(struct mmc_card *card)
>  	u8 ctrl;
>  
>  	if (!(card->host->caps & MMC_CAP_4_BIT_DATA))
> -		return 0;
> +		return -EOPNOTSUPP;

grr.

"The requested operation is not supported on this type of object. 
 This usually occurs if you are trying to accept(2) a non SOCK_STREAM
 socket."

So if this EOPNOTSUPP gets propagated back to userspace, our poor user
will be looking at his networking code wondering what he did wrong!

Please, just because an error code sounds appropriate, that doesn't
mean that it was the correct thing to use.  ENXIO might be appropriate,
but when in doubt, plain old EIO is good.

> +static int sdio_enable_hs(struct mmc_card *card)
> +{
> +	int err;
> +
> +	err = mmc_sdio_switch_hs(card, true);
> +	if (err)
> +		return err;
> +
> +	if (card->type == MMC_TYPE_SD_COMBO) {
> +		err = mmc_sd_switch_hs(card);
> +		if (err == -EOPNOTSUPP)
> +			mmc_sdio_switch_hs(card, false);
> +	}

Now, if the EOPNOTSUPP is purely for internal use and never gets
propagated back to userspace then I _guess_ that's acceptable.  It's a
kind of internal overloading of an inappropriate identifier for MMC's
own usage.

But it would be clearer and cleaner to not borrow the Unix errnos in
this fashion.  Better to define a set of MMC-specific error codes and
put them in an MMC-specific header file.

> @@ -295,6 +356,34 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
>  
>  	card->type = MMC_TYPE_SDIO;
>  
> +	if (!oldcard || oldcard->type == MMC_TYPE_SDIO) {
> +		u32 cid[4];
> +
> +		err = mmc_sd_get_cid(host, host->ocr & ocr, cid);
> +		if (!err) {
> +			/* this is SD-combo card */
> +			if (oldcard && oldcard->type == MMC_TYPE_SDIO) {
> +				err = -ENOENT;
> +				goto remove;
> +			}
> +			card->type = MMC_TYPE_SD_COMBO;
> +			memcpy(card->raw_cid, cid, sizeof(card->raw_cid));
> +		}
> +	} else if (oldcard->type == MMC_TYPE_SD_COMBO) {
> +		u32 cid[4];
> +
> +		err = mmc_sd_get_cid(host, host->ocr & ocr, cid);
> +		if (err) {
> +			/* this is SDIO-only card */
> +			goto remove;
> +		}
> +
> +		if (memcmp(cid, oldcard->raw_cid, sizeof(cid)) != 0) {
> +			err = -ENOENT;
> +			goto remove;
> +		}
> +	}

Be aware that gcc has a habit of being inefficient with local
variables.  It will probably allocate 32 bytes of stack for the above
two cid[] arrays.  But it could have allocated just 16 bytes.

It's not a big problem in this particular case, but it should be
remembered.  Unfortunately any C-level workaround for this involves
making the source code nastier :(


