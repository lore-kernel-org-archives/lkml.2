Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0DOGNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:13:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56369 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab0DOGNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:13:30 -0400
Message-ID: <4BC6AE82.3070703@us.ibm.com>
Date: Wed, 14 Apr 2010 23:13:22 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH V5 0/4][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270790121-16317-1-git-send-email-dvhltc@us.ibm.com>
In-Reply-To: <1270790121-16317-1-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dvhltc@us.ibm.com wrote:

> Now that an advantage can be shown using FUTEX_LOCK_ADAPTIVE over FUTEX_LOCK,
> the next steps as I see them are:
> 
> o Try and show improvement of FUTEX_LOCK_ADAPTIVE over FUTEX_WAIT based
>   implementations (pthread_mutex specifically).

I've spent a bit of time on this, and made huge improvements through 
some simple optimizations of the testcase lock/unlock routines. I'll be 
away for a few days and wanted to let people know where things stand 
with FUTEX_LOCK_ADAPTIVE.

I ran all the tests with the following options:
	-i 1000000 -p 1000 -d 20
where:
	-i iterations
	-p period (in instructions)
	-d duty cycle (in percent)

MECHANISM		KITERS/SEC
----------------------------------
pthread_mutex_adaptive	1562
FUTEX_LOCK_ADAPTIVE	1190
pthread_mutex		1010
FUTEX_LOCK		 532


I took some perf data while running each of the above tests as well. Any 
thoughts on getting more from perf are appreciated, this is my first 
pass at it. I recorded with "perf record -fg" and snippets of "perf 
report" follow:

FUTEX_LOCK (not adaptive) spends a lot of time spinning on the futex 
hashbucket lock.
# Overhead     Command       Shared Object  Symbol
# ........  ..........  ..................  ......
#
     40.76%  futex_lock  [kernel.kallsyms]   [k] _raw_spin_lock
             |
             --- _raw_spin_lock
                |
                |--62.16%-- do_futex
                |          sys_futex
                |          system_call_fastpath
                |          syscall
                |
                |--31.05%-- futex_wake
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          syscall
                ...
     14.98%  futex_lock  futex_lock          [.] locktest


FUTEX_LOCK_ADAPTIVE spends much of its time in the test loop itself, 
followed by the actual adaptive loop in the kernel. It appears much of 
our savings over FUTEX_LOCK comes from not contending on the hashbucket 
lock.
# Overhead     Command       Shared Object  Symbol
# ........  ..........  ..................  ......
#
     36.07%  futex_lock  futex_lock          [.] locktest
             |
             --- locktest
                |
                 --100.00%-- 0x400e7000000000

      9.12%  futex_lock  perf                [.] 0x00000000000eee
             ...
      8.26%  futex_lock  [kernel.kallsyms]   [k] futex_spin_on_owner


Pthread Mutex Adaptive spends most of it's time in the glibc heuristic 
spinning, as expected, followed by the test loop itself. An impressively 
minimal 3.35% is spent on the hashbucket lock.
# Overhead          Command             Shared Object  Symbol
# ........  ...............  ........................  ......
#
     47.88%  pthread_mutex_2  libpthread-2.5.so         [.] 
__pthread_mutex_lock_internal
             |
             --- __pthread_mutex_lock_internal

     22.78%  pthread_mutex_2  pthread_mutex_2           [.] locktest
             ...
     15.16%  pthread_mutex_2  perf                      [.] ...
             ...
     3.35%  pthread_mutex_2  [kernel.kallsyms]         [k] _raw_spin_lock


Pthread Mutex (not adaptive) spends much of it's time on the hashbucket 
lock as expected, followed by the test loop.
    33.89%  pthread_mutex_2  [kernel.kallsyms]         [k] _raw_spin_lock
             |
             --- _raw_spin_lock
                |
                |--56.90%-- futex_wake
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          __lll_unlock_wake
                |
                |--28.95%-- futex_wait_setup
                |          futex_wait
                |          do_futex
                |          sys_futex
                |          system_call_fastpath
                |          __lll_lock_wait
                ...
    16.60%  pthread_mutex_2  pthread_mutex_2           [.] locktest


These results mostly confirm the expected: the adaptive versions spend 
more time in their spin loops and less time contending for hashbucket 
locks while the non-adaptive versions take the hashbucket lock more 
often, and therefore shore more contention there.

I believe I should be able to get the plain FUTEX_LOCK implementation to 
be much closer in performance to the plain pthread mutex version. I 
expect much of the work done to benefit FUTEX_LOCK will also benefit 
FUTEX_LOCK_ADAPTIVE. If that's true, and I can make a significant 
improvement to FUTEX_LOCK, it wouldn't take much to get 
FUTEX_LOCK_ADAPTIVE to beat the heuristics spinlock in glibc.

It could also be that this synthetic benchmark is an ideal situation for 
glibc's heuristics, and a more realistic load with varying lock hold 
times wouldn't favor the adaptive pthread mutex over FUTEX_LOCK_ADAPTIVE 
by such a large margin.

More next week.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
