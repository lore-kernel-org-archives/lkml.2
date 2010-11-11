Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0KKRJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:09:15 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:49422 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0KKRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:19 -0500
Message-Id: <20101111170352.732381138@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:52 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][PATCH v2 0/7] taskstats: Enhancements for precise process accounting (version 2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CHANGE HISTORY OF THIS PATCH SET
---------------------------------
Version 2
---------
* The following patches from version 1 have been accepted upstream for 2.6.37:
  + taskstats: use real microsecond granularity for CPU times
    git commit: d57af9b2142f31a39dcfdeb30776baadfc802827
  + taskstats: separate taskstats commands
    git commit: 9323312592cca636d7c2580dc85fa4846efa86a2
  + taskstats: split fill_pid function
    git commit: 3d9e0cf1fe007b88db55d43dfdb6839e1a029ca5

* Comment from Andrew Morton:
  I replaced the /proc/taskstats ioctls with a write interface (see patch [2])

* Based on discussions with Oleg Nesterov and Roland McGrath:
  We have identified the following problems of the current approach for getting
  100% CPU time between two taskstats snapshots without using exit events:

  1)Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
    to the cumulative time of the parents, if the parents ignore SIGCHLD
    or have set SA_NOCLDWAIT. This behaviour has the major drawback that
    it is not possible to calculate all consumed CPU time of a system by
    looking at the current tasks. CPU time can be lost.

  2)When a parent process dies, its children get the init process as
    new parent. For accounting this is suboptimal, because then init
    gets the CPU time of the tasks. For accounting it would be better,
    if the CPU time is passed along the relationship tree using the
    cumulative time counters as would have happened if the child had died
    before the parent. The main benefit of this approach is that between
    two task snapshots it is always clear which parent got the CPU time
    of dead tasks. Otherwise there are situations, where we can't
    determine if either init or an older relative of a dead task has
    inherited the CPU time.

  3)If a non-leader thread calls exec(), in the de_thread() function it
    gets some of the identity of the old thread group leader e.g. the PID
    and the start time. But it keeps the old CPU times. This can lead to
    confusion in user space, because CPU time can go backwards for the thread
    group leader.

  As a result of this discussion I have developed a new patch [5] (see below):
  * It adds a second set of accounting data to the signal_struct.
    This set is used to save all accounting data and resolves issue (1).
  * In addition to that, the patch adds a new accounting hierarchy for
    processes in the signal_struct to resolve issue (2).

  There are three possible alternatives to this approach:
  * Introduce "reparent" events for tasks that get init as new parent.
  * Get all task exit events (very expensive).
  * Live with the fact that accounting without exit events cannot be done
    100% accurate on UNIX/Linux and provide a solution that works with the
    cumulative time accounting as it is currently available under Linux.

  I have developed an additional patch [6] to resolve issue (3).
  It swaps the accounting data between the forking thread and the thread
  group leader in the de_thread() function. But perhaps another solution
  should be found for that problem because this might cause problems with
  the scheduler that gets confused by the swapped values.

DESCRIPTION OF PATCH SET
------------------------
Currently tools like "top" gather the task information by reading procfs
files. This has several disadvantages:

* It is very CPU intensive, because a lot of system calls (readdir, open,
  read, close) are necessary.
* No real task snapshot can be provided, because while the procfs files are
  read the system continues running.
* It is not possible to identify 100% of all consumed CPU time between two
  snapshots.
* The procfs times granularity is restricted to jiffies.

In parallel to procfs there is the taskstats binary interface that uses
netlink sockets as transport mechanism to deliver task information to
user space. There is a taskstats command "TASKSTATS_CMD_ATTR_PID"
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
* identify 100% of the consumed CPU time between two snapshots without
  using task exit events.
* provide a transport mechanism that does not require a lot of system calls
  and that allows implementing low CPU overhead task monitoring.
* provide microsecond CPU time granularity.

FIRST RESULTS
-------------
Together with this kernel patch set also user space code for a new top
utility (ptop) is provided that exploits the new kernel infrastructure. See
patch 6 for more details.

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

  System with 2 CPUs:

  for ((i=0; i < $(cat /proc/cpuinfo  | grep "^processor" | wc -l); i++))
  do
       ./loop &
  done
  cd linux-2.6
  make -j 5

  # ptop_snap_proc
  pid     user  sys stea cuser  csys cstea xuser xsys xstea  total Name
  (#)      (%)  (%)  (%)   (%)   (%)   (%)   (%)  (%)   (%)    (%) (str)
  2802   43.22 0.35 0.22  0.00  0.00  0.00  0.00 0.00  0.00  43.79 loop
  2799   35.96 0.33 0.21  0.00  0.00  0.00  0.00 0.00  0.00  36.50 loop
  2811    0.04 0.05 0.00 23.22 12.97  0.19  0.00 0.00  0.00  36.46 make
  2796   35.80 0.32 0.19  0.00  0.00  0.00  0.00 0.00  0.00  36.30 loop
  2987   15.93 2.14 0.07  8.23  3.12  0.06  0.00 0.00  0.00  29.53 make
  3044   11.56 1.72 0.22  0.00  0.00  0.00  0.00 0.00  0.00  13.50 make
  3053    1.92 0.73 0.01  0.00  0.00  0.00  0.00 0.00  0.00   2.65 make
  ....
  V:V:S 144.76 6.24 1.22 31.44 16.09  0.25  0.00 0.00  0.00 200.00
                                                            ^^^^^^

  With the snapshot mechanism the sum of all tasks CPU times will be exactly
  200.00% CPU time with this testcase. The following CPU times are used:
  * user/sys/stea:    Time that has been consumed by task itself
  * cuser/csys/cstea: Time that has been consumed by dead children of task
  * xuser/xsys/xstea: Time that has been consumed by dead threads of thread
                      group of task

  Note that the CPU times on x86 are not as precise as on s390.

PATCHSET OVERVIEW
-----------------
Patches apply on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

The code is not final and still has several TODOs. The following kernel patches
are provided:

[1] Add new command "TASKSTATS_CMD_ATTR_PIDS" to get a snapshot of multiple
    tasks.
[2] Add procfs interface for taskstats commands. This allows to get a complete
    and consistent snapshot with all tasks using two system calls (write and
    read). Transferring a snapshot of all running tasks is not possible using
    the existing netlink interface, because there we have the socket buffer
    size as restricting factor.
[3] Add TGID to taskstats.
[4] Add steal time per task accounting.
[5] Improve cumulative CPU time accounting.
[6] Fix accounting for non-leader thread exec.

[7] Besides of the kernel patches also user space code is provided that
    exploits the new kernel infrastructure. The user space code provides the
    following:
    1. A proposal for a taskstats user space library:
       1.1 Based on netlink (requires libnl-devel-1.1-5)
       2.1 Based on the new /proc/taskstats interface (see patch [2])
    2. A proposal for a task snapshot library based on taskstats library (1.1)
    3. A new tool "ptop" (precise top) that uses the libraries

* Especially patch [1] "Add new command "TASKSTATS_CMD_ATTR_PIDS" to
  get a snapshot of multiple tasks" needs more review because it provides
  the main functionality for getting consistent task snapshots. Up to now
  I did not get any feedback on version 1 of this patch.

* Also the user space part with the libraries [7] would need some review.
