Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0E2CwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 22:52:09 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59782 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0E2CwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 22:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wbzTCmP48GkYRWiVqRiJerbjhKDVPp9k7S3V7cHnKfB3JZKzRm2ffb3zfJUyr/U/wX
         UYZ1EJT4O9x4oVLHEkoK8eAowe8yMFruak0QxLyX/UHkfeUPsY2v5ofK0qjBynDxcPHv
         /C4HcHjBoMtPV2VevF0IBIqfFE1aBf1INmXbA=
Date: Fri, 28 May 2010 19:52:15 -0700
From: mark gross <640e9920@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100529025215.GB11600@gvim.org>
Reply-To: markgross@thegnar.org
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
 <201005252344.37639.rjw@sisk.pl>
 <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
 <1274863342.5882.4850.camel@twins>
 <1274863987.5882.4892.camel@twins>
 <20100526124929.GA32580@srcf.ucam.org>
 <1274878665.27810.354.camel@twins>
 <20100526132051.GA1834@srcf.ucam.org>
 <20100527172354.43e46cef@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527172354.43e46cef@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:23:54PM +1000, Neil Brown wrote:
> On Wed, 26 May 2010 14:20:51 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Wed, May 26, 2010 at 02:57:45PM +0200, Peter Zijlstra wrote:
> > 
> > > I fail to see why. In both cases the woken userspace will contact a
> > > central governing task, either the kernel or the userspace suspend
> > > manager, and inform it there is work to be done, and please don't
> > > suspend now.
> > 
> > Thinking about this, you're right - we don't have to wait, but that does 
> > result in another problem. Imagine we get two wakeup events 
> > approximately simultaneously. In the kernel-level universe the kernel 
> > knows when both have been handled. In the user-level universe, we may 
> > have one task schedule, bump the count, handle the event, drop the count 
> > and then we attempt a suspend again because the second event handler 
> > hasn't had an opportunity to run yet. We'll then attempt a suspend and 
> > immediately bounce back up. That's kind of wasteful, although it'd be 
> > somewhat mitigated by checking that right at the top of suspend entry 
> > and returning -EAGAIN or similar.
> > 
> 
> (I'm coming a little late to this party, so excuse me if I say something that
> has already been covered however...)
> 
> The above triggers a sequence of thoughts which (When they settled down) look
> a bit like this.
> 
> At the hardware level, there is a thing that we could call a "suspend
> blocker".  It is an interrupt (presumably level-triggered) that causes the
> processor to come out of suspend, or not to go into it.
> 
> Maybe it makes sense to export a similar thing from the kernel to user-space.
> When any event happens that would wake the device (and drivers need to know
> about these already), it would present something to user-space to say that
> the event happened.
> 
> When user-space processes the event, it clears the event indicator.

we did I proposed making the suspend enabling a oneshot type of thing
and all sorts of weak arguments came spewing forth.  I honestly couldn't
tell if I was reading valid input or fanboy BS.

--mgross


> 
> When there are no more current event indicators, userspace is allowed to
> request a suspend.  Obviously this could fail as an event could happen at any
> moment, but the same is true when the kernel asks the device to suspend, an
> interrupt might happen immediately to stop it.  But in either case an event
> will be reported.  So when userspace requests a suspend and it fails, it
> will see events reported and so will wait for them to be handled.
> 
> I imagine a sysfs directory with files that appear when events are pending.
> We could have some separate mechanism for user-space processes to request
> that the suspend-daemon not suspend.  Then it suspends whenever there are no
> pending requests from user-space or from the kernel.
> 
> The advantage of this model of suspend-blockers is that it is a close
> analogue for something that already exists in hardware so it isn't really
> creating new concepts, just giving the Linux virtual-machine features that
> have proved themselves in physical machines.
> 
> The cost is that any wake-up event needs to not only be handled, but also
> explicitly acknowledged by clearing the relevant suspend-blocker (i.e.
> removing the file from sysfs, or whatever interface was ultimately chosen).
> I'm hoping that isn't a big cost.
> 
> NeilBrown
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
