Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1JOV0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:26:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1JOV0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:26:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate mode
Date: Sat, 15 Oct 2011 23:29:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
References: <201110132145.42270.rjw@sisk.pl> <201110150049.39219.rjw@sisk.pl> <1318637079.3375.262.camel@work-vm>
In-Reply-To: <1318637079.3375.262.camel@work-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110152329.03774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 15, 2011, John Stultz wrote:
> On Sat, 2011-10-15 at 00:49 +0200, Rafael J. Wysocki wrote:
> > On Friday, October 14, 2011, John Stultz wrote:
> > > On Thu, 2011-10-13 at 21:50 +0200, Rafael J. Wysocki wrote:
> > > > equivalent to the SLEEPCTL_STAY_AWAKE ioctl() for all processes
> > > > that have /dev/sleepctl open at that time and whose timeouts are
> > > > greater than 0 (i.e. enabled), to allows those processes to
> > > > complete the handling of wakeup events before the system can be
> > > > put to a sleep state again.
> > > 
> > > So the application psudocode looks like the following?
> > 
> > Not really.
> > 
> > > Example 1:
> > > ----------
> > > sleepfd = open("/dev/sleepctl",...);
> > > devfd = open("/dev/wakeup-button",...);
> > > ...
> > > count = read(devfd, buf, bufsize);
> > > ioctl(sleepfd, SLEEP_STAY_AWAKE, 0); /* no timeout */
> > 
> > No, this doesn't work like this.  You'd need to do:
> > 
> > write(sleepfd, zero_buf, sizeof(unsigned int));
> > ioctl(sleepfd, SLEEP_STAY_AWAKE);
> 
> Sorry for misunderstanding. Thanks for the clarification!
> 
>  
> > > Now, my opinion: So, again, I'd welcome any solution to the problem, but
> > > I'm personally not a big fan of the timeout usage found in this
> > > proposal, as well as the Android wakelocks implementation. Its simply
> > > racy, and would break down under heavy load or when interacting with
> > > cpuhogging SCHED_FIFO tasks. Practically, it can be made to work, but I
> > > worry the extra safety-margins folks will add to the timeouts will
> > > result in inefficient power wasting.
> > 
> > That's the cost of simplicity.
> 
> True. Again, just my feelings about the approach, not an objection to
> it. I'm happy if a workable solution can be merged, but I want to make
> sure the tradeoffs are discussed/understood.
> 
> 
> > > Now, an actual problem: Further, I'm worried this still doesn't address
> > > the main race in the alarmtimer triggered system backup case:
> > > 
> > > Example 2:
> > > ----------
> > > sleepfd = open("/dev/sleepctl",...);
> > > ...
> > > /* wait till 5pm */
> > > clock_nanosleep(CLOCK_REALTIME_ALARM, TIMER_ABSTIME, backup_ts); 
> > > ioctl(sleepfd, SLEEP_STAY_AWAKE, 0); /* no timeout */
> > > do_backup();
> > > ioctl(sleepfd, SLEEP_RELAX);
> > > 
> > > 
> > > Which is basically identical to the above. At 5pm the alarmtimer fires,
> > > and increments the wakeup_count. 
> > > 
> > > At the same time, maybe on a different cpu, the PM daemon reads the
> > > updated wakeup_count, writes it back and triggers suspend.
> > 
> > It doesn't really have to write it back, but that's a minor thing.
> > 
> > > All of this happens before my backup application gets scheduled and can
> > > call the ioctl.
> > 
> > So the solution for your backup application is to (1) open "/dev/sleepctl",
> > (2) set a suitable timeout (using write()), (3) call
> > ioctl(sleepfd, SLEEP_STAY_AWAKE) and go to sleep, (4) (when woken up)
> > open "/dev/sleepctl" again, set the timeout on sleepfd2 to 0 and call
> > ioctl(sleepfd2, SLEEP_STAY_AWAKE), (5) close sleepfd (the first instance),
> > (6) do whatever it wants and (7) call ioctl(sleepfd2, SLEEP_RELAX).
> 
> I think I see how using the two open fds on sleepctl allows having the
> timeout based stay-awake to be triggered after the resume, as well as
> the infinite stay-awake which can be taken once the task is woken up.
> 
> But I'm still not sure I follow how this avoids the race between the
> alarm firing and a separate suspend call when the system has been
> running. That is why I suggested having the kernel take the stay-awake
> timeout on *any* wakeup event (which I think would resolve this
> concern). Does that make any sense?
> 
> My apologies if I'm still just not understanding it.

No, you understand it very well, I'm sorry for being a bit dense.  I must
have been really tired last night. :-)

So I think (please correct me if I'm wrong) that you're worried about the
following situation:

- The process opens /dev/sleepctl and sets the timeout
- It sets up a wake alarm to trigger at time T.
- It goes to sleep and sets it wakeup time to time T too, e.g. using select()
  with a timeout.
- The system doesn't go to sleep in the meantime.
- The wake alarm triggers a bit earlier than the process is woken up and
  system suspend is started in between of the two events.

This race particular race is avoidable if the process sets its wakeup time
to T - \Delta T, where \Delta T is enough for the process to be scheduled
and run ioctl(sleepfd, SLEEPCTL_STAY_AWAKE).  So the complete sequence may
look like this:

- The process opens /dev/sleepctl as sleepfd1 and sets the timeout to 0.
- The process opens /dev/sleepctl as sleepfd2 and sets the timeout to T_2.
  T_2 should be sufficient for the process to be able to call
  ioctl(sleepfd1, SLEEPCT_STAY_AWAKE) when woken up.
- It sets up a wake alarm to trigger at time T.
- It goes to sleep and sets it wakeup time to time T - \Delta T, such that
  \Delta T is sufficient for the process to call
  ioctl(sleepfd2, SLEEPCT_STAY_AWAKE).

Then, if system suspend happens before T - \Delta T, the process will be
woken up along with the wakealarm event at time T and it will be able to call
ioctl(sleepfd1, SLEEPCT_STAY_AWAKE) before T_2 expires.  If system suspend
doesn't happen in that time frame, the process will wake up at T - \Delta T
and it will be able to call ioctl(sleepfd1, SLEEPCT_STAY_AWAKE) (even if
system suspend triggers after the process has been woken up and before it's
able to run the ioctl, it doesn't matter, because the wakealarm wakeup will
trigger the sleepfd2's STAY_AWAKE anyway).

Still, there appear to be similar races that aren't avoidable (for example,
if the time the wake alarm will trigger is not known to the process in
advance), so I have an idea how to address them.  Namely, suppose we have
one more ioctl, SLEEPCTL_WAIT_EVENT, that's equivalent to a combination
of _RELAX, wait and _STAY_AWAKE such that the process will be sent a signal
(say SIGPWR) on the first wakeup event and it's _STAY_AWAKE will trigger
automatically.

So in the scenarion above:

- The process opens /dev/sleepctl, sets the timeout to 0 and calls
  ioctl(sleepfd, SLEEPCTL_STAY_AWAKE).
- It sets up a wake alarm to trigger at time T.
- It runs ioctl(sleepctl, SLEEPCTL_WAIT_EVENT) which "relaxes" its sleepfd
  and makes it go to sleep until the first wakeup event happens.
- The process' signal handler checks if the current time is >= T and makes
  the process go to the previous step if not.

Hmm?

Rafael
