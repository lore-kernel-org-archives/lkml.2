Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab1JOAEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:04:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43162 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab1JOAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:04:50 -0400
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
From: John Stultz <john.stultz@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
In-Reply-To: <201110150049.39219.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
	 <201110132150.28915.rjw@sisk.pl> <1318546686.3375.231.camel@work-vm>
	 <201110150049.39219.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 17:04:39 -0700
Message-ID: <1318637079.3375.262.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11101500-2398-0000-0000-000001008414
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 00:49 +0200, Rafael J. Wysocki wrote:
> On Friday, October 14, 2011, John Stultz wrote:
> > On Thu, 2011-10-13 at 21:50 +0200, Rafael J. Wysocki wrote:
> > > equivalent to the SLEEPCTL_STAY_AWAKE ioctl() for all processes
> > > that have /dev/sleepctl open at that time and whose timeouts are
> > > greater than 0 (i.e. enabled), to allows those processes to
> > > complete the handling of wakeup events before the system can be
> > > put to a sleep state again.
> > 
> > So the application psudocode looks like the following?
> 
> Not really.
> 
> > Example 1:
> > ----------
> > sleepfd = open("/dev/sleepctl",...);
> > devfd = open("/dev/wakeup-button",...);
> > ...
> > count = read(devfd, buf, bufsize);
> > ioctl(sleepfd, SLEEP_STAY_AWAKE, 0); /* no timeout */
> 
> No, this doesn't work like this.  You'd need to do:
> 
> write(sleepfd, zero_buf, sizeof(unsigned int));
> ioctl(sleepfd, SLEEP_STAY_AWAKE);

Sorry for misunderstanding. Thanks for the clarification!

 
> > Now, my opinion: So, again, I'd welcome any solution to the problem, but
> > I'm personally not a big fan of the timeout usage found in this
> > proposal, as well as the Android wakelocks implementation. Its simply
> > racy, and would break down under heavy load or when interacting with
> > cpuhogging SCHED_FIFO tasks. Practically, it can be made to work, but I
> > worry the extra safety-margins folks will add to the timeouts will
> > result in inefficient power wasting.
> 
> That's the cost of simplicity.

True. Again, just my feelings about the approach, not an objection to
it. I'm happy if a workable solution can be merged, but I want to make
sure the tradeoffs are discussed/understood.


> > Now, an actual problem: Further, I'm worried this still doesn't address
> > the main race in the alarmtimer triggered system backup case:
> > 
> > Example 2:
> > ----------
> > sleepfd = open("/dev/sleepctl",...);
> > ...
> > /* wait till 5pm */
> > clock_nanosleep(CLOCK_REALTIME_ALARM, TIMER_ABSTIME, backup_ts); 
> > ioctl(sleepfd, SLEEP_STAY_AWAKE, 0); /* no timeout */
> > do_backup();
> > ioctl(sleepfd, SLEEP_RELAX);
> > 
> > 
> > Which is basically identical to the above. At 5pm the alarmtimer fires,
> > and increments the wakeup_count. 
> > 
> > At the same time, maybe on a different cpu, the PM daemon reads the
> > updated wakeup_count, writes it back and triggers suspend.
> 
> It doesn't really have to write it back, but that's a minor thing.
> 
> > All of this happens before my backup application gets scheduled and can
> > call the ioctl.
> 
> So the solution for your backup application is to (1) open "/dev/sleepctl",
> (2) set a suitable timeout (using write()), (3) call
> ioctl(sleepfd, SLEEP_STAY_AWAKE) and go to sleep, (4) (when woken up)
> open "/dev/sleepctl" again, set the timeout on sleepfd2 to 0 and call
> ioctl(sleepfd2, SLEEP_STAY_AWAKE), (5) close sleepfd (the first instance),
> (6) do whatever it wants and (7) call ioctl(sleepfd2, SLEEP_RELAX).

I think I see how using the two open fds on sleepctl allows having the
timeout based stay-awake to be triggered after the resume, as well as
the infinite stay-awake which can be taken once the task is woken up.

But I'm still not sure I follow how this avoids the race between the
alarm firing and a separate suspend call when the system has been
running. That is why I suggested having the kernel take the stay-awake
timeout on *any* wakeup event (which I think would resolve this
concern). Does that make any sense?

My apologies if I'm still just not understanding it.


> > I think in order to avoid this with your approach, I think you're going
> > to need to have the kernel take the SLEEPCTL_STAY_AWAKE timeout for
> > every open fd upon *any* wakeup event, even when the system is running
> > and not just at resume.
> > 
> > The same bad behavior could also be tripped in example #1, with the
> > wakeup button being pressed while the system was running, right as a
> > suspend was triggered.
> > 
> > 
> > I think this is in part an issue with the "globalness" of the
> > wakeup_count value. We know an event happened, but we don't *which*
> > event, or if anyone was waiting for that event, or if the event has been
> > consumed. Thus with your approach, its necessary to use a timeout to try
> > to cover everyone, since there's not enough knowledge. 
> > 
> > Basically it breaks down to three questions I think we have to answer:
> > 1) What event is being waited on?
> > 2) Who is waiting?
> > 3) Has the event been consumed?
> 
> Which only is relevant if we want to have a very fine grained resolution
> of things.  I'm not really sure that very fine grained resolution is
> achievable at all anyway, though.
> 
> > To summarize my understanding of other recently proposed approaches to
> > this core issue:
> > 
> > Again, in your proposal (if adjusted as I suggest to avoid the backup
> > race) tasks register their wakeup-interest (#2), by opening the sleepctl
> > file, and then you inhibit suspend for the maximum specified timeout on
> > every wakeup event (#1) assuming that gives enough time for whichever
> > task was waiting on the triggered event to consume it (#3).
> 
> To be precise, the maximum specified timeout is only used for the events
> that either aborted suspend in progress, or actually woke up the system.
> 
> > Neil's userspace approach (as best as I understand it) tries to resolve
> > this knowledge issue by requiring *everyone* who might be waiting to
> > consume wakeup events check-in with the PM daemon prior to *any* suspend
> > (If the PM daemon is aggressive, trying to suspend frequently, this
> > results in requiring every consumer to check in on every wakeup event).
> > So in this model, we get a list of waiters (#2) communicating with the
> > PM daemon, and for any event (#1), we require all waiters to ack (#3)
> > that its ok to suspend.
> > 
> > Mark's approach uses per-wakeup-device files in order to inform the
> > kernel about interest, allowing the kernel to inhibit suspend when a
> > wakeup event occurs on that device for each open fd (#1 & #2). Then it
> > requires each consumer to "ack" the events consumption (#3) back to the
> > fd, where the suspend inhibition is dropped. 
> > 
> > My approach is using a per-task flag of power-importance(#2), which
> > inhibits suspend if any task has such a flag. Any blocking call upon a
> > wakeup device (#1) will drop the flag, allowing suspend to occur, and
> > the kernel re-raises the flag when the task is woken up, which the task
> > can drop when its done (#3). 
> > 
> > Finally, Android's wakelock's are actually very conceptually similar to
> > Mark's, but utilize existing device files (#1&#2) (so its a little more
> > implicit) and uses read()  as the "ack" (#3) to allow the kernel to drop
> > the wakelock.
> 
> I don't think it works this way.  The Android's interface for using wakelocks
> from user space is just that a user space process can create and use a
> wakelock with the help of a special device file or something like this,
> IIRC.

There are also wakelocks (with timeouts) taken by the kernel to protect
the wakeup-event data while it is buffered until it is read by userland
(or the timeout trips). Thus the select/wake_lock/read pattern that was
discussed by Arve here:
http://www.kerneltrap.com/mailarchive/linux-kernel/2010/5/21/4573616


> > Does that seem reasonably accurate/fair?
> 
> It would be fair if you said that your approach and the Android's one had been
> frowned upon by the scheduler people, so I don't think we can realistically
> regard them as doable. :-)

Totally true! My approach does have its significant detractors. :) 

My hope with the above was not to judge the different approaches, but
just to summarize what we've seen so far in the hopes that we can better
understand the problem.

Again, as I said, I'm very excited to see your proposal, and look
forward to it (or maybe just my understanding of it :) progressing.

thanks
-john

