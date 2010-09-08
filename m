Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0IHO0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:26:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58741 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab0IHOZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HkZXt38mN4dQ4RDQyPj+fEGPGPCywymg0RZogVO9plkKOLG5CijokzDSpdPLk1np8N
         s8spuqZm6HaoWYSnB4d+EBJPwzokp8Bg/8m4GFY1YNMssYQ4V9G1X92qTt45gMppDbLO
         fzCo5SiDN1V4u+RNeK6LFV/86dBpm0K8d1aRA=
MIME-Version: 1.0
In-Reply-To: <20100820221323.GC8535@lixom.net>
References: <20100818041333.GA14149@lixom.net>
	<20100818171636.0625b668.akpm@linux-foundation.org>
	<20100819032230.GA21980@lixom.net>
	<20100820010242.GA29588@lixom.net>
	<20100820221323.GC8535@lixom.net>
Date: Wed, 8 Sep 2010 22:25:58 +0800
Message-ID: <AANLkTikLLwfSXbnjPByXTktEFFVueeAd7HZS5ft-rj-m@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: add config and runtime option for number of
 mmcblk minors
From: Lei Wen <adrian.wenl@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Baines <msb@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Aug 21, 2010 at 6:13 AM, Olof Johansson <olof@lixom.net> wrote:
> The old limit of number of minor numbers per mmcblk device was hardcoded
> at 8. This isn't enough for some of the more elaborate partitioning
> schemes, for example those used by Chrome OS.
>
> Since there might be a bunch of systems out there with static /dev
> contents that relies on the old numbering scheme, let's make it a
> build-time option with the default set to the previous 8.
>
> Also provide a boot/modprobe-time parameter to override the config
> default: mmcblk.perdev_minors.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Mandeep Baines <msb@chromium.org>
>
> ---
>
> Andrew, sorry for the churn but Mandeep had a couple of good points that
> needed addressing.
>
> Changes since v1:
>        * Runtime override of config default
>        * Better help text
>        * DIV_ROUND_UP for max_devices calculation
>        * Clarify mmcblk device count limitations
>
> Changes since v2 based on feedback from Mandeep Baines:
>        * DIV_ROUND_UP is doing the wrong thing, we'll end up using
>          the last fractional range of minors which we shouldn't.
>        * Documentation/devices.txt update
>        * No need to compute max_devices twice, just do it at runtime.
>        * Permission fix for the module_param -- it's readonly.
>
>  Documentation/devices.txt |    6 ++++++
>  drivers/mmc/card/Kconfig  |   17 +++++++++++++++++
>  drivers/mmc/card/block.c  |   41 ++++++++++++++++++++++++++++++-----------
>  3 files changed, 53 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 1d83d12..fdf3821 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -2518,6 +2518,12 @@ Your cooperation is appreciated.
>                  8 = /dev/mmcblk1      Second SD/MMC card
>                    ...
>
> +               The start of next SD/MMC card can be configured with
> +               CONFIG_MMC_BLOCK_MINORS, or overridden at boot/modprobe
> +               time using the mmcblk.perdev_minors option. That would
> +               bump the offset between each card to be the configured
> +               value instead of the default 8.
> +
>  179 char       CCube DVXChip-based PCI products
>                  0 = /dev/dvxirq0      First DVX device
>                  1 = /dev/dvxirq1      Second DVX device
> diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
> index 3f2a912..57e4416 100644
> --- a/drivers/mmc/card/Kconfig
> +++ b/drivers/mmc/card/Kconfig
> @@ -14,6 +14,23 @@ config MMC_BLOCK
>          mount the filesystem. Almost everyone wishing MMC support
>          should say Y or M here.
>
> +config MMC_BLOCK_MINORS
> +       int "Number of minors per block device"
> +       range 4 256
> +       default 8
> +       help
> +         Number of minors per block device. One is needed for every
> +         partition on the disk (plus one for the whole disk).
> +
> +         Number of total MMC minors available is 256, so your number
> +         of supported block devices will be limited to 256 divided
> +         by this number.
> +
> +         Default is 8 to be backwards compatible with previous
> +         hardwired device numbering.
> +
> +         If unsure, say 8 here.
> +
>  config MMC_BLOCK_BOUNCE
>        bool "Use bounce buffer for simple hosts"
>        depends on MMC_BLOCK
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index cb9fbc8..ec94f56 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -43,14 +43,26 @@
>  #include "queue.h"
>
>  MODULE_ALIAS("mmc:block");
> +#ifdef MODULE_PARAM_PREFIX
> +#undef MODULE_PARAM_PREFIX
> +#endif
> +#define MODULE_PARAM_PREFIX "mmcblk."
> +
> +
> +/*
> + * The defaults come from config options but can be overriden by module
> + * or bootarg options.
> + */
> +static int perdev_minors = CONFIG_MMC_BLOCK_MINORS;
>
>  /*
> - * max 8 partitions per card
> + * We've only got one major, so number of mmcblk devices is
> + * limited to 256 / number of minors per device.
>  */
> -#define MMC_SHIFT      3
> -#define MMC_NUM_MINORS (256 >> MMC_SHIFT)
> +static int max_devices;
>
> -static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
> +/* 256 minors, so at most 256 separate devices */
> +static DECLARE_BITMAP(dev_use, 256);
>
>  /*
>  * There is one mmc_blk_data per slot.
> @@ -66,6 +78,9 @@ struct mmc_blk_data {
>
>  static DEFINE_MUTEX(open_lock);
>
> +module_param(perdev_minors, int, 0444);
> +MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
> +
>  static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
>  {
>        struct mmc_blk_data *md;
> @@ -87,10 +102,10 @@ static void mmc_blk_put(struct mmc_blk_data *md)
>        md->usage--;
>        if (md->usage == 0) {
>                int devmaj = MAJOR(disk_devt(md->disk));
> -               int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
> +               int devidx = MINOR(disk_devt(md->disk)) / perdev_minors;
>
>                if (!devmaj)
> -                       devidx = md->disk->first_minor >> MMC_SHIFT;
> +                       devidx = md->disk->first_minor / perdev_minors;
>
>                blk_cleanup_queue(md->queue.queue);
>
> @@ -482,8 +497,8 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
>        struct mmc_blk_data *md;
>        int devidx, ret;
>
> -       devidx = find_first_zero_bit(dev_use, MMC_NUM_MINORS);
> -       if (devidx >= MMC_NUM_MINORS)
> +       devidx = find_first_zero_bit(dev_use, max_devices);
> +       if (devidx >= max_devices)
>                return ERR_PTR(-ENOSPC);
>        __set_bit(devidx, dev_use);
>
> @@ -500,7 +515,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
>         */
>        md->read_only = mmc_blk_readonly(card);
>
> -       md->disk = alloc_disk(1 << MMC_SHIFT);
> +       md->disk = alloc_disk(perdev_minors);
>        if (md->disk == NULL) {
>                ret = -ENOMEM;
>                goto err_kfree;
> @@ -517,7 +532,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
>        md->queue.data = md;
>
>        md->disk->major = MMC_BLOCK_MAJOR;
> -       md->disk->first_minor = devidx << MMC_SHIFT;
> +       md->disk->first_minor = devidx * perdev_minors;
>        md->disk->fops = &mmc_bdops;
>        md->disk->private_data = md;
>        md->disk->queue = md->queue.queue;
> @@ -593,7 +608,6 @@ static int mmc_blk_probe(struct mmc_card *card)
>  {
>        struct mmc_blk_data *md;
>        int err;
> -
>        char cap_str[10];
>
>        /*
> @@ -683,6 +697,11 @@ static int __init mmc_blk_init(void)
>  {
>        int res;
>
> +       if (perdev_minors != CONFIG_MMC_BLOCK_MINORS)
> +               pr_info("mmcblk: using %d minors per device\n", perdev_minors);
> +
> +       max_devices = 256 / perdev_minors;
> +
>        res = register_blkdev(MMC_BLOCK_MAJOR, "mmc");
>        if (res)
>                goto out;
> --
> 1.5.6.5
>

The patch's purpose is good. As modern sd&mmc is used to host the file
system, the 8 partition limitation is becoming a kind of bottleneck...
But why not just add GENHD_FL_EXT_DEVT flag to allow mmc use extended
partition numbers?

Like this modification?
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 8d2bd24..2e3eeb1 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -557,6 +557,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct
mmc_card *card)
        md->disk->private_data = md;
        md->disk->queue = md->queue.queue;
        md->disk->driverfs_dev = &card->dev;
+       md->disk->flags |= GENHD_FL_EXT_DEVT;

        /*
         * As discussed on lkml, GENHD_FL_REMOVABLE should:

Best regards,
Lei
