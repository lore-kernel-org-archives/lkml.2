Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1JKT4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab1JKT4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:56:34 -0400
Date: Tue, 11 Oct 2011 15:56:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>,
        Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Subject: Re: Block regression since 3.1-rc3
Message-ID: <20111011195611.GA26277@redhat.com>
References: <1317397918.27140.15.camel@localhost>
 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
 <1317729761.25998.4.camel@localhost>
 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
 <20111008161421.GA5743@redhat.com>
 <20111010213316.GM8100@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010213316.GM8100@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10 2011 at  5:33pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello, Mike.
> 
> On Sat, Oct 08, 2011 at 12:14:21PM -0400, Mike Snitzer wrote:
> > Unless others have an immediate ah-ha moment, I'd suggest we revert
> > commit 4853abaae7e4a2a (block: fix flush machinery for stacking drivers
> > with differring flush flags).  Whereby avoiding unnecessarily reentering
> > the flush machinery.
> 
> I don't object to the immediate fix but think that adding such special
> case is gonna make the thing even more brittle and make future changes
> even more difficult.  Those one off cases tend to cause pretty severe
> headache when someone wants to evolve common code, so let's please
> find out what went wrong and fix it properly so that everyone follows
> the same set of rules.

Are you referring to Jeff's fix as "the immediate fix"?  Christophe
seems to have had success with it after all.

As for the special case that you're suggesting makes the code more
brittle, etc.  If you could be more specific that'd be awesome.

Jeff asked a question about the need to kick the queue in this case (as
he didn't feel he had a proper justification for why it was needed).

If we can get a proper patch header together to justify Jeff's patch
that'd be great.  And then revisit any of the special casing you'd like
us to avoid in >= 3.2?

(we're obviously _very_ short on time for a 3.1 fix right now).

> > If commit ed8b752bccf256 (dm table: set flush capability based on
> > underlying devices) is in place the flush gets fed directly to
> > scsi_request_fn, which is fine because the request-based DM's
> > request_queue's flush_flags reflect the flush capabilities of the
> > underlying device(s).
> > 
> > We are then covered relative to the only request-based DM use-case
> > people care about (e.g. dm-multipath, which doesn't use stacked
> > request-based DM).
> > 
> > We can revisit upholding the purity of the flush machinery for stacked
> > devices in >= 3.2.
> 
> Hmmm... another rather nasty assumption the current flush code makes
> is that every flush request has either zero or single bio attached to
> it.  The assumption has always been there for quite some time now.

OK.

> That somehow seems broken by request based dm (either that or wrong
> request is taking INSERT_FLUSH path).

Where was this issue of a flush having multiple bios reported?

> Is it possible that a rq /w single bio can end up with multiple bios
> after cloning?

No, blk_rq_prep_clone() just clones the bio(s) that are attached to the
request being cloned.

Mike
