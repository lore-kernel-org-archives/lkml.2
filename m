Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0IQXR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:17:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab0IQXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:17:26 -0400
Date: Fri, 17 Sep 2010 16:17:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] MEMSTICK: add support for legacy memorysticks
Message-Id: <20100917161724.3705b21a.akpm@linux-foundation.org>
In-Reply-To: <1283165327-10144-3-git-send-email-maximlevitsky@gmail.com>
References: <1283165327-10144-1-git-send-email-maximlevitsky@gmail.com>
	<1283165327-10144-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 13:48:46 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Huge thanks for Alex Dubov for code that this is based on
> and for lot, really lot of help he gave me in understanding
> MemorySticks and implementing this driver.
> 
> His help made this driver possible.
> 
> As any code that works with user data this driver isn't recommened
> to use with valuable data.
> 
> It tries its best though to avoid data corruption and possible
> damage to the card.
> 
>
> ...
>
> +/* Calculate number of sg entries in sg list */
> +static int sg_nents(struct scatterlist *sg)
> +{
> +	int nents = 0;
> +	while (sg) {
> +		nents++;
> +		sg = sg_next(sg);
> +	}
> +
> +	return nents;
> +}
> +
> +/* Calculate total lenght of scatterlist */
> +static int sg_total_len(struct scatterlist *sg)
> +{
> +	int len = 0;
> +	while (sg) {
> +		len += sg->length;
> +		sg = sg_next(sg);
> +	}
> +	return len;
> +}

Either

a) these functions should be provided by the core scarrerlist code or

b) these functions aren't needed, and this code is doing something
   wrong, or at least unusual.

>From a peek at other users of sg_miter_start(), I'm suspecting b) ?


I suppose these should use for_each_sg().


> +/* Compare contents of an sg to a buffer */
> +static bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
> +{
> +	unsigned long flags;
> +	int retval = 0;
> +	struct sg_mapping_iter miter;
> +
> +	if (sg_total_len(sg) < len)
> +		return 1;
> +
> +	local_irq_save(flags);
> +	sg_miter_start(&miter, sg, sg_nents(sg),
> +				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +
> +	while (sg_miter_next(&miter) && len > 0) {
> +
> +		int cmplen = min(miter.length, len);
> +
> +		if (memcmp(miter.addr, buffer, cmplen)) {
> +			retval = 1;
> +			break;
> +		}
> +
> +		buffer += cmplen;
> +		len -= cmplen;
> +	}
> +
> +	sg_miter_stop(&miter);
> +	local_irq_restore(flags);
> +	return retval;
> +}

What's the local_irq_disable() doing here?  It does nothing to block out
other CPUs.

> +/* Get zone at which block with logical address 'lba' lives */
> +static int msb_get_zone_from_lba(int lba)
> +{
> +	if (lba < 494)
> +		return 0;
> +	return ((lba - 494) / 496) + 1;
> +}

Wow.  What do those magic numbers mean?  Something friom some memstick
standard?  Should they be enumerated and documented in a header or
something?

>
> ...
>
> + * This function is a handler for reads of one page from device

Missing "." :)

>
> ...
>
> +static int msb_ftl_scan(struct msb_data *msb)
> +{
> +	u16 pba, lba, other_block;
> +	u8 overwrite_flag, managment_flag, other_overwrite_flag;
> +	int error;
> +	struct ms_extra_data_register extra;
> +
> +	u8 *overwrite_flags = kzalloc(msb->block_count, GFP_KERNEL);

The above two lines should be swapped.

> +	if (!overwrite_flags)
> +		return -ENOMEM;
> +
> +	dbg("Start of media scanning");
> +
> +	for (pba = 0 ; pba < msb->block_count ; pba++) {
> +
> +

The patch adds some randon unneeded vertical whitespace.

> +		if (pba == msb->boot_block_locations[0] ||
> +			pba == msb->boot_block_locations[1]) {
> +			dbg_verbose("pba %05d -> [boot block]", pba);
> +			msb_mark_block_used(msb, pba);
> +			continue;
> +		}
> +
> +		if (test_bit(pba, msb->used_blocks_bitmap)) {
> +			dbg_verbose("pba %05d -> [factory bad]", pba);
> +			continue;
> +		}
> +
> +		error = msb_read_oob(msb, pba, 0, &extra);
> +
> +		/* can't trust the page if we can't read the oob */
> +		if (error == -EBADMSG) {
> +			ms_printk(
> +			"oob of pba %d damaged, will try to erase it", pba);
> +			msb_mark_block_used(msb, pba);
> +			msb_erase_block(msb, pba);
> +			continue;
> +		} else if (error)
> +			return error;
> +
> +		lba = be16_to_cpu(extra.logical_address);
> +		managment_flag = extra.management_flag;
> +		overwrite_flag = extra.overwrite_flag;
> +		overwrite_flags[pba] = overwrite_flag;
> +
> +		/* Skip bad blocks */
> +		if (!(overwrite_flag & MEMSTICK_OVERWRITE_BKST)) {
> +			dbg("pba %05d -> [BAD]", pba);
> +			msb_mark_block_used(msb, pba);
> +			continue;
> +		}
> +
> +
> +		/* Skip system/drm blocks */
> +		if ((managment_flag & MEMSTICK_MANAGMENT_FLAG_NORMAL) !=
> +			MEMSTICK_MANAGMENT_FLAG_NORMAL) {
> +			dbg("pba %05d -> [reserved managment flag %02x]",
> +							pba, managment_flag);
> +			msb_mark_block_used(msb, pba);
> +			continue;
> +		}
> +
> +
> +		/* Erase temporary tables */
> +		if (!(managment_flag & MEMSTICK_MANAGEMENT_ATFLG)) {
> +			dbg("pba %05d -> [temp table] - will erase", pba);
> +
> +			msb_mark_block_used(msb, pba);
> +			msb_erase_block(msb, pba);
> +			continue;
> +		}
> +
> +		if (lba == MS_BLOCK_INVALID) {
> +			dbg_verbose("pba %05d -> [free]", pba);
> +			continue;
> +		}
> +
> +
> +		msb_mark_block_used(msb, pba);
> +
> +		/* Block has LBA not according to zoning*/
> +		if (msb_get_zone_from_lba(lba) != msb_get_zone_from_pba(pba)) {
> +			ms_printk("pba %05d -> [bad lba %05d] - will erase",
> +								pba, lba);
> +			msb_erase_block(msb, pba);
> +			continue;
> +		}
> +
> +		/* No collisions - great */
> +		if (msb->lba_to_pba_table[lba] == MS_BLOCK_INVALID) {
> +			dbg_verbose("pba %05d -> [lba %05d]", pba, lba);
> +			msb->lba_to_pba_table[lba] = pba;
> +			continue;
> +		}
> +
> +		other_block = msb->lba_to_pba_table[lba];
> +		other_overwrite_flag = overwrite_flags[other_block];
> +
> +		ms_printk("Collision between pba %d and pba %d",
> +			pba, other_block);
> +
> +		if (!(overwrite_flag & MEMSTICK_OVERWRITE_UDST)) {
> +			ms_printk("pba %d is marked as stable, use it", pba);
> +			msb_erase_block(msb, other_block);
> +			msb->lba_to_pba_table[lba] = pba;
> +			continue;
> +		}
> +
> +		if (!(other_overwrite_flag & MEMSTICK_OVERWRITE_UDST)) {
> +			ms_printk("pba %d is marked as stable, use it",
> +								other_block);
> +			msb_erase_block(msb, pba);
> +			continue;
> +		}
> +
> +		ms_printk("collision between blocks %d and %d with"
> +		" without stable flag set on both, erasing pba %d",
> +				pba, other_block, other_block);
> +
> +		msb_erase_block(msb, other_block);
> +		msb->lba_to_pba_table[lba] = pba;
> +	}
> +
> +	dbg("End of media scanning");
> +	kfree(overwrite_flags);
> +	return 0;
> +}
> +
> +static void msb_cache_flush_timer(unsigned long data)
> +{
> +	struct msb_data *msb = (struct msb_data *)data;
> +	msb->need_flush_cache = true;
> +	wake_up_process(msb->io_thread);
> +}
> +
> +
> +static void msb_cache_discard(struct msb_data *msb)
> +{
> +	if (msb->cache_block_lba == MS_BLOCK_INVALID)
> +		return;
> +
> +	dbg_verbose("Discarding the write cache");
> +	msb->cache_block_lba = MS_BLOCK_INVALID;
> +	bitmap_zero(&msb->valid_cache_bitmap, msb->pages_in_block);
> +	del_timer(&msb->cache_flush_timer);

Worried.  Bear in mind that the timer handler might now be running and
about to kick off the io_thread.  Races everywhere.  A del_timer_sync()
here would set minds at ease.

> +}
>
>
> ...
>
> +static int msb_cache_flush(struct msb_data *msb)
> +{
> +	struct scatterlist sg;
> +	struct ms_extra_data_register extra;
> +	int page, offset, error;
> +	u16 pba, lba;
> +
> +	if (msb->read_only)
> +		return -EROFS;
> +
> +	if (msb->cache_block_lba == MS_BLOCK_INVALID)
> +		return 0;
> +
> +	lba = msb->cache_block_lba;
> +	pba = msb->lba_to_pba_table[lba];
> +
> +	dbg_verbose("Flusing the write cache of pba %d (LBA %d)",

typo

> +						pba, msb->cache_block_lba);
> +
> +	/* Read all missing pages in cache */
> +	for (page = 0 ; page < msb->pages_in_block ; page++) {
> +
> +		if (test_bit(page, &msb->valid_cache_bitmap))
> +			continue;
> +
> +		offset = page * msb->page_size;
> +		sg_init_one(&sg, msb->cache + offset , msb->page_size);
> +
> +
> +		dbg_verbose("reading non-present sector %d of cache block %d",
> +			page, lba);
> +		error = msb_read_page(msb, pba, page, &extra, &sg);
> +
> +		/* Bad pages are copied with 00 page status */
> +		if (error == -EBADMSG) {
> +			ms_printk("read error on sector %d, contents probably"
> +				" damaged", page);
> +			continue;
> +		}
> +
> +		if (error)
> +			return error;
> +
> +		if ((extra.overwrite_flag & MEMSTICK_OV_PG_NORMAL) !=
> +							MEMSTICK_OV_PG_NORMAL) {
> +			dbg("page %d is marked as bad", page);
> +			continue;
> +		}
> +
> +		set_bit(page, &msb->valid_cache_bitmap);
> +	}
> +
>
> ...
>
> +static const struct chs_entry chs_table[] = {
> +	{ 4,    16,  247,  2  },
> +	{ 8,    16,  495,  2  },
> +	{ 16,   16,  495,  4  },
> +	{ 32,   16,  991,  4  },
> +	{ 64,   16,  991,  8  },
> +	{128,   16,  991,  16 },
> +	{ 0 }
> +};

One wonders where this info came from.  Is there a spec we can link
readers to?

>
> ...
>
> +static int msb_io_thread(void *data)
> +{
> +	struct msb_data *msb = data;
> +	int page, error, len;
> +	sector_t lba;
> +	unsigned long flags;
> +
> +	dbg("IO: thread started");
> +
> +	while (1) {
> +
> +		if (kthread_should_stop()) {
> +			if (msb->req)
> +				blk_requeue_request(msb->queue, msb->req);
> +			break;
> +		}
> +
> +		spin_lock_irqsave(&msb->q_lock, flags);
> +
> +		if (msb->need_flush_cache) {
> +			msb->need_flush_cache = false;
> +			spin_unlock_irqrestore(&msb->q_lock, flags);
> +			msb_cache_flush(msb);
> +			continue;
> +		}
> +
> +		if (!msb->req) {
> +			msb->req = blk_fetch_request(msb->queue);
> +
> +			if (!msb->req) {
> +				dbg_verbose("IO: no more requests, sleeping");
> +				set_current_state(TASK_INTERRUPTIBLE);
> +				spin_unlock_irqrestore(&msb->q_lock, flags);
> +				schedule();
> +				dbg_verbose("IO: thread woken up");
> +				continue;
> +			}
> +		}
> +
> +		spin_unlock_irqrestore(&msb->q_lock, flags);
> +
> +		/* If card was removed meanwhile */
> +		if (!msb->req)
> +			continue;
> +
> +		/* process the request */
> +		dbg_verbose("IO: thread processing new request");
> +		blk_rq_map_sg(msb->queue, msb->req, msb->req_sg);
> +
> +		lba = blk_rq_pos(msb->req);
> +
> +		sector_div(lba, msb->page_size / 512);
> +		page = do_div(lba, msb->pages_in_block);
> +
> +
> +		mutex_lock(&msb->card->host->lock);
> +		if (rq_data_dir(msb->req) == READ)
> +			error = msb_do_read_request(
> +					msb, lba, page, msb->req_sg, &len);
> +		else
> +			error = msb_do_write_request(
> +					msb, lba, page, msb->req_sg, &len);
> +
> +		mutex_unlock(&msb->card->host->lock);
> +
> +		spin_lock_irqsave(&msb->q_lock, flags);
> +
> +		if (len)
> +			if (!__blk_end_request(msb->req, 0, len))
> +				msb->req = NULL;
> +
> +		if (error && msb->req) {
> +			dbg_verbose("IO: ending one sector "
> +					"of the request with error");
> +			if (!__blk_end_request(msb->req, error, msb->page_size))
> +				msb->req = NULL;
> +		}
> +
> +		if (msb->req)
> +			dbg_verbose("IO: request still pending");
> +
> +		spin_unlock_irqrestore(&msb->q_lock, flags);
> +	}
> +	return 0;
> +}

Did we need a try_to_freeze() in that loop?

>
> ...
>
> +static int msb_init_disk(struct memstick_dev *card)
> +{
> +	struct msb_data *msb = memstick_get_drvdata(card);
> +	struct memstick_host *host = card->host;
> +	int rc, disk_id;
> +	u64 limit = BLK_BOUNCE_HIGH;
> +	unsigned long capacity;
> +
> +	if (host->dev.dma_mask && *(host->dev.dma_mask))
> +		limit = *(host->dev.dma_mask);
> +
> +	if (!idr_pre_get(&msb_disk_idr, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	mutex_lock(&msb_disk_lock);
> +	rc = idr_get_new(&msb_disk_idr, card, &disk_id);
> +	mutex_unlock(&msb_disk_lock);

There's a silly race window where another thread can come in and steal
the resutls of your idr_pre_get().  Easily fixable by moving the
idr_pre_get() call to inside the mutex_lock().

> +	if (rc)
> +		return rc;
> +
> +	if ((disk_id << MS_BLOCK_PART_SHIFT) > 255) {
> +		rc = -ENOSPC;
> +		goto out_release_id;
> +	}
> +
> +	msb->disk = alloc_disk(1 << MS_BLOCK_PART_SHIFT);
> +	if (!msb->disk) {
> +		rc = -ENOMEM;
> +		goto out_release_id;
> +	}
> +
> +	msb->queue = blk_init_queue(msb_submit_req, &msb->q_lock);
> +	if (!msb->queue) {
> +		rc = -ENOMEM;
> +		goto out_put_disk;
> +	}
> +
> +	msb->queue->queuedata = card;
> +	blk_queue_prep_rq(msb->queue, msb_prepare_req);
> +
> +	blk_queue_bounce_limit(msb->queue, limit);
> +	blk_queue_max_hw_sectors(msb->queue, MS_BLOCK_MAX_PAGES);
> +	blk_queue_max_segments(msb->queue, MS_BLOCK_MAX_SEGS);
> +	blk_queue_max_segment_size(msb->queue,
> +				   MS_BLOCK_MAX_PAGES * msb->page_size);
> +	msb->disk->major = major;
> +	msb->disk->first_minor = disk_id << MS_BLOCK_PART_SHIFT;
> +	msb->disk->fops = &msb_bdops;
> +	msb->usage_count = 1;
> +	msb->disk->private_data = msb;
> +	msb->disk->queue = msb->queue;
> +	msb->disk->driverfs_dev = &card->dev;
> +
> +	sprintf(msb->disk->disk_name, "msblk%d", disk_id);
> +
> +	blk_queue_logical_block_size(msb->queue, msb->page_size);
> +
> +	capacity = msb->pages_in_block * msb->logical_block_count;
> +	capacity *= (msb->page_size / 512);
> +
> +	set_capacity(msb->disk, capacity);
> +	dbg("set total disk size to %lu sectors", capacity);
> +
> +
> +	if (msb->read_only)
> +		set_disk_ro(msb->disk, 1);
> +
> +
> +	msb_start(card);
> +
> +	mutex_unlock(&host->lock);
> +	add_disk(msb->disk);
> +	mutex_unlock(&host->lock);
> +	dbg("Disk added");
> +	return 0;
> +
> +out_put_disk:
> +	put_disk(msb->disk);
> +out_release_id:
> +	mutex_lock(&msb_disk_lock);
> +	idr_remove(&msb_disk_idr, disk_id);
> +	mutex_unlock(&msb_disk_lock);
> +	return rc;
> +}
> +
>
> ...
>
> +struct ms_boot_header {
> +	unsigned short block_id;
> +	unsigned short format_reserved;
> +	unsigned char  reserved0[184];
> +	unsigned char  data_entry;
> +	unsigned char  reserved1[179];
> +} __attribute__((packed));

We have a __packed helper to avoid this mouthful.

>
> ...
>

That was quite a lot of code.
