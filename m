Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0DINdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0DINdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:33:08 -0400
Date: Fri, 9 Apr 2010 09:32:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100409133252.GH15159@redhat.com>
References: <20100323213338.GA29170@redhat.com>
 <20100405141122.GD15159@redhat.com>
 <20100409010248.GE6672@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409010248.GE6672@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:02:53AM +0200, Frederic Weisbecker wrote:
> On Mon, Apr 05, 2010 at 10:11:22AM -0400, Don Zickus wrote:
> > On Tue, Mar 23, 2010 at 05:33:38PM -0400, Don Zickus wrote:
> > > The new nmi_watchdog (which uses the perf event subsystem) is very
> > > similar in structure to the softlockup detector.  Using Ingo's suggestion,
> > > I combined the two functionalities into one file, kernel/watchdog.c.
> > > 
> > > Now both the nmi_watchdog (or hardlockup detector) and softlockup detector
> > > sit on top of the perf event subsystem, which is run every 60 seconds or so
> > > to see if there are any lockups.
> > 
> > I raised some questions privately to Ingo, he asked I re-iterate them with
> > Peter Z. and Frederic W. cc'd.
> > 
> > > Ok thanks.  When you get a chance I had a couple of questions I was hoping
> > > you could answer for me.
> > >
> > > - does the hrtimer stuff look ok?
> 
> 
> IMO, only partially, as explained in my previous mail.

Yup, makes sense, thanks.

> 
> 
> > > - I wanted to merge the hung task detector code into watchdog.c.  The main
> > >   logic of the code is to walk the task list which i thought about doing
> > >   in the watchdog kthread.  I assume that is the right way to go, but i was a
> > >   little confused on how the scheduler worked.  I thought the watchdog kthread
> > >   would be scheduled very frequently (being a high priority task) but it seems
> > >   to only schedule when the code wakes it up.  Is that right?
> 
> 
> Yeah but high-prio doesn't mean that it is scheduled often.
> It means that once it is in a runnable state (TASK_RUNNING), it
> will have a higher priority to get into the cpu (lower prio tasks
> will have less time in the cpu than the higher prio until the higher prio
> get to sleep). Especially here this is a SCHED_FIFO class, so usual
> tasks (SCHED_OTHER) won't ever run until it goes to sleep.
> 
> But when it goes to sleep, it doesn't need the cpu, so other tasks
> can run.
> And it is only woken up every 30 secs, just to call
> __touch_softlockup_watchdog() and then it goes to sleep again
> until the timer wakes it up. That's why it doesn't run often.
> The high priority is just here to ensure it will do its job
> without too much latency, may be even to avoid rt-tasks to
> trigger spurious soft lockups just because the softlockup task
> couldn't run because of them taking the cpu for too long.
> If it starves because of a higher priority task running for
> too long, it can't touch the softlockup_touch_ts, and the timer
> will think there is a softlockup.

Ok.

> 
> 
> Concerning the hung task detector, I think it should be left as is in
> its own file and dedicated task. IIRC the hung task and softlockup
> detectors were in the same file before but they were split up.

I was doing that work based on a request by Ingo.  Ingo, thoughts?

> 
> We can't factorize both in the same task. The softlockup detector
> needs to be a real time task for the reasons stated above. And it's fine
> because it does very few things so it doesn't bother the other tasks
> with its high prio (unless there are strong rt requirement elsewhere).
> But the hung task detector must be a normal task, because it doesn't
> have latency requirements, it just checks if a task is blocked for too
> long, it's not like the softlockup detector that really needs to keep
> up with a timer. Also it does too much things to be an rt task (walking
> through the entire task list).

Ok.  Makes sense.

Cheers,
Don

