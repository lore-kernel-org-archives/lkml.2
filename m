Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0ITTDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809Ab0ITTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:03:07 -0400
Date: Mon, 20 Sep 2010 12:02:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] MEMSTICK: add support for legacy memorysticks
Message-Id: <20100920120235.f7b93405.akpm@linux-foundation.org>
In-Reply-To: <1284771968.2741.23.camel@maxim-laptop>
References: <1283165327-10144-1-git-send-email-maximlevitsky@gmail.com>
	<1283165327-10144-3-git-send-email-maximlevitsky@gmail.com>
	<20100917161724.3705b21a.akpm@linux-foundation.org>
	<1284771968.2741.23.camel@maxim-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010 03:06:08 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Fri, 2010-09-17 at 16:17 -0700, Andrew Morton wrote: 
> > On Mon, 30 Aug 2010 13:48:46 +0300
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > Huge thanks for Alex Dubov for code that this is based on
> > > and for lot, really lot of help he gave me in understanding
> > > MemorySticks and implementing this driver.
> > > 
> > > His help made this driver possible.
> > > 
> > > As any code that works with user data this driver isn't recommened
> > > to use with valuable data.
> > > 
> > > It tries its best though to avoid data corruption and possible
> > > damage to the card.
> > > 
> > >
> > > ...
> > >
> > > +/* Calculate number of sg entries in sg list */
> > > +static int sg_nents(struct scatterlist *sg)
> > > +{
> > > +	int nents = 0;
> > > +	while (sg) {
> > > +		nents++;
> > > +		sg = sg_next(sg);
> > > +	}
> > > +
> > > +	return nents;
> > > +}
> > > +
> > > +/* Calculate total lenght of scatterlist */
> > > +static int sg_total_len(struct scatterlist *sg)
> > > +{
> > > +	int len = 0;
> > > +	while (sg) {
> > > +		len += sg->length;
> > > +		sg = sg_next(sg);
> > > +	}
> > > +	return len;
> > > +}
> > 
> > Either
> > 
> > a) these functions should be provided by the core scarrerlist code or
> > 
> > b) these functions aren't needed, and this code is doing something
> >    wrong, or at least unusual.
> > 
> > From a peek at other users of sg_miter_start(), I'm suspecting b) ?
> > 
> > 
> > I suppose these should use for_each_sg().
> 
> Yes and No.
> Due to the interfaces of memorystick core I have to deal with
> scatterlists.
> Due to no assumptions attached to them I have to go through great
> lengths of sucky code to deal with them.
> For example short of sg_mitter there is no way to read/write to sg, and
> it isn't flexible enough.
> Also I need to be able to process the sg sector after sector.
> sg_mitter doesn't allow to do that ether.
> So for cases where I can modify the sg I use sg_advance to 'consume' the
> data, in other cases I have to revert to ugly hacks of keeping an offset
> into sg and incrementing it.
> Really, sg was designed to be converted into hardware equivalent and
> given to hardware, but that not the case here.
> On the other hand, working with 'bio's isn't much easier ether...

None of that explains why we're putting non-memstick-specific
scatterlist infrastructure into the memstick driver, rather than into
the scatterlist code.

> > 
> > 
> > > +/* Compare contents of an sg to a buffer */
> > > +static bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
> > > +{
> > > +	unsigned long flags;
> > > +	int retval = 0;
> > > +	struct sg_mapping_iter miter;
> > > +
> > > +	if (sg_total_len(sg) < len)
> > > +		return 1;
> > > +
> > > +	local_irq_save(flags);
> > > +	sg_miter_start(&miter, sg, sg_nents(sg),
> > > +				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> > > +
> > > +	while (sg_miter_next(&miter) && len > 0) {
> > > +
> > > +		int cmplen = min(miter.length, len);
> > > +
> > > +		if (memcmp(miter.addr, buffer, cmplen)) {
> > > +			retval = 1;
> > > +			break;
> > > +		}
> > > +
> > > +		buffer += cmplen;
> > > +		len -= cmplen;
> > > +	}
> > > +
> > > +	sg_miter_stop(&miter);
> > > +	local_irq_restore(flags);
> > > +	return retval;
> > > +}
> This for example is the result of the above. How else can I verify the
> writes?
> 
> > 
> > What's the local_irq_disable() doing here?  It does nothing to block out
> > other CPUs.
> It is here for sg_mitter so it can use the KMAP_IRQ0 entries.

hm, OK.  KM_BIO_SRC_IRQ, actually.

> > 
> > > +/* Get zone at which block with logical address 'lba' lives */
> > > +static int msb_get_zone_from_lba(int lba)
> > > +{
> > > +	if (lba < 494)
> > > +		return 0;
> > > +	return ((lba - 494) / 496) + 1;
> > > +}
> > 
> > Wow.  What do those magic numbers mean?  Something friom some memstick
> > standard?  Should they be enumerated and documented in a header or
> > something?
> These just mean that first zone id 494 sectors long and all others are
> 496 sectors long.
> No problem adding a #define someplace, but these are used only here.

Some comment would suffice.  Right now those numbers are
incomprehensible to the casual reader.  It'd be useful to describe
where they come from.

> > 
> > >
> > > ...
> > >
> > > + * This function is a handler for reads of one page from device
> > 
> > Missing "." :)
> > 
> > >
> > > ...
> > >
> > > +static int msb_ftl_scan(struct msb_data *msb)
> > > +{
> > > +	u16 pba, lba, other_block;
> > > +	u8 overwrite_flag, managment_flag, other_overwrite_flag;
> > > +	int error;
> > > +	struct ms_extra_data_register extra;
> > > +
> > > +	u8 *overwrite_flags = kzalloc(msb->block_count, GFP_KERNEL);
> > 
> > The above two lines should be swapped.
> Don't understand.
> What should I swap?
> Maybe error and extra ?

You have a blank line in the middle of the definitions-of-locals and no
blank line between end-of-locals and start-of-code.

> > >
> > > +static const struct chs_entry chs_table[] = {
> > > +	{ 4,    16,  247,  2  },
> > > +	{ 8,    16,  495,  2  },
> > > +	{ 16,   16,  495,  4  },
> > > +	{ 32,   16,  991,  4  },
> > > +	{ 64,   16,  991,  8  },
> > > +	{128,   16,  991,  16 },
> > > +	{ 0 }
> > > +};
> > 
> > One wonders where this info came from.  Is there a spec we can link
> > readers to?
> Ah, these are more or less random junk.
> This table just specifies the emulated geometry, thus anything plausible
> will do.
> I don't have the spec.

Again, please think how this looks to the unexpert reader: it's a bunch
of numbers with no hint as to how they were generated.

> > > ...
> > >
> > > +static int msb_init_disk(struct memstick_dev *card)
> > > +{
> > > +	struct msb_data *msb = memstick_get_drvdata(card);
> > > +	struct memstick_host *host = card->host;
> > > +	int rc, disk_id;
> > > +	u64 limit = BLK_BOUNCE_HIGH;
> > > +	unsigned long capacity;
> > > +
> > > +	if (host->dev.dma_mask && *(host->dev.dma_mask))
> > > +		limit = *(host->dev.dma_mask);
> > > +
> > > +	if (!idr_pre_get(&msb_disk_idr, GFP_KERNEL))
> > > +		return -ENOMEM;
> > > +
> > > +	mutex_lock(&msb_disk_lock);
> > > +	rc = idr_get_new(&msb_disk_idr, card, &disk_id);
> > > +	mutex_unlock(&msb_disk_lock);
> > 
> > There's a silly race window where another thread can come in and steal
> > the resutls of your idr_pre_get().  Easily fixable by moving the
> > idr_pre_get() call to inside the mutex_lock().
> Sure. I didn't get a good look at that code as it is mostly copied from
> Alex's driver and I probably made a mistake while copying it.

Probably the code you copied from was wrong.  The IDR interface is
really ugly.  All "container class" code which needs to allocate memory
at element-insertion time has this issue.  You should've seen all the
crap we had to do to make insertion of pagecache into radix-trees
reliable :(

> > We have a __packed helper to avoid this mouthful.
> You mean instead of __attribute__((packed))?

yup.


