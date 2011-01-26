Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1AZRmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:42:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60455 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZRme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:42:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=haz5SeIvQZZY2+4EzwLcfIH46eEfUNB1F19FXb1FWpHgCz2cRCDUbot6Ho1q/FJSXw
         G1U7sgJptp2ycg92NeWq341WqQ/lmBIaB6vbgMqDqI0J1Qo7Wax2CudsPVmNuZBJoGMF
         PU/5lX55EYBT/wzK/9kDEfi88yzDkySFTHQ6g=
MIME-Version: 1.0
In-Reply-To: <20110126172317.GD8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172317.GD8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:42:33 +0200
X-Google-Sender-Auth: I54H_LBr2QVw0Wo5Mly1CaP8nYE
Message-ID: <AANLkTikLCJXhVG9FRmmYznRG+9Gz4U8m-SoeasZyPy39@mail.gmail.com>
Subject: Re: [PATCH 2/7] zram: Prevent overflow in logical block size
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:23 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> On a 64K page kernel, the value PAGE_SIZE passed to
> blk_queue_logical_block_size would overflow the logical block size
> argument (resulting in setting it to 0).
>
> Take the minimum of PAGE_SIZE or 4096 and use this for the block device
> logical block size.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
>  drivers/staging/zram/zram_drv.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index d0e9e02..d5e0275 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -621,7 +621,8 @@ static int create_device(struct zram *zram, int device_id)
>         * and n*PAGE_SIZED sized I/O requests.
>         */
>        blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
> -       blk_queue_logical_block_size(zram->disk->queue, PAGE_SIZE);
> +       blk_queue_logical_block_size(zram->disk->queue,
> +                       (unsigned short) min_t(unsigned int, PAGE_SIZE, 4096));

I don't get it. No architecture supports PAGE_SIZE less than 4K so
that expression always ends up being 4096, no?

>        blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>        blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
>
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
