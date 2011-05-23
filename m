Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1EWJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:09:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43649 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1EWJJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:09:51 -0400
Date: Mon, 23 May 2011 11:09:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
Message-ID: <20110523090918.GA5474@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
 <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 19, 2011 at 11:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (sparc32 defconfig)
> > failed like this:
> 
> Hmm. So I had actually done a "allyesconfig" build on x86, which
> annoys me. Because it means that the extra "let's compile everything
> to make sure I didn't break anything" was just almost totally
> worthless.
> 
> What seems to be happening is that the x86 <asm/uaccess.h> include
> ends up getting the <linux/prefetch.h>.
> 
> I have *no* idea why x86 does that, but x86 wants prefetch.h *so* much
> that it actually includes it first in <asm/uaccess.h> and then *again*
> in each of the 32/64-bit specific <asm/uaccess_[32,64].h> header
> files.
>
> That seems a bit excessive. I don't think x86 should include 
> <linux/prefetch.h> at all, since (a) it doesn't actually use any of it, and 
> (b) it ended up hiding this problem from me.

Most definitely.

> Thomas, Ingo, Peter: would you be willing to just remove that stupid header 
> file inclusion and fix up the fallout? Instead of having these one-by-one 
> patches that come from Stephen testing out breakage on other architectures 
> that x86 simply hid due to its odd include files?

Agreed - i see you've done this with commit 268bb0ce.

I've done some kernel change archeology, and the prefetch.h inclusion was done 
for hysterical reasons:

 - In Feb 2002 we added prefetch() to uaccess*.h, see this commit in 
   linux-2.6-historic.git, introducing prefetch() in 
   include/asm-i386/uaccess.h::__constant_copy_to_user():

    1d66e22e0f6b: v2.4.9.8 -> v2.4.9.9

   ( I *think* paulus did it as part of preparing more PowerPC changes - but 
     it's not explicitly mentioned in the changelog.)

 - the x86_64 fork copied the asm-i386 prefetch() so now 64-bit had it too

 - In Sep 2002 this commit from Andrew removed the prefetch() from the i386 
   uaccess.h header:

     0a7bf9c89604: [PATCH] uninline the ia32 copy_*_user functions

   But did not declare this in the changelog - nor did it remove the 
   (now dangling) prefetch.h.

 - In Sep 2003 this x86_64 commit removed the prefetch() usage from the 64-bit 
   uaccess.h as well:

      24594a2bfcaa: [PATCH] x86-64 merge

     - Remove some unneeded prefetches.  Just two are enough to kickstart
       the hardware prefetcher.

   But despite touching prefetches explicitly, this too sloppily left the (now
   dangling) prefetch.h include file around.

 - 8 years later it was still around.

Such thing happen due to:

 - header files only get added, almost never removed

The key thing was that the build did not break when prefetch.h was kept 
dangling. Not sure what to do about that - for humans a dangling header is 
absolutely non-obvious to find - we'd need tooling help.

Especially since a tight (or bloated) header file hierarchy directly impacts 
our build performance. For example kernel/fork.c has 1700 lines of code in it, 
but after preprocessing it has 30x times as much code (!):

 earth4:~/tip> wc -l kernel/fork.c kernel/fork.i
    1691 kernel/fork.c
   49385 kernel/fork.i

While fork.c is definitely a central file which has to know about almost all 
other subsystem's structure definitions, the #include situation is still 
somewhat obscene.

For smaller subsystems it's in fact *worse*:

 earth4:~/tip> wc -l kernel/pid.[ci]
     570 kernel/pid.c
   38724 kernel/pid.i.vanilla

That's a 60x size bloat! The compiler will run *significantly* slower with 
increasing source code size - it has to parse through those duplications and 
has to process those many inlines as well.

Here's a quick hack and a perf stat measurement showing the effect in action. 

I've attached a totally hacky patch that removes all the big #include's from 
kernel/pid.c and includes all structure and API definitions explicitly.

( Note: near the end it was getting really tedious so i took some shortcuts
  and hacks just to make it build - it's a broken kernel otherwise.  Object 
  file size is still similar so i have not taken too many shortcuts, at least 
  as far as compilation speed goes. )

Firstly, the effective file size results are:

 aldebaran:~/linux/linux> wc -l kernel/pid.c kernel/pid.i.*
     570 kernel/pid.c.vanilla
   38724 kernel/pid.i.vanilla

    3006 kernel/pid.c.slim
    2542 kernel/pid.i.slim

So the 38 KLOC bloat was cut down to 2.5 KLOC - a more than 10x improvement.

Even considering the invalid shortcuts i took to make this build, halving the 
bloat would be quite realistic.

What effect does include file bloat have on kernel build speed?

I've measured the build time of kernel/pid.o - with no Make overhead, just the 
cc command itself:

 gcc -Wp,-MD,kernel/.pid.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/home/mingo/tip/arch/x86/include -Iinclude  -include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(pid)"  -D"KBUILD_MODNAME=KBUILD_STR(pid)" -c -o kernel/pid.o kernel/pid.c

The results are pretty interesting:

 | Vanilla pid.c :
 -----------------

 $ perf stat -e task-clock --repeat 10 ./build-pid 

 Performance counter stats for './build-pid' (10 runs):

        223.500413 task-clock                #    1.010 CPUs utilized            ( +-  0.10% )

       0.221370168 seconds time elapsed                                          ( +-  0.20% )

 | Debloated pid.c :
 -------------------

 $ perf stat -e task-clock --repeat 10 ./build-pid 

 Performance counter stats for './build-pid' (10 runs):

         97.488258 task-clock                #    1.019 CPUs utilized            ( +-  0.06% )

       0.095649333 seconds time elapsed                                          ( +-  0.15% )

So we got a 56.4% kernel build speedup from the debloating! Note, i used the 
latest available version of GCC, 4.6.0.

Put differently, our bloat is causing a 2.3x slowdown in kernel build speed 
right now (!).

Where does the bloat come from? Here's the rough distribution (by line numbers):

29:/*-- basic kernel types: ---------------------------------------------------*/
32:/*-- RCU header - should move into types.h? ---------------------------------------------------*/
39:/*-- pid.h types: ---------------------------------------------------*/
49:/*-- sched.h, rbnode.h dependency: ---------------------------------------------------*/
67:/*-- sched.h, scheduler state: ---------------------------------------------------*/
164:/*-- sched.h, cpumask.h types: ---------------------------------------------------*/
174:/*-- sched.h, plist.h types: ---------------------------------------------------*/
190:/*-- sched.h, pid types: ---------------------------------------------------*/
198:/*-- sched.h, time types - needlessly arch dependent should move into types.h? -----------*/
216:/*-- sched.h, spinlock.h dependencies:  -----------*/
284:/*-- sched.h, ipc.h dependencies:  -----------*/
296:/*-- sched.h, signal state dependencies:  -----------*/
375:/*-- sched.h, arch thread state dependencies:  -----------*/
545:/*-- sched.h, seccomp state dependencies:  -----------*/
549:/*-- sched.h, IO accounting state dependencies:  -----------*/
587:/*-- sched.h, nodemask.h types:  -----------*/
599:/*-- sched.h, mutex type:  -----------*/
618:/*-- sched.h, perf event state:  -----------*/
681:/*-- sched.h, mm dirty state:  -----------*/
698:/*-- sched.h, task state:  -----------*/
1052:/*--  pid.c, PID type definitions:  -----------*/
1133:/*-- module.h arch dependency: ---------------------------------------------------*/
1149:/*-- module.h ELF dependencies: ---------------------------------------------------*/
1233:/*-- module.h sysfs dependencies: ---------------------------------------------------*/
1259:/*-- module.h's init.h dependency: -------------------------------*/
1263:/*-- module.h: ---------------------------------------------------*/
1730:/*-- pid.c API usage: ---------------------------------------------------*/
1731:/*-- preempt.h thread_info dependencies: --------------------------------*/
1732:/*-- preempt.h thread_info processor.h dependencies: --------------------*/
1738:/*-- preempt.h linux/thread_info.h dependencies: --------------------*/
1778:/*-- preempt.h asm/thread_info.h page_types.h dependencies: --------------------*/
1783:/*-- preempt.h asm/thread_info.h dependencies: --------------------*/
1820:/*-- preempt.h linux/thread_info.h bitops.h dependencies (simplfied): --------------------*/
1838:/*-- preempt.h linux/thread_info.h dependencies: --------------------*/
1866:/*-- rcu API preempt.h dependencies: ---------------------------------------------------*/
1925:/*-- pid.c sched.h API usage: ---------------------------------------------------*/
1932:/*-- pid.c cache.h API usage: ---------------------------------------------------*/
1950:/*-- pid.c spinlock.h API usage: ---------------------------------------------------*/
1962:/*-- pid.c atomic.h API usage: ---------------------------------------------------*/
2080:/*-- pid.c hash.h API usage: ---------------------------------------------------*/
2134:/*-- pid.c API (some of them nasty hacks/shortcuts): ----------------------------------------------*/
2474:/*-- pid.c C code: ---------------------------------------------------*/

Out of ~2400 lines of header files, half of it is task state. Most of the 
task_struct details that get defined are not used by pid.c! Much of this could 
be fixed by moving scheduler, signal, arch thread state details behind an 
opaque pointer. This would have runtime performance impact - but most likely a 
pretty minimal one.

A surprisingly large chunk are all the module.h details which brings in details 
like large elf.h definitions - despite pid.c only relying on the module code 
for the spurious use of EXPORT_SYMBOL primitives. Fixing this would cause no 
runtime overhead AFAICS.

Another big chunk are the RCU definitions and APIs. These too are inlined for 
performance reasons - and that seems justified.

Anway, what i tried to demonstrate with this mail how much *real* slowdown in 
the kernel build our current header file bloat is causing. We could literally 
halve our kernel build times if we fixed this!

Thanks,

	Ingo

-------------------->
Subject: pid.c: Ugly hacks to measure include file bloat
From: Ingo Molnar <mingo@elte.hu>
Date: Mon May 23 09:09:27 CEST 2011

Absolutely-NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/pid.c | 2458 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 2447 insertions(+), 11 deletions(-)

Index: linux/kernel/pid.c
===================================================================
--- linux.orig/kernel/pid.c
+++ linux/kernel/pid.c
@@ -26,16 +26,2452 @@
  *
  */
 
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/rculist.h>
-#include <linux/bootmem.h>
-#include <linux/hash.h>
-#include <linux/pid_namespace.h>
-#include <linux/init_task.h>
-#include <linux/syscalls.h>
+/*-- basic kernel types: ---------------------------------------------------*/
+#include <linux/types.h>
+
+/*-- RCU header - should move into types.h? ---------------------------------------------------*/
+
+struct rcu_head {
+	struct rcu_head *next;
+	void (*func)(struct rcu_head *head);
+};
+
+/*-- pid.h types: ---------------------------------------------------*/
+
+enum pid_type
+{
+	PIDTYPE_PID,
+	PIDTYPE_PGID,
+	PIDTYPE_SID,
+	PIDTYPE_MAX
+};
+
+/*-- sched.h, rbnode.h dependency: ---------------------------------------------------*/
+
+struct rb_node
+{
+	unsigned long  rb_parent_color;
+#define	RB_RED		0
+#define	RB_BLACK	1
+	struct rb_node *rb_right;
+	struct rb_node *rb_left;
+} __attribute__((aligned(sizeof(long))));
+    /* The alignment might seem pointless, but allegedly CRIS needs it */
+
+struct rb_root
+{
+	struct rb_node *rb_node;
+};
+
+
+/*-- sched.h, scheduler state: ---------------------------------------------------*/
+
+struct load_weight {
+	unsigned long weight, inv_weight;
+};
+
+
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+struct sched_info {
+	/* cumulative counters */
+	unsigned long pcount;	      /* # of times run on this cpu */
+	unsigned long long run_delay; /* time spent waiting on a runqueue */
+
+	/* timestamps */
+	unsigned long long last_arrival,/* when we last ran on a cpu */
+			   last_queued;	/* when we were last queued to run */
+};
+#endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
+
+#ifdef CONFIG_SCHEDSTATS
+struct sched_statistics {
+	u64			wait_start;
+	u64			wait_max;
+	u64			wait_count;
+	u64			wait_sum;
+	u64			iowait_count;
+	u64			iowait_sum;
+
+	u64			sleep_start;
+	u64			sleep_max;
+	s64			sum_sleep_runtime;
+
+	u64			block_start;
+	u64			block_max;
+	u64			exec_max;
+	u64			slice_max;
+
+	u64			nr_migrations_cold;
+	u64			nr_failed_migrations_affine;
+	u64			nr_failed_migrations_running;
+	u64			nr_failed_migrations_hot;
+	u64			nr_forced_migrations;
+
+	u64			nr_wakeups;
+	u64			nr_wakeups_sync;
+	u64			nr_wakeups_migrate;
+	u64			nr_wakeups_local;
+	u64			nr_wakeups_remote;
+	u64			nr_wakeups_affine;
+	u64			nr_wakeups_affine_attempts;
+	u64			nr_wakeups_passive;
+	u64			nr_wakeups_idle;
+};
+#endif
+
+struct sched_entity {
+	struct load_weight	load;		/* for load-balancing */
+	struct rb_node		run_node;
+	struct list_head	group_node;
+	unsigned int		on_rq;
+
+	u64			exec_start;
+	u64			sum_exec_runtime;
+	u64			vruntime;
+	u64			prev_sum_exec_runtime;
+
+	u64			nr_migrations;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_statistics statistics;
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_entity	*parent;
+	/* rq on which this entity is (to be) queued: */
+	struct cfs_rq		*cfs_rq;
+	/* rq "owned" by this entity/group: */
+	struct cfs_rq		*my_q;
+#endif
+};
+
+struct sched_rt_entity {
+	struct list_head run_list;
+	unsigned long timeout;
+	unsigned int time_slice;
+	int nr_cpus_allowed;
+
+	struct sched_rt_entity *back;
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity	*parent;
+	/* rq on which this entity is (to be) queued: */
+	struct rt_rq		*rt_rq;
+	/* rq "owned" by this entity/group: */
+	struct rt_rq		*my_q;
+#endif
+};
+
+/*-- sched.h, cpumask.h types: ---------------------------------------------------*/
+
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
+#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, 8 * sizeof(long))
+
+#define NR_CPUS		CONFIG_NR_CPUS
+
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+
+/*-- sched.h, plist.h types: ---------------------------------------------------*/
+
+struct plist_node {
+	int			prio;
+	struct list_head	prio_list;
+	struct list_head	node_list;
+};
+
+struct plist_head {
+	struct list_head node_list;
+#ifdef CONFIG_DEBUG_PI_LIST
+	raw_spinlock_t *rawlock;
+	spinlock_t *spinlock;
+#endif
+};
+
+/*-- sched.h, pid types: ---------------------------------------------------*/
+
+struct pid_link
+{
+	struct hlist_node node;
+	struct pid *pid;
+};
+
+/*-- sched.h, time types - needlessly arch dependent should move into types.h? -----------*/
+
+typedef unsigned long cputime_t;
+
+struct task_cputime {
+	cputime_t utime;
+	cputime_t stime;
+	unsigned long long sum_exec_runtime;
+};
+
+/* Alternate field names when used to cache expirations. */
+struct timespec {
+	__kernel_time_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
+};
+
+#define TASK_COMM_LEN 16
+
+/*-- sched.h, spinlock.h dependencies:  -----------*/
+
+typedef struct arch_spinlock {
+	unsigned int slock;
+} arch_spinlock_t;
+
+typedef struct {
+	unsigned int lock;
+} arch_rwlock_t;
+
+typedef struct raw_spinlock {
+	arch_spinlock_t raw_lock;
+#ifdef CONFIG_GENERIC_LOCKBREAK
+	unsigned int break_lock;
+#endif
+#ifdef CONFIG_DEBUG_SPINLOCK
+	unsigned int magic, owner_cpu;
+	void *owner;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+} raw_spinlock_t;
+
+#define SPINLOCK_MAGIC		0xdead4ead
+
+#define SPINLOCK_OWNER_INIT	((void *)-1L)
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+#else
+# define SPIN_DEP_MAP_INIT(lockname)
+#endif
+
+#ifdef CONFIG_DEBUG_SPINLOCK
+# define SPIN_DEBUG_INIT(lockname)		\
+	.magic = SPINLOCK_MAGIC,		\
+	.owner_cpu = -1,			\
+	.owner = SPINLOCK_OWNER_INIT,
+#else
+# define SPIN_DEBUG_INIT(lockname)
+#endif
+
+#define __RAW_SPIN_LOCK_INITIALIZER(lockname)	\
+	{					\
+	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
+	SPIN_DEBUG_INIT(lockname)		\
+	SPIN_DEP_MAP_INIT(lockname) }
+
+#define __RAW_SPIN_LOCK_UNLOCKED(lockname)	\
+	(raw_spinlock_t) __RAW_SPIN_LOCK_INITIALIZER(lockname)
+
+#define DEFINE_RAW_SPINLOCK(x)	raw_spinlock_t x = __RAW_SPIN_LOCK_UNLOCKED(x)
+
+typedef struct spinlock {
+	union {
+		struct raw_spinlock rlock;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define LOCK_PADSIZE (offsetof(struct raw_spinlock, dep_map))
+		struct {
+			u8 __padding[LOCK_PADSIZE];
+			struct lockdep_map dep_map;
+		};
+#endif
+	};
+} spinlock_t;
+
+/*-- sched.h, ipc.h dependencies:  -----------*/
+
+struct sem_undo_list {
+	atomic_t		refcnt;
+	spinlock_t		lock;
+	struct list_head	list_proc;
+};
+
+struct sysv_sem {
+	struct sem_undo_list *undo_list;
+};
+
+/*-- sched.h, signal state dependencies:  -----------*/
+
+typedef unsigned long sigset_t;
+
+struct sigpending {
+	struct list_head list;
+	sigset_t signal;
+};
+
+typedef union sigval {
+	int sival_int;
+	void __user *sival_ptr;
+} sigval_t;
+
+#define __ARCH_SI_PREAMBLE_SIZE	(3 * sizeof(int))
+
+#define SI_MAX_SIZE	128
+#define SI_PAD_SIZE	((SI_MAX_SIZE - __ARCH_SI_PREAMBLE_SIZE) / sizeof(int))
+
+#define __ARCH_SI_UID_T	__kernel_uid32_t
+
+#define __ARCH_SI_BAND_T long
+
+typedef struct siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[SI_PAD_SIZE];
+
+		/* kill() */
+		struct {
+			__kernel_pid_t _pid;	/* sender's pid */
+			__ARCH_SI_UID_T _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			__kernel_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			char _pad[sizeof( __ARCH_SI_UID_T) - sizeof(int)];
+			sigval_t _sigval;	/* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			__kernel_pid_t _pid;	/* sender's pid */
+			__ARCH_SI_UID_T _uid;	/* sender's uid */
+			sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			__kernel_pid_t _pid;	/* which child */
+			__ARCH_SI_UID_T _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			__kernel_clock_t _utime;
+			__kernel_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			void __user *_addr; /* faulting insn/memory ref. */
+#ifdef __ARCH_SI_TRAPNO
+			int _trapno;	/* TRAP # which caused the signal */
+#endif
+			short _addr_lsb; /* LSB of the reported address */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			__ARCH_SI_BAND_T _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} siginfo_t;
+
+/*-- sched.h, arch thread state dependencies:  -----------*/
+
+#define GDT_ENTRY_TLS_ENTRIES 3
+#define HBP_NUM 4
+
+struct desc_struct {
+	union {
+		struct {
+			unsigned int a;
+			unsigned int b;
+		};
+		struct {
+			u16 limit0;
+			u16 base0;
+			unsigned base1: 8, type: 4, s: 1, dpl: 2, p: 1;
+			unsigned limit: 4, avl: 1, l: 1, d: 1, g: 1, base2: 8;
+		};
+	};
+} __attribute__((packed));
+
+struct i387_fsave_struct {
+	u32			cwd;	/* FPU Control Word		*/
+	u32			swd;	/* FPU Status Word		*/
+	u32			twd;	/* FPU Tag Word			*/
+	u32			fip;	/* FPU IP Offset		*/
+	u32			fcs;	/* FPU IP Selector		*/
+	u32			foo;	/* FPU Operand Pointer Offset	*/
+	u32			fos;	/* FPU Operand Pointer Selector	*/
+
+	/* 8*10 bytes for each FP-reg = 80 bytes:			*/
+	u32			st_space[20];
+
+	/* Software status information [not touched by FSAVE ]:		*/
+	u32			status;
+};
+
+struct i387_fxsave_struct {
+	u16			cwd; /* Control Word			*/
+	u16			swd; /* Status Word			*/
+	u16			twd; /* Tag Word			*/
+	u16			fop; /* Last Instruction Opcode		*/
+	union {
+		struct {
+			u64	rip; /* Instruction Pointer		*/
+			u64	rdp; /* Data Pointer			*/
+		};
+		struct {
+			u32	fip; /* FPU IP Offset			*/
+			u32	fcs; /* FPU IP Selector			*/
+			u32	foo; /* FPU Operand Offset		*/
+			u32	fos; /* FPU Operand Selector		*/
+		};
+	};
+	u32			mxcsr;		/* MXCSR Register State */
+	u32			mxcsr_mask;	/* MXCSR Mask		*/
+
+	/* 8*16 bytes for each FP-reg = 128 bytes:			*/
+	u32			st_space[32];
+
+	/* 16*16 bytes for each XMM-reg = 256 bytes:			*/
+	u32			xmm_space[64];
+
+	u32			padding[12];
+
+	union {
+		u32		padding1[12];
+		u32		sw_reserved[12];
+	};
+
+} __attribute__((aligned(16)));
+
+struct i387_soft_struct {
+	u32			cwd;
+	u32			swd;
+	u32			twd;
+	u32			fip;
+	u32			fcs;
+	u32			foo;
+	u32			fos;
+	/* 8*10 bytes for each FP-reg = 80 bytes: */
+	u32			st_space[20];
+	u8			ftop;
+	u8			changed;
+	u8			lookahead;
+	u8			no_update;
+	u8			rm;
+	u8			alimit;
+	struct math_emu_info	*info;
+	u32			entry_eip;
+};
+
+struct ymmh_struct {
+	/* 16 * 16 bytes for each YMMH-reg = 256 bytes */
+	u32 ymmh_space[64];
+};
+
+struct xsave_hdr_struct {
+	u64 xstate_bv;
+	u64 reserved1[2];
+	u64 reserved2[5];
+} __attribute__((packed));
+
+struct xsave_struct {
+	struct i387_fxsave_struct i387;
+	struct xsave_hdr_struct xsave_hdr;
+	struct ymmh_struct ymmh;
+	/* new processor state extensions will go here */
+} __attribute__ ((packed, aligned (64)));
+
+union thread_xstate {
+	struct i387_fsave_struct	fsave;
+	struct i387_fxsave_struct	fxsave;
+	struct i387_soft_struct		soft;
+	struct xsave_struct		xsave;
+};
+
+struct fpu {
+	union thread_xstate *state;
+};
+
+struct thread_struct {
+	/* Cached TLS descriptors: */
+	struct desc_struct	tls_array[GDT_ENTRY_TLS_ENTRIES];
+	unsigned long		sp0;
+	unsigned long		sp;
+#ifdef CONFIG_X86_32
+	unsigned long		sysenter_cs;
+#else
+	unsigned long		usersp;	/* Copy from PDA */
+	unsigned short		es;
+	unsigned short		ds;
+	unsigned short		fsindex;
+	unsigned short		gsindex;
+#endif
+#ifdef CONFIG_X86_32
+	unsigned long		ip;
+#endif
+#ifdef CONFIG_X86_64
+	unsigned long		fs;
+#endif
+	unsigned long		gs;
+	/* Save middle states of ptrace breakpoints */
+	struct perf_event	*ptrace_bps[HBP_NUM];
+	/* Debug status used for traps, single steps, etc... */
+	unsigned long           debugreg6;
+	/* Keep track of the exact dr7 value set by the user */
+	unsigned long           ptrace_dr7;
+	/* Fault info: */
+	unsigned long		cr2;
+	unsigned long		trap_no;
+	unsigned long		error_code;
+	/* floating point and extended processor state */
+	struct fpu		fpu;
+#ifdef CONFIG_X86_32
+	/* Virtual 86 mode info */
+	struct vm86_struct __user *vm86_info;
+	unsigned long		screen_bitmap;
+	unsigned long		v86flags;
+	unsigned long		v86mask;
+	unsigned long		saved_sp0;
+	unsigned int		saved_fs;
+	unsigned int		saved_gs;
+#endif
+	/* IO permissions: */
+	unsigned long		*io_bitmap_ptr;
+	unsigned long		iopl;
+	/* Max allowed port in the bitmap, in bytes: */
+	unsigned		io_bitmap_max;
+};
+
+/*-- sched.h, seccomp state dependencies:  -----------*/
+
+typedef struct { int mode; } seccomp_t;
+
+/*-- sched.h, IO accounting state dependencies:  -----------*/
+
+struct task_io_accounting {
+#ifdef CONFIG_TASK_XACCT
+	/* bytes read */
+	u64 rchar;
+	/*  bytes written */
+	u64 wchar;
+	/* # of read syscalls */
+	u64 syscr;
+	/* # of write syscalls */
+	u64 syscw;
+#endif /* CONFIG_TASK_XACCT */
+
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	/*
+	 * The number of bytes which this task has caused to be read from
+	 * storage.
+	 */
+	u64 read_bytes;
+
+	/*
+	 * The number of bytes which this task has caused, or shall cause to be
+	 * written to disk.
+	 */
+	u64 write_bytes;
+
+	/*
+	 * A task can cause "negative" IO too.  If this task truncates some
+	 * dirty pagecache, some IO which another task has been accounted for
+	 * (in its write_bytes) will not be happening.  We _could_ just
+	 * subtract that from the truncating task's write_bytes, but there is
+	 * information loss in doing that.
+	 */
+	u64 cancelled_write_bytes;
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
+};
+
+/*-- sched.h, nodemask.h types:  -----------*/
+
+#ifdef CONFIG_NODES_SHIFT
+#define NODES_SHIFT     CONFIG_NODES_SHIFT
+#else
+#define NODES_SHIFT     0
+#endif
+
+#define MAX_NUMNODES    (1 << NODES_SHIFT)
+
+typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
+
+/*-- sched.h, mutex type:  -----------*/
+
+struct mutex {
+	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
+	atomic_t		count;
+	spinlock_t		wait_lock;
+	struct list_head	wait_list;
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
+	struct task_struct	*owner;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
+	const char 		*name;
+	void			*magic;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+/*-- sched.h, perf event state:  -----------*/
+
+enum perf_event_context_type {
+	task_context,
+	cpu_context,
+};
+
+/**
+ * struct perf_event_context - event context structure
+ *
+ * Used as a container for task events and CPU events as well:
+ */
+struct perf_event_context {
+	struct pmu			*pmu;
+	enum perf_event_context_type	type;
+	/*
+	 * Protect the states of the events in the list,
+	 * nr_active, and the list:
+	 */
+	raw_spinlock_t			lock;
+	/*
+	 * Protect the list of events.  Locking either mutex or lock
+	 * is sufficient to ensure the list doesn't change; to change
+	 * the list you need to lock both the mutex and the spinlock.
+	 */
+	struct mutex			mutex;
+
+	struct list_head		pinned_groups;
+	struct list_head		flexible_groups;
+	struct list_head		event_list;
+	int				nr_events;
+	int				nr_active;
+	int				is_active;
+	int				nr_stat;
+	int				rotate_disable;
+	atomic_t			refcount;
+	struct task_struct		*task;
+
+	/*
+	 * Context clock, runs when context enabled.
+	 */
+	u64				time;
+	u64				timestamp;
+
+	/*
+	 * These fields let us detect when two contexts have both
+	 * been cloned (inherited) from a common ancestor.
+	 */
+	struct perf_event_context	*parent_ctx;
+	u64				parent_gen;
+	u64				generation;
+	int				pin_count;
+	struct rcu_head			rcu_head;
+	int				nr_cgroups; /* cgroup events present */
+};
+
+enum perf_event_task_context {
+	perf_invalid_context = -1,
+	perf_hw_context = 0,
+	perf_sw_context,
+	perf_nr_task_contexts,
+};
+
+/*-- sched.h, mm dirty state:  -----------*/
+
+struct prop_local_single {
+	/*
+	 * the local events counter
+	 */
+	unsigned long events;
+
+	/*
+	 * snapshot of the last seen global state
+	 * and a lock protecting this state
+	 */
+	unsigned long period;
+	int shift;
+	spinlock_t lock;		/* protect the snapshot state */
+};
+
+/*-- sched.h, task state:  -----------*/
+
+struct task_struct {
+	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
+	void *stack;
+	atomic_t usage;
+	unsigned int flags;	/* per process flags, defined below */
+	unsigned int ptrace;
+
+#ifdef CONFIG_SMP
+	struct task_struct *wake_entry;
+	int on_cpu;
+#endif
+	int on_rq;
+
+	int prio, static_prio, normal_prio;
+	unsigned int rt_priority;
+	const struct sched_class *sched_class;
+	struct sched_entity se;
+	struct sched_rt_entity rt;
+
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	/* list of struct preempt_notifier: */
+	struct hlist_head preempt_notifiers;
+#endif
+
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	unsigned int btrace_seq;
+#endif
+
+	unsigned int policy;
+	cpumask_t cpus_allowed;
+
+#ifdef CONFIG_PREEMPT_RCU
+	int rcu_read_lock_nesting;
+	char rcu_read_unlock_special;
+	struct list_head rcu_node_entry;
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	struct rcu_node *rcu_blocked_node;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rcu_boost_mutex;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+	struct sched_info sched_info;
+#endif
+
+	struct list_head tasks;
+#ifdef CONFIG_SMP
+	struct plist_node pushable_tasks;
+#endif
+
+	struct mm_struct *mm, *active_mm;
+#ifdef CONFIG_COMPAT_BRK
+	unsigned brk_randomized:1;
+#endif
+#if defined(SPLIT_RSS_COUNTING)
+	struct task_rss_stat	rss_stat;
+#endif
+/* task state */
+	int exit_state;
+	int exit_code, exit_signal;
+	int pdeath_signal;  /*  The signal sent when the parent dies  */
+	unsigned int group_stop;	/* GROUP_STOP_*, siglock protected */
+	/* ??? */
+	unsigned int personality;
+	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
+	unsigned in_iowait:1;
+
+
+	/* Revert to default priority/policy when forking */
+	unsigned sched_reset_on_fork:1;
+	unsigned sched_contributes_to_load:1;
+
+	pid_t pid;
+	pid_t tgid;
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/* Canary value for the -fstack-protector gcc feature */
+	unsigned long stack_canary;
+#endif
+
+	/* 
+	 * pointers to (original) parent process, youngest child, younger sibling,
+	 * older sibling, respectively.  (p->father can be replaced with 
+	 * p->real_parent->pid)
+	 */
+	struct task_struct *real_parent; /* real parent process */
+	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
+	/*
+	 * children/sibling forms the list of my natural children
+	 */
+	struct list_head children;	/* list of my children */
+	struct list_head sibling;	/* linkage in my parent's children list */
+	struct task_struct *group_leader;	/* threadgroup leader */
+
+	/*
+	 * ptraced is the list of tasks this task is using ptrace on.
+	 * This includes both natural children and PTRACE_ATTACH targets.
+	 * p->ptrace_entry is p's link on the p->parent->ptraced list.
+	 */
+	struct list_head ptraced;
+	struct list_head ptrace_entry;
+
+	/* PID/PID hash table linkage. */
+	struct pid_link pids[PIDTYPE_MAX];
+	struct list_head thread_group;
+
+	struct completion *vfork_done;		/* for vfork() */
+	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
+	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
+
+	cputime_t utime, stime, utimescaled, stimescaled;
+	cputime_t gtime;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	cputime_t prev_utime, prev_stime;
+#endif
+	unsigned long nvcsw, nivcsw; /* context switch counts */
+	struct timespec start_time; 		/* monotonic time */
+	struct timespec real_start_time;	/* boot based time */
+/* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
+	unsigned long min_flt, maj_flt;
+
+	struct task_cputime cputime_expires;
+	struct list_head cpu_timers[3];
+
+/* process credentials */
+	const struct cred __rcu *real_cred; /* objective and real subjective task
+					 * credentials (COW) */
+	const struct cred __rcu *cred;	/* effective (overridable) subjective task
+					 * credentials (COW) */
+	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
+
+	char comm[TASK_COMM_LEN]; /* executable name excluding path
+				     - access with [gs]et_task_comm (which lock
+				       it with task_lock())
+				     - initialized normally by setup_new_exec */
+/* file system info */
+	int link_count, total_link_count;
+#ifdef CONFIG_SYSVIPC
+/* ipc stuff */
+	struct sysv_sem sysvsem;
+#endif
+#ifdef CONFIG_DETECT_HUNG_TASK
+/* hung task detection */
+	unsigned long last_switch_count;
+#endif
+/* CPU-specific state of this task */
+	struct thread_struct thread;
+/* filesystem information */
+	struct fs_struct *fs;
+/* open file information */
+	struct files_struct *files;
+/* namespaces */
+	struct nsproxy *nsproxy;
+/* signal handlers */
+	struct signal_struct *signal;
+	struct sighand_struct *sighand;
+
+	sigset_t blocked, real_blocked;
+	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
+	struct sigpending pending;
+
+	unsigned long sas_ss_sp;
+	size_t sas_ss_size;
+	int (*notifier)(void *priv);
+	void *notifier_data;
+	sigset_t *notifier_mask;
+	struct audit_context *audit_context;
+#ifdef CONFIG_AUDITSYSCALL
+	uid_t loginuid;
+	unsigned int sessionid;
+#endif
+	seccomp_t seccomp;
+
+/* Thread group tracking */
+   	u32 parent_exec_id;
+   	u32 self_exec_id;
+/* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed,
+ * mempolicy */
+	spinlock_t alloc_lock;
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+	/* IRQ handler threads */
+	struct irqaction *irqaction;
+#endif
+
+	/* Protection of the PI data structures: */
+	raw_spinlock_t pi_lock;
+
+#ifdef CONFIG_RT_MUTEXES
+	/* PI waiters blocked on a rt_mutex held by this task */
+	struct plist_head pi_waiters;
+	/* Deadlock detection and priority inheritance handling */
+	struct rt_mutex_waiter *pi_blocked_on;
+#endif
+
+#ifdef CONFIG_DEBUG_MUTEXES
+	/* mutex deadlock detection */
+	struct mutex_waiter *blocked_on;
+#endif
+#ifdef CONFIG_TRACE_IRQFLAGS
+	unsigned int irq_events;
+	unsigned long hardirq_enable_ip;
+	unsigned long hardirq_disable_ip;
+	unsigned int hardirq_enable_event;
+	unsigned int hardirq_disable_event;
+	int hardirqs_enabled;
+	int hardirq_context;
+	unsigned long softirq_disable_ip;
+	unsigned long softirq_enable_ip;
+	unsigned int softirq_disable_event;
+	unsigned int softirq_enable_event;
+	int softirqs_enabled;
+	int softirq_context;
+#endif
+#ifdef CONFIG_LOCKDEP
+# define MAX_LOCK_DEPTH 48UL
+	u64 curr_chain_key;
+	int lockdep_depth;
+	unsigned int lockdep_recursion;
+	struct held_lock held_locks[MAX_LOCK_DEPTH];
+	gfp_t lockdep_reclaim_gfp;
+#endif
+
+/* journalling filesystem info */
+	void *journal_info;
+
+/* stacked block device info */
+	struct bio_list *bio_list;
+
+#ifdef CONFIG_BLOCK
+/* stack plugging */
+	struct blk_plug *plug;
+#endif
+
+/* VM state */
+	struct reclaim_state *reclaim_state;
+
+	struct backing_dev_info *backing_dev_info;
+
+	struct io_context *io_context;
+
+	unsigned long ptrace_message;
+	siginfo_t *last_siginfo; /* For ptrace use.  */
+	struct task_io_accounting ioac;
+#if defined(CONFIG_TASK_XACCT)
+	u64 acct_rss_mem1;	/* accumulated rss usage */
+	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
+	cputime_t acct_timexpd;	/* stime + utime since last update */
+#endif
+#ifdef CONFIG_CPUSETS
+	nodemask_t mems_allowed;	/* Protected by alloc_lock */
+	int mems_allowed_change_disable;
+	int cpuset_mem_spread_rotor;
+	int cpuset_slab_spread_rotor;
+#endif
+#ifdef CONFIG_CGROUPS
+	/* Control Group info protected by css_set_lock */
+	struct css_set __rcu *cgroups;
+	/* cg_list protected by css_set_lock and tsk->alloc_lock */
+	struct list_head cg_list;
+#endif
+#ifdef CONFIG_FUTEX
+	struct robust_list_head __user *robust_list;
+#ifdef CONFIG_COMPAT
+	struct compat_robust_list_head __user *compat_robust_list;
+#endif
+	struct list_head pi_state_list;
+	struct futex_pi_state *pi_state_cache;
+#endif
+#ifdef CONFIG_PERF_EVENTS
+	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
+	struct mutex perf_event_mutex;
+	struct list_head perf_event_list;
+#endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
+	short il_next;
+	short pref_node_fork;
+#endif
+	atomic_t fs_excl;	/* holding fs exclusive resources */
+	struct rcu_head rcu;
+
+	/*
+	 * cache last used pipe for splice
+	 */
+	struct pipe_inode_info *splice_pipe;
+#ifdef	CONFIG_TASK_DELAY_ACCT
+	struct task_delay_info *delays;
+#endif
+#ifdef CONFIG_FAULT_INJECTION
+	int make_it_fail;
+#endif
+	struct prop_local_single dirties;
+#ifdef CONFIG_LATENCYTOP
+	int latency_record_count;
+	struct latency_record latency_record[LT_SAVECOUNT];
+#endif
+	/*
+	 * time slack values; these are used to round up poll() and
+	 * select() etc timeout values. These are in nanoseconds.
+	 */
+	unsigned long timer_slack_ns;
+	unsigned long default_timer_slack_ns;
+
+	struct list_head	*scm_work_list;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* Index of current stored address in ret_stack */
+	int curr_ret_stack;
+	/* Stack of return addresses for return function tracing */
+	struct ftrace_ret_stack	*ret_stack;
+	/* time stamp for last schedule */
+	unsigned long long ftrace_timestamp;
+	/*
+	 * Number of functions that haven't been traced
+	 * because of depth overrun.
+	 */
+	atomic_t trace_overrun;
+	/* Pause for the tracing */
+	atomic_t tracing_graph_pause;
+#endif
+#ifdef CONFIG_TRACING
+	/* state flags for use by tracers */
+	unsigned long trace;
+	/* bitmask of trace recursion */
+	unsigned long trace_recursion;
+#endif /* CONFIG_TRACING */
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
+	struct memcg_batch_info {
+		int do_batch;	/* incremented when batch uncharge started */
+		struct mem_cgroup *memcg; /* target memcg of uncharge */
+		unsigned long nr_pages;	/* uncharged usage */
+		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
+	} memcg_batch;
+#endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_t ptrace_bp_refcnt;
+#endif
+};
+
+/*--  pid.c, PID type definitions:  -----------*/
+
+struct kref {
+	atomic_t refcount;
+};
+
+#define PAGE_SIZE 4096
+
+/*
+ * This controls the default maximum pid allocated to a process
+ */
+#define PID_MAX_DEFAULT (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)
+
+/*
+ * A maximum of 4 million PIDs should be enough for a while.
+ * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
+ */
+#define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
+	(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
+
+#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
+
+struct pidmap {
+       atomic_t nr_free;
+       void *page;
+};
+
+#define INIT_STRUCT_PID {						\
+	.count 		= ATOMIC_INIT(1),				\
+	.tasks		= {						\
+		{ .first = NULL },					\
+		{ .first = NULL },					\
+		{ .first = NULL },					\
+	},								\
+	.level		= 0,						\
+	.numbers	= { {						\
+		.nr		= 0,					\
+		.ns		= &init_pid_ns,				\
+		.pid_chain	= { .next = NULL, .pprev = NULL },	\
+	}, }								\
+}
+
+struct pid_namespace {
+	struct kref kref;
+	struct pidmap pidmap[PIDMAP_ENTRIES];
+	int last_pid;
+	struct task_struct *child_reaper;
+	struct kmem_cache *pid_cachep;
+	unsigned int level;
+	struct pid_namespace *parent;
+#ifdef CONFIG_PROC_FS
+	struct vfsmount *proc_mnt;
+#endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+	struct bsd_acct_struct *bacct;
+#endif
+};
+
+struct upid {
+	/* Try to keep pid_chain in the same cacheline as nr for find_vpid */
+	int nr;
+	struct pid_namespace *ns;
+	struct hlist_node pid_chain;
+};
+
+struct pid
+{
+	atomic_t count;
+	unsigned int level;
+	/* lists of tasks that use this pid */
+	struct hlist_head tasks[PIDTYPE_MAX];
+	struct rcu_head rcu;
+	struct upid numbers[1];
+};
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+extern struct pid_namespace init_pid_ns;
+
+extern struct task_struct init_task;
+
+/*-- module.h arch dependency: ---------------------------------------------------*/
+
+struct mod_arch_specific
+{
+};
+
+#ifdef CONFIG_64BIT
+#define Elf_Shdr Elf64_Shdr
+#define Elf_Sym Elf64_Sym
+#define Elf_Ehdr Elf64_Ehdr
+#else
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Ehdr Elf32_Ehdr
+#endif
+
+/*-- module.h ELF dependencies: ---------------------------------------------------*/
+
+
+/* 32-bit ELF base types. */
+typedef __u32	Elf32_Addr;
+typedef __u16	Elf32_Half;
+typedef __u32	Elf32_Off;
+typedef __s32	Elf32_Sword;
+typedef __u32	Elf32_Word;
+
+/* 64-bit ELF base types. */
+typedef __u64	Elf64_Addr;
+typedef __u16	Elf64_Half;
+typedef __s16	Elf64_SHalf;
+typedef __u64	Elf64_Off;
+typedef __s32	Elf64_Sword;
+typedef __u32	Elf64_Word;
+typedef __u64	Elf64_Xword;
+typedef __s64	Elf64_Sxword;
+
+typedef struct dynamic{
+  Elf32_Sword d_tag;
+  union{
+    Elf32_Sword	d_val;
+    Elf32_Addr	d_ptr;
+  } d_un;
+} Elf32_Dyn;
+
+typedef struct {
+  Elf64_Sxword d_tag;		/* entry tag value */
+  union {
+    Elf64_Xword d_val;
+    Elf64_Addr d_ptr;
+  } d_un;
+} Elf64_Dyn;
+
+/* The following are used with relocations */
+#define ELF32_R_SYM(x) ((x) >> 8)
+#define ELF32_R_TYPE(x) ((x) & 0xff)
+
+#define ELF64_R_SYM(i)			((i) >> 32)
+#define ELF64_R_TYPE(i)			((i) & 0xffffffff)
+
+typedef struct elf32_rel {
+  Elf32_Addr	r_offset;
+  Elf32_Word	r_info;
+} Elf32_Rel;
+
+typedef struct elf64_rel {
+  Elf64_Addr r_offset;	/* Location at which to apply the action */
+  Elf64_Xword r_info;	/* index and type of relocation */
+} Elf64_Rel;
+
+typedef struct elf32_rela{
+  Elf32_Addr	r_offset;
+  Elf32_Word	r_info;
+  Elf32_Sword	r_addend;
+} Elf32_Rela;
+
+typedef struct elf64_rela {
+  Elf64_Addr r_offset;	/* Location at which to apply the action */
+  Elf64_Xword r_info;	/* index and type of relocation */
+  Elf64_Sxword r_addend;	/* Constant addend used to compute value */
+} Elf64_Rela;
+
+typedef struct elf32_sym{
+  Elf32_Word	st_name;
+  Elf32_Addr	st_value;
+  Elf32_Word	st_size;
+  unsigned char	st_info;
+  unsigned char	st_other;
+  Elf32_Half	st_shndx;
+} Elf32_Sym;
+
+typedef struct elf64_sym {
+  Elf64_Word st_name;		/* Symbol name, index in string tbl */
+  unsigned char	st_info;	/* Type and binding attributes */
+  unsigned char	st_other;	/* No defined meaning, 0 */
+  Elf64_Half st_shndx;		/* Associated section index */
+  Elf64_Addr st_value;		/* Value of the symbol */
+  Elf64_Xword st_size;		/* Associated symbol size */
+} Elf64_Sym;
+
+
+/*-- module.h sysfs dependencies: ---------------------------------------------------*/
+
+struct attribute {
+	const char		*name;
+	mode_t			mode;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key	*key;
+	struct lock_class_key	skey;
+#endif
+};
+
+struct kobject {
+	const char		*name;
+	struct list_head	entry;
+	struct kobject		*parent;
+	struct kset		*kset;
+	struct kobj_type	*ktype;
+	struct sysfs_dirent	*sd;
+	struct kref		kref;
+	unsigned int state_initialized:1;
+	unsigned int state_in_sysfs:1;
+	unsigned int state_add_uevent_sent:1;
+	unsigned int state_remove_uevent_sent:1;
+	unsigned int uevent_suppress:1;
+};
+
+/*-- module.h's init.h dependency: -------------------------------*/
+
+typedef void (*ctor_fn_t)(void);
+
+/*-- module.h: ---------------------------------------------------*/
+
+/* You can override this manually, but generally this should match the
+   module name. */
+#ifdef MODULE
+#define MODULE_PARAM_PREFIX /* empty */
+#else
+#define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
+#endif
+
+/* Chosen so that structs with an unsigned long line up. */
+#define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
+
+#define ___module_cat(a,b) __mod_ ## a ## b
+#define __module_cat(a,b) ___module_cat(a,b)
+#ifdef MODULE
+#define __MODULE_INFO(tag, name, info)					  \
+static const char __module_cat(name,__LINE__)[]				  \
+  __used __attribute__((section(".modinfo"), unused, aligned(1)))	  \
+  = __stringify(tag) "=" info
+#else  /* !MODULE */
+/* This struct is here for syntactic coherency, it is not used */
+#define __MODULE_INFO(tag, name, info)					  \
+  struct __module_cat(name,__LINE__) {}
+#endif
+#define __MODULE_PARM_TYPE(name, _type)					  \
+  __MODULE_INFO(parmtype, name##type, #name ":" _type)
+
+struct kernel_param;
+
+struct kernel_param_ops {
+	/* Returns 0, or -errno.  arg is in kp->arg. */
+	int (*set)(const char *val, const struct kernel_param *kp);
+	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
+	int (*get)(char *buffer, const struct kernel_param *kp);
+	/* Optional function to free kp->arg when module unloaded. */
+	void (*free)(void *arg);
+};
+
+/* Flag bits for kernel_param.flags */
+#define KPARAM_ISBOOL		2
+
+struct kernel_param {
+	const char *name;
+	const struct kernel_param_ops *ops;
+	u16 perm;
+	u16 flags;
+	union {
+		void *arg;
+		const struct kparam_string *str;
+		const struct kparam_array *arr;
+	};
+};
+
+/* Special one for strings we want to copy into */
+struct kparam_string {
+	unsigned int maxlen;
+	char *string;
+};
+
+/* Special one for arrays */
+struct kparam_array
+{
+	unsigned int max;
+	unsigned int elemsize;
+	unsigned int *num;
+	const struct kernel_param_ops *ops;
+	void *elem;
+};
+
+/* Some toolchains use a `_' prefix for all user symbols. */
+#ifdef CONFIG_SYMBOL_PREFIX
+#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define MODULE_SYMBOL_PREFIX ""
+#endif
+
+#define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
+
+struct kernel_symbol
+{
+	unsigned long value;
+	const char *name;
+};
+
+struct modversion_info
+{
+	unsigned long crc;
+	char name[MODULE_NAME_LEN];
+};
+
+struct module;
+
+struct module_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct module_attribute *, struct module *, char *);
+        ssize_t (*store)(struct module_attribute *, struct module *,
+			 const char *, size_t count);
+	void (*setup)(struct module *, const char *);
+	int (*test)(struct module *);
+	void (*free)(struct module *);
+};
+
+struct module_version_attribute {
+	struct module_attribute mattr;
+	const char *module_name;
+	const char *version;
+} __attribute__ ((__aligned__(sizeof(void *))));
+
+extern ssize_t __modver_version_show(struct module_attribute *,
+				     struct module *, char *);
+
+struct module_kobject
+{
+	struct kobject kobj;
+	struct module *mod;
+	struct kobject *drivers_dir;
+	struct module_param_attrs *mp;
+};
+
+/* These are either module local, or the kernel's dummy ones. */
+extern int init_module(void);
+extern void cleanup_module(void);
+
+/* Archs provide a method of finding the correct exception table. */
+struct exception_table_entry;
+
+const struct exception_table_entry *
+search_extable(const struct exception_table_entry *first,
+	       const struct exception_table_entry *last,
+	       unsigned long value);
+void sort_extable(struct exception_table_entry *start,
+		  struct exception_table_entry *finish);
+void sort_main_extable(void);
+void trim_init_extable(struct module *m);
+
+#ifdef MODULE
+#define MODULE_GENERIC_TABLE(gtype,name)			\
+extern const struct gtype##_id __mod_##gtype##_table		\
+  __attribute__ ((unused, alias(__stringify(name))))
+
+extern struct module __this_module;
+#define THIS_MODULE (&__this_module)
+#else  /* !MODULE */
+#define MODULE_GENERIC_TABLE(gtype,name)
+#define THIS_MODULE ((struct module *)0)
+#endif
+
+/* Generic info of form tag = "info" */
+#define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
+
+/* For userspace: you can also call me... */
+#define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
+
+/*
+ * The following license idents are currently accepted as indicating free
+ * software modules
+ *
+ *	"GPL"				[GNU Public License v2 or later]
+ *	"GPL v2"			[GNU Public License v2]
+ *	"GPL and additional rights"	[GNU Public License v2 rights and more]
+ *	"Dual BSD/GPL"			[GNU Public License v2
+ *					 or BSD license choice]
+ *	"Dual MIT/GPL"			[GNU Public License v2
+ *					 or MIT license choice]
+ *	"Dual MPL/GPL"			[GNU Public License v2
+ *					 or Mozilla license choice]
+ *
+ * The following other idents are available
+ *
+ *	"Proprietary"			[Non free products]
+ *
+ * There are dual licensed components, but when running with Linux it is the
+ * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
+ * is a GPL combined work.
+ *
+ * This exists for several reasons
+ * 1.	So modinfo can show license info for users wanting to vet their setup 
+ *	is free
+ * 2.	So the community can ignore bug reports including proprietary modules
+ * 3.	So vendors can do likewise based on their own policies
+ */
+#define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
+
+/*
+ * Author(s), use "Name <email>" or just "Name", for multiple
+ * authors use multiple MODULE_AUTHOR() statements/lines.
+ */
+#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
+  
+/* What your module does. */
+#define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
+
+/* One for each parameter, describing how to use it.  Some files do
+   multiple of these per line, so can't just use MODULE_INFO. */
+#define MODULE_PARM_DESC(_parm, desc) \
+	__MODULE_INFO(parm, _parm, #_parm ":" desc)
+
+#define MODULE_DEVICE_TABLE(type,name)		\
+  MODULE_GENERIC_TABLE(type##_device,name)
+
+/* Version of form [<epoch>:]<version>[-<extra-version>].
+   Or for CVS/RCS ID version, everything but the number is stripped.
+  <epoch>: A (small) unsigned integer which allows you to start versions
+           anew. If not mentioned, it's zero.  eg. "2:1.0" is after
+	   "1:2.0".
+  <version>: The <version> may contain only alphanumerics and the
+           character `.'.  Ordered by numeric sort for numeric parts,
+	   ascii sort for ascii parts (as per RPM or DEB algorithm).
+  <extraversion>: Like <version>, but inserted for local
+           customizations, eg "rh3" or "rusty1".
+
+  Using this automatically adds a checksum of the .c files and the
+  local headers in "srcversion".
+*/
+
+#if defined(MODULE) || !defined(CONFIG_SYSFS)
+#define MODULE_VERSION(_version) MODULE_INFO(version, _version)
+#else
+#define MODULE_VERSION(_version)					\
+	static struct module_version_attribute ___modver_attr = {	\
+		.mattr	= {						\
+			.attr	= {					\
+				.name	= "version",			\
+				.mode	= S_IRUGO,			\
+			},						\
+			.show	= __modver_version_show,		\
+		},							\
+		.module_name	= KBUILD_MODNAME,			\
+		.version	= _version,				\
+	};								\
+	static const struct module_version_attribute			\
+	__used __attribute__ ((__section__ ("__modver")))		\
+	* __moduleparam_const __modver_attr = &___modver_attr
+#endif
+
+/* Optional firmware file (or files) needed by the module
+ * format is simply firmware file name.  Multiple firmware
+ * files require multiple MODULE_FIRMWARE() specifiers */
+#define MODULE_FIRMWARE(_firmware) MODULE_INFO(firmware, _firmware)
+
+/* Given an address, look for it in the exception tables */
+const struct exception_table_entry *search_exception_tables(unsigned long add);
+
+struct notifier_block;
+
+extern int modules_disabled; /* for sysctl */
+/* Get/put a kernel symbol (calls must be symmetric) */
+void *__symbol_get(const char *symbol);
+void *__symbol_get_gpl(const char *symbol);
+#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x)))
+
+/* modules using other modules: kdb wants to see this. */
+struct module_use {
+	struct list_head source_list;
+	struct list_head target_list;
+	struct module *source, *target;
+};
+
+#ifndef __GENKSYMS__
+#ifdef CONFIG_MODVERSIONS
+/* Mark the CRC weak since genksyms apparently decides not to
+ * generate a checksums for some symbols */
+#define __CRC_SYMBOL(sym, sec)					\
+	extern void *__crc_##sym __attribute__((weak));		\
+	static const unsigned long __kcrctab_##sym		\
+	__used							\
+	__attribute__((section("___kcrctab" sec "+" #sym), unused))	\
+	= (unsigned long) &__crc_##sym;
+#else
+#define __CRC_SYMBOL(sym, sec)
+#endif
+
+/* For every exported symbol, place a struct in the __ksymtab section */
+#define __EXPORT_SYMBOL(sym, sec)				\
+	extern typeof(sym) sym;					\
+	__CRC_SYMBOL(sym, sec)					\
+	static const char __kstrtab_##sym[]			\
+	__attribute__((section("__ksymtab_strings"), aligned(1))) \
+	= MODULE_SYMBOL_PREFIX #sym;                    	\
+	static const struct kernel_symbol __ksymtab_##sym	\
+	__used							\
+	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
+	= { (unsigned long)&sym, __kstrtab_##sym }
+
+#define EXPORT_SYMBOL(sym)					\
+	__EXPORT_SYMBOL(sym, "")
+
+#define EXPORT_SYMBOL_GPL(sym)					\
+	__EXPORT_SYMBOL(sym, "_gpl")
+
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
+	__EXPORT_SYMBOL(sym, "_gpl_future")
+
+
+#ifdef CONFIG_UNUSED_SYMBOLS
+#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
+#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
+#else
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+#endif
+
+#endif
+
+enum module_state
+{
+	MODULE_STATE_LIVE,
+	MODULE_STATE_COMING,
+	MODULE_STATE_GOING,
+};
+
+struct module
+{
+	enum module_state state;
+
+	/* Member of list of modules */
+	struct list_head list;
+
+	/* Unique handle for this module */
+	char name[MODULE_NAME_LEN];
+
+	/* Sysfs stuff. */
+	struct module_kobject mkobj;
+	struct module_attribute *modinfo_attrs;
+	const char *version;
+	const char *srcversion;
+	struct kobject *holders_dir;
+
+	/* Exported symbols */
+	const struct kernel_symbol *syms;
+	const unsigned long *crcs;
+	unsigned int num_syms;
+
+	/* Kernel parameters. */
+	struct kernel_param *kp;
+	unsigned int num_kp;
+
+	/* GPL-only exported symbols. */
+	unsigned int num_gpl_syms;
+	const struct kernel_symbol *gpl_syms;
+	const unsigned long *gpl_crcs;
+
+#ifdef CONFIG_UNUSED_SYMBOLS
+	/* unused exported symbols. */
+	const struct kernel_symbol *unused_syms;
+	const unsigned long *unused_crcs;
+	unsigned int num_unused_syms;
+
+	/* GPL-only, unused exported symbols. */
+	unsigned int num_unused_gpl_syms;
+	const struct kernel_symbol *unused_gpl_syms;
+	const unsigned long *unused_gpl_crcs;
+#endif
+
+	/* symbols that will be GPL-only in the near future. */
+	const struct kernel_symbol *gpl_future_syms;
+	const unsigned long *gpl_future_crcs;
+	unsigned int num_gpl_future_syms;
+
+	/* Exception table */
+	unsigned int num_exentries;
+	struct exception_table_entry *extable;
+
+	/* Startup function. */
+	int (*init)(void);
+
+	/* If this is non-NULL, vfree after init() returns */
+	void *module_init;
+
+	/* Here is the actual code + data, vfree'd on unload. */
+	void *module_core;
+
+	/* Here are the sizes of the init and core sections */
+	unsigned int init_size, core_size;
+
+	/* The size of the executable code in each section.  */
+	unsigned int init_text_size, core_text_size;
+
+	/* Size of RO sections of the module (text+rodata) */
+	unsigned int init_ro_size, core_ro_size;
+
+	/* Arch-specific module values */
+	struct mod_arch_specific arch;
+
+	unsigned int taints;	/* same bits as kernel:tainted */
+
+#ifdef CONFIG_GENERIC_BUG
+	/* Support for BUG */
+	unsigned num_bugs;
+	struct list_head bug_list;
+	struct bug_entry *bug_table;
+#endif
+
+#ifdef CONFIG_KALLSYMS
+	/*
+	 * We keep the symbol and string tables for kallsyms.
+	 * The core_* fields below are temporary, loader-only (they
+	 * could really be discarded after module init).
+	 */
+	Elf_Sym *symtab, *core_symtab;
+	unsigned int num_symtab, core_num_syms;
+	char *strtab, *core_strtab;
+
+	/* Section attributes */
+	struct module_sect_attrs *sect_attrs;
+
+	/* Notes attributes */
+	struct module_notes_attrs *notes_attrs;
+#endif
+
+	/* The command line arguments (may be mangled).  People like
+	   keeping pointers to this stuff */
+	char *args;
+
+#ifdef CONFIG_SMP
+	/* Per-cpu data. */
+	void __percpu *percpu;
+	unsigned int percpu_size;
+#endif
+
+#ifdef CONFIG_TRACEPOINTS
+	unsigned int num_tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
+#endif
+#ifdef HAVE_JUMP_LABEL
+	struct jump_entry *jump_entries;
+	unsigned int num_jump_entries;
+#endif
+#ifdef CONFIG_TRACING
+	unsigned int num_trace_bprintk_fmt;
+	const char **trace_bprintk_fmt_start;
+#endif
+#ifdef CONFIG_EVENT_TRACING
+	struct ftrace_event_call **trace_events;
+	unsigned int num_trace_events;
+#endif
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+	unsigned int num_ftrace_callsites;
+	unsigned long *ftrace_callsites;
+#endif
+
+#ifdef CONFIG_MODULE_UNLOAD
+	/* What modules depend on me? */
+	struct list_head source_list;
+	/* What modules do I depend on? */
+	struct list_head target_list;
+
+	/* Who is waiting for us to be unloaded */
+	struct task_struct *waiter;
+
+	/* Destruction function. */
+	void (*exit)(void);
+
+	struct module_ref {
+		unsigned int incs;
+		unsigned int decs;
+	} __percpu *refptr;
+#endif
+
+#ifdef CONFIG_CONSTRUCTORS
+	/* Constructor functions. */
+	ctor_fn_t *ctors;
+	unsigned int num_ctors;
+#endif
+};
+
+/*-- pid.c API usage: ---------------------------------------------------*/
+/*-- preempt.h thread_info dependencies: --------------------------------*/
+/*-- preempt.h thread_info processor.h dependencies: --------------------*/
+
+typedef struct {
+	unsigned long		seg;
+} mm_segment_t;
+
+/*-- preempt.h linux/thread_info.h dependencies: --------------------*/
+
+struct timespec;
+struct compat_timespec;
+
+/*
+ * System call restart block.
+ */
+struct restart_block {
+	long (*fn)(struct restart_block *);
+	union {
+		/* For futex_wait and futex_wait_requeue_pi */
+		struct {
+			u32 __user *uaddr;
+			u32 val;
+			u32 flags;
+			u32 bitset;
+			u64 time;
+			u32 __user *uaddr2;
+		} futex;
+		/* For nanosleep */
+		struct {
+			clockid_t index;
+			struct timespec __user *rmtp;
+#ifdef CONFIG_COMPAT
+			struct compat_timespec __user *compat_rmtp;
+#endif
+			u64 expires;
+		} nanosleep;
+		/* For poll */
+		struct {
+			struct pollfd __user *ufds;
+			int nfds;
+			int has_timeout;
+			unsigned long tv_sec;
+			unsigned long tv_nsec;
+		} poll;
+	};
+};
+
+/*-- preempt.h asm/thread_info.h page_types.h dependencies: --------------------*/
+
+#define THREAD_ORDER    1
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+
+/*-- preempt.h asm/thread_info.h dependencies: --------------------*/
+
+struct task_struct;
+struct exec_domain;
+
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	__u32			flags;		/* low level flags */
+	__u32			status;		/* thread synchronous flags */
+	__u32			cpu;		/* current CPU */
+	int			preempt_count;	/* 0 => preemptable,
+						   <0 => BUG */
+	mm_segment_t		addr_limit;
+	struct restart_block    restart_block;
+	void __user		*sysenter_return;
+#ifdef CONFIG_X86_32
+	unsigned long           previous_esp;   /* ESP of the previous stack in
+						   case of nested (IRQ) stacks
+						*/
+	__u8			supervisor_stack[0];
+#endif
+	int			uaccess_err;
+};
+
+/* how to get the current stack pointer from C */
+register unsigned long current_stack_pointer asm("esp") __used;
+
+/* how to get the thread information struct from C */
+static inline struct thread_info *current_thread_info(void)
+{
+	return (struct thread_info *)
+		(current_stack_pointer & ~(THREAD_SIZE - 1));
+}
+
+#define TIF_NEED_RESCHED        3       /* rescheduling necessary */
+
+/*-- preempt.h linux/thread_info.h bitops.h dependencies (simplfied): --------------------*/
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
+}
+
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+}
+
+/*-- preempt.h linux/thread_info.h dependencies: --------------------*/
+
+static inline void set_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	set_bit(flag, (unsigned long *)&ti->flags);
+}
+
+static inline void clear_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	clear_bit(flag, (unsigned long *)&ti->flags);
+}
+
+static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	return test_bit(flag, (unsigned long *)&ti->flags);
+}
+
+#define set_thread_flag(flag) \
+	set_ti_thread_flag(current_thread_info(), flag)
+#define clear_thread_flag(flag) \
+	clear_ti_thread_flag(current_thread_info(), flag)
+#define test_and_set_thread_flag(flag) \
+	test_and_set_ti_thread_flag(current_thread_info(), flag)
+#define test_and_clear_thread_flag(flag) \
+	test_and_clear_ti_thread_flag(current_thread_info(), flag)
+#define test_thread_flag(flag) \
+	test_ti_thread_flag(current_thread_info(), flag)
+
+/*-- rcu API preempt.h dependencies: ---------------------------------------------------*/
+
+void preempt_schedule(void);
+
+#define preempt_disable() \
+do { \
+	inc_preempt_count(); \
+	barrier(); \
+} while (0)
+
+#define preempt_enable_no_resched() \
+do { \
+	barrier(); \
+	dec_preempt_count(); \
+} while (0)
+
+#define preempt_check_resched() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule(); \
+} while (0)
+
+#define preempt_enable() \
+do { \
+	preempt_enable_no_resched(); \
+	barrier(); \
+	preempt_check_resched(); \
+} while (0)
+
+# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
+# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+
+#define inc_preempt_count() add_preempt_count(1)
+#define dec_preempt_count() sub_preempt_count(1)
+
+#define preempt_count()	(current_thread_info()->preempt_count)
+
+static inline void __rcu_read_lock(void)
+{
+	preempt_disable();
+}
+
+static inline void __rcu_read_unlock(void)
+{
+	preempt_enable();
+}
+
+static inline void rcu_read_lock(void)
+{
+	__rcu_read_lock();
+	__acquire(RCU);
+}
+
+static inline void rcu_read_unlock(void)
+{
+	__release(RCU);
+	__rcu_read_unlock();
+}
+
+/*-- pid.c sched.h API usage: ---------------------------------------------------*/
+
+static inline struct pid *task_pid(struct task_struct *task)
+{
+	return task->pids[PIDTYPE_PID].pid;
+}
+
+/*-- pid.c cache.h API usage: ---------------------------------------------------*/
+
+#define SMP_CACHE_BYTES 32
+
+#ifndef __cacheline_aligned
+#define __cacheline_aligned					\
+  __attribute__((__aligned__(SMP_CACHE_BYTES),			\
+		 __section__(".data..cacheline_aligned")))
+#endif /* __cacheline_aligned */
+
+#ifndef __cacheline_aligned_in_smp
+#ifdef CONFIG_SMP
+#define __cacheline_aligned_in_smp __cacheline_aligned
+#else
+#define __cacheline_aligned_in_smp
+#endif /* CONFIG_SMP */
+#endif
+
+/*-- pid.c spinlock.h API usage: ---------------------------------------------------*/
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+
+#define __SPIN_LOCK_INITIALIZER(lockname) \
+	{ { .rlock = __RAW_SPIN_LOCK_INITIALIZER(lockname) } }
+
+#define __SPIN_LOCK_UNLOCKED(lockname) \
+	(spinlock_t ) __SPIN_LOCK_INITIALIZER(lockname)
+
+#define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
+
+/*-- pid.c atomic.h API usage: ---------------------------------------------------*/
+
+#define LOCK_PREFIX "lock;"
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.
+ */
+static inline int atomic_read(const atomic_t *v)
+{
+	return (*(volatile int *)&(v)->counter);
+}
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
+
+/**
+ * atomic_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic_add(int i, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "subl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic_sub_and_test(int i, atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic_inc(atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "incl %0"
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic_dec(atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "decl %0"
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec_and_test - decrement and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic_dec_and_test(atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
+	return c != 0;
+}
+
+/*-- pid.c hash.h API usage: ---------------------------------------------------*/
+
+/* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
+#define GOLDEN_RATIO_PRIME_32 0x9e370001UL
+/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
+#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL
+
+#if BITS_PER_LONG == 32
+#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_32
+#define hash_long(val, bits) hash_32(val, bits)
+#elif BITS_PER_LONG == 64
+#define hash_long(val, bits) hash_64(val, bits)
+#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_64
+#else
+#error Wordsize not 32 or 64
+#endif
+
+static inline u64 hash_64(u64 val, unsigned int bits)
+{
+	u64 hash = val;
+
+	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
+	u64 n = hash;
+	n <<= 18;
+	hash -= n;
+	n <<= 33;
+	hash -= n;
+	n <<= 3;
+	hash += n;
+	n <<= 3;
+	hash -= n;
+	n <<= 4;
+	hash += n;
+	n <<= 2;
+	hash += n;
+
+	/* High bits are more random, so use them. */
+	return hash >> (64 - bits);
+}
+
+static inline u32 hash_32(u32 val, unsigned int bits)
+{
+	/* On some cpus multiply is faster, on others gcc will do shifts */
+	u32 hash = val * GOLDEN_RATIO_PRIME_32;
+
+	/* High bits are more random, so use them. */
+	return hash >> (32 - bits);
+}
+
+static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
+{
+	return hash_long((unsigned long)ptr, bits);
+}
+
+/*-- pid.c API (some of them nasty hacks/shortcuts): ----------------------------------------------*/
+
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+extern void call_rcu(struct rcu_head *head,
+                              void (*func)(struct rcu_head *head));
+#define cmpxchg(ptr, old, new) ({ new; })
+
+extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
+		size, unsigned long offset);
+
+extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
+		long size, unsigned long offset);
+
+extern unsigned long find_first_bit(const unsigned long *addr,
+				    unsigned long size);
+
+extern unsigned long find_first_zero_bit(const unsigned long *addr,
+					 unsigned long size);
+
+#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
+#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
+
+static inline struct pid *get_pid(struct pid *pid)
+{
+	if (pid)
+		atomic_inc(&pid->count);
+	return pid;
+}
+
+extern void kref_get(struct kref *kref);
+
+static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
+{
+	if (ns != &init_pid_ns)
+		kref_get(&ns->kref);
+	return ns;
+}
+
+#define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0)
+
+extern void hlist_add_head_rcu(struct hlist_node *n, struct hlist_head *h);
+extern void hlist_del_rcu(struct hlist_node *n);
+extern void *kzalloc(size_t size, gfp_t flags);
+extern void *kfree(void *ptr);
+
+#define GFP_KERNEL 1
+
+void kmem_cache_free(struct kmem_cache *, void *);
+void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
+
+#define lockdep_tasklist_lock_is_held() do { } while (0)
+
+static inline void put_pid_ns(struct pid_namespace *ns) { }
+
+#define rcu_dereference_raw(x) x
+#define rcu_dereference_check(x, y) x
+#define hlist_first_rcu(head)	(*((struct hlist_node __rcu **)(&(head)->first)))
+
+
+#define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
+
+static inline void INIT_HLIST_NODE(struct hlist_node *h)
+{
+	h->next = NULL;
+	h->pprev = NULL;
+}
+
+static inline int hlist_unhashed(const struct hlist_node *h)
+{
+	return !h->pprev;
+}
+
+static inline int hlist_empty(const struct hlist_head *h)
+{
+	return !h->first;
+}
+
+static inline void __hlist_del(struct hlist_node *n)
+{
+	struct hlist_node *next = n->next;
+	struct hlist_node **pprev = n->pprev;
+	*pprev = next;
+	if (next)
+		next->pprev = pprev;
+}
+
+static inline void hlist_del(struct hlist_node *n)
+{
+	__hlist_del(n);
+}
+
+static inline void hlist_del_init(struct hlist_node *n)
+{
+	if (!hlist_unhashed(n)) {
+		__hlist_del(n);
+		INIT_HLIST_NODE(n);
+	}
+}
+
+#define hlist_entry(ptr, type, member) container_of(ptr,type,member)
+#define hlist_next_rcu(node)	(*((struct hlist_node __rcu **)(&(node)->next)))
+
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		\
+	for (pos = rcu_dereference_raw(hlist_first_rcu(head));		\
+		pos &&							 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+		pos = rcu_dereference_raw(hlist_next_rcu(pos)))
+
+extern struct task_struct *current;
+
+static __always_inline int test_and_set_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+}
+
+
+extern void spin_lock_irq(spinlock_t *lock);
+extern void spin_lock_irqsave(spinlock_t *lock, unsigned long flags);
+extern void spin_unlock_irq(spinlock_t *lock);
+extern void spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags);
+
+struct mnt_namespace;
+struct uts_namespace;
+struct ipc_namespace;
+struct pid_namespace;
+struct fs_struct;
+
+/*
+ * A structure to contain pointers to all per-process
+ * namespaces - fs (mount), uts, network, sysvipc, etc.
+ *
+ * 'count' is the number of tasks holding a reference.
+ * The count for each namespace, then, will be the number
+ * of nsproxies pointing to it, not the number of tasks.
+ *
+ * The nsproxy is shared by tasks which share all namespaces.
+ * As soon as a single namespace is cloned or unshared, the
+ * nsproxy is copied.
+ */
+struct nsproxy {
+	atomic_t count;
+	struct uts_namespace *uts_ns;
+	struct ipc_namespace *ipc_ns;
+	struct mnt_namespace *mnt_ns;
+	struct pid_namespace *pid_ns;
+	struct net 	     *net_ns;
+};
+
+static inline struct pid_namespace *ns_of_pid(struct pid *pid)
+{
+	struct pid_namespace *ns = NULL;
+	if (pid)
+		ns = pid->numbers[pid->level].ns;
+	return ns;
+}
+
+#define rcu_lockdep_assert(x)
+#define rcu_read_lock_held() 0
+
+#define pid_alive(x) 1
+
+extern void hlist_replace_rcu(struct hlist_node *old, struct hlist_node *new);
+
+static inline struct pid *task_tgid(struct task_struct *task)
+{
+	return task->group_leader->pids[PIDTYPE_PID].pid;
+}
+
+#define __init
+
+extern void *alloc_large_system_hash(const char *tablename,
+				     unsigned long bucketsize,
+				     unsigned long numentries,
+				     int scale,
+				     int flags,
+				     unsigned int *_hash_shift,
+				     unsigned int *_hash_mask,
+				     unsigned long limit);
+
+#define HASH_EARLY	0x00000001	/* Allocating during early boot? */
+#define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min */
+
+
+/*
+ * min()/max()/clamp() macros that also do
+ * strict type-checking.. See the
+ * "unnecessary" pointer comparison.
+ */
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+#define min3(x, y, z) ({			\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	typeof(z) _min3 = (z);			\
+	(void) (&_min1 == &_min2);		\
+	(void) (&_min1 == &_min3);		\
+	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
+		(_min2 < _min3 ? _min2 : _min3); })
+
+#define max3(x, y, z) ({			\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	typeof(z) _max3 = (z);			\
+	(void) (&_max1 == &_max2);		\
+	(void) (&_max1 == &_max3);		\
+	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
+		(_max2 > _max3 ? _max2 : _max3); })
+
+/**
+ * min_not_zero - return the minimum that is _not_ zero, unless both are zero
+ * @x: value1
+ * @y: value2
+ */
+#define min_not_zero(x, y) ({			\
+	typeof(x) __x = (x);			\
+	typeof(y) __y = (y);			\
+	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
+
+/**
+ * clamp - return a value clamped to a given range with strict typechecking
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does strict typechecking of min/max to make sure they are of the
+ * same type as val.  See the unnecessary pointer comparisons.
+ */
+#define clamp(val, min, max) ({			\
+	typeof(val) __val = (val);		\
+	typeof(min) __min = (min);		\
+	typeof(max) __max = (max);		\
+	(void) (&__val == &__min);		\
+	(void) (&__val == &__max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
+
+/*
+ * ..and if you can't take the strict
+ * types, you can specify one yourself.
+ *
+ * Or not use min/max/clamp at all, of course.
+ */
+#define min_t(type, x, y) ({			\
+	type __min1 = (x);			\
+	type __min2 = (y);			\
+	__min1 < __min2 ? __min1: __min2; })
+
+#define max_t(type, x, y) ({			\
+	type __max1 = (x);			\
+	type __max2 = (y);			\
+	__max1 > __max2 ? __max1: __max2; })
+
+/**
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * 'type' to make all the comparisons.
+ */
+#define clamp_t(type, val, min, max) ({		\
+	type __val = (val);			\
+	type __min = (min);			\
+	type __max = (max);			\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
+
+/**
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument 'val' is.  This is useful when val is an unsigned
+ * type and min and max are literals that will otherwise be assigned a signed
+ * integer type.
+ */
+#define clamp_val(val, min, max) ({		\
+	typeof(val) __val = (val);		\
+	typeof(val) __min = (min);		\
+	typeof(val) __max = (max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
+
+#define PIDS_PER_CPU_DEFAULT	1024
+#define PIDS_PER_CPU_MIN	8
+
+extern const struct cpumask *const cpu_possible_mask;
+
+#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+#define cpumask_bits(maskp) ((maskp)->bits)
+
+extern int bitmap_weight(const unsigned long *bitmap, int bits);
+
+#define nr_cpumask_bits	NR_CPUS
+
+static inline unsigned int cpumask_weight(const struct cpumask *srcp)
+{
+	return bitmap_weight(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+int eprintf(int level,
+	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+
+#define pr_fmt(fmt) fmt
+
+#define pr_info(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+
+#define KMEM_CACHE(__struct, __flags) kmem_cache_create(#__struct,\
+		sizeof(struct __struct), __alignof__(struct __struct),\
+		(__flags), NULL)
+
+struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
+			unsigned long,
+			void (*)(void *));
+void kmem_cache_destroy(struct kmem_cache *);
+
+#define SLAB_HWCACHE_ALIGN 32
+
+#define SLAB_PANIC 1
+
+/*-- pid.c C code: ---------------------------------------------------*/
 
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
@@ -264,7 +2700,7 @@ void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
 	int i;
-	unsigned long flags;
+	unsigned long flags = 0;
 
 	spin_lock_irqsave(&pidmap_lock, flags);
 	for (i = 0; i <= pid->level; i++)
