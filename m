Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2GWVP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:15:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37152 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab2GWVPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:15:54 -0400
Date: Mon, 23 Jul 2012 14:15:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 4/7] softirq: Use hotplug thread infrastructure
Message-ID: <20120723211521.GA7586@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
 <20120716103948.456416747@linutronix.de>
 <20120721172151.GB6698@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120721172151.GB6698@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072321-7182-0000-0000-0000020F6466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 10:21:51AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 16, 2012 at 10:42:37AM -0000, Thomas Gleixner wrote:
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  kernel/softirq.c |  107 +++++++++++++------------------------------------------
> >  1 file changed, 26 insertions(+), 81 deletions(-)

[ . . . ]

> Again, I also placed the updated series on -rcu at branch rcu/smp/hotplug
> (git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git),
> based on tip/smp/hotplug, for Linaro testing purposes.
> 
> With these two changes, this series merged with Tejun's workqueue
> hotplug changes merged with my -rcu tree passed moderate rcutorture
> and hotplug testing, with the exception of some apparently unrelated
> build problems in UP configuration:
> 
> warning: call to ‘copy_from_user_overflow’ declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default
> 
> I have a fix for an earlier occurrence of this problem that I will try next.

And the fix worked, but uncovered a !SMP build problem in the underlying
patchset.  I fixed this with the following patch, which is also available
as noted above.

							Thanx, Paul

------------------------------------------------------------------------

 Makefile  |    3 +--
 smpboot.c |    4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

hotplug: Fix UP bug in smpboot hotplug code

Because kernel subsystems need their per-CPU kthreads on UP systems
as well as on SMP systems, the smpboot hotplug kthread functions
must be provided in UP builds as well as in SMP builds.  This commit
therefore adds smpboot.c to UP builds and excludes irrelevant code
via #ifdef.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/Makefile b/kernel/Makefile
index c0cc67a..e5602d3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o lglock.o
+	    async.o range.o groups.o lglock.o smpboot.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
@@ -46,7 +46,6 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
-obj-$(CONFIG_SMP) += smpboot.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index b2545c8..0a49ee7 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -15,6 +15,8 @@
 
 #include "smpboot.h"
 
+#ifdef CONFIG_SMP
+
 #ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
 /*
  * For the hotplug case we keep the task structs around and reuse
@@ -72,6 +74,8 @@ void __init idle_threads_init(void)
 }
 #endif
 
+#endif /* #ifdef CONFIG_SMP */
+
 static LIST_HEAD(hotplug_threads);
 static DEFINE_MUTEX(smpboot_threads_lock);
 

