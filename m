Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0HITDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:03:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61714 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0HITDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eEhnN3PtpJ/Ss4fRNStW0sYDg6eJA6tKC/MNwmiUjG021vRgH8RskKEJqDz5ht1/yy
         13CxaZmABvmYjeI6i5RDT4Ux8sd+Xr9dwZ5IcMeukfZOfebp03mNQCHCbdUQXH9IHdnW
         gE2cloYoT58rp1iu1zRIRCX6nOoH+dOfnqg4s=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-7-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-7-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 22:03:50 +0300
X-Google-Sender-Auth: 1NkhaStaX4oiDeWPnp8WzW2yBiw
Message-ID: <AANLkTimtdLb4Mk81fmCwksPR0GbTEaGZbo888OFefjXK@mail.gmail.com>
Subject: Re: [PATCH 06/10] Block discard support
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> The 'discard' bio discard request provides information to
> zram disks regarding blocks which are no longer in use by
> filesystem. This allows freeing memory allocated for such
> blocks.
>
> When zram devices are used as swap disks, we already have
> a callback (block_device_operations->swap_slot_free_notify).
> So, the discard support is useful only when used as generic
> (non-swap) disk.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Lets CC fsdevel and Jens for this.

> ---
>  drivers/staging/zram/zram_drv.c   |   25 +++++++++++++++++++++++++
>  drivers/staging/zram/zram_sysfs.c |   11 +++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index efe9c93..0f9785f 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -420,6 +420,20 @@ out:
>        return 0;
>  }
>
> +static void zram_discard(struct zram *zram, struct bio *bio)
> +{
> +       size_t bytes = bio->bi_size;
> +       sector_t sector = bio->bi_sector;
> +
> +       while (bytes >= PAGE_SIZE) {
> +               zram_free_page(zram, sector >> SECTORS_PER_PAGE_SHIFT);
> +               sector += PAGE_SIZE >> SECTOR_SHIFT;
> +               bytes -= PAGE_SIZE;
> +       }
> +
> +       bio_endio(bio, 0);
> +}
> +
>  /*
>  * Check if request is within bounds and page aligned.
>  */
> @@ -451,6 +465,12 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
>                return 0;
>        }
>
> +       if (unlikely(bio_rw_flagged(bio, BIO_RW_DISCARD))) {
> +               zram_inc_stat(zram, ZRAM_STAT_DISCARD);
> +               zram_discard(zram, bio);
> +               return 0;
> +       }
> +
>        switch (bio_data_dir(bio)) {
>        case READ:
>                ret = zram_read(zram, bio);
> @@ -606,6 +626,11 @@ static int create_device(struct zram *zram, int device_id)
>        blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>        blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
>
> +       zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
> +       zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
> +       zram->disk->queue->limits.discard_zeroes_data = 1;
> +       queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->queue);
> +
>        add_disk(zram->disk);
>
>  #ifdef CONFIG_SYSFS
> diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
> index 43bcdd4..74971c0 100644
> --- a/drivers/staging/zram/zram_sysfs.c
> +++ b/drivers/staging/zram/zram_sysfs.c
> @@ -165,6 +165,15 @@ static ssize_t notify_free_show(struct device *dev,
>                zram_get_stat(zram, ZRAM_STAT_NOTIFY_FREE));
>  }
>
> +static ssize_t discard_show(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct zram *zram = dev_to_zram(dev);
> +
> +       return sprintf(buf, "%llu\n",
> +               zram_get_stat(zram, ZRAM_STAT_DISCARD));
> +}
> +
>  static ssize_t zero_pages_show(struct device *dev,
>                struct device_attribute *attr, char *buf)
>  {
> @@ -215,6 +224,7 @@ static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
>  static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
>  static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
>  static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
> +static DEVICE_ATTR(discard, S_IRUGO, discard_show, NULL);
>  static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
>  static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
>  static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
> @@ -228,6 +238,7 @@ static struct attribute *zram_disk_attrs[] = {
>        &dev_attr_num_writes.attr,
>        &dev_attr_invalid_io.attr,
>        &dev_attr_notify_free.attr,
> +       &dev_attr_discard.attr,
>        &dev_attr_zero_pages.attr,
>        &dev_attr_orig_data_size.attr,
>        &dev_attr_compr_data_size.attr,
> --
> 1.7.2.1
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
