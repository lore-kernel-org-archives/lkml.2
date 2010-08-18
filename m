Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0HRTgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:36:05 -0400
Received: from walscop001.walsimou.com ([82.228.201.70]:27388 "EHLO
	bekkor.walsimou.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0HRTgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:36:03 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2010 15:36:02 EDT
Message-ID: <4C6C34DE.2050904@embtoolkit.org>
Date: Wed, 18 Aug 2010 21:30:38 +0200
From: Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Brian Norris <norris@broadcom.com>
CC: linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, mike@it-loops.com,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: nand: Fix regression in BBM detection
References: <1282155904-10113-1-git-send-email-norris@broadcom.com>
In-Reply-To: <1282155904-10113-1-git-send-email-norris@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 08:25 PM, Brian Norris wrote:
> Commit c7b28e25cb9beb943aead770ff14551b55fa8c79 caused a regression
> in detection of factory-set bad block markers, especially for certain
> small-page NAND. This fix removes some unneeded constraints on using
> NAND_SMALL_BADBLOCK_POS, making the detection code more correct.
>
> This regression can be seen, for example, in Hynix HY27US081G1M and
> similar.
>
> Signed-off-by: Brian Norris<norris@broadcom.com>
> ---
>   drivers/mtd/nand/nand_base.c |   10 +++-------
>   1 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index a3c7473..a22ed7b 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -2934,14 +2934,10 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
>   		chip->chip_shift = ffs((unsigned)(chip->chipsize>>  32)) + 32 - 1;
>
>   	/* Set the bad block position */
> -	if (!(busw&  NAND_BUSWIDTH_16)&&  (*maf_id == NAND_MFR_STMICRO ||
> -				(*maf_id == NAND_MFR_SAMSUNG&&
> -				 mtd->writesize == 512) ||
> -				*maf_id == NAND_MFR_AMD))
> -		chip->badblockpos = NAND_SMALL_BADBLOCK_POS;
> -	else
> +	if (mtd->writesize>  512 || (busw&  NAND_BUSWIDTH_16))
>   		chip->badblockpos = NAND_LARGE_BADBLOCK_POS;
> -
> +	else
> +		chip->badblockpos = NAND_SMALL_BADBLOCK_POS;
>
>   	/* Get chip options, preserve non chip based options */
>   	chip->options&= ~NAND_CHIPOPTIONS_MSK;
>    

Brian,
Sorry for the long delay!
I tested the above patch unfortunately it does not help in my case!
And when I go further and put a JFFS2 in that partition and boot the
board I have

(S3c2410 nand hardware ECC enable):
mtd->read(0x400 bytes from 0x1274000) returned ECC error
mtd->read(0x3c08 bytes from 0x12743f8) returned ECC error

(without S3c2410 nand hardware ECC enable):
uncorrectable error :
uncorrectable error :
uncorrectable error :
uncorrectable error :
mtd->read(0x400 bytes from 0x1274000) returned ECC error
uncorrectable error :
uncorrectable error :
uncorrectable error :
[...]
uncorrectable error :
uncorrectable error :
mtd->read(0x3c08 bytes from 0x12743f8) returned ECC error

Despite these errors I can actually use the board (no kernel panic)!
The part is Samsung K9F1208U0C - PCB0

Hope that helps!

Thanks,
AWG

