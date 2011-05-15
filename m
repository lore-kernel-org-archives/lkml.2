Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1EOTtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 15:49:03 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:47991 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751452Ab1EOTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 15:49:01 -0400
Date: Sun, 15 May 2011 21:48:29 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110515194829.GA27023@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515172505.GL23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Sun, 15 May 2011 19:25:05 +0200, Tejun Heo wrote:
> On Sun, May 15, 2011 at 07:15:12PM +0200, Jan Kratochvil wrote:
> > On Sun, 15 May 2011 18:26:30 +0200, Tejun Heo wrote:
> > > the code to SEIZE and establish initial state would be simple.
> > 
> > In normal case yes; but one needs to handle all the corner cases when the
> > first signal is not INTERRUPT; which one usually does not handle as during
> > development (=in normal cases) it is always INTERRUPT.
[...]
> Maybe this is best solved with a test case which can reliably trigger
> different initial traps sites?

How to trigger it reliably?  One can just try it in a loop but it takes minutes
and depends on hardware specifics making it I guess even unreproducible in
various configurations.  We were allocating various machines for hours in the
farm but it may be unreproducible anyway.

http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/attach-into-signal.c?cvsroot=systemtap
  // Even DEFAULT_LOOPS of 400 is not enough to catch it reliably.
  // With TESTTIME=60 or more it should be close to 100%,
  // but takes long time (~10 minutes).
http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/attach-sigcont-wait.c?cvsroot=systemtap
/* Failure occurs either immediately or in about 20 runs.
   But sometimes not.  */
etc.


> > > You can tell them apart from userland and it doesn't matter which order or
> > > how many times INTERRUPT occurs.
> > 
> > I must know in which order they come to know when the tracee is still stopped
> > and I collect the signals to be displayed to the user and at which moment
> > there are no more signals in the queue and I start waiting on the debuggee
> > which started running.
> > 
> > Otherwise I can workaround it by various waitpid(NOHANG)s but it is better if
> > the ordering and when INTERRUPT is / is not reported is well defined.
> 
> Hmmm... you should be able to tell that without resorting to WNOHANG
> or depending on order of traps.  That's the goal anyway.  I'm a bit
> confused tho.  What do you mean by "the tracee is still stopped"?
> Tracee is always stopped (or rather trapped) after reporting a trap.

When debugging races in multithreaded applications a thread may get multiple
signals at once.  GDB in the default all-stop mode (the other is non-stop mode)
stops all the other threads when it sees the first event on some thread.

#include <pthread.h>
#include <assert.h>
#include <asm/unistd.h>
#include <unistd.h>
#include <signal.h>
#define tkill(tid, sig) syscall (__NR_tkill, (tid), (sig))
#define gettid() syscall (__NR_gettid)
static volatile pid_t tid;
static void *
start (void *arg)
{
  int i = (intptr_t) arg;
  while (!tid);
  sleep (1);
  tkill (tid, i & 1 ? SIGUSR1 : SIGUSR2);
  pause ();
  return arg;
}
int main (void)
{
  pthread_t thread;
  int i;
  for (i = 0; i < 10; i++)
    pthread_create (&thread, NULL, start, (void *) (intptr_t) i);
  tid = gettid ();	/* line 25 */
  sleep (1);
  return pause ();
}

gdb -nx ./threadsigs -ex 'tb 25' -ex r -ex 'set debug lin-lwp 1' -ex c
GNU gdb (GDB) 7.3.50.20110514-cvs
This GDB was configured as "x86_64-unknown-linux-gnu".
Program received signal SIGUSR1, User defined signal 1.
(gdb) info threads 
  Id   Target Id         Frame 
  11   Thread 0x7ffff3019700 (LWP 31784) "threadsigs" 0x00007ffff7bcecfd in pause () at ../sysdeps/unix/syscall-template.S:82
... [ everything in pause () ]
  2    Thread 0x7ffff7822700 (LWP 31775) "threadsigs" 0x00007ffff7bcecfd in pause () at ../sysdeps/unix/syscall-template.S:82
* 1    Thread 0x7ffff7fe6720 (LWP 31772) "threadsigs" 0x00007ffff78d0ced in nanosleep () at ../sysdeps/unix/syscall-template.S:82
(gdb) _

$ grep SigCgt /proc/31772/task/31772/status
SigCgt:	0000000180000000

OK, so the threads managed to deliver both SIGUSR1 and SIGUSR2 but GDB has
reported only SIGUSR1 to the user.

# The debugee does not handle SIGUSR1 so it would crash on its delivery:
(gdb) handle SIGUSR1 nopass
Signal        Stop	Print	Pass to program	Description
SIGUSR1       Yes	Yes	No		User defined signal 1
(gdb) continue 
Program received signal SIGUSR1, User defined signal 1.

OK, GDB has waitpid()ed SIGUSR1 already and still some thread has delivered
afterwards before GDB has managed to stop that thread.

(gdb) continue 
Program received signal SIGUSR2, User defined signal 2.

Only now the user has found SIGUSR2 has also been delivered.  The main thread
(receiving the signals) has not run yet been resumed at all.  It would be nice
if GDB could display all the signals the inferior has received as the other
threads are stopped already after the signals were sent (in pause ()) - this
gives user a skewed picture of different state in time for each thread.

I would prefer if GDB would print all the signals at once on a single stop:

Program received signal SIGUSR1, User defined signal 1.
Program received signal SIGUSR2, User defined signal 2.
(gdb) _

(This is not a simple change for GDB as it has many operations bound to
receiving single signal.)

Currently when GDB receives SIGUSR1 it has to do PTRACE_CONT before waitpid()
and receiving SIGUSR2.  The time it does PTRACE_CONT it does not know if then
waitpid() returns immediately or if the application will run for another hour.

There are similar problems GDB wanting to do something-like-INTERRUPT sends now
SIGSTOP and then it wants to remove that SIGSTOP from the inferior's queue as
it would confuse both user and the debuggee if left there.  Fortunately this
paragraph's pain will no longer be needed with PTRACE_INTERRUPT.

For example if you guarantee that after PTRACE_INTERRUPT the INTERRUPT even
will always get delivered as the last one after all the other signals GDB could
safely operate on all the delivered signals without a risk of accidentally
resuming the debuggee before explicitly instructed to do so by the user.

This is not a real plan how it should be done - but I hope it gives a picture
debuggers are interested the processing all the already delivered signals.
GDB should probably check the SigCgt /proc field (it already does in some
cases) for the informational display of delivered threads.


Thanks,
Jan
