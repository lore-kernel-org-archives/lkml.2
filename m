Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2IYSZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:25:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51827 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2IYSZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:25:05 -0400
Date: Tue, 25 Sep 2012 11:25:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memstick: add support for legacy memorysticks
Message-ID: <20120925182500.GD16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
 <1348562326-10462-3-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348562326-10462-3-git-send-email-maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 25, 2012 at 10:38:46AM +0200, Maxim Levitsky wrote:
> diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
> new file mode 100644
> index 0000000..318e40b
> --- /dev/null
> +++ b/drivers/memstick/core/ms_block.c
> @@ -0,0 +1,2422 @@
> +/*
> + *  ms_block.c - Sony MemoryStick (legacy) storage support
> +

Missing '*'?

> + *  Copyright (C) 2012 Maxim Levitsky <maximlevitsky@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Minor portions of the driver were copied from mspro_block.c which is
> + * Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
> + *
> + */
...
> +static size_t sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to,
> +					int to_nents, size_t offset, size_t len)

Probably not the best idea to use a name this generic in driver code.
linux/scatterlist.h likely might wanna use the name.

> +{
> +	size_t copied = 0;
> +
> +	while (offset > 0) {
> +
> +		if (offset >= sg_from->length) {
> +			if (sg_is_last(sg_from))
> +				return 0;
> +
> +			offset -= sg_from->length;
> +			sg_from = sg_next(sg_from);
> +			continue;
> +		}
> +
> +		copied = min(len, sg_from->length - offset);
> +		sg_set_page(sg_to, sg_page(sg_from),
> +			copied, sg_from->offset + offset);
> +
> +		len -= copied;
> +		offset = 0;
> +
> +		if (sg_is_last(sg_from) || !len)
> +			goto out;
> +
> +		sg_to = sg_next(sg_to);
> +		to_nents--;
> +		sg_from = sg_next(sg_from);
> +	}
> +
> +	while (len > sg_from->length && to_nents--) {
> +
> +		len -= sg_from->length;
> +		copied += sg_from->length;
> +
> +		sg_set_page(sg_to, sg_page(sg_from),
> +				sg_from->length, sg_from->offset);
> +
> +		if (sg_is_last(sg_from) || !len)
> +			goto out;
> +
> +		sg_from = sg_next(sg_from);
> +		sg_to = sg_next(sg_to);
> +	}
> +
> +	if (len && to_nents) {
> +		sg_set_page(sg_to, sg_page(sg_from), len, sg_from->offset);
> +		copied += len;
> +	}
> +
> +out:
> +	sg_mark_end(sg_to);
> +	return copied;
> +}

Also, from what it does, it seems sg_copy() is a bit of misnomer.
Rename it to sg_remap_with_offset() or something and move it to
lib/scatterlist.c?

> +/*
> + * Compares section of 'sg' starting from offset 'offset' and with length 'len'
> + * to linear buffer of length 'len' at address 'buffer'
> + * Returns 0 if equal and  -1 otherwice
> + */
> +static int sg_compare_to_buffer(struct scatterlist *sg,
> +					size_t offset, u8 *buffer, size_t len)
> +{
> +	int retval = 0;
> +	struct sg_mapping_iter miter;
> +
> +	sg_miter_start(&miter, sg, sg_nents(sg),
> +					SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +
> +	while (sg_miter_next(&miter) && len > 0) {
> +
> +		int cmplen;
> +
> +		if (offset >= miter.length) {
> +			offset -= miter.length;
> +			continue;
> +		}
> +
> +		cmplen = min(miter.length - offset, len);
> +		retval = memcmp(miter.addr + offset, buffer, cmplen) ? -1 : 0;
> +		if (retval)
> +			break;
> +
> +		buffer += cmplen;
> +		len -= cmplen;
> +		offset = 0;
> +	}
> +
> +	if (!retval && len)
> +		retval = -1;
> +
> +	sg_miter_stop(&miter);
> +	return retval;
> +}

Maybe we can make sg_copy_buffer() more generic so that it takes a
callback and implement this on top of it?  Having sglist manipulation
scattered isn't too attractive.

...
> +/*
> + * This function is a handler for reads of one page from device.
> + * Writes output to msb->current_sg, takes sector address from msb->reg.param
> + * Can also be used to read extra data only. Set params accordintly.
> + */
> +static int h_msb_read_page(struct memstick_dev *card,
> +					struct memstick_request **out_mrq)
> +{
> +	struct msb_data *msb = memstick_get_drvdata(card);
> +	struct memstick_request *mrq = *out_mrq = &card->current_mrq;
> +	struct scatterlist sg[2];
> +	u8 command, intreg;
> +
> +	if (mrq->error) {
> +		dbg("read_page, unknown error");
> +		return msb_exit_state_machine(msb, mrq->error);
> +	}
> +again:
> +	switch (msb->state) {
> +	case MSB_RP_SEND_BLOCK_ADDRESS:
...
> +	case MSB_RP_SEND_READ_COMMAND:
...
> +	case MSB_RP_SEND_INT_REQ:
...
> +	case MSB_RP_RECEIVE_INT_REQ_RESULT:
...

Is it really necessary to implement explicit state machine?  Can't you
just throw a work item at it and process it synchronously?  Explicit
state machines can save some resources at the cost of a lot more
complexity and generally making things a lot more fragile.  Is it
really worth it here?

> +/* Registers the block device */
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
> +	mutex_lock(&msb_disk_lock);
> +
> +	if (!idr_pre_get(&msb_disk_idr, GFP_KERNEL)) {
> +		mutex_unlock(&msb_disk_lock);
> +		return -ENOMEM;
> +	}
> +
> +	rc = idr_get_new(&msb_disk_idr, card, &disk_id);
> +	mutex_unlock(&msb_disk_lock);
> +
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

Unless you need fixed major:minor mapping (and you don't), you can
simply leave disk->major, first_minor and minors zero and set
GENHD_FL_EXT_DEVT.  Block layer will automatically allocate device
numbers dynamically as necessary.  No need to worry about MAJ:MIN.

Thanks.

-- 
tejun
