Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1JQVLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:11:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46624 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab1JQVLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:11:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate mode
Date: Mon, 17 Oct 2011 23:13:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
References: <201110132145.42270.rjw@sisk.pl> <201110152329.03774.rjw@sisk.pl> <1318870100.3125.30.camel@work-vm>
In-Reply-To: <1318870100.3125.30.camel@work-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110172313.41970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011, John Stultz wrote:
> On Sat, 2011-10-15 at 23:29 +0200, Rafael J. Wysocki wrote:
> > So I think (please correct me if I'm wrong) that you're worried about the
> > following situation:
> > 
> > - The process opens /dev/sleepctl and sets the timeout
> > - It sets up a wake alarm to trigger at time T.
> > - It goes to sleep and sets it wakeup time to time T too, e.g. using select()
> >   with a timeout.
> > - The system doesn't go to sleep in the meantime.
> > - The wake alarm triggers a bit earlier than the process is woken up and
> >   system suspend is started in between of the two events.
> > 
> > This race particular race is avoidable if the process sets its wakeup time
> > to T - \Delta T, where \Delta T is enough for the process to be scheduled
> > and run ioctl(sleepfd, SLEEPCTL_STAY_AWAKE).  So the complete sequence may
> > look like this:
> > 
> > - The process opens /dev/sleepctl as sleepfd1 and sets the timeout to 0.
> > - The process opens /dev/sleepctl as sleepfd2 and sets the timeout to T_2.
> >   T_2 should be sufficient for the process to be able to call
> >   ioctl(sleepfd1, SLEEPCT_STAY_AWAKE) when woken up.
> > - It sets up a wake alarm to trigger at time T.
> > - It goes to sleep and sets it wakeup time to time T - \Delta T, such that
> >   \Delta T is sufficient for the process to call
> >   ioctl(sleepfd2, SLEEPCT_STAY_AWAKE).
> > 
> > Then, if system suspend happens before T - \Delta T, the process will be
> > woken up along with the wakealarm event at time T and it will be able to call
> > ioctl(sleepfd1, SLEEPCT_STAY_AWAKE) before T_2 expires.  If system suspend
> > doesn't happen in that time frame, the process will wake up at T - \Delta T
> > and it will be able to call ioctl(sleepfd1, SLEEPCT_STAY_AWAKE) (even if
> > system suspend triggers after the process has been woken up and before it's
> > able to run the ioctl, it doesn't matter, because the wakealarm wakeup will
> > trigger the sleepfd2's STAY_AWAKE anyway).
> 
> So, the alarmtimer code is a bit more simple then what you describe
> above (alarmtimers are just like regular posix timers, only enable an
> RTC wakeup for the soonest event when the system goes into suspend).
> 
> However, such a dual-timer style behavior seems like it could work for
> timer driven wakeups (and have been suggested to me by others as well).
> Just to reiterate my understanding so that we're sure we're on the same
> wavelength:
> 
> For any timer-style wakeup event, you set another non-wakeup timer for
> some small period of time before the wakeup timer. Then when the
> non-wakeup timer fires, the application inhibits suspend and waits for
> the wakeup timer.  
> 
> Thus if the system is supended, the system will stay asleep until the
> wakeup event, where we'll hold off suspend for a timeout length so the
> task can run. If the system is not suspended, the early timer inhibits
> suspend to block the possible race.
> 
> So yes, while not a very elegant solution in my mind (as its still racy
> like any timeout based solution), it would seem to be workable in
> practice, assuming wide error margins are used as the kernel does not
> guarantee that timers will fire at a specific time (only after the
> requested time). 
> 
> And this again assumes we'll see no timing issues as a result of system
> load or realtime task processing.
> 
> 
> > Still, there appear to be similar races that aren't avoidable (for example,
> > if the time the wake alarm will trigger is not known to the process in
> > advance), so I have an idea how to address them.  Namely, suppose we have
> > one more ioctl, SLEEPCTL_WAIT_EVENT, that's equivalent to a combination
> > of _RELAX, wait and _STAY_AWAKE such that the process will be sent a signal
> > (say SIGPWR) on the first wakeup event and it's _STAY_AWAKE will trigger
> > automatically.
> 
> So actually first sentence above is key, so let me talk about that
> before I get into your new solution: As long as we know the timer is
> going to fire, we can set the pre-timer to inhibit suspend. But most
> wakeup events (network packets, keyboard presses, other buttons) are not
> timer based, and we don't know when they would arrive. Thus the same
> race could trigger between a wakeup-button press and a suspend call. 
> 
> 1) wakeup key press
> 2) suspend call
> 3) key-press task scheduled
> 
> That's why I suggested adding the timeout on any wake event, instead of
> resume. This would block the suspend call inbetween the wake event and
> the application processing it. 
> 
> Really, the interaction is between the wakeup event and it being
> processed in userland. Resume, if it occurs, should really be
> transparent to that interaction. So that's why I think the
> resume-specific behavior in your original proposal doesn't make sense.
> 
> 
> > So in the scenarion above:
> > 
> > - The process opens /dev/sleepctl, sets the timeout to 0 and calls
> >   ioctl(sleepfd, SLEEPCTL_STAY_AWAKE).
> > - It sets up a wake alarm to trigger at time T.
> > - It runs ioctl(sleepctl, SLEEPCTL_WAIT_EVENT) which "relaxes" its sleepfd
> >   and makes it go to sleep until the first wakeup event happens.
> > - The process' signal handler checks if the current time is >= T and makes
> >   the process go to the previous step if not.
> 
> 
> So I'm not sure if I'm understanding your suggestion totally. Is it that
> when you call SLEEP_CTL_WAIT_EVENT, the ioctl sets SLEEP_CTL_RELAX, and
> then the ioctl call blocks? 
> 
> Then when the signal handler triggers, where exactly does the
> SLEEP_CTL_STAY_AWAKE call get made? Is it in the signal handler (after
> the task has been scheduled)? Or is it done by the kernel on task
> wakeup?
> 
> If its the former, I don't see how it blocks the race. 
> 
> If its the latter, then it seems this proposal starts to somewhat
> approximate to my proposal (ie: kernel allows suspend on blocking on a
> specific device, then disables it on task wakeup).

It's the latter, but I think I have a better idea.

Please see my recent reply to Alan in this thread for details.

Thanks,
Rafael
