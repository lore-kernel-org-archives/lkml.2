Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3AERqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:46:39 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:41066 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802Ab3AERqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:46:37 -0500
Date: Sat, 5 Jan 2013 11:46:32 -0600
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org
Subject: kernel BUG at kernel/sched_rt.c:493!
Message-ID: <20130105174632.GB19226@u1004.rgmadvisors.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently managed to crash 10 of our test machines at the same time.
Half of the machines were running a 3.1.9 kernel and half were running
3.4.9.  I realize that these are both fairly old kernels but I've
skimmed the list of fixes in the 3.4.* stable series and didn't see
anything that appeared to be relevant to this issue.

All we managed to get was some screenshots of the stacks from the
consoles. On one of the 3.1.9 machines you can see we hit the
BUG_ON(want) statement in __disable_runtime() at
kernel/sched_rt.c:493, and all of the machines had essentially the
same stack showing:

rt_offline_rt
rq_attach_root
cpu_attach_domain
partition_sched_domains
do_rebuild_sched_domains

Here is one of the screenshots of the 3.1.9 machines:

https://dl.dropbox.com/u/84066079/berbox38.png

And here is one from a 3.4.9 machine:

https://dl.dropbox.com/u/84066079/berbox18.png

Three of the five 3.4.9 machines also managed to print
"[sched_delayed] sched: RT throttling activated" ~7 minutes before the
machines locked up.

I've tried reproducing the issue, but so far I've been unsuccessful
but I believe that is because my RT tasks aren't using enough CPU
cause borrowing from the other runqueues.  Normally our RT tasks use
very little CPU so I'm not entirely sure what conditions caused them
to run into throttling on the day that this happened.

The details that I do know about the workload that caused this are as
follows.

1) These are all dual socket 4 core X5460 systems with no
hyperthreading.  Thus there are 8 cores total in the system.
2) We use the cpuset cgroup to apply CPU affinity to various types of
processes.  Initially everything starts out in a single cpuset and the
top level cpuset has cpuset.sched_load_balance=1 thus there is only a
single scheduling domain.
3) In this case tasks were then placed into four non overlapping
cpusets.  1 containing a single core and single SCHED_FIFO task, 2
containing two cores, and multiple SCHED_FIFO tasks, and 1 containing
3 cores and everything else on the system running as SCHED_OTHER.
4) In the case of cpusets that contain SCHED_FIFO tasks, the tasks
start out as SCHED_OTHER are placed into the cpuset then change their
policy to SCHED_FIFO.
5) Once all tasks are placed into non overlapping cpusets the top
level cpuset.sched_load_balance is set to 0 to split the system into
four scheduling domains.
6) The system ran like this for some unknown amount of time.
7) All the processes are then sent a signal to exit, and at the same
time the top level cpuset.sched_load_balance is set back to 1.  This
is when the systems locked up.

Hopefully that is enough information to give someone more familiar
with the scheduler code an idea of where the bug is here.  I will
point out that in step #5 above there is a small window where the RT
tasks could encounter runtime limits but are still in a single big
scheduling domain.  I don't know if that is what happened or if it is
simply sufficient to hit the runtime limits while the system is split
into four domains.  For the curious we are using the default RT
runtime limits:

# grep . /proc/sys/kernel/sched_rt_*
/proc/sys/kernel/sched_rt_period_us:1000000
/proc/sys/kernel/sched_rt_runtime_us:950000

Let me know if you anyone needs any more information about this issue.

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
