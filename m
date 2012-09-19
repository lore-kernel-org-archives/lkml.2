Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2ISVwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:52:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2ISVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:52:30 -0400
Date: Wed, 19 Sep 2012 14:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-Id: <20120919145228.80f72f59.akpm@linux-foundation.org>
In-Reply-To: <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
	<1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012 16:19:02 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Based partially on MS standard spec quotes from Alex Dubov.
> 
> As any code that works with user data this driver isn't
> recommended to use to write cards that contain valuable data.
> 
> It tries its best though to avoid data corruption
> and possible damage to the card.
> 
> Tested on MS DUO 64 MB card on Ricoh R592 card reader..
> 

Generally looks nice to me, although I wouldn't know a memstick if one
stuck to my shoe.

I have a bunch of fairly trivial comments, and one head-scratcher for
Tejun: what's up with the local-irqs-disabled requirement in sg_miter_next()?

> ...
>
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

I think we may as well put this in scatterlist.c immediately.  It
wouldn't surprise me if we already have open-coded copies of this lying
around the tree.

> +/*
> + * Copies section of 'sg_from' starting from offset 'offset' and with length
> + * 'len' To another scatterlist of to_nents enties
> + */
> +static int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to,
> +					int to_nents, int offset, size_t len)

The should return a size_t, to match the type of `len'.  And the type
of `offset' is fishy - there's nothing which intrinsically limits these
things to 2G?

> +{
> +	int copied = 0;
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
> +		copied = min(len, (size_t)(sg_from->length - offset));

min_t would be more conventional.  Or perhaps even min(), depending on
`offset's new type (but probably not).

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
> +
> +/*
> + * Compares section of 'sg' starting from offset 'offset' and with length 'len'
> + * to linear buffer of length 'len' at address 'buffer'

The comment should document the return value.

> + */
> +static bool sg_compare_to_buffer(struct scatterlist *sg,
> +					int offset, u8 *buffer, size_t len)
> +{
> +	unsigned long flags;
> +	int retval = 0;
> +	struct sg_mapping_iter miter;
> +
> +	local_irq_save(flags);

hm, the "IRQ disabled if SG_MITER_ATOMIC" requirement of
sg_miter_next() is weird and unexpected.

Tejun's 137d3edb48425f8 added the code whch has this strange
requirement, but it is unexplained.  Wazzup?

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
> +		retval = memcmp(miter.addr + offset, buffer, cmplen);
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
> +	local_irq_restore(flags);
> +	return retval;
> +}
>
> ...
>
> +static void msb_mark_block_unused(struct msb_data *msb, int pba)
> +{
> +	int zone = msb_get_zone_from_pba(pba);
> +
> +	if (!test_bit(pba, msb->used_blocks_bitmap)) {
> +		ms_printk("BUG: attempt to mark "
> +				"already unused pba %d as unused" , pba);
> +		msb->read_only = true;
> +		return;
> +	}
> +
> +#ifdef DEBUG
> +	if (msb_validate_used_block_bitmap(msb))
> +		return;
> +#endif
> +	clear_bit(pba, msb->used_blocks_bitmap);
> +	msb->free_block_count[zone]++;
> +}

Presumably there is some lock which the caller must hold to prevent the
obvious races in the above two functions.  I suggest adding a comment
whcih documents this requirement, then take advantage of that lock to
switch to the more efficient __set_bit() and __clear_bit().

> +/* Invalidate current register window*/

hm, checkpatch misses the missing space before */

> +static void msb_invalidate_reg_window(struct msb_data *msb)
> +{
> +	msb->reg_addr.w_offset = offsetof(struct ms_register, id);
> +	msb->reg_addr.w_length = sizeof(struct ms_id_register);
> +	msb->reg_addr.r_offset = offsetof(struct ms_register, id);
> +	msb->reg_addr.r_length = sizeof(struct ms_id_register);
> +	msb->addr_valid = false;
> +}
> +
> +/* Sane way to start a state machine*/
> +static int msb_run_state_machine(struct msb_data *msb, int   (*state_func)
> +		(struct memstick_dev *card, struct memstick_request **req))
> +{
> +	struct memstick_dev *card = msb->card;
> +
> +	WARN_ON(msb->state != -1);
> +	msb->int_polling = false;
> +	msb->state = 0;
> +	msb->exit_error = 0;
> +
> +	memset(&card->current_mrq, 0, sizeof(card->current_mrq));
> +
> +	card->next_request = state_func;
> +	memstick_new_req(card->host);
> +	wait_for_completion(&card->mrq_complete);
> +
> +	WARN_ON(msb->state != -1);
> +	return msb->exit_error;
> +}
> +
> +/* State machines call that to exit */
> +int msb_exit_state_machine(struct msb_data *msb, int error)

static

> +{
> +	WARN_ON(msb->state == -1);
> +
> +	msb->state = -1;
> +	msb->exit_error = error;
> +	msb->card->next_request = h_msb_default_bad;
> +
> +	/* Invalidate reg window on errors */
> +	if (error)
> +		msb_invalidate_reg_window(msb);
> +
> +	complete(&msb->card->mrq_complete);
> +	return -ENXIO;
> +}
> +
> +/* read INT register */
> +int msb_read_int_reg(struct msb_data *msb, long timeout)

static

> +{
> +	struct memstick_request *mrq = &msb->card->current_mrq;
> +	WARN_ON(msb->state == -1);

It's conventional to put a newline between end-of-locals and start-of-code.

> +	if (!msb->int_polling) {
> +		msb->int_timeout = jiffies +
> +			msecs_to_jiffies(timeout == -1 ? 500 : timeout);
> +		msb->int_polling = true;
> +	} else if (time_after(jiffies, msb->int_timeout)) {
> +		mrq->data[0] = MEMSTICK_INT_CMDNAK;
> +		return 0;
> +	}
> +
> +	if ((msb->caps & MEMSTICK_CAP_AUTO_GET_INT) &&
> +				mrq->need_card_int && !mrq->error) {
> +		mrq->data[0] = mrq->int_reg;
> +		mrq->need_card_int = false;
> +		return 0;
> +	} else {
> +		memstick_init_req(mrq, MS_TPC_GET_INT, NULL, 1);
> +		return 1;
> +	}
> +}
> +
> +/* Read a register */
> +int msb_read_regs(struct msb_data *msb, int offset, int len)

static.  I'll stop checking them now ;)

> +{
> +	struct memstick_request *req = &msb->card->current_mrq;
> +
> +	if (msb->reg_addr.r_offset != offset ||
> +	    msb->reg_addr.r_length != len || !msb->addr_valid) {
> +
> +		msb->reg_addr.r_offset = offset;
> +		msb->reg_addr.r_length = len;
> +		msb->addr_valid = true;
> +
> +		memstick_init_req(req, MS_TPC_SET_RW_REG_ADRS,
> +			&msb->reg_addr, sizeof(msb->reg_addr));
> +		return 0;
> +	}
> +
> +	memstick_init_req(req, MS_TPC_READ_REG, NULL, len);
> +	return 1;
> +}
> +
> +/* Write a card register */
> +int msb_write_regs(struct msb_data *msb, int offset, int len, void *buf)
> +{
> +	struct memstick_request *req = &msb->card->current_mrq;
> +
> +	if (msb->reg_addr.w_offset != offset ||
> +		msb->reg_addr.w_length != len  || !msb->addr_valid) {
> +
> +		msb->reg_addr.w_offset = offset;
> +		msb->reg_addr.w_length = len;
> +		msb->addr_valid = true;
> +
> +		memstick_init_req(req, MS_TPC_SET_RW_REG_ADRS,
> +			&msb->reg_addr, sizeof(msb->reg_addr));
> +		return 0;
> +	}
> +
> +	memstick_init_req(req, MS_TPC_WRITE_REG, buf, len);
> +	return 1;
> +}
> +
> +/* Handler for absense of IO */

"absence" :)

> +static int h_msb_default_bad(struct memstick_dev *card,
> +						struct memstick_request **mrq)
> +{
> +	return -ENXIO;
> +}
> +
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
> +	case 0: /* Write the sector address */
> +		if (!msb_write_regs(msb,
> +			offsetof(struct ms_register, param),
> +			sizeof(struct ms_param_register),
> +			(unsigned char *)&msb->regs.param))
> +			return 0;
> +		break;
> +
> +	case 1: /* Execute the read command*/
> +		command = MS_CMD_BLOCK_READ;
> +		memstick_init_req(mrq, MS_TPC_SET_CMD, &command, 1);
> +		break;
> +
> +	case 2: /* send INT request */
> +		if (msb_read_int_reg(msb, -1))
> +			break;
> +		msb->state++;
> +
> +	case 3: /* get result of the INT request*/
> +		intreg = mrq->data[0];
> +		msb->regs.status.interrupt = intreg;
> +
> +		if (intreg & MEMSTICK_INT_CMDNAK)
> +			return msb_exit_state_machine(msb, -EIO);
> +
> +		if (!(intreg & MEMSTICK_INT_CED)) {
> +			msb->state--;
> +			goto again;
> +		}
> +
> +		msb->int_polling = false;
> +
> +		if (intreg & MEMSTICK_INT_ERR)
> +			msb->state++;
> +		else
> +			msb->state = 6;
> +
> +		goto again;
> +
> +	case 4: /* read the status register
> +				to understand source of the INT_ERR */
> +		if (!msb_read_regs(msb,
> +			offsetof(struct ms_register, status),
> +			sizeof(struct ms_status_register)))
> +			return 0;
> +		break;
> +
> +	case 5: /* get results of status check */
> +		msb->regs.status = *(struct ms_status_register *)mrq->data;
> +		msb->state++;
> +
> +	case 6: /* Send extra data read request */
> +		if (!msb_read_regs(msb,
> +			offsetof(struct ms_register, extra_data),
> +			sizeof(struct ms_extra_data_register)))
> +			return 0;
> +		break;
> +
> +	case 7: /* Save result of extra data request */
> +		msb->regs.extra_data =
> +			*(struct ms_extra_data_register *) mrq->data;
> +		msb->state++;
> +
> +	case 8: /* Send the  MS_TPC_READ_LONG_DATA to read IO buffer */
> +
> +		/* Skip that state if we only read the oob */
> +		if (msb->regs.param.cp == MEMSTICK_CP_EXTRA) {
> +			msb->state++;
> +			goto again;
> +		}
> +
> +		sg_init_table(sg, ARRAY_SIZE(sg));
> +		sg_copy(msb->current_sg, sg, ARRAY_SIZE(sg),
> +			msb->current_sg_offset,
> +			msb->page_size);
> +
> +		memstick_init_req_sg(mrq, MS_TPC_READ_LONG_DATA, sg);
> +		break;
> +
> +	case 9: /* check validity of data buffer & done */
> +
> +		if (!(msb->regs.status.interrupt & MEMSTICK_INT_ERR)) {
> +			msb->current_sg_offset += msb->page_size;
> +			return msb_exit_state_machine(msb, 0);
> +		}
> +
> +		if (msb->regs.status.status1 & MEMSTICK_UNCORR_ERROR) {
> +			dbg("read_page: uncorrectable error");
> +			return msb_exit_state_machine(msb, -EBADMSG);
> +		}
> +
> +		if (msb->regs.status.status1 & MEMSTICK_CORR_ERROR) {
> +			dbg("read_page: correctable error");
> +			msb->current_sg_offset += msb->page_size;
> +			return msb_exit_state_machine(msb, -EUCLEAN);
> +		} else {
> +			dbg("read_page: INT error, but no status error bits");
> +			return msb_exit_state_machine(msb, -EIO);
> +		}
> +	default:
> +		BUG();
> +	}
> +	msb->state++;

I think this code would be quite a lot cleaner, safer and more readable
if you were to do away with the "msb->state++" concept altogether.  Just do

enum msb_states {
	state_foo1,
	state_foo2
	...
};

and do

	msb->state = state_foo2;

in each switch case.

This way, the reader doesn't have to scratch his head over what the
state _used_ to be, and the states have nice names to help the reader
understand what's going on.


> +	return 0;
> +}
>
> ...
>
> +/*
> + * This function is used to send simple IO requests to device that consist
> + * of register write + command
> + */
> +static int h_msb_send_command(struct memstick_dev *card,
> +					struct memstick_request **out_mrq)
> +{
> +	struct msb_data *msb = memstick_get_drvdata(card);
> +	struct memstick_request *mrq = *out_mrq = &card->current_mrq;
> +

stray newline

> +	u8 intreg;
> +
> +	if (mrq->error) {
> +		dbg("send_command: unknown error");
> +		return msb_exit_state_machine(msb, mrq->error);
> +	}
> +again:
> +	switch (msb->state) {
> +
> +		/* HACK: see h_msb_write_block */
> +
>
> ...
>
> +static int h_msb_parallel_switch(struct memstick_dev *card,
> +					struct memstick_request **out_mrq)
> +{
> +	struct msb_data *msb = memstick_get_drvdata(card);
> +	struct memstick_request *mrq = *out_mrq = &card->current_mrq;
> +

stray newline.  Please fix 'em up - it does make the code a little
discordant to read.

> +	struct memstick_host *host = card->host;
> +
> +	if (mrq->error) {
> +		dbg("parallel_switch: error");
> +		msb->regs.param.system &= ~MEMSTICK_SYS_PAM;
> +		return msb_exit_state_machine(msb, mrq->error);
> +	}
> +
> +	switch (msb->state) {
> +	case 0: /* Set the parallel interface on memstick side */
> +		msb->regs.param.system |= MEMSTICK_SYS_PAM;
> +
> +		if (!msb_write_regs(msb,
> +			offsetof(struct ms_register, param),
> +			1,
> +			(unsigned char *)&msb->regs.param))
> +			return 0;
> +		break;
> +
> +	case 1: /* Set parallel interface on our side + send a dummy request
> +			to see if card responds */
> +		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
> +		memstick_init_req(mrq, MS_TPC_GET_INT, NULL, 1);
> +		break;
> +
> +	case 2:
> +		return msb_exit_state_machine(msb, 0);
> +	}
> +	msb->state++;
> +	return 0;
> +}
> +
> +static int msb_switch_to_parallel(struct msb_data *msb);
> +
> +/* Reset the card, to guard against hw errors beeing treated as bad blocks */
> +static int msb_reset(struct msb_data *msb, bool full)
> +{
> +
> +	bool was_parallel = msb->regs.param.system & MEMSTICK_SYS_PAM;

fyi, alas, this is (probably) slower than using an `int'.  gcc will
convert the result of the expression into 1-or-0.

> +	struct memstick_dev *card = msb->card;
> +	struct memstick_host *host = card->host;
> +	int error;
> +
> +	/* Reset the card */
> +	msb->regs.param.system = MEMSTICK_SYS_BAMD;
> +
> +	if (full) {
> +		error =  host->set_param(host,
> +					MEMSTICK_POWER, MEMSTICK_POWER_OFF);
> +		if (error)
> +			goto out_error;
> +
> +		msb_invalidate_reg_window(msb);
> +
> +		error = host->set_param(host,
> +					MEMSTICK_POWER, MEMSTICK_POWER_ON);
> +		if (error)
> +			goto out_error;
> +
> +		error = host->set_param(host,
> +					MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
> +		if (error) {
>
> ...
>
> +static int msb_erase_block(struct msb_data *msb, u16 pba)
> +{
> +	int error, try;
> +	if (msb->read_only)
> +		return -EROFS;
> +
> +	dbg_verbose("erasing pba %d", pba);
> +
> +	for (try = 1 ; try < 3 ; try++) {
> +		msb->regs.param.block_address = cpu_to_be16(pba);
> +		msb->regs.param.page_address = 0;
> +		msb->regs.param.cp = MEMSTICK_CP_BLOCK;
> +		msb->command_value = MS_CMD_BLOCK_ERASE;
> +		msb->command_need_oob = false;
> +
> +
> +		error = msb_run_state_machine(msb, h_msb_send_command);
> +		if (!error || msb_reset(msb, true))
> +			break;
> +	}
> +
> +	if (error) {
> +		ms_printk("erase failed, marking pba %d as bad", pba);
> +		msb_mark_bad(msb, pba);
> +	}
> +
> +	dbg_verbose("erase success, marking pba %d as unused", pba);
> +	msb_mark_block_unused(msb, pba);
> +	set_bit(pba, msb->erased_blocks_bitmap);

Should be able to use __set_bit() here, as msb_mark_block_unused()
required caller-provided locking.

> +	return error;
> +}
> +
>
> ...
>
> +static int msb_read_oob(struct msb_data *msb, u16 pba, u16 page,
> +	struct ms_extra_data_register *extra)
> +{
> +	int error;
> +	BUG_ON(!extra);
> +

vertical whitespace oddnesses

> +	msb->regs.param.block_address = cpu_to_be16(pba);
> +	msb->regs.param.page_address = page;
> +	msb->regs.param.cp = MEMSTICK_CP_EXTRA;
> +
> +	if (pba > msb->block_count) {
> +		ms_printk("BUG: attempt to read beyond"
> +					" the end of card at pba %d", pba);
> +		return -EINVAL;
> +	}
> +
> +	error = msb_run_state_machine(msb, h_msb_read_page);
> +	*extra = msb->regs.extra_data;
> +
> +	if (error == -EUCLEAN) {
> +		ms_printk("correctable error on pba %d, page %d",
> +			pba, page);
> +		return 0;
> +	}
> +
> +	return error;
> +}
> +
> +
> +/* Reads a block and compares it with data contained in scatterlist orig_sg */
> +static bool msb_verify_block(struct msb_data *msb, u16 pba,
> +				struct scatterlist *orig_sg,  int offset)
> +{
> +	struct scatterlist sg;
> +	int page = 0, error;
> +
> +	sg_init_one(&sg, msb->block_buffer, msb->block_size);
> +
> +	while (page < msb->pages_in_block) {
> +
> +		error = msb_read_page(msb, pba, page,
> +				NULL, &sg, page * msb->page_size);
> +		if (error)
> +			return -EIO;

msb_read_page() returned an errno.  Propagate that, rather than
overwriting it?

> +		page++;
> +	}
> +
> +	if (sg_compare_to_buffer(orig_sg, offset,
> +				msb->block_buffer, msb->block_size))
> +		return -EIO;
> +	return 0;
> +}
> +
>
> ...
>
> +static int msb_read_bad_block_table(struct msb_data *msb, int block_nr)

hm.  Should block_nr be a sector_t?  

> +{
> +	struct ms_boot_page *boot_block;
> +	struct scatterlist sg;
> +	u16 *buffer = NULL;
> +	int offset = 0;
> +
> +	int i, error = 0;
> +	int data_size, data_offset, page, page_offset, size_to_read;
> +	u16 pba;

vertical whitespace oddness

> +	BUG_ON(block_nr > 1);
> +
> +	boot_block = &msb->boot_page[block_nr];
> +	pba = msb->boot_block_locations[block_nr];
> +
>
> ...
>
> +static int msb_cache_write(struct msb_data *msb, int lba,
> +	int page, bool add_to_cache_only, struct scatterlist *sg, int offset)
> +{
> +	int error;
> +	struct scatterlist sg_tmp[10];

newline..

> +	if (msb->read_only)
> +		return -EROFS;
> +
> +	if (msb->cache_block_lba == MS_BLOCK_INVALID ||
> +						lba != msb->cache_block_lba)
> +		if (add_to_cache_only)
> +			return 0;
> +
> +	/* If we need to write different block */
> +	if (msb->cache_block_lba != MS_BLOCK_INVALID &&
> +						lba != msb->cache_block_lba) {
> +		dbg_verbose("first flush the cache");
> +		error = msb_cache_flush(msb);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (msb->cache_block_lba  == MS_BLOCK_INVALID) {
> +		msb->cache_block_lba  = lba;
> +		mod_timer(&msb->cache_flush_timer,
> +			jiffies + msecs_to_jiffies(cache_flush_timeout));
> +	}
> +
> +	dbg_verbose("Write of LBA %d page %d to cache ", lba, page);
> +
> +	sg_init_table(sg_tmp, ARRAY_SIZE(sg_tmp));
> +	sg_copy(sg, sg_tmp, ARRAY_SIZE(sg_tmp), offset, msb->page_size);
> +
> +	sg_copy_to_buffer(sg_tmp, sg_nents(sg_tmp),
> +		msb->cache + page * msb->page_size, msb->page_size);
> +
> +	set_bit(page, &msb->valid_cache_bitmap);
> +	return 0;
> +}
> +
>
> ...
>
> +static int msb_do_write_request(struct msb_data *msb, int lba,
> +	int page, struct scatterlist *sg, int len, int *sucessfuly_written)
> +{
> +	int error = 0;
> +	int offset = 0;
> +	*sucessfuly_written = 0;

(more vertical whitespace glitches)

Again the types look a bit wrong.  I'd have expected `len' and `offset'
to be size_t.

> +	while (offset < len) {
> +		if (page == 0 && len - offset >= msb->block_size) {
> +
> +			if (msb->cache_block_lba == lba)
> +				msb_cache_discard(msb);
> +
> +			dbg_verbose("Writing whole lba %d", lba);
> +			error = msb_update_block(msb, lba, sg, offset);
> +			if (error)
> +				return error;
> +
> +			offset += msb->block_size;
> +			*sucessfuly_written += msb->block_size;
> +			lba++;
> +			continue;
> +		}
> +
> +		error = msb_cache_write(msb, lba, page, false, sg, offset);
> +		if (error)
> +			return error;
> +
> +		offset += msb->page_size;
> +		*sucessfuly_written += msb->page_size;
> +
> +		page++;
> +		if (page == msb->pages_in_block) {
> +			page = 0;
> +			lba++;
> +		}
> +	}
> +	return 0;
> +}
>
> ...
>
> +static DEFINE_IDR(msb_disk_idr);
> +static DEFINE_MUTEX(msb_disk_lock);

A little comment which describes the overall role of msb_disk_idr wold
be nice.

>
> ...
>

