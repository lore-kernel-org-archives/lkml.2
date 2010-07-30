Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab0G3O6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:58:31 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:8840 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324Ab0G3O6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:58:30 -0400
X-IronPort-AV: E=Sophos;i="4.55,287,1278280800"; 
   d="scan'208";a="54947116"
Message-ID: <4C52E892.1040709@inria.fr>
Date: Fri, 30 Jul 2010 16:58:26 +0200
From: Tomasz Buchert <Tomasz.Buchert@inria.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Rationale for wall clocks
References: <1280483867-6387-1-git-send-email-tomasz.buchert@inria.fr> <20100730132343.4c15bfdc@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100730132343.4c15bfdc@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

To begin with, there are two main things that my patches concern:
  A) Limited access to POSIX CPU clocks
  B) Access to wall time information of a process/thread.

By CPU time I understand "user time" + "system time".

The scenerio I have, is (making the long story short) that my process
supervises a set of tasks. It "freezes" them (using freezer cgroups)
when their (CPU time) / (wall time) ratio reaches a certain threshold.
Now, to make this decision as precise as possible, I need to get a good 
measurement of CPU/wall time of a task (identified by TID). If internally
the kernel time-keeping is in nanoseconds (well, at least on my x86 machine)
why shouldn't I expect to have access to it?

Let's agree at the very beginning that procfs is not feasible
to achieve that with acceptable quality. /proc/[pid]/stat
and /proc/[tid]/task/[tid]/stat expose CPU time in clock ticks
(on my machine I have sysconf(_SC_CLK_TCK) = 100 so precision is 10ms). 
Start time of a process is given in a number of ticks
after the system boot and the boot time itself is given in /proc/stat in ... 
a number of seconds after the beginning of Unix epoch. That's not good enough.

Ad. A)
clock_gettime is a very nice interface with nanosecond precision
(again on my x86 machine). You can ask for CPU time of a thread
or a process. And finally you can clock_nanosleep on it.
When asking for CPU time of a task, however, you can only query
tasks from your own thread group. I see no reason why this
couldn't be extended to all tasks of the same user (extending 
it further could introduce potential security risks). I think 
also that a root user could have the access to all clocks in the system.

This kind of information may be retrieved via taskstats anyway
(for EVERY task in the system), but with only ms precision
(because of the mentioned security problems?)

Ad. B)
As far I can tell, the only good way to obtain elapsed time
of a process/thread is to use taskstats interface. It's not THAT bad,
I agree with Stanislaw on that, it gives you some valuable pieces of information. 
The precision is 2ms for the CPU time and 1us for elapsed time. In fact
with CONFIG_TASK_DELAY_ACCT enabled you can get CPU time with nanosecond precision
(it's not compiled in on my Ubuntu 9.10 kernel but it is in on one Debian machine
I have somewhere). Another exotic way to get CPU time is to use CONFIG_SCHEDSTATS
and read the first number in /proc/[tid]/schedstat. Interestingly, this is available
by default on my Ubuntu box but not in the previously mentioned Debian :).

The most portable way would be to use taskstats (it's in both kernels...:) ).
I didn't like the CPU time precision given and the whole messy code needed to use
netlink interface, though. Moreover, to get the best available precision 
I would have to use POSIX clocks to get CPU time (assuming the change A would accepted!)
and taskstats to get WALL time (the precision would be however still 1us). I didn't
like this idea at all.

That's why I started to dig the kernel a little bit. After some time I found unused slot
in clockid_t which would perfectly fit an additional clock. What I like about this interface:
    1) clean and simple
    2) nanosecond precision
    3) cheap, compared to taskstats
    4) unified access to 2 important clocks of a process: CPU clock and WALL clock
The nice thing also is that you can clock_nanosleep on that clock. I have this kind
of scenario on mind: I control a process and, say, want to kill it after 1 sec
(because it is only allowed to run for that amount of time). It is easily and robustly
done with this interface: you just sleep on the WALL time clock of that process until 
absolute time of 1s. Sadly, right now you can't do it precisely and correctly at the same time.

I agree that these problems could be addressed with giving the access to start_time
field, as Stanislaw suggested. Adding new fields with the same meaning but with 
higher precision to taskstats is a terrible idea of course. 
I simply felt, that adding a new clock type is a nice and consistent approach.

That's it.

Tomasz
