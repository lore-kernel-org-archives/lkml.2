Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0IWNsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:48:08 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:58693 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0IWNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:48:05 -0400
Subject: [RFC][PATCH 00/10] taskstats: Enhancements for precise accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 15:48:01 +0200
Message-ID: <1285249681.1837.28.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently tools like "top" gather the task information by reading procfs
files. This has several disadvantages:

* It is very CPU intensive, because a lot of system calls (readdir, open,
  read, close) are necessary.
* No real task snapshot can be provided, because while the procfs files are
  read the system continues running.
* The procfs times granularity is restricted to jiffies.

In parallel to procfs there exists the taskstats binary interface that uses
netlink sockets as transport mechanism to deliver task information to
user space. There exists a taskstats command "TASKSTATS_CMD_ATTR_PID"
to get task information for a given PID. This command can already be used for
tools like top, but has also several disadvantages:

* You first have to find out which PIDs are available in the system. Currently
  we have to use procfs again to do this.
* For each task two system calls have to be issued (First send the command and
  then receive the reply).
* No snapshot mechanism is available.

GOALS OF THIS PATCH SET
-----------------------
The intention of this patch set is to provide better support for tools like
top. The goal is to:

* provide a task snapshot mechanism where we can get a consistent view of
  all running tasks.
* provide a transport mechanism that does not require a lot of system calls
  and that allows implementing low CPU overhead task monitoring.
* provide microsecond CPU time granularity.

FIRST RESULTS
-------------
Together with this kernel patch set also user space code for a new top
utility (ptop) is provided that exploits the new kernel infrastructure. See
patch 10 for more details.

TEST1: System with many sleeping tasks

  for ((i=0; i < 1000; i++))
  do
         sleep 1000000 &
  done

  # ptop_new_proc

             VVVV
  pid   user  sys  ste  total  Name
  (#)    (%)  (%)  (%)    (%)  (str)
  541   0.37 2.39 0.10   2.87  top
  3743  0.03 0.05 0.00   0.07  ptop_new_proc
             ^^^^

Compared to the old top command that has to scan more than 1000 proc
directories the new ptop consumes much less CPU time (0.05% system time
on my s390 system).

TEST2: Show snapshot consistency with system that is 100% busy

  System with 3 CPUs:

  for ((i=0; i < $(cat /proc/cpuinfo  | grep "^processor" | wc -l); i++))
  do
       ./loop &
  done

  # ptop_snap_proc

          VVVV  VVV  VVV                        VVVVV
  pid     user  sys  ste cuser csys cste delay  total Elap+ Name
  (#)      (%)  (%)  (%)   (%)  (%)  (%)   (%)    (%)  (hm) (str)
  23891  99.84 0.06 0.09  0.00 0.00 0.00  0.01  99.99  0:00 loop
  23881  99.66 0.06 0.09  0.00 0.00 0.00  0.20  99.81  0:00 loop
  23886  99.65 0.06 0.09  0.00 0.00 0.00  0.20  99.80  0:00 loop
  2413    0.00 0.00 0.00  0.00 0.00 0.00  0.00   0.01  4:17 sshd
  ...
  V:V:S 299.36 0.36 0.27  0.00 0.00 0.00  0.40 300.00  4:22
                                               ^^^^^^

  With the snapshot mechanism the sum of all tasks CPU times (user + system +
  steal) will be exactly 300.00% CPU time with this testcase. Using
  ptop_snap_proc (see patch 10) this works fine on s390.

PATCHSET OVERVIEW
-----------------
The code is not final and still has a few TODOs. But it is good enough for a
first round of review. The following kernel patches are provided:

[01] Prepare-0: Use real microsecond granularity for taskstats CPU times.
[02] Prepare-1: Restructure taskstats.c in order to be able to add new commands
     more easily.
[03] Prepare-2: Separate the finding of a task_struct by PID or TGID from
     filling the taskstats.
[04] Add new command "TASKSTATS_CMD_ATTR_PIDS" to get a snapshot of multiple
     tasks.
[05] Add procfs interface for taskstats commands. This allows to get a complete
     and consistent snapshot with all tasks using two system calls (ioctl and
     read). Transferring a snapshot of all running tasks is not possible using
     the existing netlink interface, because there we have the socket buffer
     size as restricting factor.
[06] Add TGID to taskstats.
[07] Add steal time per task accounting.
[08] Add cumulative CPU time (user, system and steal) to taskstats.
[09] Fix exit CPU time accounting.

[10] Besides of the kernel patches also user space code is provided that
     exploits the new kernel infrastructure. The user space code provides the
     following:
     1. A proposal for a taskstats user space library:
        1.1 Based on netlink (requires libnl-devel-1.1-5)
        2.1 Based on the new /proc/taskstats interface (see [05])
     2. A proposal for a task snapshot library based on taskstats library (1.1)
     3. A new tool "ptop" (precise top) that uses the libraries


