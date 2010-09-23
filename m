Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0IWUNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:13:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab0IWUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:13:03 -0400
Date: Thu, 23 Sep 2010 13:11:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
Message-Id: <20100923131136.356075f4.akpm@linux-foundation.org>
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 15:48:01 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> Currently tools like "top" gather the task information by reading procfs
> files. This has several disadvantages:
> 
> * It is very CPU intensive, because a lot of system calls (readdir, open,
>   read, close) are necessary.
> * No real task snapshot can be provided, because while the procfs files are
>   read the system continues running.
> * The procfs times granularity is restricted to jiffies.
> 
> In parallel to procfs there exists the taskstats binary interface that uses
> netlink sockets as transport mechanism to deliver task information to
> user space. There exists a taskstats command "TASKSTATS_CMD_ATTR_PID"
> to get task information for a given PID. This command can already be used for
> tools like top, but has also several disadvantages:
> 
> * You first have to find out which PIDs are available in the system. Currently
>   we have to use procfs again to do this.
> * For each task two system calls have to be issued (First send the command and
>   then receive the reply).
> * No snapshot mechanism is available.
> 
> GOALS OF THIS PATCH SET
> -----------------------
> The intention of this patch set is to provide better support for tools like
> top. The goal is to:
> 
> * provide a task snapshot mechanism where we can get a consistent view of
>   all running tasks.
> * provide a transport mechanism that does not require a lot of system calls
>   and that allows implementing low CPU overhead task monitoring.
> * provide microsecond CPU time granularity.

This is a big change!  If this is done right then we're heading in the
direction of deprecating the longstanding way in which userspace
observes the state of Linux processes and we're recommending that the
whole world migrate to taskstats.  I think?

If so, much chin-scratching will be needed, coordination with
util-linux people, etc.

We'd need to think about the implications of taskstats versioning.  It
_is_ a versioned interface, so people can't just go and toss random new
stuff in there at will - it's not like adding a new procfs file, or
adding a new line to an existing one.  I don't know if that's likely to
be a significant problem.

I worry that there's a dependency on CONFIG_NET?  If so then that's a
big problem because in N years time, 99% of the world will be using
taskstats, but a few embedded losers will be stuck using (and having to
support) the old tools.


> FIRST RESULTS
> -------------
> Together with this kernel patch set also user space code for a new top
> utility (ptop) is provided that exploits the new kernel infrastructure. See
> patch 10 for more details.
> 
> TEST1: System with many sleeping tasks
> 
>   for ((i=0; i < 1000; i++))
>   do
>          sleep 1000000 &
>   done
> 
>   # ptop_new_proc
> 
>              VVVV
>   pid   user  sys  ste  total  Name
>   (#)    (%)  (%)  (%)    (%)  (str)
>   541   0.37 2.39 0.10   2.87  top
>   3743  0.03 0.05 0.00   0.07  ptop_new_proc
>              ^^^^
> 
> Compared to the old top command that has to scan more than 1000 proc
> directories the new ptop consumes much less CPU time (0.05% system time
> on my s390 system).

How many CPUs does that system have?

What's the `top' update period?  One second?

So we're saying that a `top -d 1' consumes 2.4% of this
mystery-number-of-CPUs machine?  That's quite a lot.

> PATCHSET OVERVIEW
> -----------------
> The code is not final and still has a few TODOs. But it is good enough for a
> first round of review. The following kernel patches are provided:
> 
> [01] Prepare-0: Use real microsecond granularity for taskstats CPU times.
> [02] Prepare-1: Restructure taskstats.c in order to be able to add new commands
>      more easily.
> [03] Prepare-2: Separate the finding of a task_struct by PID or TGID from
>      filling the taskstats.
> [04] Add new command "TASKSTATS_CMD_ATTR_PIDS" to get a snapshot of multiple
>      tasks.
> [05] Add procfs interface for taskstats commands. This allows to get a complete
>      and consistent snapshot with all tasks using two system calls (ioctl and
>      read). Transferring a snapshot of all running tasks is not possible using
>      the existing netlink interface, because there we have the socket buffer
>      size as restricting factor.

So this is a binary interface which uses an ioctl.  People don't like
ioctls.  Could we have triggered it with a write() instead?

Does this have the potential to save us from the CONFIG_NET=n problem?

> [06] Add TGID to taskstats.
> [07] Add steal time per task accounting.
> [08] Add cumulative CPU time (user, system and steal) to taskstats.

These didn't update the taskstats version number.  Should they have?

> [09] Fix exit CPU time accounting.
> 
> [10] Besides of the kernel patches also user space code is provided that
>      exploits the new kernel infrastructure. The user space code provides the
>      following:
>      1. A proposal for a taskstats user space library:
>         1.1 Based on netlink (requires libnl-devel-1.1-5)
>         2.1 Based on the new /proc/taskstats interface (see [05])
>      2. A proposal for a task snapshot library based on taskstats library (1.1)

ooh, excellent.  A standardised userspace access library.

>      3. A new tool "ptop" (precise top) that uses the libraries

Talk to me about namespaces, please.  A lot of the new code involves
PIDs, but PIDs are not system-wide unique.  A PID is relative to a PID
namespace.  Does everything Just Work?  When userspace sends a PID to
the kernel, that PID is assumed to be within the sending process's PID
namespace?  If so, then please spell it all out in the changelogs.  If
not then that is a problem!

If I can only observe processes in my PID namespace then is that a
problem?  Should I be allowed to observe another PID namespace's
processes?  I assume so, because I might be root.  If so, how is that
to be done?

