Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1E0E5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:57:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37266 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1E0E5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r9q06Y/XQ3tw5HVdYiIaw8Tw3A5KHDzv8T74udbNZBdU32zpDdyPQfyvsCOMbwJFsC
         kI5yc0e7f2yyNTJYN7rsP11XE8xmlMLnIa4jUD/1dHJKg6VaGpKOoWzt0JqFFTT9CJW3
         Ge2w4bP7QFi9us2OipOEg0opbiFv5oTSaSrno=
Subject: Re: [PATCH] loop: export module parameters
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
In-Reply-To: <1306302242-7019-1-git-send-email-namhyung@gmail.com>
References: <1306302242-7019-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 13:57:38 +0900
Message-ID: <1306472258.2544.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-25 (수), 14:44 +0900, Namhyung Kim:
> Export 'max_loop' and 'max_part' parameters to sysfs so user can know
> that how many devices are allowed and how many partitions are supported.
> 
> If 'max_loop' is 0, there is no restriction on the number of loop devices.
> User can create/use the devices as many as minor numbers available. If
> 'max_part' is 0, it means simply the device doesn't support partitioning.
> 
> Also note that 'max_part' can be adjusted to power of 2 minus 1 form if
> needed. User should check this value after the module loading if he/she
> want to use that number correctly (i.e. fdisk, mknod, etc.).
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Laurent Vivier <Laurent.Vivier@bull.net>
> ---
>  drivers/block/loop.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c59a672a3de0..76c8da78212b 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1540,9 +1540,9 @@ static const struct block_device_operations lo_fops = {
>   * And now the modules code and kernel interface.
>   */
>  static int max_loop;
> -module_param(max_loop, int, 0);
> +module_param(max_loop, int, S_IRUGO);
>  MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
> -module_param(max_part, int, 0);
> +module_param(max_part, int, S_IRUGO);
>  MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
> @@ -1688,9 +1688,20 @@ static int __init loop_init(void)
>  	 */
>  
>  	part_shift = 0;
> -	if (max_part > 0)
> +	if (max_part > 0) {
>  		part_shift = fls(max_part);
>  
> +		/*
> +		 * Adjust max_part according to part_shift as it is exported
> +		 * to user space so that user can decide correct minor number
> +		 * if [s]he want to create more devices.
> +		 *
> +		 * Note that -1 is required because partition 0 is reserved
> +		 * for the whole disk.
> +		 */
> +		max_part = (1UL << part_shift) - 1;
> +	}
> +
>  	if ((1UL << part_shift) > DISK_MAX_PARTS)
>  		return -EINVAL;
>  

Hi Jens,

Could you please consider applying this in your tree too? It's exactly
the same thing what I did for brd series.

Thanks.


-- 
Regards,
Namhyung Kim


