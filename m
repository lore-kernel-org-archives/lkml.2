Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1DRWi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:38:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:45877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab1DRWiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:38:25 -0400
Date: Tue, 19 Apr 2011 08:38:13 +1000
From: NeilBrown <neilb@suse.de>
To: "hch@infradead.org" <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110419083813.5c61aa99@notabene.brown>
In-Reply-To: <20110418213048.GA21852@infradead.org>
References: <4DA2E03A.2080607@fusionio.com>
	<20110411212635.7959de70@notabene.brown>
	<4DA2E7F0.9010904@fusionio.com>
	<20110411220505.1028816e@notabene.brown>
	<4DA2F00E.6010907@fusionio.com>
	<20110418081922.1651474a@notabene.brown>
	<4DABDC60.2090009@fusionio.com>
	<20110418172551.55629fc6@notabene.brown>
	<4DABF1EA.3070301@fusionio.com>
	<20110418183343.036f412e@notabene.brown>
	<20110418213048.GA21852@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 17:30:48 -0400 "hch@infradead.org" <hch@infradead.org>
wrote:

> >       md: provide generic support for handling unplug callbacks.
> 
> This looks like some horribly ugly code to me.  The real fix is to do
> the plugging in the block layers for bios instead of requests.  The
> effect should be about the same, except that merging will become a
> little easier as all bios will be on the list now when calling into
> __make_request or it's equivalent, and even better if we extent the
> list sort callback to also sort by the start block it will actually
> simplify the merge algorithm a lot as it only needs to do front merges
> and no back merges for the on-stack merging.
> 
> In addition it should also allow for much more optimal queue_lock
> roundtrips - we can keep it locked at the end of what's currently
> __make_request to have it available for the next bio that's been
> on the list.  If it either can be merged now that we have the lock
> and/or we optimize get_request_wait not to sleep in the fast path
> we could get down to a single queue_lock roundtrip for each unplug.

Does the following match with your thinking?  I'm trying to make for a more
concrete understanding...

 - We change the ->make_request_fn interface so that it takes a list of
   bios rather than a single bio - linked on ->bi_next.
   These bios must all have the same ->bi_bdev.  They *might* be sorted
   by bi_sector (that needs to be decided).


 - generic_make_request currently queues bios if there is already an active
   request (this limits recursion).  We enhance this to also queue requests
   when code calls blk_start_plug.
   In effect, generic_make_request becomes:
        if (current->plug)
		blk_add_to_plug(current->plug, bio);
	else {
		struct blk_plug plug;
		blk_start_plug(&plug);
		__generic_make_request(bio);
		blk_finish_plug(&plug);
	}

 - __generic_make_request would sort the list of bios by bi_bdev (and maybe 
   bi_sector) and pass them along to the different ->make_request_fn
   functions.

   As there are likely to be only a few different bi_bdev values (often 1) but
   hopefully lots and lots of bios it might be more efficient to do a linear
   bucket sort based on bi_bdev, and only sort those buckets on bi_sector if
   required.

Then make_request_fn handlers can expect to get lots of bios at once, can
optimise their handling as seems appropriate, and not require any further
plugging.


Is that at all close to what you are thinking?

NeilBrown
