Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0C0QVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 12:21:40 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44723 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753535Ab0C0QVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 12:21:38 -0400
Date: Sat, 27 Mar 2010 12:21:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: mingo@elte.hu
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (another round for v9)
Message-ID: <20100327162133.GA26567@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:19:40 up 63 days, 18:56,  6 users,  load average: 0.10, 0.07,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding LKML in CC. Sorry for the re-send. I am seriously thinking about adding
  a "default LKML CC" binding to mutt. ;-) ]

I am resubmitting this patch without modification from the previous round as a
RFC following the discussion with Ingo, where it seems to turn out that the
signal-based alternative he proposed will lead to important scheduler
modifications, which involves adding context-switch in/out overhead (calling
user-space upon scheduler switch in and out). In addition to the overhead issue,
I am also reluctant to base a synchronization primitive on the signals, which,
to quote Linus, are

" already one of our more "exciting" layers out there "

This does not give me the warm feeling of rock-solidness that's usually expected
from synchronization primitives.

So, Ingo had objections for this patch based on the ground of cleanness too.
Quoting him:

[ There's also a few small cleanliness details i noticed in your patch: enums
  are a tiny bit nicer for ABIs than #define's, the #ifdef SMP is ugly, etc. -
  but it doesnt really matter much as i think we should concentrate on the
  scalability problems of signals first. ]

So can you be more specific about these specific issues ? Pointing out in the
source code the offending parts would be welcome.

This patch applies on top of -tip based on 2.6.34-rc2.

Thanks,

Mathieu


Here is an implementation of a new system call, sys_membarrier(), which
executes a memory barrier on all threads of the current process. It can be used
to distribute the cost of user-space memory barriers asymmetrically by
transforming pairs of memory barriers into pairs consisting of sys_membarrier()
and a compiler barrier. For synchronization primitives that distinguish between
read-side and write-side (e.g. userspace RCU, rwlocks), the read-side can be
accelerated significantly by moving the bulk of the memory barrier overhead to
the write-side.
 
The first user of this system call is the "liburcu" Userspace RCU implementation
found at http://lttng.org/urcu. It aims at greatly simplifying and enhancing the
current implementation, which uses a scheme similar to the sys_membarrier(), but
based on signals sent to each reader thread.

This patch mostly sits in kernel/sched.c (it needs to access struct rq). It is
based on kernel v2.6.33, and also applies fine to tip/master commit
bd37c0157993c3f2fcf9eecbe1a04c246df69eab. I am proposing it for merge into
2.6.34. I think the -tip tree would be the right one to pick up this patch, as
it touches sched.c.

Changes since v8:
- Go back to rq spin locks taken by sys_membarrier() rather than adding memory
  barriers to the scheduler. It implies a potential RoS (reduction of service)
  if sys_membarrier() is executed in a busy-loop by a user, but nothing more
  than what is already possible with other existing system calls, but saves
  memory barriers in the scheduler fast path.
- re-add the memory barrier comments to x86 switch_mm() as an example to other
  architectures.
- Update documentation of the memory barriers in sys_membarrier and switch_mm().
- Append execution scenarios to the changelog showing the purpose of each memory
  barrier.

Changes since v7:
- Move spinlock-mb and scheduler related changes to separate patches.
- Add support for sys_membarrier on x86_32.
- Only x86 32/64 system calls are reserved in this patch. It is planned to
  incrementally reserve syscall IDs on other architectures as these are tested.

Changes since v6:
- Remove some unlikely() not so unlikely.
- Add the proper scheduler memory barriers needed to only use the RCU read lock
  in sys_membarrier rather than take each runqueue spinlock:
- Move memory barriers from per-architecture switch_mm() to schedule() and
  finish_lock_switch(), where they clearly document that all data protected by
  the rq lock is guaranteed to have memory barriers issued between the scheduler
  update and the task execution. Replacing the spin lock acquire/release
  barriers with these memory barriers imply either no overhead (x86 spinlock
  atomic instruction already implies a full mb) or some hopefully small
  overhead caused by the upgrade of the spinlock acquire/release barriers to
  more heavyweight smp_mb().
- The "generic" version of spinlock-mb.h declares both a mapping to standard
  spinlocks and full memory barriers. Each architecture can specialize this
  header following their own need and declare CONFIG_HAVE_SPINLOCK_MB to use
  their own spinlock-mb.h.
- Note: benchmarks of scheduler overhead with specialized spinlock-mb.h
  implementations on a wide range of architecture would be welcome.

Changes since v5:
- Plan ahead for extensibility by introducing mandatory/optional masks to the
  "flags" system call parameter. Past experience with accept4(), signalfd4(),
  eventfd2(), epoll_create1(), dup3(), pipe2(), and inotify_init1() indicates
  that this is the kind of thing we want to plan for. Return -EINVAL if the
  mandatory flags received are unknown.
- Create include/linux/membarrier.h to define these flags.
- Add MEMBARRIER_QUERY optional flag.

Changes since v4:
- Add "int expedited" parameter, use synchronize_sched() in the non-expedited
  case. Thanks to Lai Jiangshan for making us consider seriously using
  synchronize_sched() to provide the low-overhead membarrier scheme.
- Check num_online_cpus() == 1, quickly return without doing nothing.

Changes since v3a:
- Confirm that each CPU indeed runs the current task's ->mm before sending an
  IPI. Ensures that we do not disturb RT tasks in the presence of lazy TLB
  shootdown.
- Document memory barriers needed in switch_mm().
- Surround helper functions with #ifdef CONFIG_SMP.

Changes since v2:
- simply send-to-many to the mm_cpumask. It contains the list of processors we
  have to IPI to (which use the mm), and this mask is updated atomically.

Changes since v1:
- Only perform the IPI in CONFIG_SMP.
- Only perform the IPI if the process has more than one thread.
- Only send IPIs to CPUs involved with threads belonging to our process.
- Adaptative IPI scheme (single vs many IPI with threshold).
- Issue smp_mb() at the beginning and end of the system call.


To explain the benefit of this scheme, let's introduce two example threads:
 
Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
Thread B (frequent, e.g. executing liburcu rcu_read_lock()/rcu_read_unlock())

In a scheme where all smp_mb() in thread A are ordering memory accesses with
respect to smp_mb() present in Thread B, we can change each smp_mb() within
Thread A into calls to sys_membarrier() and each smp_mb() within
Thread B into compiler barriers "barrier()".

Before the change, we had, for each smp_mb() pairs:

Thread A                    Thread B
previous mem accesses       previous mem accesses
smp_mb()                    smp_mb()
following mem accesses      following mem accesses

After the change, these pairs become:

Thread A                    Thread B
prev mem accesses           prev mem accesses
sys_membarrier()            barrier()
follow mem accesses         follow mem accesses

As we can see, there are two possible scenarios: either Thread B memory
accesses do not happen concurrently with Thread A accesses (1), or they
do (2).

1) Non-concurrent Thread A vs Thread B accesses:

Thread A                    Thread B
prev mem accesses
sys_membarrier()
follow mem accesses
                            prev mem accesses
                            barrier()
                            follow mem accesses

In this case, thread B accesses will be weakly ordered. This is OK,
because at that point, thread A is not particularly interested in
ordering them with respect to its own accesses.

2) Concurrent Thread A vs Thread B accesses

Thread A                    Thread B
prev mem accesses           prev mem accesses
sys_membarrier()            barrier()
follow mem accesses         follow mem accesses

In this case, thread B accesses, which are ensured to be in program
order thanks to the compiler barrier, will be "upgraded" to full
smp_mb() by to the IPIs executing memory barriers on each active
system threads. Each non-running process threads are intrinsically
serialized by the scheduler.


* Benchmarks

For an Intel Xeon E5405
(one thread is calling sys_membarrier, the other T threads are busy looping)

* expedited

10,000,000 sys_membarrier calls:

T=1: 0m20.173s
T=2: 0m20.506s
T=3: 0m22.632s
T=4: 0m24.759s
T=5: 0m26.633s
T=6: 0m29.654s
T=7: 0m30.669s

----For a 2-3 microseconds/call.

* non-expedited

1000 sys_membarrier calls:

T=1-7: 0m16.002s

----For a 16 milliseconds/call. (~5000-8000 times slower than expedited)


* User-space user of this system call: Userspace RCU library

Both the signal-based and the sys_membarrier userspace RCU schemes
permit us to remove the memory barrier from the userspace RCU
rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
accelerating them. These memory barriers are replaced by compiler
barriers on the read-side, and all matching memory barriers on the 
write-side are turned into an invokation of a memory barrier on all
active threads in the process. By letting the kernel perform this
synchronization rather than dumbly sending a signal to every process
threads (as we currently do), we diminish the number of unnecessary wake
ups and only issue the memory barriers on active threads. Non-running
threads do not need to execute such barrier anyway, because these are
implied by the scheduler context switches.

Results in liburcu:

Operations in 10s, 6 readers, 2 writers:

(what we previously had)
memory barriers in reader: 973494744 reads, 892368 writes
signal-based scheme:      6289946025 reads,   1251 writes

(what we have now, with dynamic sys_membarrier check, expedited scheme)
memory barriers in reader: 907693804 reads, 817793 writes
sys_membarrier scheme:    4316818891 reads, 503790 writes

(dynamic sys_membarrier check, non-expedited scheme)
memory barriers in reader: 907693804 reads, 817793 writes
sys_membarrier scheme:    8698725501 reads,    313 writes

So the dynamic sys_membarrier availability check adds some overhead to the
read-side, but besides that, with the expedited scheme, we can see that we are
close to the read-side performance of the signal-based scheme and also close
(5/8) to the performance of the memory-barrier write-side. We have a write-side
speedup of 400:1 over the signal-based scheme by using the sys_membarrier system
call. This allows a 4.5:1 read-side speedup over the memory barrier scheme.

The non-expedited scheme adds indeed a much lower overhead on the read-side
both because we do not send IPIs and because we perform less updates, which in
turn generates less cache-line exchanges. The write-side latency becomes even
higher than with the signal-based scheme. The advantage of the non-expedited
sys_membarrier() scheme over signal-based scheme is that it does not require to
wake up all the process threads.


* More information about memory barriers in:

- sys_membarrier()
- membarrier_ipi()
- switch_mm()
- issued with ->mm update while the rq lock is held

The goal of these memory barriers is to ensure that all memory accesses to
user-space addresses performed by every processor which execute threads
belonging to the current process are observed to be in program order at least
once between the two memory barriers surrounding sys_membarrier().

If we were to simply broadcast an IPI to all processors between the two smp_mb()
in sys_membarrier(), membarrier_ipi() would execute on each processor, and
waiting for these handlers to complete execution guarantees that each running
processor passed through a state where user-space memory address accesses were
in program order.

However, this "big hammer" approach does not please the real-time concerned
people. This would let a non RT task disturb real-time tasks by sending useless
IPIs to processors not concerned by the memory of the current process.

This is why we iterate on the mm_cpumask, which is a superset of the processors
concerned by the process memory map and check each processor ->mm with the rq
lock held to confirm that the processor is indeed running a thread concerned
with our mm (and not just part of the mm_cpumask due to lazy TLB shootdown).

The barriers added in switch_mm() have one objective: user-space memory address
accesses must be in program order when mm_cpumask is set or cleared. (more
details in the x86 switch_mm() comments).

The verification, for each cpu part of the mm_cpumask, that the rq ->mm is
indeed part of the current ->mm needs to be done with the rq lock held. This
ensures that each time a rq ->mm is modified, a memory barrier (typically
implied by the change of memory mapping) is also issued. These ->mm update and
memory barrier are made atomic by the rq spinlock.

The execution scenario (1) shows the behavior of the sys_membarrier() system
call executed on Thread A while Thread B executes memory accesses that need to
be ordered. Thread B is running. Memory accesses in Thread B are in program
order (e.g. separated by a compiler barrier()).

1) Thread B running, ordering ensured by the membarrier_ipi():

  Thread A                               Thread B
-------------------------------------------------------------------------
  prev accesses to userspace addr.       prev accesses to userspace addr.
  sys_membarrier
    smp_mb
    IPI  ------------------------------membarrier_ipi()
                                         smp_mb
                                         return
    smp_mb
  following accesses to userspace addr.  following accesses to userspace addr.


The execution scenarios (2-3-4-5) show the same setup as (1), but Thread B is
not running while sys_membarrier() is called. Thanks to the memory barriers
added to switch_mm(), Thread B user-space address memory accesses are already in
program order when sys_membarrier finds out that either the mm_cpumask does not
contain Thread B CPU or that that CPU's ->mm is not running the current process
mm.

2) Context switch in, showing rq spin lock synchronization:

  Thread A                               Thread B
-------------------------------------------------------------------------
                                         <prev accesses to userspace addr. saved
                                          on stack>
  prev accesses to userspace addr.
  sys_membarrier
    smp_mb
      for each cpu in mm_cpumask
        <Thread B CPU is present e.g. due
         to lazy TLB shootdown>
        spin lock cpu rq
        mm = cpu rq mm 
        spin unlock cpu rq
                                         context switch in
                                         <spin lock cpu rq by other thread>
                                         load_cr3 (or equiv. mem. barrier)
                                         spin unlock cpu rq
                                         following accesses to userspace addr.
        if (mm == current rq mm)
          <false>
    smp_mb
  following accesses to userspace addr.

Here, the important point is that Thread B have passed through a point where all
its userspace memory address accesses were in program order between the two
smp_mb() in sys_membarrier.


3) Context switch out, showing rq spin lock synchronization:

  Thread A                               Thread B
-------------------------------------------------------------------------
  prev accesses to userspace addr.
                                         prev accesses to userspace addr.
  sys_membarrier
    smp_mb
      for each cpu in mm_cpumask
                                         context switch out
                                         spin lock cpu rq
                                         load_cr3 (or equiv. mem. barrier)
                                         <spin unlock cpu rq by other thread>
                                         <following accesses to userspace addr.
                                          will happen when rescheduled>
        spin lock cpu rq
        mm = cpu rq mm 
        spin unlock cpu rq
        if (mm == current rq mm)
          <false>
    smp_mb
  following accesses to userspace addr.

Same as (2): the important point is that Thread B have passed through a point
where all its userspace memory address accesses were in program order between
the two smp_mb() in sys_membarrier.

4) Context switch in, showing mm_cpumask synchronization:

  Thread A                               Thread B
-------------------------------------------------------------------------
                                         <prev accesses to userspace addr. saved
                                          on stack>
  prev accesses to userspace addr.
  sys_membarrier
    smp_mb
      for each cpu in mm_cpumask
        <Thread B CPU not in mask>
                                         context switch in
                                         set cpu bit in mm_cpumask
                                         load_cr3 (or equiv. mem. barrier)
                                         following accesses to userspace addr.
    smp_mb
  following accesses to userspace addr.

Same as 2-3: Thread B is passing through a point where userspace memory address
accesses are in program order between the two smp_mb() in sys_membarrier().

5) Context switch out, showing mm_cpumask synchronization:

  Thread A                               Thread B
-------------------------------------------------------------------------
  prev accesses to userspace addr.
                                         prev accesses to userspace addr.
  sys_membarrier
    smp_mb
                                         context switch out
                                         smp_mb_before_clear_bit
                                         clear cpu bit in mm_cpumask
                                         <following accesses to userspace addr.
                                          will happen when rescheduled>
      for each cpu in mm_cpumask
        <Thread B CPU not in mask>
    smp_mb
  following accesses to userspace addr.

Same as 2-3-4: Thread B is passing through a point where userspace memory
address accesses are in program order between the two smp_mb() in
sys_membarrier().

This patch only adds the system calls to x86 32/64. See the sys_membarrier()
comments for memory barriers requirement in switch_mm() to port to other
architectures.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Nicholas Miell <nmiell@comcast.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: akpm@linux-foundation.org
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: Nick Piggin <npiggin@suse.de>
CC: Chris Friesen <cfriesen@nortel.com>
---
 arch/x86/ia32/ia32entry.S          |    1 
 arch/x86/include/asm/mmu_context.h |   28 +++++
 arch/x86/include/asm/unistd_32.h   |    3 
 arch/x86/include/asm/unistd_64.h   |    2 
 arch/x86/kernel/syscall_table_32.S |    1 
 include/linux/Kbuild               |    1 
 include/linux/membarrier.h         |   47 +++++++++
 kernel/sched.c                     |  189 +++++++++++++++++++++++++++++++++++++
 8 files changed, 269 insertions(+), 3 deletions(-)

Index: linux.trees.git/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/unistd_64.h	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/unistd_64.h	2010-03-27 12:04:16.000000000 -0400
@@ -663,6 +663,8 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_membarrier				300
+__SYSCALL(__NR_membarrier, sys_membarrier)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/kernel/sched.c	2010-03-27 12:04:16.000000000 -0400
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <linux/membarrier.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -8971,6 +8972,194 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
+#ifdef CONFIG_SMP
+
+/*
+ * Execute a memory barrier on all active threads from the current process
+ * on SMP systems. Do not rely on implicit barriers in IPI handler execution,
+ * because batched IPI lists are synchronized with spinlocks rather than full
+ * memory barriers. This is not the bulk of the overhead anyway, so let's stay
+ * on the safe side.
+ */
+static void membarrier_ipi(void *unused)
+{
+	smp_mb();
+}
+
+/*
+ * Handle out-of-mem by sending per-cpu IPIs instead.
+ */
+static void membarrier_retry(void)
+{
+	struct mm_struct *mm;
+	int cpu;
+
+	for_each_cpu(cpu, mm_cpumask(current->mm)) {
+		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+		mm = cpu_curr(cpu)->mm;
+		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+		if (current->mm == mm)
+			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
+	}
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+/*
+ * sys_membarrier - issue memory barrier on current process running threads
+ * @flags: One of these must be set:
+ *         MEMBARRIER_EXPEDITED
+ *             Adds some overhead, fast execution (few microseconds)
+ *         MEMBARRIER_DELAYED
+ *             Low overhead, but slow execution (few milliseconds)
+ *
+ *         MEMBARRIER_QUERY
+ *           This optional flag can be set to query if the kernel supports
+ *           a set of flags.
+ *
+ * return values: Returns -EINVAL if the flags are incorrect. Testing for kernel
+ * sys_membarrier support can be done by checking for -ENOSYS return value.
+ * Return values >= 0 indicate success. For a given set of flags on a given
+ * kernel, this system call will always return the same value. It is therefore
+ * correct to check the return value only once at library load, passing the
+ * MEMBARRIER_QUERY flag in addition to only check if the flags are supported,
+ * without performing any synchronization.
+ *
+ * This system call executes a memory barrier on all running threads of the
+ * current process. Upon completion, the caller thread is ensured that all
+ * process threads have passed through a state where all memory accesses to
+ * user-space addresses match program order. (non-running threads are de facto
+ * in such a state)
+ *
+ * Using the non-expedited mode is recommended for applications which can
+ * afford leaving the caller thread waiting for a few milliseconds. A good
+ * example would be a thread dedicated to execute RCU callbacks, which waits
+ * for callbacks to enqueue most of the time anyway.
+ *
+ * The expedited mode is recommended whenever the application needs to have
+ * control returning to the caller thread as quickly as possible. An example
+ * of such application would be one which uses the same thread to perform
+ * data structure updates and issue the RCU synchronization.
+ *
+ * It is perfectly safe to call both expedited and non-expedited
+ * sys_membarrier() in a process.
+ *
+ * mm_cpumask is used as an approximation of the processors which run threads
+ * belonging to the current process. It is a superset of the cpumask to which we
+ * must send IPIs, mainly due to lazy TLB shootdown. Therefore, for each CPU in
+ * the mm_cpumask, we check each runqueue with the rq lock held to make sure our
+ * ->mm is indeed running on them. The rq lock ensures that a memory barrier is
+ * issued each time the rq current task is changed. This reduces the risk of
+ * disturbing a RT task by sending unnecessary IPIs. There is still a slight
+ * chance to disturb an unrelated task, because we do not lock the runqueues
+ * while sending IPIs, but the real-time effect of this heavy locking would be
+ * worse than the comparatively small disruption of an IPI.
+ *
+ * RED PEN: before assinging a system call number for sys_membarrier() to an
+ * architecture, we must ensure that switch_mm issues full memory barriers
+ * (or a synchronizing instruction having the same effect) between:
+ * - memory accesses to user-space addresses and clear mm_cpumask.
+ * - set mm_cpumask and memory accesses to user-space addresses.
+ *
+ * The reason why these memory barriers are required is that mm_cpumask updates,
+ * as well as iteration on the mm_cpumask, offer no ordering guarantees.
+ * These added memory barriers ensure that any thread modifying the mm_cpumask
+ * is in a state where all memory accesses to user-space addresses are
+ * guaranteed to be in program order.
+ *
+ * In some case adding a comment to this effect will suffice, in others we
+ * will need to add smp_mb__before_clear_bit()/smp_mb__after_clear_bit() or
+ * simply smp_mb(). These barriers are required to ensure we do not _miss_ a
+ * CPU that need to receive an IPI, which would be a bug.
+ *
+ * On uniprocessor systems, this system call simply returns 0 without doing
+ * anything, so user-space knows it is implemented.
+ *
+ * The flags argument has room for extensibility, with 16 lower bits holding
+ * mandatory flags for which older kernels will fail if they encounter an
+ * unknown flag. The high 16 bits are used for optional flags, which older
+ * kernels don't have to care about.
+ *
+ * This synchronization only takes care of threads using the current process
+ * memory map. It should not be used to synchronize accesses performed on memory
+ * maps shared between different processes.
+ */
+SYSCALL_DEFINE1(membarrier, unsigned int, flags)
+{
+#ifdef CONFIG_SMP
+	struct mm_struct *mm;
+	cpumask_var_t tmpmask;
+	int cpu;
+
+	/*
+	 * Expect _only_ one of expedited or delayed flags.
+	 * Don't care about optional mask for now.
+	 */
+	switch (flags & MEMBARRIER_MANDATORY_MASK) {
+	case MEMBARRIER_EXPEDITED:
+	case MEMBARRIER_DELAYED:
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (unlikely(flags & MEMBARRIER_QUERY
+		     || thread_group_empty(current))
+		     || num_online_cpus() == 1)
+		return 0;
+	if (flags & MEMBARRIER_DELAYED) {
+		synchronize_sched();
+		return 0;
+	}
+	/*
+	 * Memory barrier on the caller thread between previous memory accesses
+	 * to user-space addresses and sending memory-barrier IPIs. Orders all
+	 * user-space address memory accesses prior to sys_membarrier() before
+	 * mm_cpumask read and membarrier_ipi executions. This barrier is paired
+	 * with memory barriers in:
+	 * - membarrier_ipi() (for each running threads of the current process)
+	 * - switch_mm() (ordering scheduler mm_cpumask update wrt memory
+	 *                accesses to user-space addresses)
+	 * - Each CPU ->mm update performed with rq lock held by the scheduler.
+	 *   A memory barrier is issued each time ->mm is changed while the rq
+	 *   lock is held.
+	 */
+	smp_mb();
+	if (!alloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
+		membarrier_retry();
+		goto out;
+	}
+	cpumask_copy(tmpmask, mm_cpumask(current->mm));
+	preempt_disable();
+	cpumask_clear_cpu(smp_processor_id(), tmpmask);
+	for_each_cpu(cpu, tmpmask) {
+		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+		mm = cpu_curr(cpu)->mm;
+		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+		if (current->mm != mm)
+			cpumask_clear_cpu(cpu, tmpmask);
+	}
+	smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
+	preempt_enable();
+	free_cpumask_var(tmpmask);
+out:
+	/*
+	 * Memory barrier on the caller thread between sending&waiting for
+	 * memory-barrier IPIs and following memory accesses to user-space
+	 * addresses. Orders mm_cpumask read and membarrier_ipi executions
+	 * before all user-space address memory accesses following
+	 * sys_membarrier(). This barrier is paired with memory barriers in:
+	 * - membarrier_ipi() (for each running threads of the current process)
+	 * - switch_mm() (ordering scheduler mm_cpumask update wrt memory
+	 *                accesses to user-space addresses)
+	 * - Each CPU ->mm update performed with rq lock held by the scheduler.
+	 *   A memory barrier is issued each time ->mm is changed while the rq
+	 *   lock is held.
+	 */
+	smp_mb();
+#endif /* #ifdef CONFIG_SMP */
+	return 0;
+}
+
 #ifndef CONFIG_SMP
 
 int rcu_expedited_torture_stats(char *page)
Index: linux.trees.git/include/linux/membarrier.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/membarrier.h	2010-03-27 12:04:16.000000000 -0400
@@ -0,0 +1,47 @@
+#ifndef _LINUX_MEMBARRIER_H
+#define _LINUX_MEMBARRIER_H
+
+/* First argument to membarrier syscall */
+
+/*
+ * Mandatory flags to the membarrier system call that the kernel must
+ * understand are in the low 16 bits.
+ */
+#define MEMBARRIER_MANDATORY_MASK	0x0000FFFF	/* Mandatory flags */
+
+/*
+ * Optional hints that the kernel can ignore are in the high 16 bits.
+ */
+#define MEMBARRIER_OPTIONAL_MASK	0xFFFF0000	/* Optional hints */
+
+/* Expedited: adds some overhead, fast execution (few microseconds) */
+#define MEMBARRIER_EXPEDITED		(1 << 0)
+/* Delayed: Low overhead, but slow execution (few milliseconds) */
+#define MEMBARRIER_DELAYED		(1 << 1)
+
+/* Query flag support, without performing synchronization */
+#define MEMBARRIER_QUERY		(1 << 16)
+
+
+/*
+ * All memory accesses performed in program order from each process threads are
+ * guaranteed to be ordered with respect to sys_membarrier(). If we use the
+ * semantic "barrier()" to represent a compiler barrier forcing memory accesses
+ * to be performed in program order across the barrier, and smp_mb() to
+ * represent explicit memory barriers forcing full memory ordering across the
+ * barrier, we have the following ordering table for each pair of barrier(),
+ * sys_membarrier() and smp_mb() :
+ *
+ * The pair ordering is detailed as (O: ordered, X: not ordered):
+ *
+ *                        barrier()   smp_mb() sys_membarrier()
+ *        barrier()          X           X            O
+ *        smp_mb()           X           O            O
+ *        sys_membarrier()   O           O            O
+ *
+ * This synchronization only takes care of threads using the current process
+ * memory map. It should not be used to synchronize accesses performed on memory
+ * maps shared between different processes.
+ */
+
+#endif
Index: linux.trees.git/include/linux/Kbuild
===================================================================
--- linux.trees.git.orig/include/linux/Kbuild	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/include/linux/Kbuild	2010-03-27 12:04:16.000000000 -0400
@@ -111,6 +111,7 @@ header-y += magic.h
 header-y += major.h
 header-y += map_to_7segment.h
 header-y += matroxfb.h
+header-y += membarrier.h
 header-y += meye.h
 header-y += minix_fs.h
 header-y += mmtimer.h
Index: linux.trees.git/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/unistd_32.h	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/unistd_32.h	2010-03-27 12:04:16.000000000 -0400
@@ -343,10 +343,11 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
+#define __NR_membarrier		338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 339
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux.trees.git/arch/x86/ia32/ia32entry.S
===================================================================
--- linux.trees.git.orig/arch/x86/ia32/ia32entry.S	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/arch/x86/ia32/ia32entry.S	2010-03-27 12:04:16.000000000 -0400
@@ -842,4 +842,5 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_membarrier
 ia32_syscall_end:
Index: linux.trees.git/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/syscall_table_32.S	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/arch/x86/kernel/syscall_table_32.S	2010-03-27 12:04:16.000000000 -0400
@@ -337,3 +337,4 @@ ENTRY(sys_call_table)
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_recvmmsg
+	.long sys_membarrier
Index: linux.trees.git/arch/x86/include/asm/mmu_context.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/mmu_context.h	2010-03-27 11:31:28.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/mmu_context.h	2010-03-27 12:04:16.000000000 -0400
@@ -36,6 +36,16 @@ static inline void switch_mm(struct mm_s
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
+		/*
+		 * smp_mb() between memory accesses to user-space addresses and
+		 * mm_cpumask clear is required by sys_membarrier(). This
+		 * ensures that all user-space address memory accesses are in
+		 * program order when the mm_cpumask is cleared.
+		 * smp_mb__before_clear_bit() turns into a barrier() on x86. It
+		 * is left here to document that this barrier is needed, as an
+		 * example for other architectures.
+		 */
+		smp_mb__before_clear_bit();
 		/* stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
@@ -43,7 +53,13 @@ static inline void switch_mm(struct mm_s
 		percpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpumask_set_cpu(cpu, mm_cpumask(next));
-
+		/*
+		 * smp_mb() between mm_cpumask set and memory accesses to
+		 * user-space addresses is required by sys_membarrier(). This
+		 * ensures that all user-space address memory accesses performed
+		 * by the current thread are in program order when the
+		 * mm_cpumask is set. Implied by load_cr3.
+		 */
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
@@ -59,9 +75,17 @@ static inline void switch_mm(struct mm_s
 		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
 
 		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
-			/* We were in lazy tlb mode and leave_mm disabled
+			/*
+			 * We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
+			 *
+			 * smp_mb() between mm_cpumask set and memory accesses
+			 * to user-space addresses is required by
+			 * sys_membarrier(). This ensures that all user-space
+			 * address memory accesses performed by the current
+			 * thread are in program order when the mm_cpumask is
+			 * set. Implied by load_cr3.
 			 */
 			load_cr3(next->pgd);
 			load_LDT_nolock(&next->context);

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
