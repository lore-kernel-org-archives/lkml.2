Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1IAKy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:54:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37959 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1IAKy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:54:26 -0400
Subject: Re: process time < thread time?
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 12:54:19 +0200
In-Reply-To: <alpine.LFD.2.02.1109011226160.2723@ionos>
References: <20110831.230718.2029810906806382170.davem@davemloft.net>
	  <alpine.LFD.2.02.1109011148060.2723@ionos>
	 <1314871884.7945.20.camel@twins> <alpine.LFD.2.02.1109011226160.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314874459.7945.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 12:39 +0200, Thomas Gleixner wrote:
> > I think we just deadlocked:
> 
> That's why I said untested :) 

the below seems to build boot and give consistent output.. 

---
Subject: posix-cpu-timers: Cure SMP wobbles
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Sep 01 12:42:04 CEST 2011

David reported:

  Attached below is a watered-down version of rt/tst-cpuclock2.c from
  GLIBC.  Just build it with "gcc -o test test.c -lpthread -lrt" or
  similar.

  Run it several times, and you will see cases where the main thread
  will measure a process clock difference before and after the nanosleep
  which is smaller than the cpu-burner thread's individual thread clock
  difference.  This doesn't make any sense since the cpu-burner thread
  is part of the top-level process's thread group.

  I've reproduced this on both x86-64 and sparc64 (using both 32-bit and
  64-bit binaries).

  For example:

  [davem@boricha build-x86_64-linux]$ ./test
  process: before(0.001221967) after(0.498624371) diff(497402404)
  thread:  before(0.000081692) after(0.498316431) diff(498234739)
  self:    before(0.001223521) after(0.001240219) diff(16698)
  [davem@boricha build-x86_64-linux]$ 

  The diff of 'process' should always be >= the diff of 'thread'.

  I make sure to wrap the 'thread' clock measurements the most tightly
  around the nanosleep() call, and that the 'process' clock measurements
  are the outer-most ones.

  ---
  #include <unistd.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <time.h>
  #include <fcntl.h>
  #include <string.h>
  #include <errno.h>
  #include <pthread.h>

  static pthread_barrier_t barrier;

  static void *chew_cpu(void *arg)
  {
	  pthread_barrier_wait(&barrier);
	  while (1)
		  __asm__ __volatile__("" : : : "memory");
	  return NULL;
  }

  int main(void)
  {
	  clockid_t process_clock, my_thread_clock, th_clock;
	  struct timespec process_before, process_after;
	  struct timespec me_before, me_after;
	  struct timespec th_before, th_after;
	  struct timespec sleeptime;
	  unsigned long diff;
	  pthread_t th;
	  int err;

	  err = clock_getcpuclockid(0, &process_clock);
	  if (err)
		  return 1;

	  err = pthread_getcpuclockid(pthread_self(), &my_thread_clock);
	  if (err)
		  return 1;

	  pthread_barrier_init(&barrier, NULL, 2);
	  err = pthread_create(&th, NULL, chew_cpu, NULL);
	  if (err)
		  return 1;

	  err = pthread_getcpuclockid(th, &th_clock);
	  if (err)
		  return 1;

	  pthread_barrier_wait(&barrier);

	  err = clock_gettime(process_clock, &process_before);
	  if (err)
		  return 1;

	  err = clock_gettime(my_thread_clock, &me_before);
	  if (err)
		  return 1;

	  err = clock_gettime(th_clock, &th_before);
	  if (err)
		  return 1;

	  sleeptime.tv_sec = 0;
	  sleeptime.tv_nsec = 500000000;
	  nanosleep(&sleeptime, NULL);

	  err = clock_gettime(th_clock, &th_after);
	  if (err)
		  return 1;

	  err = clock_gettime(my_thread_clock, &me_after);
	  if (err)
		  return 1;

	  err = clock_gettime(process_clock, &process_after);
	  if (err)
		  return 1;

	  diff = process_after.tv_nsec - process_before.tv_nsec;
	  printf("process: before(%lu.%.9lu) after(%lu.%.9lu) diff(%lu)\n",
		 process_before.tv_sec, process_before.tv_nsec,
		 process_after.tv_sec, process_after.tv_nsec, diff);
	  diff = th_after.tv_nsec - th_before.tv_nsec;
	  printf("thread:  before(%lu.%.9lu) after(%lu.%.9lu) diff(%lu)\n",
		 th_before.tv_sec, th_before.tv_nsec,
		 th_after.tv_sec, th_after.tv_nsec, diff);
	  diff = me_after.tv_nsec - me_before.tv_nsec;
	  printf("self:    before(%lu.%.9lu) after(%lu.%.9lu) diff(%lu)\n",
		 me_before.tv_sec, me_before.tv_nsec,
		 me_after.tv_sec, me_after.tv_nsec, diff);

	  return 0;
  }

This is due to us using p->se.sum_exec_runtime in
thread_group_cputime() where we iterate the thread group and sum all
data. This does not take time since the last schedule operation (tick
or otherwise) into account. We can cure this by using
task_sched_runtime() at the cost of having to take locks.

This also means we can (and must) do away with
thread_group_sched_runtime() since the modified thread_group_cputime()
is now more accurate and would deadlock when called from
thread_group_sched_runtime().

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-nk5489zjtxsln3ixjonjs3h3@git.kernel.org
---
 include/linux/sched.h     |    1 -
 kernel/posix-cpu-timers.c |    5 +++--
 kernel/sched.c            |   24 ------------------------
 3 files changed, 3 insertions(+), 27 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1956,7 +1956,6 @@ static inline void disable_sched_clock_i
 
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
-extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -250,7 +250,7 @@ void thread_group_cputime(struct task_st
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime += t->se.sum_exec_runtime;
+		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -312,7 +312,8 @@ static int cpu_clock_sample_group(const 
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = thread_group_sched_runtime(p);
+		thread_group_cputime(p, &cputime);
+		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3866,30 +3866,6 @@ unsigned long long task_sched_runtime(st
 }
 
 /*
- * Return sum_exec_runtime for the thread group.
- * In case the task is currently running, return the sum plus current's
- * pending runtime that have not been accounted yet.
- *
- * Note that the thread group might have other running tasks as well,
- * so the return value not includes other pending runtime that other
- * running tasks might have.
- */
-unsigned long long thread_group_sched_runtime(struct task_struct *p)
-{
-	struct task_cputime totals;
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns;
-
-	rq = task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
-	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @cputime: the cpu time spent in user space since the last update

