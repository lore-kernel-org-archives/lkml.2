Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0LJW1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:27:16 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:57390 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0LJW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tAWwb32Pm8euqZ/yF/oMGeXYEq4Ca54ouGaLTz9iTx8UBQ0mDXmtkgTpiKRhfhnQ3V
         4hJpMOIkTuB0vvKj3LbpnNV0YpYVTDDVBB3HIWi8vycwtodRlyaVjR8JD4qS7Zp9TnjY
         lwJOdK6RR7mX42sZcGnQz63a/6CsHEdSaGMAQ=
Subject: Re: [PATCH 1/2] memstick: add support for legacy memorysticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
        Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20101209130936.5c62ac10.akpm@linux-foundation.org>
References: <1291862363.7792.28.camel@maxim-laptop>
	 <1291862546-10064-1-git-send-email-maximlevitsky@gmail.com>
	 <20101209130936.5c62ac10.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Dec 2010 00:27:08 +0200
Message-ID: <1292020028.31669.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 13:09 -0800, Andrew Morton wrote:
> On Thu,  9 Dec 2010 04:42:25 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > +/*
> > + * Advance scatterlist by 'consumed' bytes
> > + * Returns new scatterlist, or NULL if can't advance that much
> > + */
> > +static struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
> > +{
> > +	while (consumed >= sg->length) {
> > +		consumed -= sg->length;
> > +
> > +		sg = sg_next(sg);
> > +		if (!sg)
> > +			break;
> > +	}
> > +
> > +	WARN_ON(!sg && consumed);
> > +
> > +	if (!sg)
> > +		return NULL;
> > +
> > +	sg->offset += consumed;
> > +	sg->length -= consumed;
> > +
> > +	if (sg->offset >= PAGE_SIZE) {
> > +		struct page *page =
> > +			nth_page(sg_page(sg), sg->offset / PAGE_SIZE);
> > +		sg_set_page(sg, page, sg->length, sg->offset % PAGE_SIZE);
> > +	}
> > +
> > +	return sg;
> > +}
> > +
> > +/* Calculate number of sg entries in sg list */
> > +static int sg_nents(struct scatterlist *sg)
> > +{
> > +	int nents = 0;
> > +	while (sg) {
> > +		nents++;
> > +		sg = sg_next(sg);
> > +	}
> > +
> > +	return nents;
> > +}
> > +
> > +/* Calculate total lenght of scatterlist */
> 
> (typo)
> 
> > +static int sg_total_len(struct scatterlist *sg)
> > +{
> > +	int len = 0;
> > +	while (sg) {
> > +		len += sg->length;
> > +		sg = sg_next(sg);
> > +	}
> > +	return len;
> > +}
> > +
> > +/* Compare contents of an sg to a buffer */
> > +static bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
> > +{
> > +	unsigned long flags;
> > +	int retval = 0;
> > +	struct sg_mapping_iter miter;
> > +
> > +	if (sg_total_len(sg) < len)
> > +		return 1;
> > +
> > +	local_irq_save(flags);
> > +	sg_miter_start(&miter, sg, sg_nents(sg),
> > +				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> > +
> > +	while (sg_miter_next(&miter) && len > 0) {
> > +
> > +		int cmplen = min(miter.length, len);
> > +		if (memcmp(miter.addr, buffer, cmplen)) {
> > +			retval = 1;
> > +			break;
> > +		}
> > +
> > +		buffer += cmplen;
> > +		len -= cmplen;
> > +	}
> > +
> > +	sg_miter_stop(&miter);
> > +	local_irq_restore(flags);
> > +	return retval;
> > +}
> 
> I think I mentioned this before, but ...  it's really bad that the
> above functions appear in a particular device driver.  They are, to
> varying degrees, independent of that driver and should be provided by
> the sglist core code.
I agree with you.
However, note that Alex's mspro_blk.c, also contains the above logic, it
is just not separated from the code.
I don't mind adding these to scatterlist code.



> 
> Also, the local_irq_save/restore in sg_compare_to_buffer() is quite
> mysterious and should have a comment explaining why it is there.  Once
> that's done, I might understand why it isn't a bug on SMP machines ;)
Its is done to be able to use kmap_atomic.
I think I can use sg_mitter there, I will try to.

Best regards,
	Maxim Levitsky.




