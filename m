Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0KHWzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:55:55 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:35382 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755445Ab0KHWzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:55:54 -0500
Date: Tue, 9 Nov 2010 09:55:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dio: track and serialise unaligned direct IO
Message-ID: <20101108225548.GR2715@dastard>
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
 <1289202023-15102-2-git-send-email-david@fromorbit.com>
 <x4962w7al7m.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x4962w7al7m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:28:29AM -0500, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > +struct dio_zero_block {
> > +	struct list_head dio_list;	/* list of io in progress */
> > +	sector_t	zero_block;	/* block being zeroed */
> > +	struct dio	*dio;		/* owner dio */
> > +	wait_queue_head_t wq;		/* New IO block here */
>                       New IOs block here, or new IO blocks here?
> 
> > +/*
> > + * Add a filesystem block to the list of blocks we are tracking.
> > + */
> > +static void
> > +dio_start_zero_block(struct dio *dio, sector_t zero_block)
> > +{
> > +	struct dio_zero_block *zb;
> > +
> > +	zb = kmalloc(sizeof(*zb), GFP_NOIO);
> > +	if (!zb)
> > +		return;
> > +	INIT_LIST_HEAD(&zb->dio_list);
> > +	init_waitqueue_head(&zb->wq);
> > +	zb->zero_block = zero_block;
> > +	zb->dio = dio;
> > +	atomic_set(&zb->ref, 1);
> > +
> > +	spin_lock(&dio_zero_block_lock);
> > +	list_add(&zb->dio_list, &dio_zero_block_list);
> > +	spin_unlock(&dio_zero_block_lock);
> 
> What protects from two processes getting here at the same time, and
> hence adding the same block to the list?  i_mutex?

The wait in dio_zero_block() called before this function is called is
supposed to serialise them, but now that you point it out, it's not
an atomic wait-and-add so ther eis a small window where two IOs
could pass through here. Easy enoug to fix by combining the search
and inѕert - I'll restructure it along those lines.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
