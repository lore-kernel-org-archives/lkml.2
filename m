Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1JKWHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 18:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1JKWHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 18:07:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>,
        Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Subject: Re: Block regression since 3.1-rc3
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	<20111008161421.GA5743@redhat.com> <20111010213316.GM8100@google.com>
	<20111011195611.GA26277@redhat.com> <20111011205251.GA6281@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 11 Oct 2011 18:07:25 -0400
In-Reply-To: <20111011205251.GA6281@google.com> (Tejun Heo's message of "Tue,
	11 Oct 2011 13:52:51 -0700")
Message-ID: <x498vor41ya.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Mike.
>
> On Tue, Oct 11, 2011 at 03:56:12PM -0400, Mike Snitzer wrote:
>> > I don't object to the immediate fix but think that adding such special
>> > case is gonna make the thing even more brittle and make future changes
>> > even more difficult.  Those one off cases tend to cause pretty severe
>> > headache when someone wants to evolve common code, so let's please
>> > find out what went wrong and fix it properly so that everyone follows
>> > the same set of rules.
>> 
>> Are you referring to Jeff's fix as "the immediate fix"?  Christophe
>> seems to have had success with it after all.
>
> I meant reverting the previous commit.  Oops... it seems like I
> misread Jeff's patch.  Please read on.
>
>> As for the special case that you're suggesting makes the code more
>> brittle, etc.  If you could be more specific that'd be awesome.
>
> I was still talking about the previous attempt of making dm treated
> special by flush machinery.  (the purity thing someone was talking
> about)
>
>> Jeff asked a question about the need to kick the queue in this case (as
>> he didn't feel he had a proper justification for why it was needed).
>> 
>> If we can get a proper patch header together to justify Jeff's patch
>> that'd be great.  And then revisit any of the special casing you'd like
>> us to avoid in >= 3.2?
>> 
>> (we're obviously _very_ short on time for a 3.1 fix right now).
> ...
>> > Hmmm... another rather nasty assumption the current flush code makes
>> > is that every flush request has either zero or single bio attached to
>> > it.  The assumption has always been there for quite some time now.
>> 
>> OK.
>> 
>> > That somehow seems broken by request based dm (either that or wrong
>> > request is taking INSERT_FLUSH path).
>> 
>> Where was this issue of a flush having multiple bios reported?
>
> I was misreading Jeff's patch, so the problem is request w/o bio
> reaching INSERT_FLUSH, not rq's with multiple bio's.  Sorry about
> that.  Having another look...
>
> Ah, okay, so, blk-flush on the lower layer device is seeing
> q->flush_rq of the upper layer which doesn't have bio.  Yes, the
> BUG_ON() change looks correct to me.  That or we can do
>
>   BUG_ON(rq->bio != rq->bio_tail); /* assumes zero or single bio rq */
>
> As for the blk_run_queue_async(), it's a bit confusing.  Currently,
> the block layer isn't clear about who's responsible kicking the queue
> after putting a request onto elevator and I suppose Jeff put it there
> because blk_insert_cloned_request() doesn't kick the queue.
>
> Hmm... Jeff, you also added blk_run_queue_async() call in
> 4853abaae7e4a too.  Is there a reason why blk_insert_cloned_request()
> isn't calling __blk_run_queue() or async variant of it like
> blk_insert_request() does?
>
> At any rate, the queue kicking is a different issue.  Let's not mix
> the two here.  The BUG_ON() change looks good to me.

I can submit a two part series, sure.  I'll have to get back to you on
where I think the right place for the queue kick is.  I'll look at it in
detail tomorrow.

-Jeff
