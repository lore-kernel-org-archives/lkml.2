Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0FUFzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:55:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51617 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0FUFzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GqmEM6NYVGpuN7Xmq6wt+ELWo7agnT6/RbvEQOMW7q2uASXmakFW5JKsqpZBkJaVuo
         1VPUc7aKewsUONUUMawLPg1q1UyV5p3+aBrKZoYvx76R8khuv2Fv9SKrJERAaKUtyLfN
         /DUj2yqnMvruB9c2/EQw8odaCkwMlSw/B9hdA=
Date: Sun, 20 Jun 2010 22:55:22 -0700
From: mark gross <640e9920@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621055522.GE9735@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100620225810.GB9735@gvim.org>
 <Pine.LNX.4.44L0.1006202223440.29532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006202223440.29532-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 10:33:01PM -0400, Alan Stern wrote:
> On Sun, 20 Jun 2010, mark gross wrote:
> 
> > > Indeed, the same problem arises if the event isn't delivered to
> > > userspace until after userspace is frozen.  Of course, the underlying
> > > issue here is that the kernel has no direct way to know when userspace
> > > has finished processing an event.  Userspace would have to tell it,
> > > which generally would mean rewriting some large number of user
> > > programs.
> > 
> > Suspend blockers don't solve this, and the large number of user programs
> > isn't a big number.  /me thinks its 1 or 2 services.
> 
> On Android, perhaps.  What about on other systems?

This is just speculation but, I would expect other systems would have
the graphics, input, telephony, and any PM services wake_count / wake
event ware.  

I can't imagine (at the moment) anything else that would care.

> 
> > > In what way is this better than suspend blockers?
> > 
> > 1) I don't think suspend blockers really solve or effectively articulate
> > the suspend wake event race problem.
> 
> Why not?

For starters the suspend block patch is about suspend blocking, at least
at first before competing ideas starting coming out and this race issue
was offered up as an excuse to not consider the alternative ideas, then
suddenly suspend blocking became a wake event notification mechanism
implementation that was baked into the implementation.  The arguments
are still a blur and irritating to recall / look up again.

But, the point I'm trying to make is that wake event serialization /
event handling suddenly became a big FUD-pie tightly bound to a specific
feature for suspend blocking (or was is auto suspending?  Its a magical
solution to all the PM problems in the kernel.  I'm being sarcastic.)  

Its much better to call out the issue and provide a clean targeted
solution to it without binding it to some other solution to a different
problem.

> 
> > 2) the partial solution suspend blocker offer for the suspend race is
> > tightly bound to the suspend blocker implementation and not useful in
> > more general contexts.
> 
> I don't understand.  Can you explain further?
> 
> > > One advantage of the suspend-blocker approach is that it essentially
> > > uses a single tool to handle both kinds of races (event not fully
> > > handled by the kernel, or event not fully handled by userspace).  
> > > Things aren't quite this simple, because of the need for a special API
> > > to implement userspace suspend blockers, but this does avoid the need
> > > for a power-manager process.
> > 
> > I don't think suspend-blocker handles both kinds of races as well as you
> > seem to think.
> 
> Can you give any counterexamples?

I knew you'd ask such a thing.  Do you have any correctness proofs of it
working right?

Lets consider the RIL incoming call race:
1) user mode initiates an "opportunistic suspend" or whatever we call
this these days by writing to some sys interface.
2) a call comes in (multi-threaded cpu) just after the write.
3) the caif driver grabs a blocker, stopping the in flight suspend in the
nick of time.  But, when should it release it without racing?  How does
one implement that kernel code such that its portable to non-android user
mode stacks? 

> 
> >  A single tool that conflates multiple kernel facilities
> > is not an advantage.  It limits applications outside of the scope of
> > doing it the "android way".
> 
> I don't see that necessarily as a drawback.  You might just as well say
> that the entire Linux kernel limits applications to doing things the
> "Unix" way.  Often have fewer choices is an advantage.

I disagree with your analogy.  One problem one solution with minimal
coupling to other implementation details is nice.  Two problems with one
solution dependent on the system wide architecture bound to a user mode
PM design is fragile and not portable.
 
> > Where do you get the idea that there isn't a need for a centralized PM
> > process in Android?  Thats not true.
> 
> I didn't get that idea from anywhere.  Sorry if I gave the wrong
> impression -- I meant that non-Android systems would need to implement
> a centralized power-manager process, along with all the necessary
> changes to other programs.
> 
> (Incidentally, even on Android the centralized PM process does not 
> handle _all_ of the userspace/kernel wakelock interactions.)
>

Yeah, I've been told that too.  I've grepped for where the wake_unlock
sysfs interfaces are hit from user mode android (eclair) and I would
like some help in identifying those guys. Maybe its in the FroYo code I
don't get to look at yet?

There is libhardware_legacy/power/power.c and  an out of tree kernel
broadcom bcm4329 driver under hardware/broadcom but that doesn't count
as it looks like a kernel driver to me.

--mgross 

