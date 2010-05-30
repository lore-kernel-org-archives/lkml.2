Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0E3UcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:32:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56394 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0E3UcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mJTA+qNww887dQ6I6xeM302dfS8DZ2xGa00Nfr7BBdDZt2PaaFwDsUuVnO6jXu3ZIx
         5C8wJB1joQWCA409PzVuHYHBxghJ1JbFZ8oYmPPjVsEPLM/86OqRHkPPUlLEB/G4La/Z
         +e/We0d4cGu1Nok0+3IobMJdFvMDHeogDMvCM=
Date: Sun, 30 May 2010 13:32:17 -0700
From: mark gross <640e9920@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       markgross@thegnar.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Greg KH <gregkh@suse.de>, linux-doc@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <ak@linux.intel.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       James Bottomley <James.Bottomley@suse.de>, tytso@mit.edu,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100530203217.GD25545@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
 <1274863342.5882.4850.camel@twins>
 <1274863987.5882.4892.camel@twins>
 <20100526124929.GA32580@srcf.ucam.org>
 <1274878665.27810.354.camel@twins>
 <20100526132051.GA1834@srcf.ucam.org>
 <20100527172354.43e46cef@notabene.brown>
 <20100529025215.GB11600@gvim.org>
 <AANLkTimVhC3X68uN3krrkkAAAK4a4D5yTK1V8i_x_Vfy@mail.gmail.com>
 <20100530180846.408e50be@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100530180846.408e50be@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 06:08:46PM +1000, Neil Brown wrote:
> On Fri, 28 May 2010 21:04:53 -0700
> Arve Hjønnevåg <arve@android.com> wrote:
> 
> > On Fri, May 28, 2010 at 7:52 PM, mark gross <640e9920@gmail.com> wrote:
> > > On Thu, May 27, 2010 at 05:23:54PM +1000, Neil Brown wrote:
> > >> On Wed, 26 May 2010 14:20:51 +0100
> > >> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > >>
> > >> > On Wed, May 26, 2010 at 02:57:45PM +0200, Peter Zijlstra wrote:
> > >> >
> > >> > > I fail to see why. In both cases the woken userspace will contact a
> > >> > > central governing task, either the kernel or the userspace suspend
> > >> > > manager, and inform it there is work to be done, and please don't
> > >> > > suspend now.
> > >> >
> > >> > Thinking about this, you're right - we don't have to wait, but that does
> > >> > result in another problem. Imagine we get two wakeup events
> > >> > approximately simultaneously. In the kernel-level universe the kernel
> > >> > knows when both have been handled. In the user-level universe, we may
> > >> > have one task schedule, bump the count, handle the event, drop the count
> > >> > and then we attempt a suspend again because the second event handler
> > >> > hasn't had an opportunity to run yet. We'll then attempt a suspend and
> > >> > immediately bounce back up. That's kind of wasteful, although it'd be
> > >> > somewhat mitigated by checking that right at the top of suspend entry
> > >> > and returning -EAGAIN or similar.
> > >> >
> > >>
> > >> (I'm coming a little late to this party, so excuse me if I say something that
> > >> has already been covered however...)
> > >>
> > >> The above triggers a sequence of thoughts which (When they settled down) look
> > >> a bit like this.
> > >>
> > >> At the hardware level, there is a thing that we could call a "suspend
> > >> blocker".  It is an interrupt (presumably level-triggered) that causes the
> > >> processor to come out of suspend, or not to go into it.
> > >>
> > >> Maybe it makes sense to export a similar thing from the kernel to user-space.
> > >> When any event happens that would wake the device (and drivers need to know
> > >> about these already), it would present something to user-space to say that
> > >> the event happened.
> > >>
> > >> When user-space processes the event, it clears the event indicator.
> > >
> > > we did I proposed making the suspend enabling a oneshot type of thing
> > > and all sorts of weak arguments came spewing forth.  I honestly couldn't
> > > tell if I was reading valid input or fanboy BS.
> > >
> > 
> > Can you be more specific? If you are talking about only letting
> > drivers abort suspend, not block it, then the main argument against
> > that is that you are forcing user-space to poll until the driver stops
> > aborting suspend (which according to people arguing against us using
> > suspend would make the power-manager a "bad" process). Or are you
> > talking about blocking the request from user-space until all other
> > suspend-blockers have been released and then doing a single suspend
> > cycle before returning. This would not be as bad, but it would force
> > the user-space power manager to be multi-threaded since it now would
> > have way to cancel the request. Either way, what problem are you
> > trying to solve by making it a one-shot request?
> > 

Sorry about missing Avr's email, I've been fighting with getting my
email forwarding working right.

The problems I want to solve with the one-shot styled interface are:

1) of having to sprinkle suspend blocking sections from isr up to
usermode and get them right.

2) provide a platform / architecture independent framework supporting
other low power modes.

I've just posted a patch that expresses what I was trying to express.
Its hard to take design over email without tossing code back and forth.
It's my turn to toss some code.



> 
> Simply aborting the suspend cannot work as you rightly say - the suspend
> daemon would then spin until other user-space processes get into action.

Not if you have sensible event messaging to the user-space processes.
I've posted a patch that attempts to add some messaging.

> Simply blocking while there are any unhandled 'wakeup events' - then aborting
> if there were any - is how I think it should work.  However as it
> doesn't work that way now I don't think it is safe to make it work that way
> unconditionally.  If we did we could find that existing configurations always
> block suspend indefinitely with would clearly be a regression.
> 
> I think we still need some sort of "suspend_prepare".  This would have two
> particular effects.
> 1/ it sets the start time for interpreting the word "were" above.  i.e. the
>   suspend would abort of there were any unhandled wakeup events since the
>   "suspend_prepare" was issued.
> 2/ It would allow unhandled wakeup events to abort the suspend.  If no
>   suspend_prepare had been issued, then only "new" wakeup events would
>   be allowed to abort the suspend (i.e. the old racy version of suspend).
> 
> So the suspend daemon does:
> 
>    wait for there to be no user-space suspend blocks
>    issue suspend_prepare
>    check there are still no suspend blocks
>    if there are, loop (possibly issue suspend_abort if needed)
>    issue suspend request
>    loop
> 
> processes that handle wakeup events would
> 
>    poll for event to be available
>    request suspend-block
>    consume event
>    release suspend-block
>    loop

In my mind I'm thinking of something like:
	attempt low power entry (suspend)
	if blocked, get -EBUSY back
		select on block_file until block is released
		retry suspend
	else // entered low power and exited
		read wake_event
		do something with event; typically wait a bit and loop.

--mgross

> 
> (where consuming the event would quite possibly cause some other
> suspend-block to become active - e.g. it might request that the display
> be unlocked which would block suspends for a time).
> 
> NeilBrown
