Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0EaWK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:10:26 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:44095 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0EaWKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EulffekPiQTwwL9iqcK2MQf2cS5HpfH3BlraEchfxvnEvxZwB2CHkP613poD3rdJTI
         O2PoYWuonERmMDC8/m0/ktONWf/47F2zm9Ad8XeM2Vsq9lvooKCdOgKthgdgm6py1c0P
         5Ah9zLaeh0p1HzOuzx8EscQGJ/V0XRpoQmasQ=
Date: Mon, 31 May 2010 15:10:35 -0700
From: mark gross <640e9920@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: markgross@thegnar.org, 640e9920@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mark.gross@intel.com
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode
 and kernel API
Message-ID: <20100531221035.GB31155@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100530200409.GA21632@gvim.org>
 <20100531095753.4c174f2d@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531095753.4c174f2d@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 09:57:53AM +1000, Neil Brown wrote:
> On Sun, 30 May 2010 13:04:10 -0700
> mark gross <640e9920@gmail.com> wrote:
> 
> > Low Power Events is a possible alternative to suspend blocker / wake
> > lock API used by Android.
> 
> Here is how I see your proposal.  It is of course possible that I
> misunderstood bits, so please correct me where I'm wrong.
> 
> 1/ You have introduced a new mechanism for requesting a transition
>   to a low power state.  This involves writing a number to /dev/lpe_enter.
>   It is not clear to me from your text what the magic number really means.
>   I think this parallels writing to /sys/power/state, but achieves the same
>   result though a different mechanism and adds some extra checking.
>   So: I don't understand the numbers, and I don't see why we need a
>    second way to request a low power state.  Probably I missed something
>    important.

You are not missing much.  Those numbers where an attempt at
generalization for the level of suspend that could be requested by user
mode.  The semantics of what I'm talking about are different form
/sys/power/state even though they both enter low power states.

> 
> 2/ Rather than tracking wake-events from the hardware up through possibly
>    several kernel modules, you go directly from hardware to user-space so each
>    event is potentially presented to user-space twice: once as a "wake up
>    from low power state" event and once following the normal path (maybe a
>    key-press event, maybe a serial-port event, maybe a network receive event).
>    I can see that this is a very tempting approach.  It allows all those
>    intermediate modules to remain unchanged and that is good.
>    However it isn't clear to me that this would be easy for user-space to use
>    correctly.

yeah, I think it needs some prototyping too.

>    When an lpe event arrived it would need to wait around for the real event
>    to arrive and then process that.  I probably wouldn't wait long, but it
>    would be an indeterminate wait, and it might not be  trivial to determine
>    if all events that would cause a wake-up have been consumed as a direct
>    mapping from lpe event to normal event may not always be possible.
>    Maybe this is more of a theoretical problem and in practice it would be
>    easy to get it right - I don't have enough concrete experience to be sure.

You suggest below adding a input class for wakeups.  I think using that
would make sense.
 
>    So: I like the idea of leaving the intermediate layers unchanged, but I'm
>    not convinced it would work.
> 

I'm not fully convinced yet either, but I still think it could work.

> 3/ You have created a new mechanism for passing events to user-space.  That
>    seems unnecessary.  We already have the input subsystem which is pretty
>    good at communication arbitrary events, and the events you are dealing
>    with a very much like input events.

really good idea!
 
> So I would suggest modifying your proposal to simply create a new 'input'
> device.  Any driver that supports wake-from-suspend queues an event to that
> device when a wakeup event occurs.  If the device is open and has any queued
> events, then a suspend request such as 'echo mem > /sys/power/state' completes
> without going into full suspend.

/me likes.
 
> Then you just need to convince us that this mechanism can be used without any
> race problems.  If it can, then it would certainly be a simple and
> unobtrusive approach.

Lets find out.

--mgross

> 
> Thanks,
> NeilBrown
