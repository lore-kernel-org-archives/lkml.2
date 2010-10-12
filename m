Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0JLKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:16:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0JLKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:16:56 -0400
Date: Tue, 12 Oct 2010 12:16:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: William Pitcock <nenolod@dereferenced.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
Message-ID: <20101012101645.GA32486@elte.hu>
References: <20101012093044.GD20366@elte.hu>
 <8358526.1721286876359420.JavaMail.root@ifrit.dereferenced.org>
 <20101012094735.GH20366@elte.hu>
 <201010122057.37272.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010122057.37272.kernel@kolivas.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> On Tue, 12 Oct 2010 20:47:35 Ingo Molnar wrote:
> > * William Pitcock <nenolod@dereferenced.org> wrote:
> > > Hi,
> > > 
> > > ----- "Ingo Molnar" <mingo@elte.hu> wrote:
> > > > * William Pitcock <nenolod@dereferenced.org> wrote:
> > > > > Inspired by the recent change to BFS by Con Kolivas, this patch
> > > > 
> > > > causes
> > > > 
> > > > > vruntime to be penalized based on parent depth from their root task
> > > > > 
> > > > > group.
> > > > > 
> > > > > I have, for the moment, decided to make it a default feature since
> > > > 
> > > > the
> > > > 
> > > > > design of CFS ensures that broken applications depending on task
> > > > > enqueue behaviour behaving traditionally will continue to work.
> > > > 
> > > > Just curious, is this v5 submission a reply to Peter's earlier review
> > > > of
> > > > your v3 patch? If yes then please explicitly outline the changes you
> > > > did
> > > > so that Peter and others do not have to guess about the direction your
> > > > 
> > > > work is taking.
> > > 
> > > I just did that in the email I just sent.  Simply put, I was talking
> > > with Con a few weeks ago about the concept of having a maximum amount
> > > of service for all threads belonging to a process.  This did not work
> > > out so well, so Con proposed penalizing based on fork depth, which
> > > still allows us to maintain interactivity with make -j64 running in
> > > the background.
> > > 
> > > Actually, I lie: it works great for server scenarios where you have
> > > some sysadmin also running azureus.  Azureus gets penalized instead,
> > > but other apps like audacious get penalized too.
> > 
> > Thanks for the explanation!
> > 
> > 	Ingo
> 
> It's a fun feature I've been playing with that was going to make it into the 
> next -ck, albeit disabled by default. Here's what the patch changelog was 
> going to say:

Find below the reply Peter sent to William's v5 patch. I suspect there 
will be a v6 to address those problems :)

(William: please Cc: Con too to future updates of your patch.)

Thanks,

	Ingo

----- Forwarded message from Peter Zijlstra <peterz@infradead.org> -----

Date: Tue, 12 Oct 2010 11:46:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: William Pitcock <nenolod@dereferenced.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH try 3] CFS: Add hierarchical tree-based penalty.

On Tue, 2010-10-12 at 13:34 +0400, William Pitcock wrote:
> Yes, this should be a multiplication I believe, not a divide.  My original
> code had this as a multiplication, not a division, as does the new patch.
> 
> However, I think:
> 
>     vruntime >>= tsk->fork_depth;
> 
> would do the job just as well and be faster. 

That's still somewhat iffy as explained, vruntime is the absolute
service level, multiplying that by 2 (or even more) will utterly upset
things.

Imagine two runnable tasks of weight 1, say both have a vruntime of 3
million, seconds (there being two, vruntime will advance at 1/2
wall-time).

Now, suppose you wake a third, it too had a vruntime of around 3 million
seconds (it only slept for a little while), if you then multiply that
with 2 and place it at 6 mil, it will have to wait for 6 mil seconds
before it gets serviced (twice the time of the 3 mil difference in
service time between this new and the old tasks).

So, theory says the fair thing to do is place new tasks at the weighted
average of the existing tasks, but computing that is expensive, so what
we do is place it somewhere near the leftmost task in the tree.

Now, you don't want to push it out too far to the right, otherwise we
get starvation issues and people get upset.

So you have to somehow determine a window in which you want to place
this task and then vary in that depending on your fork_depth.

Simply manipulating the absolute service levels like you propose isn't
going to work.


----- End forwarded message -----

-- 
Thanks,

	Ingo
