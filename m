Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0HISev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:34:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57280 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0HISeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BB8hHf7ZTjJ16CKsvFQEr3xL2jKQ2+ELqA4fVJxDxZFtyDq5n3RMkYS2DXNMlyP8qX
         ntBNsNB5mzcPD7CBQFk8TSW1BX1NIQChKl+qE3DPdz9NmV02lnNwOGvIYdQNZ+EZCdEL
         UOX8OtGgCmZH51IaUb5PT4HiRMgrEHJJtW1z0=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-2-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-2-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 21:34:48 +0300
X-Google-Sender-Auth: xAKPYR5T_l06jiYMIKQyc4O9iMc
Message-ID: <AANLkTimuPK=1+xNMKfV=G1sSG60+=fa7eA3142JJZZ6p@mail.gmail.com>
Subject: Re: [PATCH 01/10] Replace ioctls with sysfs interface
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Creates per-device sysfs nodes in /sys/block/zram<id>/
> Currently following stats are exported:
>  - disksize
>  - num_reads
>  - num_writes
>  - invalid_io
>  - zero_pages
>  - orig_data_size
>  - compr_data_size
>  - mem_used_total
>
> By default, disksize is set to 0. So, to start using
> a zram device, fist write a disksize value and then
> initialize device by writing any positive value to
> initstate. For example:
>
>        # initialize /dev/zram0 with 50MB disksize
>        echo 50*1024*1024 | bc > /sys/block/zram0/disksize
>        echo 1 > /sys/block/zram0/initstate
>
> When done using a disk, issue reset to free its memory
> by writing any positive value to reset node:
>
>        echo 1 > /sys/block/zram0/reset
>
> This change also obviates the need for 'rzscontrol' utility.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Looks good to me (but I'm not a sysfs guy).

Acked-by: Pekka Enberg <penberg@kernel.org>

>  /* Module params (documentation at end) */
> -static unsigned int num_devices;
> +unsigned int num_devices;
> +
> +static void zram_stat_inc(u32 *v)
> +{
> +       *v = *v + 1;
> +}
> +
> +static void zram_stat_dec(u32 *v)
> +{
> +       *v = *v - 1;
> +}
> +
> +static void zram_stat64_add(struct zram *zram, u64 *v, u64 inc)
> +{
> +       spin_lock(&zram->stat64_lock);
> +       *v = *v + inc;
> +       spin_unlock(&zram->stat64_lock);
> +}
> +
> +static void zram_stat64_sub(struct zram *zram, u64 *v, u64 dec)
> +{
> +       spin_lock(&zram->stat64_lock);
> +       *v = *v - dec;
> +       spin_unlock(&zram->stat64_lock);
> +}
> +
> +static void zram_stat64_inc(struct zram *zram, u64 *v)
> +{
> +       zram_stat64_add(zram, v, 1);
> +}

These could probably use atomic_inc(), atomic64_inc(), and friends, no?
