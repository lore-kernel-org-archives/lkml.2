Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0LFMhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:37:53 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:48731 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0LFMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:37:52 -0500
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
 taskstats
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: balbir@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20101203073303.GS2746@balbir.in.ibm.com>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
	 <20101203073303.GS2746@balbir.in.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 06 Dec 2010 13:37:37 +0100
Message-ID: <1291639057.1848.85.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Balbir,

On Fri, 2010-12-03 at 13:03 +0530, Balbir Singh wrote:
> * Oleg Nesterov <oleg@redhat.com> [2010-12-01 19:51:28]:
> 
> > On 11/29, Michael Holzheu wrote:
[snip]
> > Say, taskstats_exit()->fill_stats()->bacct_add_tsk(). Every thread
> > does this, including the group_leader. But, it is possible that
> > group_leader exits first, before other threads. IOW, what
> > stats->ac_cXtime actually mean?
> > 
> 
> stats->ac_* time was designed only for tgid's to begin with,

You mean for tids (threads/tasks), no? stats->ac_* time is only reported
for threads in bacct_add_tsk() and not for tgids.

> so I am
> not sure if ac_cXtime makes sense for threads

I would suggest to do it the same way as /proc/<tgid>/tasks/<tid>/stat.
It reports the (same) cumulative time for each thread. See
do_task_stat() in fs/proc/array.c. So IMHO also for taskstats it makes
sense to include the cXtime for all threads and not only for the thread
group leader. 

Also I would include tgid in taskstats so that userspace can group the
tasks into thread groups. 

I am not sure regarding the aggregation for tgids in
TASKSTATS_CMD_ATTR_TGID and exit events with group_dead=1. Currently
only the delay accounting numbers are aggregated. If we would do it
like /proc/<tgid>/stat (do_task_stat() with whole=1) we also could
aggregate also the other values e.g. the CPU time.

I think the following tgid data would make sense to be returned for
TASKSTATS_CMD_ATTR_TGID and exit events with group_dead=1:

bacct_add_tsk():
----------------
ac_pid         thread group leader (tsk->tgid)
ac_etime       thread group leader
ac_btime       thread group leader
ac_nice        thread group leader
ac_sched       thread group leader
ac_uid         thread group leader
ac_gid         thread group leader
ac_ppid        thread group leader
ac_comm        thread group leader
ac_exit_code   thread group leader
ac_flags       thread group leader
ac_utimescaled ??
ac_stimescaled ??
ac_utime       sum for all live threads + cdata_threads
ac_stime       sum for all live threads + cdata_threads
ac_minflt      sum for all live threads + cdata_threads
ac_majflt      sum for all live threads + cdata_threads

new:
ac_cutime      cdata_wait
ac_cstime      cdata_wait
ac_tgid        thread group leader

xacct_add_tsk():
----------------
coremem        ?
virtmem        ?
hiwater_rss    thread group leader
hiwater_vm     thread group leader
read_char      sum for all live threads + tsk->signal.ioac
write_char     sum for all live threads + tsk->signal.ioac
read_syscalls  sum for all live threads + tsk->signal.ioac
write_syscalls sum for all live threads + tsk->signal.ioac
read_bytes     sum for all live threads + tsk->signal.ioac
write bytes    sum for all live threads + tsk->signal.ioac
cancelled_write_bytes sum for all live threads + tsk->signal.ioac
  
If we leave everything as it currently is for tgid accounting, we
probably should also not include the cXtime for tgids and just include
the data for threads (TASKSTATS_CMD_ATTR_PID and task exit events).

What do you think?

Michael




