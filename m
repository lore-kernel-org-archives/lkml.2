Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2KIAky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:40:54 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41684 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2KIAkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:40:52 -0500
Message-ID: <509C5110.5090809@pobox.com>
Date: Thu, 08 Nov 2012 19:40:48 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ed Cashin <ecashin@coraid.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] aoe: provide ATA identify device content to user
 on request
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com> <9a089f76a8e21e64c89556d155833bcb286e48be.1352316179.git.ecashin@coraid.com>
In-Reply-To: <9a089f76a8e21e64c89556d155833bcb286e48be.1352316179.git.ecashin@coraid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 11:32 AM, Ed Cashin wrote:
> This patch makes the aoe driver follow expected behavior when
> the user uses ioctl to get the ATA device identify information.
>
> Signed-off-by: Ed Cashin <ecashin@coraid.com>
> ---
>   drivers/block/aoe/aoe.h    |    1 +
>   drivers/block/aoe/aoeblk.c |   30 ++++++++++++++++++++++++++++++
>   drivers/block/aoe/aoecmd.c |   16 ++++++++++++++++
>   3 files changed, 47 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
> index 536942b..f6e0c03 100644
> --- a/drivers/block/aoe/aoe.h
> +++ b/drivers/block/aoe/aoe.h
> @@ -169,6 +169,7 @@ struct aoedev {
>   	struct aoetgt *htgt;	/* target needing rexmit assistance */
>   	ulong ntargets;
>   	ulong kicked;
> +	char ident[512];
>   };
>
>   /* kthread tracking */
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index 56736cd..7ba0fcf 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -17,6 +17,7 @@
>   #include <linux/mutex.h>
>   #include <linux/export.h>
>   #include <linux/moduleparam.h>
> +#include <scsi/sg.h>
>   #include "aoe.h"
>
>   static DEFINE_MUTEX(aoeblk_mutex);
> @@ -212,9 +213,38 @@ aoeblk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>   	return 0;
>   }
>
> +static int
> +aoeblk_ioctl(struct block_device *bdev, fmode_t mode, uint cmd, ulong arg)
> +{
> +	struct aoedev *d;
> +
> +	if (!arg)
> +		return -EINVAL;
> +
> +	d = bdev->bd_disk->private_data;
> +	if ((d->flags & DEVFL_UP) == 0) {
> +		pr_err("aoe: disk not up\n");
> +		return -ENODEV;
> +	}
> +
> +	if (cmd == HDIO_GET_IDENTITY) {
> +		if (!copy_to_user((void __user *) arg, &d->ident,
> +			sizeof(d->ident)))
> +			return 0;
> +		return -EFAULT;
> +	}
> +
> +	/* udev calls scsi_id, which uses SG_IO, resulting in noise */
> +	if (cmd != SG_IO)
> +		pr_info("aoe: unknown ioctl 0x%x\n", cmd);
> +
> +	return -ENOTTY;
> +}
> +
>   static const struct block_device_operations aoe_bdops = {
>   	.open = aoeblk_open,
>   	.release = aoeblk_release,
> +	.ioctl = aoeblk_ioctl,
>   	.getgeo = aoeblk_getgeo,
>   	.owner = THIS_MODULE,
>   };
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 3ce01f6..c4ff70b 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -799,6 +799,17 @@ aoecmd_sleepwork(struct work_struct *work)
>   }
>
>   static void
> +ata_ident_fixstring(u16 *id, int ns)
> +{
> +	u16 s;
> +
> +	while (ns-- > 0) {
> +		s = *id;
> +		*id++ = s >> 8 | s << 8;
> +	}
> +}
> +
> +static void
>   ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
>   {
>   	u64 ssize;
> @@ -833,6 +844,11 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
>   		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
>   	}
>
> +	ata_ident_fixstring((u16 *) &id[10<<1], 10);	/* serial */
> +	ata_ident_fixstring((u16 *) &id[23<<1], 4);	/* firmware */
> +	ata_ident_fixstring((u16 *) &id[27<<1], 20);	/* model */

This duplicates ata_id_string() and/or ata_id_c_string(), does it not?



