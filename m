Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0E3X6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 19:58:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:52811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0E3X6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 19:58:06 -0400
Date: Mon, 31 May 2010 09:57:53 +1000
From: Neil Brown <neilb@suse.de>
To: markgross@thegnar.org
Cc: 640e9920@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mark.gross@intel.com
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode and
 kernel API
Message-ID: <20100531095753.4c174f2d@notabene.brown>
In-Reply-To: <20100530200409.GA21632@gvim.org>
References: <20100530200409.GA21632@gvim.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 May 2010 13:04:10 -0700
mark gross <640e9920@gmail.com> wrote:

> Low Power Events is a possible alternative to suspend blocker / wake
> lock API used by Android.

Here is how I see your proposal.  It is of course possible that I
misunderstood bits, so please correct me where I'm wrong.

1/ You have introduced a new mechanism for requesting a transition
  to a low power state.  This involves writing a number to /dev/lpe_enter.
  It is not clear to me from your text what the magic number really means.
  I think this parallels writing to /sys/power/state, but achieves the same
  result though a different mechanism and adds some extra checking.
  So: I don't understand the numbers, and I don't see why we need a
   second way to request a low power state.  Probably I missed something
   important.

2/ Rather than tracking wake-events from the hardware up through possibly
   several kernel modules, you go directly from hardware to user-space so each
   event is potentially presented to user-space twice: once as a "wake up
   from low power state" event and once following the normal path (maybe a
   key-press event, maybe a serial-port event, maybe a network receive event).
   I can see that this is a very tempting approach.  It allows all those
   intermediate modules to remain unchanged and that is good.
   However it isn't clear to me that this would be easy for user-space to use
   correctly.
   When an lpe event arrived it would need to wait around for the real event
   to arrive and then process that.  I probably wouldn't wait long, but it
   would be an indeterminate wait, and it might not be  trivial to determine
   if all events that would cause a wake-up have been consumed as a direct
   mapping from lpe event to normal event may not always be possible.
   Maybe this is more of a theoretical problem and in practice it would be
   easy to get it right - I don't have enough concrete experience to be sure.

   So: I like the idea of leaving the intermediate layers unchanged, but I'm
   not convinced it would work.

3/ You have created a new mechanism for passing events to user-space.  That
   seems unnecessary.  We already have the input subsystem which is pretty
   good at communication arbitrary events, and the events you are dealing
   with a very much like input events.

So I would suggest modifying your proposal to simply create a new 'input'
device.  Any driver that supports wake-from-suspend queues an event to that
device when a wakeup event occurs.  If the device is open and has any queued
events, then a suspend request such as 'echo mem > /sys/power/state' completes
without going into full suspend.

Then you just need to convince us that this mechanism can be used without any
race problems.  If it can, then it would certainly be a simple and
unobtrusive approach.

Thanks,
NeilBrown
