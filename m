Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab1JNWrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:47:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1JNWrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:47:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate mode
Date: Sat, 15 Oct 2011 00:49:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
References: <201110132145.42270.rjw@sisk.pl> <201110132150.28915.rjw@sisk.pl> <1318546686.3375.231.camel@work-vm>
In-Reply-To: <1318546686.3375.231.camel@work-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110150049.39219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, October 14, 2011, John Stultz wrote:
> On Thu, 2011-10-13 at 21:50 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The currently available mechanism allowing the suspend process to
> > avoid racing with wakeup events registered by the kernel appears
> > to be difficult to use.  Moreover, it requires that the suspend
> > process communicate with other user space processes that may take
> > part in the handling of wakeup events to make sure that they have
> > done their job before suspend is started.  Therefore all of the
> > wakeup-handling applications are expected to use an IPC mechanism
> > allowing them to exchange information with the suspend process, but
> > this expectation turns out to be unrealistic in practice.  For this
> > reason, it seems reasonable to add a mechanism allowing the
> > wakeup-handling processes to communicate with the suspend process
> > to the kernel.
> 
> Hey Rafael! 
> 
> I'm *very* excited to see some alternate approaches here, as I'll very
> much admit that my proposal does have some complexities. While I still
> prefer my approach, I'm pragmatic and would be happy with other
> solutions as long as they solve the issue.
> 
> I've not yet dug deeply into the code of your patch, but some conceptual
> thoughts and issues below.
> 
> > This change introduces a new sleep mode, called "cooperative" sleep
> > mode, which needs to be selected via the /sys/power/sleep_mode sysfs
> > attribute and causes detection of wakeup events to be always
> > enabled, among other things, and a mechanism allowing user space
> > processes to prevent the system from being put into a sleep state
> > while in this mode.
> > 
> > The mechanism introduced by this change is based on a new special
> > device file, /dev/sleepctl.  A process wanting to prevent the system
> > from being put into a sleep state is expected to open /dev/sleepctl
> > and execute the SLEEPCTL_STAY_AWAKE ioctl() with the help of it.
> > This will make all attempts to suspend or hibernate the system block
> > until (1) the process executes the SLEEPCTL_RELAX ioctl() or (2)
> > a predefined timeout expires.  The timeout is set to 500 ms by
> > default, but the process can change it by writing the new timeout
> > value (in milliseconds) to /dev/sleepctl, in binary (unsigned int)
> > format.
> 
> Just a nit, but is there any reason not to use u64 nanosecond value
> instead of the jiffies-like granularity and range? Maybe u64 ns is
> over-design, but milliseconds are getting a bit coarse these days.
> 
> >   The current timeout value can be read from /dev/sleepctl.
> > Setting the timeout to 0 disables it, i.e. it makes the
> > SLEEPCTL_STAY_AWAKE ioctl() block attempts to suspend or hibernate
> > the system until the SLEEPCTL_RELAX ioctl() is executed.
> > 
> > In addition to that, when system is resuming from suspend or
> > hibernation, the kernel automatically carries out an operation
> 
> Only when resuming from suspend/hibernation? Hrmm.. See below for my
> concerns about this specifically.
> 
> > equivalent to the SLEEPCTL_STAY_AWAKE ioctl() for all processes
> > that have /dev/sleepctl open at that time and whose timeouts are
> > greater than 0 (i.e. enabled), to allows those processes to
> > complete the handling of wakeup events before the system can be
> > put to a sleep state again.
> 
> So the application psudocode looks like the following?

Not really.

> Example 1:
> ----------
> sleepfd = open("/dev/sleepctl",...);
> devfd = open("/dev/wakeup-button",...);
> ...
> count = read(devfd, buf, bufsize);
> ioctl(sleepfd, SLEEP_STAY_AWAKE, 0); /* no timeout */

No, this doesn't work like this.  You'd need to do:

write(sleepfd, zero_buf, sizeof(unsigned int));
ioctl(sleepfd, SLEEP_STAY_AWAKE);

> do_stuff(buf,count);
> ioctl(sleepfd, SLEEP_RELAX);
> 
> 
> And the assumption is that when *any* wakeup event occurs, even if its
> not the /dev/wakeup-button, the system will stay awake on this
> application's behalf for 500ms (or the max value provided to sleepctl)
> 
> Then, the hope is that if the wakeup-button did wake the system up, the
> application would get woken up from the read() call and hopefully
> complete the STAY_AWAKE ioctl within the provided 500ms.
> 
> 
> A minor nit, first: With the code above, after we call SLEEP_RELAX, the
> timeout has been set to zero, so if we're the only one, the next wakeup
> will not actually inhibit suspend for any amount of time. It might be
> good to separate the ioctl used to set the timeout length, and the one
> to inhibit suspend.

It is separate.  The timeout is set by a write().

> 
> Now, my opinion: So, again, I'd welcome any solution to the problem, but
> I'm personally not a big fan of the timeout usage found in this
> proposal, as well as the Android wakelocks implementation. Its simply
> racy, and would break down under heavy load or when interacting with
> cpuhogging SCHED_FIFO tasks. Practically, it can be made to work, but I
> worry the extra safety-margins folks will add to the timeouts will
> result in inefficient power wasting.

That's the cost of simplicity.

> Now, an actual problem: Further, I'm worried this still doesn't address
> the main race in the alarmtimer triggered system backup case:
> 
> Example 2:
> ----------
> sleepfd = open("/dev/sleepctl",...);
> ...
> /* wait till 5pm */
> clock_nanosleep(CLOCK_REALTIME_ALARM, TIMER_ABSTIME, backup_ts); 
> ioctl(sleepfd, SLEEP_STAY_AWAKE, 0); /* no timeout */
> do_backup();
> ioctl(sleepfd, SLEEP_RELAX);
> 
> 
> Which is basically identical to the above. At 5pm the alarmtimer fires,
> and increments the wakeup_count. 
> 
> At the same time, maybe on a different cpu, the PM daemon reads the
> updated wakeup_count, writes it back and triggers suspend.

It doesn't really have to write it back, but that's a minor thing.

> All of this happens before my backup application gets scheduled and can
> call the ioctl.

So the solution for your backup application is to (1) open "/dev/sleepctl",
(2) set a suitable timeout (using write()), (3) call
ioctl(sleepfd, SLEEP_STAY_AWAKE) and go to sleep, (4) (when woken up)
open "/dev/sleepctl" again, set the timeout on sleepfd2 to 0 and call
ioctl(sleepfd2, SLEEP_STAY_AWAKE), (5) close sleepfd (the first instance),
(6) do whatever it wants and (7) call ioctl(sleepfd2, SLEEP_RELAX).

> I think in order to avoid this with your approach, I think you're going
> to need to have the kernel take the SLEEPCTL_STAY_AWAKE timeout for
> every open fd upon *any* wakeup event, even when the system is running
> and not just at resume.
> 
> The same bad behavior could also be tripped in example #1, with the
> wakeup button being pressed while the system was running, right as a
> suspend was triggered.
> 
> 
> I think this is in part an issue with the "globalness" of the
> wakeup_count value. We know an event happened, but we don't *which*
> event, or if anyone was waiting for that event, or if the event has been
> consumed. Thus with your approach, its necessary to use a timeout to try
> to cover everyone, since there's not enough knowledge. 
> 
> Basically it breaks down to three questions I think we have to answer:
> 1) What event is being waited on?
> 2) Who is waiting?
> 3) Has the event been consumed?

Which only is relevant if we want to have a very fine grained resolution
of things.  I'm not really sure that very fine grained resolution is
achievable at all anyway, though.

> To summarize my understanding of other recently proposed approaches to
> this core issue:
> 
> Again, in your proposal (if adjusted as I suggest to avoid the backup
> race) tasks register their wakeup-interest (#2), by opening the sleepctl
> file, and then you inhibit suspend for the maximum specified timeout on
> every wakeup event (#1) assuming that gives enough time for whichever
> task was waiting on the triggered event to consume it (#3).

To be precise, the maximum specified timeout is only used for the events
that either aborted suspend in progress, or actually woke up the system.

> Neil's userspace approach (as best as I understand it) tries to resolve
> this knowledge issue by requiring *everyone* who might be waiting to
> consume wakeup events check-in with the PM daemon prior to *any* suspend
> (If the PM daemon is aggressive, trying to suspend frequently, this
> results in requiring every consumer to check in on every wakeup event).
> So in this model, we get a list of waiters (#2) communicating with the
> PM daemon, and for any event (#1), we require all waiters to ack (#3)
> that its ok to suspend.
> 
> Mark's approach uses per-wakeup-device files in order to inform the
> kernel about interest, allowing the kernel to inhibit suspend when a
> wakeup event occurs on that device for each open fd (#1 & #2). Then it
> requires each consumer to "ack" the events consumption (#3) back to the
> fd, where the suspend inhibition is dropped. 
> 
> My approach is using a per-task flag of power-importance(#2), which
> inhibits suspend if any task has such a flag. Any blocking call upon a
> wakeup device (#1) will drop the flag, allowing suspend to occur, and
> the kernel re-raises the flag when the task is woken up, which the task
> can drop when its done (#3). 
> 
> Finally, Android's wakelock's are actually very conceptually similar to
> Mark's, but utilize existing device files (#1&#2) (so its a little more
> implicit) and uses read()  as the "ack" (#3) to allow the kernel to drop
> the wakelock.

I don't think it works this way.  The Android's interface for using wakelocks
from user space is just that a user space process can create and use a
wakelock with the help of a special device file or something like this,
IIRC.

> Does that seem reasonably accurate/fair?

It would be fair if you said that your approach and the Android's one had been
frowned upon by the scheduler people, so I don't think we can realistically
regard them as doable. :-)

Thanks,
Rafael
