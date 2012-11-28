Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2K1OYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:24:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53163 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2K1OYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:24:09 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1211272300000.18338@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
	<20121120180949.GG1408@quack.suse.cz>
	<CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
	<CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
	<CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
	<50AF7901.20401@kernel.dk>
	<CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
	<Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
	<CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
	<CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
	<50B46E05.70906@kernel.dk>
	<CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
	<Pine.LNX.4.64.1211272257140.18338@file.rdu.redhat.com>
	<Pine.LNX.4.64.1211272300000.18338@file.rdu.redhat.com>
Date: Wed, 28 Nov 2012 22:24:08 +0800
Message-ID: <CAAJw_Zs+fM4Tj1CJxW_60opEKHXgdsYn4xxGRewbP0AdcriyNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] block_dev: don't take the write lock if block size
 doesn't change
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:01 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> block_dev: don't take the write lock if block size doesn't change
>
> Taking the write lock has a big performance impact on the whole system
> (because of synchronize_sched_expedited). This patch avoids taking the
> write lock if the block size doesn't change (i.e. when mounting
> filesystem with block size equal to the default block size).
>
> The logic to test if the block device is mapped was moved to a separate
> function is_bdev_mapped to avoid code duplication.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  fs/block_dev.c |   25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> Index: linux-3.7-rc7/fs/block_dev.c
> ===================================================================
> --- linux-3.7-rc7.orig/fs/block_dev.c   2012-11-28 04:09:01.000000000 +0100
> +++ linux-3.7-rc7/fs/block_dev.c        2012-11-28 04:13:53.000000000 +0100
> @@ -114,10 +114,18 @@ void invalidate_bdev(struct block_device
>  }
>  EXPORT_SYMBOL(invalidate_bdev);
>
> -int set_blocksize(struct block_device *bdev, int size)
> +static int is_bdev_mapped(struct block_device *bdev)
>  {
> -       struct address_space *mapping;
> +       int ret_val;
> +       struct address_space *mapping = bdev->bd_inode->i_mapping;
> +       mutex_lock(&mapping->i_mmap_mutex);
> +       ret_val = mapping_mapped(mapping);
> +       mutex_unlock(&mapping->i_mmap_mutex);
> +       return ret_val;
> +}
>
> +int set_blocksize(struct block_device *bdev, int size)
> +{
>         /* Size must be a power of two, and between 512 and PAGE_SIZE */
>         if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
>                 return -EINVAL;
> @@ -126,18 +134,21 @@ int set_blocksize(struct block_device *b
>         if (size < bdev_logical_block_size(bdev))
>                 return -EINVAL;
>
> +       /*
> +        * If the block size doesn't change, don't take the write lock.
> +        * We check for is_bdev_mapped anyway, for consistent behavior.
> +        */
> +       if (size == bdev->bd_block_size)
> +               return is_bdev_mapped(bdev) ? -EBUSY : 0;
> +
>         /* Prevent starting I/O or mapping the device */
>         percpu_down_write(&bdev->bd_block_size_semaphore);
>
>         /* Check that the block device is not memory mapped */
> -       mapping = bdev->bd_inode->i_mapping;
> -       mutex_lock(&mapping->i_mmap_mutex);
> -       if (mapping_mapped(mapping)) {
> -               mutex_unlock(&mapping->i_mmap_mutex);
> +       if (is_bdev_mapped(bdev)) {
>                 percpu_up_write(&bdev->bd_block_size_semaphore);
>                 return -EBUSY;
>         }
> -       mutex_unlock(&mapping->i_mmap_mutex);
>
>         /* Don't change the size if it is same as current */
>         if (bdev->bd_block_size != size) {


This patch didn't really make any difference for ext2/3/4 but for
reiserfs it does.

With the synchronize_sched_expedited() patch applied, it didn't make
any difference.


Thanks,
Jeff
