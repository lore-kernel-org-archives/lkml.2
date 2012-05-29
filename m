Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2E2SuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:50:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50602 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab2E2SuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:50:24 -0400
Date: Tue, 29 May 2012 13:50:15 -0500
From: Russ Anderson <rja@sgi.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rja@americas.sgi.com
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on multi-processor systems
Message-ID: <20120529185015.GA29726@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20120524144229.GA27713@sgi.com> <20120524153409.GM1663@somewhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524153409.GM1663@somewhere>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:34:13PM +0200, Frederic Weisbecker wrote:
> On Thu, May 24, 2012 at 09:42:29AM -0500, Russ Anderson wrote:
> > When multiple cpus on a multi-processor system call dump_stack()
> > at the same time, the backtrace lines get intermixed, making 
> > the output worthless.  Add a lock so each cpu stack dump comes
> > out as a coherent set.
> > 
> > For example, when a multi-processor system is NMIed, all of the
> > cpus call dump_stack() at the same time, resulting in output for
> > all of cpus getting intermixed, making it impossible to tell what
> > any individual cpu was doing.  With this patch each cpu prints
> > its stack lines as a coherent set, so one can see what each cpu
> > was doing.
> > 
> > It has been tested on a 4069 cpu system.
> > 
> > Signed-off-by: Russ Anderson <rja@sgi.com>
> 
> I don't think this is a good idea. What if an interrupt comes
> and calls this at the same time? Sure you can mask irqs but NMIs
> can call that too. In this case I prefer to have a messy report
> rather than a deadlock on the debug path.

Below is an updated patch with your recommnded changes.

> May be something like that:
> 
> static atomic_t dump_lock = ATOMIC_INIT(-1);
> 
> static void dump_stack(void)
> {
> 	int was_locked;
> 	int old;
> 	int cpu;
> 
> 	preempt_disable();
> retry:
> 	cpu = smp_processor_id();
> 	old = atomic_cmpxchg(&dump_lock, -1, cpu);
> 	if (old == -1) {
> 		was_locked = 0;
> 	} else if (old == cpu) {
> 		was_locked = 1;
> 	} else {
> 		cpu_relax();
> 		goto retry;
> 	}
> 
> 	__dump_trace();
> 
> 	if (!was_locked)
> 		atomic_set(&dump_lock, -1);
> 
> 	preempt_enable();
> }
> 
> You could also use a spinlock with irq disabled and test in_nmi()
> but we could have a dump_trace() in an NMI before the nmi count is
> incremented. So the above is perhaps more robust.
> --
---

When multiple cpus on a multi-processor system call dump_stack()
at the same time, the backtrace lines get intermixed, making 
the output worthless.  Add a lock so each cpu stack dump comes
out as a coherent set.

For example, when a multi-processor system is NMIed, all of the
cpus call dump_stack() at the same time, resulting in output for
all of cpus getting intermixed, making it impossible to tell what
any individual cpu was doing.  With this patch each cpu prints
its stack lines as a coherent set, so one can see what each cpu
was doing.

It has been tested on a 4069 cpu system.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/dumpstack.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/dumpstack.c
===================================================================
--- linux.orig/arch/x86/kernel/dumpstack.c	2012-05-24 10:05:36.477576977 -0500
+++ linux/arch/x86/kernel/dumpstack.c	2012-05-27 16:58:26.527212233 -0500
@@ -182,7 +182,7 @@ void show_stack(struct task_struct *task
 /*
  * The architecture-independent dump_stack generator
  */
-void dump_stack(void)
+void __dump_stack(void)
 {
 	unsigned long bp;
 	unsigned long stack;
@@ -195,6 +195,32 @@ void dump_stack(void)
 		init_utsname()->version);
 	show_trace(NULL, NULL, &stack, bp);
 }
+
+static atomic_t dump_lock = ATOMIC_INIT(-1);
+
+void dump_stack(void)
+{
+	int was_locked, old, cpu;
+
+	preempt_disable();
+retry:
+	cpu = smp_processor_id();
+	old = atomic_cmpxchg(&dump_lock, -1, cpu);
+	if (old == -1) {
+		was_locked = 0;
+	} else if (old == cpu) {
+		was_locked = 1;
+	} else {
+		cpu_relax();
+		goto retry;
+	}
+
+	__dump_stack();
+
+	if (!was_locked)
+		atomic_set(&dump_lock, -1);
+	preempt_enable();
+}
 EXPORT_SYMBOL(dump_stack);
 
 static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
