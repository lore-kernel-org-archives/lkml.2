Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2IYWPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:15:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39094 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2IYWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:15:12 -0400
Date: Tue, 25 Sep 2012 15:15:08 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, axboe@kernel.dk, vgoyal@redhat.com
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
Message-ID: <20120925221508.GD22647@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-12-git-send-email-koverstreet@google.com>
 <5061464B.4090002@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061464B.4090002@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 07:51:07AM +0200, Hannes Reinecke wrote:
> On 09/25/2012 12:34 AM, Kent Overstreet wrote:
> > +/**
> > + * submit_bio_wait - submit a bio, and wait until it completes
> > + * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
> > + * @bio: The &struct bio which describes the I/O
> > + *
> > + * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
> > + * bio_endio() on failure.
> > + */
> > +int submit_bio_wait(int rw, struct bio *bio)
> > +{
> > +	struct submit_bio_ret ret;
> > +
> > +	rw |= REQ_SYNC;
> > +	init_completion(&ret.event);
> > +	bio->bi_private = &ret;
> > +	bio->bi_end_io = submit_bio_wait_endio;
> 
> Hmm. As this is meant to be a generic function, blindly overwriting
> the bi_end_io pointer doesn't look like a good idea; the caller
> could have set something there.
> 
> Please add at least a WARN_ON(bio->bi_end_io) prior to modifying it.

Nah, the general rule with bios is after it's completed anything
could've been modified; we don't document or enforce otherwise with
bi_end_io (and there's a fair amount of code that saves/sets bi_end_io,
and I don't think it all restores the original before calling it).
I'm not going to special case this unless we start documenting/enforcing
it in general.

Besides that, setting a callback on something that's being used
synchronously is just dumb. Personally, I make damn sure to read and
understand code I'm using. I mean, maybe if this restriction was in the
slightest way subtle, but... how else would submit_bio_wait() be
implemented? It's kind of obvious if you think for two seconds about it.
