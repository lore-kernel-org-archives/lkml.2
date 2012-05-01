Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2EAXXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:23:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53857 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2EAXXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <x497gwvlgvg.fsf@segfault.boston.devel.redhat.com>
References: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCAgDU8FYdMuWsn2PuUW0GQxdKWJV6K0SmQEzb3s1GHxwA@mail.gmail.com>
	<x49lilcm1tb.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCChTmXTmjY5GvsFsvXpP_WSuiiWMRDu7Lvb71G9tW1PTw@mail.gmail.com>
	<x49bom7ljt5.fsf@segfault.boston.devel.redhat.com>
	<x497gwvlgvg.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 2 May 2012 09:23:35 +1000
Message-ID: <CAPa8GCBtyOoeN0ckonwPCRa_iASm=cQ_8_E9xCaVhh48Sdkhng@mail.gmail.com>
Subject: Re: [patch|rfc] block: don't mark buffers beyond end of disk as mapped
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jaxboe@fusionio.com, Kyle McMartin <kmcmarti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 07:40, Jeff Moyer <jmoyer@redhat.com> wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
>
>> Nick Piggin <npiggin@gmail.com> writes:
>>
>>> On 2 May 2012 00:08, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> Nick Piggin <npiggin@gmail.com> writes:
>>>>
>>>>> Not a bad fix. But it's kind of sad to have i_size checking logic also in
>>>>> block_read_full_page, that does not cope with this.
>>>>>
>>>>> I have found there are parts of the kernel (readahead) that try to read
>>>>> beyond EOF and seem to get angry if we return an error (by not
>>>>> marking uptodate in readpage) in that case though :(
>>>>>
>>>>> But, either way, I think it's very reasonable to not mark buffers beyond
>>>>> end of device as mapped. So I think your patch is fine.
>>>>>
>>>>> I guess for ext[234], it does not read metadata close to the end of the
>>>>> device or you were using 4K sized blocks?
>>>>
>>>> Well, the test case just reads directly from the loop device, bypassing
>>>> the file system, and I did use 1KB blocks when making the file system, so
>>>> it is quite puzzling.
>>>
>>> It's because buffer_head creation does not go through the same paths
>>> for bdev file access versus getblk APIs.
>>>
>>> blkdev_get_block does the right thing there
>>>
>>> In fact, it's probably good to unify the checks here, i.e., use max_blocks()
>>
>> You really think it's worth it?  I mean, it's just an i_size_read and a
>> shift, and there is precedent for it inside fs/buffer.c.  I'd prefer to
>> keep the patch as-is, but will change it if you feel that strongly about
>> it.
>
> Anyway, here is the other version of the patch, using max_block as you
> suggested.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!

Acked-by: Nick Piggin <npiggin@kernel.dk>

>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index e08f6a2..ba11c30 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -70,7 +70,7 @@ static void bdev_inode_switch_bdi(struct inode *inode,
>        spin_unlock(&dst->wb.list_lock);
>  }
>
> -static sector_t max_block(struct block_device *bdev)
> +sector_t blkdev_max_block(struct block_device *bdev)
>  {
>        sector_t retval = ~((sector_t)0);
>        loff_t sz = i_size_read(bdev->bd_inode);
> @@ -163,7 +163,7 @@ static int
>  blkdev_get_block(struct inode *inode, sector_t iblock,
>                struct buffer_head *bh, int create)
>  {
> -       if (iblock >= max_block(I_BDEV(inode))) {
> +       if (iblock >= blkdev_max_block(I_BDEV(inode))) {
>                if (create)
>                        return -EIO;
>
> @@ -185,7 +185,7 @@ static int
>  blkdev_get_blocks(struct inode *inode, sector_t iblock,
>                struct buffer_head *bh, int create)
>  {
> -       sector_t end_block = max_block(I_BDEV(inode));
> +       sector_t end_block = blkdev_max_block(I_BDEV(inode));
>        unsigned long max_blocks = bh->b_size >> inode->i_blkbits;
>
>        if ((iblock + max_blocks) > end_block) {
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 351e18e..ad5938c 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -921,6 +921,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>        struct buffer_head *head = page_buffers(page);
>        struct buffer_head *bh = head;
>        int uptodate = PageUptodate(page);
> +       sector_t end_block = blkdev_max_block(I_BDEV(bdev->bd_inode));
>
>        do {
>                if (!buffer_mapped(bh)) {
> @@ -929,7 +930,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>                        bh->b_blocknr = block;
>                        if (uptodate)
>                                set_buffer_uptodate(bh);
> -                       set_buffer_mapped(bh);
> +                       if (block < end_block)
> +                               set_buffer_mapped(bh);
>                }
>                block++;
>                bh = bh->b_this_page;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8de6755..25c40b9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2051,6 +2051,7 @@ extern void unregister_blkdev(unsigned int, const char *);
>  extern struct block_device *bdget(dev_t);
>  extern struct block_device *bdgrab(struct block_device *bdev);
>  extern void bd_set_size(struct block_device *, loff_t size);
> +extern sector_t blkdev_max_block(struct block_device *bdev);
>  extern void bd_forget(struct inode *inode);
>  extern void bdput(struct block_device *);
>  extern void invalidate_bdev(struct block_device *);
