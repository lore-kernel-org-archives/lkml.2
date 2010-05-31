Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0EaW0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:26:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41815 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0EaW0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W+LyXksuiNd9NMxuvYdPwmjqivpXIrZkjpJWHu11ZnfD5ytNu2nMKNcxldtY9kxKd9
         HTMuiIWAORJVZ0Td0rSzbIuplGXUjM4xiXk563cWl4aP4bb5VHo/Fzwi+dAqHvWUYIY3
         4WfWFo5VhUIlSUmeSffWuGIwBxMsiUqOd8HCY=
Date: Mon, 31 May 2010 15:26:27 -0700
From: mark gross <640e9920@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Neil Brown <neilb@suse.de>, markgross@thegnar.org, 640e9920@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mark.gross@intel.com
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode
 and kernel API
Message-ID: <20100531222627.GC31155@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100530200409.GA21632@gvim.org>
 <20100531095753.4c174f2d@notabene.brown>
 <20100531084356.272f3e1a@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531084356.272f3e1a@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 08:43:56AM +0200, Florian Mickler wrote:
> On Mon, 31 May 2010 09:57:53 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Sun, 30 May 2010 13:04:10 -0700
> > mark gross <640e9920@gmail.com> wrote:
> > 
> > > Low Power Events is a possible alternative to suspend blocker / wake
> > > lock API used by Android.
> > 
> > Here is how I see your proposal.  It is of course possible that I
> > misunderstood bits, so please correct me where I'm wrong.
> > 
> > 1/ You have introduced a new mechanism for requesting a transition
> >   to a low power state.  This involves writing a number to /dev/lpe_enter.
> >   It is not clear to me from your text what the magic number really means.
> >   I think this parallels writing to /sys/power/state, but achieves the same
> >   result though a different mechanism and adds some extra checking.
> >   So: I don't understand the numbers, and I don't see why we need a
> >    second way to request a low power state.  Probably I missed something
> >    important.
> 
> I can only think for lpe to provide the levels and have userspace and
> platform code hook into there. Else you would have a dependency from
> userspace to platform code.
> 
> > 
> > 2/ Rather than tracking wake-events from the hardware up through possibly
> >    several kernel modules, you go directly from hardware to user-space so each
> >    event is potentially presented to user-space twice: once as a "wake up
> >    from low power state" event and once following the normal path (maybe a
> >    key-press event, maybe a serial-port event, maybe a network receive event).
> >    I can see that this is a very tempting approach.  It allows all those
> >    intermediate modules to remain unchanged and that is good.
> >    However it isn't clear to me that this would be easy for user-space to use
> >    correctly.
> >    When an lpe event arrived it would need to wait around for the real event
> >    to arrive and then process that.  I probably wouldn't wait long, but it
> >    would be an indeterminate wait, and it might not be  trivial to determine
> >    if all events that would cause a wake-up have been consumed as a direct
> >    mapping from lpe event to normal event may not always be possible.
> >    Maybe this is more of a theoretical problem and in practice it would be
> >    easy to get it right - I don't have enough concrete experience to be sure.
> > 
> >    So: I like the idea of leaving the intermediate layers unchanged, but I'm
> >    not convinced it would work.
> 
> To add to this: Is it a correct assumption
> that all wake-up events that leave a driver trickle eventually up to
> userspace?
> 
> I think splitting the actual driver product (i.e. keypress or whatever)
> of a wake-up-event and it's corresponding wake-lock is not possible.
> Because you would have to _somehow_ map the block back to the product
> when you consume the product. 

its only possible if you require a user mode transition after a wake up
before re-entry into the suspend / low power state.

I think kernel mode initiated suspends are problematic.
 
> If you want to abstract the blocking from the kernel-code you probably
> have to introduce an abstract "driver-product" entity where you can do
> all your blocking associated with the product but hidden from the code
> that uses the product. (Which I don't think is feasible, because it
> increases overhead)
> 
> Or am I on the wrong track here? 
maybe a little. 

blocking low power entry and the handling of the unblocking as an event
is orthogonal to wake event notification and handling and the coupling
of the next entry into the low power state..  Much of these
discussions are conflating these two notions.

first blocking from the kernel mode *is* needed.  My poster child for
this is the moorestown OTG hardware.  If we attempt a suspend while
attached to a host the device hangs.  there is a real need for blocking
suspend attempts from kernel mode.  How to handle the event of
unblocking is one of the two main issues.  (the other being wake event
handling.)


> cheers,
> Flo
