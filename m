Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1JKUw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:52:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51702 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1JKUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:52:57 -0400
Date: Tue, 11 Oct 2011 13:52:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>,
        Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Subject: Re: Block regression since 3.1-rc3
Message-ID: <20111011205251.GA6281@google.com>
References: <1317397918.27140.15.camel@localhost>
 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
 <1317729761.25998.4.camel@localhost>
 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
 <20111008161421.GA5743@redhat.com>
 <20111010213316.GM8100@google.com>
 <20111011195611.GA26277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011195611.GA26277@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Tue, Oct 11, 2011 at 03:56:12PM -0400, Mike Snitzer wrote:
> > I don't object to the immediate fix but think that adding such special
> > case is gonna make the thing even more brittle and make future changes
> > even more difficult.  Those one off cases tend to cause pretty severe
> > headache when someone wants to evolve common code, so let's please
> > find out what went wrong and fix it properly so that everyone follows
> > the same set of rules.
> 
> Are you referring to Jeff's fix as "the immediate fix"?  Christophe
> seems to have had success with it after all.

I meant reverting the previous commit.  Oops... it seems like I
misread Jeff's patch.  Please read on.

> As for the special case that you're suggesting makes the code more
> brittle, etc.  If you could be more specific that'd be awesome.

I was still talking about the previous attempt of making dm treated
special by flush machinery.  (the purity thing someone was talking
about)

> Jeff asked a question about the need to kick the queue in this case (as
> he didn't feel he had a proper justification for why it was needed).
> 
> If we can get a proper patch header together to justify Jeff's patch
> that'd be great.  And then revisit any of the special casing you'd like
> us to avoid in >= 3.2?
> 
> (we're obviously _very_ short on time for a 3.1 fix right now).
...
> > Hmmm... another rather nasty assumption the current flush code makes
> > is that every flush request has either zero or single bio attached to
> > it.  The assumption has always been there for quite some time now.
> 
> OK.
> 
> > That somehow seems broken by request based dm (either that or wrong
> > request is taking INSERT_FLUSH path).
> 
> Where was this issue of a flush having multiple bios reported?

I was misreading Jeff's patch, so the problem is request w/o bio
reaching INSERT_FLUSH, not rq's with multiple bio's.  Sorry about
that.  Having another look...

Ah, okay, so, blk-flush on the lower layer device is seeing
q->flush_rq of the upper layer which doesn't have bio.  Yes, the
BUG_ON() change looks correct to me.  That or we can do

  BUG_ON(rq->bio != rq->bio_tail); /* assumes zero or single bio rq */

As for the blk_run_queue_async(), it's a bit confusing.  Currently,
the block layer isn't clear about who's responsible kicking the queue
after putting a request onto elevator and I suppose Jeff put it there
because blk_insert_cloned_request() doesn't kick the queue.

Hmm... Jeff, you also added blk_run_queue_async() call in
4853abaae7e4a too.  Is there a reason why blk_insert_cloned_request()
isn't calling __blk_run_queue() or async variant of it like
blk_insert_request() does?

At any rate, the queue kicking is a different issue.  Let's not mix
the two here.  The BUG_ON() change looks good to me.

Thank you.

-- 
tejun
