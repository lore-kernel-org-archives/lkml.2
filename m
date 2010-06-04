Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0FDEir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:38:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:40472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0FDEiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:38:46 -0400
Date: Fri, 4 Jun 2010 14:38:26 +1000
From: Neil Brown <neilb@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604143826.2de9b0e8@notabene.brown>
In-Reply-To: <20100603232302.GA16184@elte.hu>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 01:23:02 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Btw., i'd like to summarize the scheduler based suspend scheme proposed by 
> Thomas Gleixner, Peter Zijlstra and myself. I found no good summary of it in 
> the big thread, and there are also new elements of the proposal:

Hi
 I would like to summarise the alternate proposal that I an others have
 suggested in a variety of different forms.

 It starts from the premise that
 1/ Android developers actually like the "big hammer" aspect of suspend.
   Initiating suspend powers down some devices, puts others in low power
   states, freezes all processes and generally puts the device to sleep
   with a well defined and easily controlled (at the whole-of-system level)
   set of events that will wake from suspend.  This is a big part of the
   Android approach to power-saving and I'm guessing they are not keen to
   depart from it.

 2/ The main problem with using suspend as-is is that it is racy.
   The purpose of suspend is to put the device to sleep until a wake-event
   occurs.  When that wake-event occurs at much the same time that suspend is
   requested races can occur.  We want a wake-event to not only wake the
   device, to be keep the device awake while the wake-event is being handled,
   and to cancel any suspend that was initiated before the wake event
   completed.
   We need to understand "wake event" in an holistic sense.  If a key press is
   expected to brighten the screen and make a glyph appear, and if that key
   press is considered to be a wake-event, then the glyph appearing must also
   be a part of the wake event.  For such a holistic wake-event to fully
   block/cancel a suspend there much be some mechanism for hand-over of
   wake-events from kernel-space to user-space.

  Given those premises, google's suspend-blocker approach was to allow a
  kernel thread to initiate suspend whenever nothing was stopping it, and to
  allow both drivers and user processes to block that suspend while handling
  a wake event (or anything else that needed to keep the device awake).
  In this case the hand-over is fairly straight forward as the kernel thread
  as full knowledge and can easily wait for all sorts of things.

  The alternate proposal is simply to have user-space initiate a suspend (as
  is already possible), user-space processes can then trivially block that
  suspend through any of a number of IPC approaches, and kernel space drivers
  can block/abort suspend by explicitly requesting a block.

  The variety of alternate proposals comes from a variety of ways to modify
  the semantics of "ask for a suspend" in such a way that userspace can
  discover when there are kernel-space blocks, and can wait for them to be
  released without spinning.

  A sample modification (which I think is different to all the ones
  mentioned so far, and hopefully pulls out the best of them all) is
  to allow userspace to write e.g. "mem_safe" rather than "mem" to
  /sys/power/state.  The 'safe' implies it is safe from races.

  When this is written, the process sleeps in an interruptible state until
  all in-kernel suspend blocks have been dropped.  If any such suspend blocks
  were found, or if a signal is received, the request aborts.  Only if there
  were no suspend blocks and no pending signals does the suspend progress.

  wake-events in the kernel then need to be tracked all the way to user-space,
  and the in-kernel lock is only dropped when the event is consumed by
  user-space.  User-space must take some sort of lock to ensure no new
  suspend is requested before consuming any wake-events from the kernel.

  I believe this is very close to what android has today, only with a much
  smaller change to the user-space interface, which I believe to be the thing
  that has been found most objectionable.
  I does still require a degree of event-tracking within the kernel which
  might still be objectionable - I'm not so sure about different people's
  positions on that.

Thanks,
NeilBrown
