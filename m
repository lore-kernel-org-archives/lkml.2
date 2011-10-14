Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1JNOBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:01:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62543 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1JNOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:01:21 -0400
Date: Fri, 14 Oct 2011 07:01:16 -0700
From: mark gross <markgross@thegnar.org>
To: NeilBrown <neilb@suse.de>
Cc: markgross@thegnar.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111014140116.GC27295@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111002164456.GC14312@mgross-G62>
 <20111008221439.48f30263@notabene.brown>
 <20111008181638.GA12672@mgross-G62>
 <20111009093100.6c15be50@notabene.brown>
 <20111013034805.GC893@mgross-G62>
 <20111013163526.3863be01@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013163526.3863be01@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 04:35:26PM +1100, NeilBrown wrote:
> On Wed, 12 Oct 2011 20:48:05 -0700 mark gross <markgross@thegnar.org> wrote:
> 
> > On Sun, Oct 09, 2011 at 09:31:00AM +1100, NeilBrown wrote:
> > > On Sat, 8 Oct 2011 11:16:38 -0700 mark gross <markgross@thegnar.org> wrote:
> > > 
> > > > On Sat, Oct 08, 2011 at 10:14:39PM +1100, NeilBrown wrote:
> > > > > On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org> wrote:
> > > > > 
> > > > > > resending to wider list for discussion
> > > > > > ----- Forwarded message from mark gross <markgross@thengar.org> -----
> > > > > > 
> > > > > > Subject: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
> > > > > > Date: Tue, 20 Sep 2011 13:33:05 -0700
> > > > > > From: mark gross <markgross@thengar.org>
> > > > > > To: linux-pm@lists.linux-foundation.org
> > > > > > Reply-To: markgross@thegnar.org
> > > > > > Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>
> > > > > > 
> > > > > > The following patch set implement an (untested) solution to the
> > > > > > following problems.
> > > > > > 
> > > > > > 1) a method for making a system unable to suspend for critical sections
> > > > > > of time.
> > > > > 
> > > > > We already have this.  A properly requested suspend (following wakeup_count
> > > > > protocol) is unable to complete between wakeup_source_activate() and
> > > > > wake_source_deactivate() - these delimit the critical sections.
> > > > > 
> > > > > What more than this do you need?
> > > > 
> > > > sometimes devices that are not wake up sources need critical sections
> > > > where suspend is a problem.
> > > 
> > > I agree with Alan that an example would help here.
> > > My naive perspective is that any device is either acting on behalf of a
> > > user-space program, so it should disable suspend, or on behalf of some
> > > external event, so that event is ipso-facto a wakeup event.
> > 
> > battery changing and usb gadget compilance are the ones I can think of
> > at the moment.  I guess the FW / BIOS update may be another (but is a
> > bit weak as an example)
> > 
> > I'm having a hard time thinking of anything else :( 
> 
> These examples are certainly credible.
> 
> In general, I think of the kernel as a service provider.  It doesn't do
> things on it's own, it just performs tasks on the request of some user-space
> process.  In such cases, the user-space process would act to disable suspend
> (by telling the suspend daemon not to).
> However I accept that there are some activities that do not have a user-space
> component.  One that is close to my heart is the NFS server.  The kernel
> contains both the support services and the core logic.
> In general I think such designs are problematic and best avoided, but I
> accept that they are inevitable.
> If the monitoring of battery charging and the management of a usb
> gadget are being handled entirely in the kernel, then so be it.  The control
> logic still has a right to disable suspend, so that has to be in the kernel.
> 
> It can do this currently by activating a wakeup_source.  This could be seen as
> a slightly ugly interface, because it isn't really a wakeup.  However this is
> simply a naming issue.  If we rename it to say_awake_request (or
> caffeine_source). which can still be activated or deactivated, then the
> ugliness goes away and the functionality remains.
> 
> In short: if control logic is in the kernel (which should be avoided but
> sometimes is required) then it is reasonable for that control logic to be able
> to disable suspend, and can do this today by activating a wakeup_source.

oops you are correct (I think.)  This mechanism could be used to block
suspend just as well as my pm_qos hack.  

I think I'll drop my pm_qos patch for suspend blocking.

We still have to handle the notification issue.


> 
> > 
> > > 
> > > > > 
> > > > > > 
> > > > > > 2) providing a race free method for the acknowledgment of wake event
> > > > > > processing before re-entry into suspend can happen.
> > > > > 
> > > > > Again, this is a user-space problem.  It is user-space which requests
> > > > > suspend.  It shouldn't request it until it has checked that there are no wake
> > > > > events that need processing - and should use the wakeup_count protocol to
> > > > > avoid races with wakeup events happening after it has checked.
> > > > 
> > > > Here you are wrong, or missing the point.  The kernel needs to be
> > > > notified from user mode that an update event has been consumed by
> > > > whoever cares about it before the next suspend can happen.  The fact
> > > > that there are time outs in the existing wake event code points to this
> > > > shortcoming in the current implementation.
> > > 
> > >  ... or I have a different perspective.
> > > A write to wakeup_count is a notification to the kernel that all wakeup
> > > events that had commenced prior to that same number being read from
> > > wakeup_count have been consumed.
> > > 
> > > So we already have a mechanism for the notification that you want.
> > 
> > If I understand you correctly; those processes still need an efficient
> > way of notification that the wake event came in.
> 
> [[while re-reading my reply, I realise that I might have misunderstood the
> above. Are you talking about an efficient notification to the process that
> the event has happened, or from the process that the event has been consumed?

Both actually.  There can be processes that need to be notified of wake
events and potentially other processes that consume them.  (think network
packet wake ups and multiple processes that consume different packets)

Those processes need some sort of notification mechanism to ACK the wake
so the next suspend could be attempted by the user mode "suspend daemon"

> I assumed the former and it still seems the best way to read that sentence.
> But if you mean the later... I think I've covered that too, but it makes the
> following paragraph irrelevant.  In that case, ignore it please]]
> 
> Is that a big ask?
> If the wake event is an RTC alarm, then the process will be using
> select/poll/epoll/whatever on an open fd on /dev/rtc and can easily check if
> there are any pending events.
> If the wake event is a button press, or lid opening, it will probably come in
> through the input subsystem and again 'poll' will do the trick.
> If it is a usb device sending a wakeup, it will probably come through input
> too.
> A character arriving on a UART is equally detectable with poll.
> 
> Are there important wakeup events which will not cause a 'poll' to wake up?
> or is poll not "efficient" enough?

I think there are usability and portability issues with using poll across
the random device node, but yes.  Poll is efficient enough to wake the
different processes that would need notification of a wake event.

The problem is that the suspend daemon also gets woken up and starts a
race with the other wake event consumers for the next suspend. 

I acknowledge that we could have a dmesg or socket handshake between the
suspend daemon and the event consumers such that the race could be
handled in user mode.  But, I think it would be nicer all around to have
a consolidated interface that handles the usability problem and
simplifies the complexity of the user mode implementation.



> 
> 
> 
> > 
> > > 
> > > > 
> > > > I suppose one could rig up the user mode suspend daemon with
> > > > notification callbacks between event consumers across the user mode
> > > > stack but its really complex to get it right and forces a solution to a
> > > > problem better solved in kernel mode be done with hacky user mode
> > > > gyrations that may ripple wildly across user mode.
> > > 
> > > I suspect it is in here that the key to our different perspectives lies.
> > > I think than any solution must "ripple wildly across user mode" if by that
> > > you mean that more applications and daemons will need to be power-aware and
> > > make definitive decisions about when they cannot tolerate suspend.
> > > Whether those apps and daemons tell the kernel "don't suspend now" or tell
> > > some user-space daemon "don't suspend now" is fairly irrelevant when
> > > assessing the total impact on user-space.
> > > 
> > > I think a fairly simple protocol involving file locking can be perfectly
> > > adequate to communicate needs relating to suspend-or-don't-suspend among
> > > user-space processes.
> > 
> > I'm not sure how the wake event notification would get to the right
> > process(es) are that need to get the notification in your concept.  But
> > after the processes that need to consume the event are notified (by
> > magic???) then some file locking could be done to coordinate between
> > those and some suspend daemon.
> 
> Not magic.  epoll.
> Any process that wants to handle wakeup events just needs to keep an fd open
> on the source of the event (and negotiate with the suspend daemon at times).
> 
> 
> > 
> > 
> > > 
> > > > 
> > > > Also it is the kernel that is currently deciding when to unblock the
> > > > suspend daemon for the next suspend attempt.  Why not build on that and
> > > > make is so we don't need the time outs?
> > > 
> > > Suspend is a joint decision by user-space and kernel-space.  Each part should
> > > participate according to its expertise.
> > > The kernel can make use of information generated by drivers in the kernel.
> > > User-space can consolidate information generated by user-space processes.
> > > 
> > > 
> > > > 
> > > > > i.e. there is no kernel-space problem to solve here (except for possible
> > > > > bugs).
> > > > 
> > > > Just a race between the kernel allowing a suspend and the user mode code
> > > > having time to consume the last wake event.
> > > >
> > > 
> > > Providing that the source of the wake event does not deactivate the
> > > wakeup_source before the event is visible to userspace, this race is easily
> > > avoided in userspace:
> > 
> > Well this is the crux of the issue.  How are you going to ack the wake
> > event in a sane way?  Its not quite the same as in interrupt.  knowing
> > when to ack it takes both user and kernel mode coordination.  I think.
> 
> This is the beauty that of the wakeup_count approach - you don't need to ack
> the event.  You don't even need to consume the event (though it would be dumb
> not to).
> All a user-space process needs to do is tell the suspend daemon "I've done all
> that I want to do".  It first checks if there is anything that it wants to do
> of course.
> 
> > 
> > > 
> > >    - read wakeup_count
> > suspend daemon blocked here when not ok to suspend.
> > 
> > >    - check all possible wakeup events.
> > but there is a user mode process that needs to chew on this wake up
> > event.  It needs to be notified (somehow) then it needs to coordinate
> > with the suspend daemon before the next suspend happens.
> > 
> 
> This is "simply" a bit of IPC.
> Any program that wants to handle wake events needs to register with the
> suspend daemon.  The daemon says "Hey everyone, I'm about to suspend".
> Each registered program then needs to say either "OK", or "Wait, don't
> suspend now".
> If everyone says "OK", it tries to suspend.  If anyone says "No, wait", it
> waits until they all say "OK, I'm done" at which point it starts at the top
> of the loop again.
> 
> This is just a software engineering issue though.
> 
> An alternate approach would be for each process to give (via unix domain
> sockets) an fd to the suspend daemon.  The suspend daemon just needs to check
> (using e.g. select) that none of the fds are ready.  If they are, it can enter
> a more heavy-weight conversation with the process in question.  If not, it
> can safely suspend.

yes.  I think you are correct.  I need to go back and re-evaluate if the
user mode notification implementation can be more simple than what I was
thinking.

At this point in the discussion I think we agree the notification
handling can be done in user mode.  my patch only attempts to
consolidate the notification and coordination through the wake event
sysfs node.

I cannot say if its worth putting this in the kernel until I attempt a
prototype of doing it in user mode.

> 
> 
> > >    - if there were none, write back to wakeup_count and request a suspend.
> > > 
> > > This is race-free.
> > I don't agree.
> 
> Can you describe a race?
> Here is the sequence as I see it.
> 
> 0: some user-space process is blocking suspend by telling the suspend daemon
>    not to suspend.  There are no pending kernel wakeup events.
>    All processes that handle wakeup events are registered with the daemon.
> 1: last blocking user-space  process releases its "don't suspend" lock.
> 2: suspend-daemon decides to initiate suspend.
> 3: suspend_daemon reads wakeup_count and remembers number.
> 4: suspend daemon tells all registered clients that suspend is imminent.
> 5: each client executes 'poll' or 'select' or whatever and discovers that
>    there are no events.
> 6: each client tells daemon that it is OK to suspend
> 7: when all votes are in, suspend daemon checks that no process is requesting
>    that suspend be blocked.
> 8: if that succeeds, suspend daemon writes the number back to wakeup_count
> 9: if that succeeds, suspend daemon daemon writes 'mem' to 'state'.
> 10: goto 1
> 
> If a wake_event happens after 3 and before 8, the write at 8 will fail.
> If a wake_event happens after 8, and before 9, the suspend will abort.
> If a wake_event happens after 9, the suspend will resume
> If a wake_event happens before 3, one of the processes will get an event
> notification from select or poll or whatever, and will ask the suspend
> daemon not to suspend just now and this will be noticed at 7, so 8 and 9
> will be skipped and we go straight to 10.
> 
> No race.

With the suspend daemon designed as above I see no race either.  I was
thinking of a more trivial suspend daemon design and trying to fix it up
in the kernel.


>  
> > > 
> > > If some wakeup_source is deactivated before the event is visible to
> > > user-space, then that is a bug and should be fixed.
> > one way is to set up overlapping critical sections from the wake event
> > up to user mode (we can call the patch "wakelock.patch" ...  I kid...
> > 
> > The wake source is at the very bottom of the kernel mode stack.
> > Basically an interrupt is the wake event.  How can the ISR possible know
> > when its ok to deactivate the wake event?  There needs to be a
> > formalized hand shake.
> 
> Yes.  But the handshake only needs to get as far as being visible to
> user-space, the event doesn't need to be consumed by user-space.
> 
> See John Stultz's patches to kernel.org
> [PATCH 3/6] [RFC] rtc: rtc-cmos: Add pm_stay_awake/pm_relax calls around IRQ
> [PATCH 4/6] [RFC] rtc: interface: Add pm_stay_awake/pm_relax chaining rtc workqueue processing
> 
> They add the required handshake to rtc.
> The ISR typically activates the wakeup event and queues something to a
> kernel thread.  That thread then does whatever is needed, makes sure the
> event is visible to user-space, and then deactivates the wakeup event.
> 
> (I'm not certain John's patches get it all right in every case, I don't
> know the code well enough, but it looks like the right sort of thing).
> 
> Once the event is visible to user-space, the handshake with the suspend
> daemon ensure that the event gets consumed if anyone is interested in it.

Thanks! I'll look at those.

> 
> > 
> > > If there is some particular case where it is non-trivial to fix that bug,
> > > then that would certainly be worth exploring in detail.
> > >
> > 
> > I don't think you accept the idea that there is a notification problem.
> 
> Nope, but I'm keen for you to convince me.  Identify a wakeup event that
> cannot be made visible to poll (or to user-space by some other
> mechanism) before the wakeup_source needs to be deactivated.  Or if I've
> misunderstood what sort of notification is problematic, help me understand.

I think you have convinced me to give moving the notification burden
into the suspend daemon a try before pushing my patch any further.

i.e. I think my patch is unnecessary now.

> 
> > Fine, Do you at least agree that my problem statement is approximately
> > what we thing the original wake lock design attempted to address?
> 
> If by your "problem statement" you mean this:
> 
> > 1) a method for making a system unable to suspend for critical sections
> > of time.
> > 
> > 2) providing a race free method for the acknowledgment of wake event
> > processing before re-entry into suspend can happen.
> 
> Then yes I agree, though I would state it with a slightly different emphasis:
> 
> 1) a method for ensuring a system does not suspend during critical sections
>    of time 
> 2) providing a race free method for the handling of wake events before
>    re-entry into suspend happens.
> 
> Your text sounds the like the kernel is forcing user-space to do the required
> thing.  My text is meant to only say that the kernel allows user-space to do
> the required thing.
> Maybe not an important difference.
> 
> 
> > 
> > If we can converge on something then maybe we can move forward.  (a bit)
> > 
> > 
> > Clearly the use case I'm talking about with out talking about it is the
> > Android wake lock problem.  I think my problem statement comes pretty
> > close to what it is trying to address.
> > 
> > I think my implementation concept is semantically close enough that I
> > think I could hack an android implementation to work with it without
> > having to change the framework API's and only minor tweaks to a few
> > services (that consume wake events).  And I think my idea provides a
> > more correct solution to the basic problem than the original wake lock
> > design.  i.e.  no over lapping critical sections up and down the stack
> > or the need for wake_locks with (racy) timeouts.
> 
> Your code essentially creates functionality in the kernel to match the IPC
> that I suggest doing in user-space  ... and we really don't need the kernel to
> provide yet another IPC mechanism.
> 
> I'm quite sure you or I could write code in user-space to work with today's
> kernel design to implement Android's wake-lock API.
> (there are bugs that need to be fixed of course, like the fact that the RTC
> wakeup doesn't activate a wake_source ... unless John's patch has gone in).
> 
> ( I would doing using lock files and change notifications: 
>   https://lwn.net/Articles/460902/  )

Thanks for helping me with this.  The next step is to write some user
mode code.

I drop my patches at this time.

--mark

