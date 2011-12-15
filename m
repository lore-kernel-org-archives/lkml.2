Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab1LOSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:09:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1LOSJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:09:25 -0500
Date: Thu, 15 Dec 2011 19:07:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: printk() vs tty_io
Message-ID: <20111215180725.GA30567@elte.hu>
References: <1323804803.9082.40.camel@twins>
 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
 <1323860206.28489.35.camel@twins>
 <20111214140527.GA18080@thunk.org>
 <1323872631.28489.37.camel@twins>
 <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
 <1323943005.18942.18.camel@twins>
 <CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Dec 15, 2011 at 1:56 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > We probably could, I can have a closer look, but the main question is,
> > are we going to commit to no wakeups from console implementations? That
> > would mean removing the USB serial console support and other such stuff.
> 
> I guess we can't.
> 
> So new approach:
> 
>  - screw it. the rq lock is just too central, you cannot call 
> printk from under it. And if you have an oops under it, you're 
> screwed.
> 
>    Peter, why do you want to try to work from under the rq 
>    lock?

Well, no real strong reason: we had that nasty xtime_lock 
related lockup in printk() (which was arguably much worse than 
the rq lock dependency - and it got fixed), and everyone assumed 
that somehow we could just remove the rq lock dependency from 
printk() as well.

It appears we can't - and that's OK.

Was an intellectual excercise which didnt work out.

>  - Make a special "debug printk" that is not synchronous. Just 
> make it buffer things, and have it actually print out from a 
> worker thread or whatever. This one *only* takes the lock for 
> that buffer itself, and works everywhere. We could probably 
> even do tricks to make it NMI-safe.

We kind of already have such a thing: trace_printk() - which 
works from the weirdest of atomic contexts as well.

IIRC Peter uses trace_printk() to develop the scheduler all the 
time.

What we could perhaps do is a sort of 'shut up regular printk 
and feed all printks into the trace buffers' kind of debug 
switch.

>    Make code that isn't an oops or other very synchronous 
> "have to print out *now*" aim to use this "softer" printk.

For early and nast oopses we have a very primitive printk: 
earlyprintk=keep which can just act as a full printk 
replacement. I use earlyprintk=keep while regular printk is 
disabled (there's no console).

[ earlyprintk can be used to debug everything except printk() 
  lockups, obviously. ]

Thanks,

	Ingo
