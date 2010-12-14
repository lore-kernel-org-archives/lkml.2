Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab0LNPNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:13:12 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:51020 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0LNPNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fRjCx0z2lGYVZJ7LpgiwSz+9chWpLjFHGdOh3wdYCYsr0c4uuly93ZUXqujUUdNuNk
         4/PfYlm7GiI7z1bUm76q1PluRvgZRY7kAQQaWHg+q3fEBzSAU3eoAU82uzNom+6xg3RU
         3ka6Cp1e3kYmI+YrIYTXNqL7B038aDJqOit0c=
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Liu <r64343@freescale.com>
Cc: David.Woodhouse@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1290156045-11719-1-git-send-email-r64343@freescale.com>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 17:12:37 +0200
Message-ID: <1292339557.2538.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 16:40 +0800, Jason Liu wrote:
> When run mtd_oobtest case, there will be one error for step(4),
> which turned out it need add one check for out of page read in
> nand_do_read_oob just like mtd_do_write_oob did it already.
> This commit also fix one typo error for comments in mtd_do_write_oob
> 
> Signed-off-by: Jason Liu <r64343@freescale.com>
> ---
>  drivers/mtd/nand/nand_base.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 1f75a1b..75d199e 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -1782,6 +1782,13 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
>  	else
>  		len = mtd->oobsize;
>  
> +	/* Do not allow read past end of page */
> +	if ((ops->ooboffs + readlen) > len) {
> +		DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt to read "
> +				"past end of page\n", __func__);
> +		return -EINVAL;
> +	}

As you reported to me in a private e-mail (although I prefer to always
have a public ML in CC when dealing with open source stuff) this patch
is wrong. Indeed, it limits the maximum amount of bytes which can be
read at one go to the OOB size, which is incorrect, because
mtd->read_oob() allows reading multiple pages at a time, see comment
near "struct mtd_oob_ops" at include/linux/mtd/mtd.h. So this patch
breaks ABI and hence, has to be reverted.

>  	if (unlikely(ops->ooboffs >= len)) {
>  		DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt to start read "
>  					"outside oob\n", __func__);

Side note: nand_base.c has a bunch of senseless unlikely() hints, would
be nice to clean that up some day.

> -	/* Do not allow reads past end of device */
> +	/* Do not allow write past end of device */

Care to make this a separate clean-up patch meanwhile?

Thank!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

