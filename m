Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0FYI1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:27:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:40851 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0FYI1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:27:13 -0400
Date: Fri, 25 Jun 2010 10:27:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
Message-ID: <20100625082711.GA32765@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
 <4C2417AA.4030306@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2417AA.4030306@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-06-10 19:42:50, Darren Hart wrote:
> On 06/23/2010 02:13 AM, Michal Hocko wrote:
> >Hi,

Hi,

> 
> Hi Michal,
> 
> Thanks for reporting the issue and providing a testcase.
> 
> >
> >attached you can find a simple test case which fails quite easily on the
> >following glibc assert:
> >"SharedMutexTest: pthread_mutex_lock.c:289: __pthread_mutex_lock:
> >   Assertion `(-(e)) != 3 || !robust' failed." "
> 
> I've run runSimple.sh in a tight loop for a couple hours (about 2k
> iterations so far) and haven't seen anything other than "Here we go"
> printed to the console.

Maybe a higher load on CPUs would help (busy loop on other CPUs). 

> 
> I had to add -D_GNU_SOURCE to get it to build on my system (RHEL5.2
> + 2.6.34). Perhaps this is just a difference in the toolchain.

I assume that you got PTHREAD_PRIO_INHERIT undeclared error, don't you?
I have hacked around that by #define __USE_UNIX98 which worked on Debian
and OpenSuse. But you are right _GNU_SOURCE is definitely better
solution.

> 
> >AFAIU, this assertion says that futex syscall cannot fail with ESRCH
> >for robust futex because it should either succeed or fail with
> >EOWNERDEAD.
> 
> I'll have to think on that and review the libc source. We do need to
> confirm that the assert is even doing the right thing.

Sure. I have looked through the glibc lock implementation and it makes
quite a good sense to me. A robust lock should never return with ESRCH.

> 
> >
> >We have seen this problem on SLES11 and SLES11SP1 but I was able to
> >reproduce it with the 2.6.34 kernel as well.
> 
> What kind of system are you seeing this on? I've been running on a
> 4-way x86_64 blade.

* Debian (squeeze/sid) with 
- Intel(R) Core(TM)2 CPU T5600 @ 1.83GHz
- kernel: vanilla 2.6.34
- glibc: 2.11.1-3
- i386

* OpenSuse 11.2 with 
- Intel(R) Core(TM)2 Duo CPU E4500 @ 2.20GHz
- kernel: distribution 2.6.31.12-0.2-desktop
- glibc: 2.10.1-10.5.1
- i386

* SLES11SP1
- Dual-Core AMD Opteron(tm) Processor 1218
- kernel: distribution 2.6.32.12-0.3-default
- glibc: 2.11.1-0.17.4
- x86_64

Each box shows a different number of asserts during 10 iterations.

> 
> >The test case is quite easy.
> >
> >Executed with a parameter it creates a test file and initializes shared,
> >robust pthread mutex (optionaly compile time configured with priority
> >inheritance) backed by the mmapped test file. Without a parameter it
> >mmaps the file and just locks, unlocks mutex and checks for EOWNERDEAD
> >(this should never happen during the test as the process never dies with
> >the lock held) in the loop.
> 
> Have you found the PI parameter to be required for reproducing the
> error? From the comments below I'm assuming so... just want to be
> sure.

Yes. If you comment out USE_PI variable in the script the problem is not 
shown at all.

> 
> >
> >If I run this application for multiple users in parallel I can see the
> >above assertion. However, if priority inheritance is turned off then
> >there is no problem. I am not able to reproduce also if the test case is
> >run under a single user.
> >
> >I am using the attached runSimple.sh script to run the test case like
> >this:
> >
> >rm test.file simple
> >for i in `seq 10`
> >do
> >	sh runSimple.sh
> >done
> >
> >To disable IP just comment out USE_PI variable in the script.
> >You need to change USER1 and USER2 variables to match you system. You
> >will need to run the script as root if you do not set any special
> >setting to run su on behalf of those users.
> >
> >I have tried to look at futex_{un}lock_pi but it is really hard to
> >understand.
> 
> *grin* tell me about it...
> 
> See Documentation/pi-futex.txt if you haven't already.

Will do.

> 
> >I assume that lookup_pi_state is the one which sets ESRCH
> >after it is not able to find the pid of the current owner.
> >
> >This would suggest that we are racing with the unlock of the current
> >lock holder but I don't see how is this possible as both lock and unlock
> >paths hold fshared lock for all operations over the lock value. I have
> >noticed that the lock path drops fshared if the current holder is dying
> >but then it retries the whole process again.
> >
> >Any advice would be highly appreciated.
> 
> If I can reproduce this I should be able to get some trace points in
> there to get a better idea of the execution path leading up to the
> problem.

Please make sure that you run the test case with two different users. I
couldn't reproduce the issue with a single user.

If you have some ideas about patches which I could try then just pass it
to me.

> 
> This would be a great time to have those futex fault injection patches...
> 
> 
> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team

Thanks for looking into it.
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
