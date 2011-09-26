Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1IZTOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:14:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58007 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab1IZTOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:14:53 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: =?UTF-8?q?=5BPATCH=200/6=5D=20=5BRFC=5D=20Proposal=20for=20optimistic=20suspend=20idea=2E?=
Date: Mon, 26 Sep 2011 12:13:48 -0700
Message-Id: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is a *VERY VERY* rough draft of patches in order to try
to illustrate an idea I've been thinking about since the wakelocks
and suspend-blockers debates happened.

While I doubt the idea is all that novel, I haven't really seen anything
similar discussed yet. Additionally this has very much been influenced by
discussions with Arve Hjønnevåg, Mark Gross, Rafael Wysocki, Alan Stern,
Kevin Hilman, Magnus Damm and others, so credits to all of them for 
clarifying the numerous points of views and requirements that exist,
and helping me better formulate the idea (even if they don't like it :).


>From the wakelock/suspend blockers discussion, as I understood it,
there were three main requirements needed for Android.

1) Method for the kernel to inhibit suspend during some critical section
2) Method for userland to inhibit suspend during some critical section
3) Method using the first two to inhibit suspend from the point that
a wakeup event occurs, until userland has consumed that event.

The third item is the most subtle, and seems to be often overlooked.

The wakelock/suspend_blockers proposal solved #3 by using the following
pattern in userland:

	wake_lock();
	do_stuff();
	wake_unlock();

	select();	//kernel will grab a wakelock when event occurs

	wake_lock();
	read();		//kernel will drop wakelock when data is read

	do_stuff()
	wake_unlock();	


This pattern allows the kernel to inhibit suspend from the wakeup event
until the new data from the event (such as a keyboard press) was read.
The select allows userland to wait until data has arrived, before grabbing
its own wakelock, and then reading the data (where the kernels' wakelock is
then dropped).

This provides proper overlapping critical sections from the wakeup event
all the way to userland consuming the event.


Recently, the pm_stay_awake/pm_relax and wakeup_source infrastructure has
been included into mainline. Some have claimed that this infrastructure
is sufficient to implement wakelock-like functionality, but because the
wakeup_count only provides a count of the number of wakeup events, it
does not provide a way to know if userland has consumed the event. So this
third requirement is not yet met.


In my mind, one disadvantage of the wakelock/suspend-blocker API is that
it requires userland to know what devices are wakeup devices, and must
follow the pattern above interlocking wake_lock calls between select and
read. This makes it a somewhat special case API, with very suspend-specific
rules.

Instead, it seems to me that we could look at this more from the schedulers
point of view. We could have some way for tasks to mark themselves as 
"important", and that would allow us to decide if suspend could occur or not.

In this (again very very rough) draft patch queue, I've used a new
SCHED_STAYAWAKE sched_setsched() flag to be used by applications to mark
themselves as important. This notifies the system that it should not suspend
until the task un-marks itself or dies.

Now, the problem with just some scheduler call is that it really isn't 
any different from the userland wakelock api.

However, here is where the idea is different. Instead of userland having
to know what devices are wakeup sources and dropping a wakelock before
blocking on them, and then having to do a dance to reacquire the wakelock
between the select and the read(), why not leave it all up to the kernel.

The application would mark itself as important, and do whatever it needs
to do.  Should it end up blocking on a device that is backed by a wakeup
source, the kernel could understand that, and de-boost the task's
importance when it blocks. Then when the wakeup event occurs, when the task
is woken up, the kernel would re-boost the task to its original importance.


This can be imagined as a sort of upside down priority inheritance.

Here is an example userland testcase: suspend-block-test.c:

/* Build: gcc -lrt suspend-block-test.c -o suspend-block-test */
#include <stdio.h>
#include <sched.h>

#define SCHED_STAYAWAKE 0x0f000000
#define CLOCK_BOOTTIME			7
#define CLOCK_BOOTTIME_ALARM		9

void main(void)
{
	struct sched_param param;
	int err;
	param.sched_priority = 0;
	sched_setscheduler(0, SCHED_STAYAWAKE, &param);
	while (1) {
		struct timespec ts1, ts2;
		char input[256];
		printf("Waiting for input:");
		scanf("%s", input);

		ts1.tv_sec = 10;
		ts1.tv_nsec = 0;
		printf("Sleeping for 10 seconds (BOOTTIME)\n");
		clock_nanosleep(CLOCK_BOOTTIME, 0, &ts1, &ts2);
		printf("wakeup!\n");

		printf("Sleeping for 10 seconds (BOOTTIME_ALARM)\n");
		clock_nanosleep(CLOCK_BOOTTIME_ALARM, 0, &ts1, &ts2);
		printf("wakeup!\n");
	}
	return;
}


As you can see, after marking itself as important, the application doesn't
need to do anything else special. The system will only allow suspends
to occur while the task is blocked in clock_nanosleep() on the RTC
backed BOOTTIME_ALARM clockid.

Now, this simplified API comes at the cost that it relies hevily on the
kernel to do the right thing. And the kernel must be able to know what
devices are backed by wakeup events or not, and also must protect the
wakeup event to task-wakeup path such that a suspend will not trigger
before the task is re-boosted. These paths can be long and varied, through
threaded-irqs, soft-irqs, workqueues and even timers. So protecting
those paths in the kernel may add quite a bit of complexity. Possibly so
much that this really becomes infeasible.

There are also other complicated cases, like selecting on multiple fds,
where some are backed by wakeup events and some aren't, where its not clear
if de-boosting or not de-boosting would be the right decision.

Further, its likely additional work will be needed refining the
wakeup_source code so we can better distinquish between wake up events
and in-kernel critical section where we want to block suspend. Currently
they are one and the same. But as those in-kernel critical sections are
added, its likely the process of suspending the system may run across code
paths that have such critical sections. And while those critical sections
need to complete before suspend finishes, we don't want them to cause
suspend to abort, as it would if a wakeup event occured.

None the less, because the userland API is a bit simpler, and entrusts the
kernel to do the right thing, it may also be a more flexible userland API
to live with for the comming decades. I could imagine it being useful for
non-suspend power related scheduling decisions, such as if the scheduler
should enforce idleness (via something like idle cycle injection) to save
power or not. Or maybe such a flag could be used to decide if a task's 
timers are important enough to schedule timer irqs in the near future or
not.

But that's all blue-sky talk. 

For now, I'd just be interested in what folks think about the concept with
regards to the wakelock discussions. Where it might not be sufficient? Or
what other disadvantages might it have? Are there any varients to this
idea that would be better?

Again, at this point I'm not trying to push this specific idea forward for
inclusion, but I'm hoping to just put it forward for review to see if it
can't help spur some constructive discussion about it or alternative
approaches.

The following patch queue implements:
* Changes to the suspend code to enforce that suspend will not occur
  while a wakeup is in progress. This is not strictly required, but
  seems useful to me.
* Changes to the scheduler to manage both the per-task importance and 
  global active count, as well as re-boosting on task wakeup.
* Changes to the RTC layers to inhibit suspend on the path from IRQ to
  the task wakeup call.
* Change to the alarmtimer nanosleep call to deboost before blocking

I'll admit there are a lot of problems with the current patches, but
hopefully they communicate the idea well enough to allow for discussion.

Again, big thanks to Mark Gross, Rafael Wysocki, and Alan Stern for
listening and helping me better formulate the idea, and letting me know
where they saw problems with it.

thanks
-john


CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 


John Stultz (6):
  [RFC] suspend: Block suspend when wakeups are in-progress
  [RFC] sched: Add support for SCHED_STAYAWAKE flag
  [RFC] rtc: rtc-cmos: Add pm_stay_awake/pm_relax calls around IRQ
  [RFC] rtc: interface: Add pm_stay_awake/pm_relax chaining rtc
    workqueue processing
  [RFC] alarmtimer: Add pm_stay_awake /pm_relax calls
  [RFC] alarmtimer: Deboost on nanosleep

 drivers/base/power/wakeup.c |   13 ++++++
 drivers/rtc/interface.c     |   16 ++++++-
 drivers/rtc/rtc-cmos.c      |   13 +++++-
 include/linux/sched.h       |   12 +++++
 include/linux/suspend.h     |    3 +
 kernel/exit.c               |    2 +
 kernel/fork.c               |    2 +
 kernel/power/hibernate.c    |    5 ++
 kernel/power/suspend.c      |    5 ++
 kernel/sched.c              |  101 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/alarmtimer.c    |   48 +++++++++++++++++++--
 11 files changed, 212 insertions(+), 8 deletions(-)

-- 
1.7.3.2.146.gca209
