Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab0FTW5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:57:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49967 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0FTW5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iBQEmOrhrOH2QQR2NTKBU3R2yvpzmKPjwOSgpKAVcFM0FKidAC1g3yfhAl2xUcX2z8
         MeT+iFRzdG2ybAykkkxhb/bqWqYL6c9LcXy06i4PJS2N473naO7BUADrJ+b2WBhRTaju
         4W5ztulEjHzbPiBM+ybBWURCJYEC9jHskyheI=
Date: Sun, 20 Jun 2010 15:58:10 -0700
From: mark gross <640e9920@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100620225810.GB9735@gvim.org>
Reply-To: markgross@thegnar.org
References: <201006200005.35771.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1006201153420.22272-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006201153420.22272-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 12:28:29PM -0400, Alan Stern wrote:
> On Sun, 20 Jun 2010, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > One of the arguments during the suspend blockers discussion was that the
> > mainline kernel didn't contain any mechanisms allowing it to avoid losing
> > wakeup events during system suspend.
> > 
> > Generally, there are two problems in that area.  First, if a wakeup event
> > occurs exactly at the same time when /sys/power/state is being written to,
> > the even may be delivered to user space right before the freezing of it,
> > in which case the user space consumer of the event may not be able to process
> > it before the system is suspended.
> 
> Indeed, the same problem arises if the event isn't delivered to
> userspace until after userspace is frozen.  Of course, the underlying
> issue here is that the kernel has no direct way to know when userspace
> has finished processing an event.  Userspace would have to tell it,
> which generally would mean rewriting some large number of user
> programs.

Suspend blockers don't solve this, and the large number of user programs
isn't a big number.  /me thinks its 1 or 2 services.
 
> >  Second, if a wakeup event occurs after user
> > space has been frozen and that event is not a wakeup interrupt, the kernel will
> > not react to it and the system will be suspended.
> 
> I don't quite understand what you mean here.  "Reacting" to an event
> involves more than one action.  The kernel has to tell the hardware to
> stop generating the wakeup signal, and it has to handle the event
> somehow.
> 
> If the kernel doesn't tell the hardware to stop generating the wakeup 
> signal, the signal will continue to be active until the system goes to 
> sleep.  At that point it will cause the system to wake up immediately,
> so there won't be any problem.
> 
> The real problem arises when the hardware stops generating the wakeup
> signal but the kernel suspends before it finishes handling the event.  
> For example, an interrupt handler might receive the event and start
> processing it by calling pm_request_resume() -- but if the pm workqueue
> thread is already frozen then the processing won't finish until
> something else wakes the system up.  (IMO this is a potential bug which
> could be fixed without too much effort.)
> 
> > The following patch illustrates my idea of how these two problems may be
> > addressed.  It introduces a new global sysfs attribute,
> > /sys/power/wakeup_count, associated with a running counter of wakeup events
> > and a helper function, pm_wakeup_event(), that may be used by kernel subsystems
> > to increment the wakeup events counter.
> 
> In what way is this better than suspend blockers?

1) I don't think suspend blockers really solve or effectively articulate
the suspend wake event race problem.
2) the partial solution suspend blocker offer for the suspend race is
tightly bound to the suspend blocker implementation and not useful in
more general contexts.
 
> > /sys/power/wakeup_count may be read from or written to by user space.  Reads
> > will always succeed and return the current value of the wakeup events counter.
> > Writes, however, will only succeed if the written number is equal to the
> > current value of the wakeup events counter.  If a write is successful, it will
> > cause the kernel to save the current value of the wakeup events counter and
> > to compare the saved number with the current value of the counter at certain
> > points of the subsequent suspend (or hibernate) sequence.  If the two values
> > don't match, the suspend will be aborted just as though a wakeup interrupt
> > happened.  Reading from /sys/power/wakeup_count again will turn that mechanism
> > off.
> > 
> > The assumption is that there's a user space power manager that will first
> > read from /sys/power/wakeup_count.  Then it will check all user space consumers
> > of wakeup events known to it for unprocessed events.
> 
> What happens if an event arrives just before you read
> /sys/power/wakeup_count, but the userspace consumer doesn't realize
> there is a new unprocessed event until after the power manager checks
> it?  Your plan is missing a critical step: the "handoff" whereby 
> responsibility for handling an event passes from the kernel to 
> userspace.
> 
> With suspend blockers, this handoff occurs when an event queue is 
> emptied and its associate suspend blocker is deactivated.  Or with some 
> kinds of events for which the Android people have not written an 
> explicit handoff, it occurs when a timer expires (timed suspend 
> blockers).

The wakeup_count will need to be incremented in the same even queue the
suspend blocker handoff happens.

> 
> >  If there are any, it will
> > wait for them to be processed and repeat.  In turn, if there are not any,
> > it will try to write to /sys/power/wakeup_count and if the write is successful,
> > it will write to /sys/power/state to start suspend, so if any wakeup events
> > accur past that point, they will be noticed by the kernel and will eventually
> > cause the suspend to be aborted.
> 
> This shares with the other alternatives posted recently the need for a
> central power-manager process.  And like in-kernel suspend blockers, it
> requires changes to wakeup-capable drivers (the wakeup-events counter
> has to be incremented).

true.
 
> One advantage of the suspend-blocker approach is that it essentially
> uses a single tool to handle both kinds of races (event not fully
> handled by the kernel, or event not fully handled by userspace).  
> Things aren't quite this simple, because of the need for a special API
> to implement userspace suspend blockers, but this does avoid the need
> for a power-manager process.

I don't think suspend-blocker handles both kinds of races as well as you
seem to think.  A single tool that conflates multiple kernel facilities
is not an advantage.  It limits applications outside of the scope of
doing it the "android way".

Where do you get the idea that there isn't a need for a centralized PM
process in Android?  Thats not true.
 
> > In addition to the above, the patch adds a wakeup events counter to the
> > power member of struct device and makes these per-device wakeup event counters
> > available via sysfs, so that it's possible to check the activity of various
> > wakeup event sources within the kernel.
> > 
> > To illustrate how subsystems can use pm_wakeup_event(), I added it to the
> > PCI runtime PM wakeup-handling code.
> > 
> > At the moment the patch only contains code changes (ie. no documentation),
> > but I'm going to add comments etc. if people like the idea.
> > 
> > Please tell me what you think.
> 
> While this isn't a bad idea, I don't see how it is superior to the 
> other alternatives that have been proposed.
> 
I like my PM-event framework better but I think this is ok too.

--mgross


 
