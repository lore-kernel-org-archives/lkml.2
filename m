Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2JRQzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780Ab2JRQzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:55:18 -0400
Date: Thu, 18 Oct 2012 12:00:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
In-Reply-To: <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1210181132430.22996@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
 <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2012, Linus Torvalds wrote:

> [ Architecture people, note the potential new SMP barrier! ]
> 
> On Tue, Oct 16, 2012 at 4:30 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > +       /*
> > +        * The lock is considered unlocked when p->locked is set to false.
> > +        * Use barrier prevent reordering of operations around p->locked.
> > +        */
> > +#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
> > +       barrier();
> > +#else
> > +       smp_mb();
> > +#endif
> >         p->locked = false;
> 
> Ugh. The #if is too ugly to live.

One instance of this is already present in the code.

I suggest that you drop this patch and use synchronize_rcu() that I 
have just posted.

But another instance of this "#if defined(CONFIG_X86) && ..." is already 
there in percpu_up_read.


What is the procedure for making changes that require support of 
architectures? It is trivial to make a patch that moves this into 
arch-specific includes, the problem is that the patch break all the 
architectures - I wrote support for x86, sparc, parisc, alpha (I can test 
those) but not the others.

Are you going to apply this patch, break majority of architectures and 
wait until architecture maintainers fix it? Or is there some arch-specific 
git tree, where the patch should be applied and where the maintainers fix 
things?

> This is a classic case of "people who write their own serialization
> primitives invariably get them wrong". And this fix is just horrible,
> and code like this should not be allowed.
> 
> I suspect we could make the above x86-specific optimization be valid
> by introducing a new barrier, called "smp_release_before_store()" or
> something like that, which on x86 just happens to be a no-op (but
> still a compiler barrier). That's because earlier reads will not pass
> a later stores, and stores are viewed in program order, so all x86
> stores have "release consistency" modulo the theoretical PPro bugs
> (that I don't think we actually ever saw in practice).
> 
> But it is possible that that is true on other architectures too, so
> your hand-crafted x86-specific #if is not just ugly, it's liable to
> get worse.
> 
> The alternative is to just say that we should use "smp_mb()"
> unconditionally, depending on how critical this code actually ends up
> being.
> 
> Added linux-arch in case architecture-maintainers have comments on
> "smp_release_before_store()" thing. It would be kind of similar to the
> odd "smp_read_barrier_depends()", except it would normally be a full
> memory barrier, except on architectures where a weaker barrier might
> be sufficient.
> 
> I suspect there may be many architectures where a "smp_wmb()" is
> sufficient for this case, for the simple reason that no sane
> microarchitecture would *ever* move earlier reads down past a later
> write,

Alpha can move reads down past writes (if the read is not in cache and the 
write hits the cache, it may make sense to do this reordering).

> so release consistency really only needs the local writes to be
> ordered, not the full memory ordering.
> 
> Arch people?
> 
> The more optimal solution may be to mark the store *itself* to be
> "store with release consistency", which on x86 would be a regular
> store (with the compiler barrier), but on other architectures may be a
> special memory operation. On architectures with
> release/aqcuire-consistency, there's not a separate barrier before the
> store, the store instruction itself is done with special semantics. So
> maybe the right thing to do is
> 
>    #define smp_release_consistency_store(val, ptr) ...
> 
> where on x86, the implementation would be a simple
> 
>    do { barrier(); *(ptr)=(val); } while (0)

smp_release_consistency_store doesn't work. In 
include/linux/percpu-rwsem.h it is required that 
"this_cpu_dec(*p->counters);" works as an unlock barrier. So we could do 
either.

"smp_mb(); this_cpu_dec(*p->counters);" - generates pointless barrier on x86

"#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && 
!defined(CONFIG_X86_OOSTORE))
        barrier();
#else
        smp_mb();
#endif
        this_cpu_dec(*p->counters);
" - removes the barrier on the most common architecture (X86), but the 
code looks dirty

"smp_release_before_store();this_cpu_dec(*p->counters);" - the code is 
clean, but the downside is that it breaks architectures that don't have 
smp_release_before_store().

> but on other architectures it might be a inline asm with the required
> magic store-with-release instruction.
> 
> How important is this code sequence? Is the "percpu_up_write()"
> function really so critical that we can't have an extra memory
> barrier?

percpu_up_write() is not critical. But percpu_up_read() is critical and it 
should be as fast as possible.

Mikulas

> Or do people perhaps see *other* places where
> release-consistency-stores might be worth doing?
> 
> But in no event do I want to see that butt-ugly #if statement.
> 
>                 Linus
> 

---
Introduce smp_release_before_store()

smp_release_before_store() with the following store operation works as
an unlock barrier - that is, memory accesses may be moved before the
unlock barrier, but no memory accesses are moved past the memory
barrier.

On x86 writes are strongly ordered (unless CONFIG_X86_PPRO_FENCE or
CONFIG_X86_OOSTORE is selected), so smp_release_before_store() defaults
to a compiler barrier (and no barrier instruction). On other
architectures it may need more heavyweight barriers.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/memory-barriers.txt   |    5 +++++
 arch/alpha/include/asm/barrier.h    |    2 ++
 arch/parisc/include/asm/barrier.h   |    1 +
 arch/sparc/include/asm/barrier_32.h |    1 +
 arch/sparc/include/asm/barrier_64.h |    2 ++
 arch/x86/include/asm/barrier.h      |    6 ++++++
 include/linux/percpu-rwsem.h        |   13 +------------
 7 files changed, 18 insertions(+), 12 deletions(-)

Index: linux-3.6.2-fast/arch/alpha/include/asm/barrier.h
===================================================================
--- linux-3.6.2-fast.orig/arch/alpha/include/asm/barrier.h	2012-10-18 17:45:12.000000000 +0200
+++ linux-3.6.2-fast/arch/alpha/include/asm/barrier.h	2012-10-18 17:46:24.000000000 +0200
@@ -29,6 +29,8 @@ __asm__ __volatile__("mb": : :"memory")
 #define smp_read_barrier_depends()	do { } while (0)
 #endif
 
+#define smp_release_before_store()	smp_mb()
+
 #define set_mb(var, value) \
 do { var = value; mb(); } while (0)
 
Index: linux-3.6.2-fast/arch/parisc/include/asm/barrier.h
===================================================================
--- linux-3.6.2-fast.orig/arch/parisc/include/asm/barrier.h	2012-10-18 17:45:13.000000000 +0200
+++ linux-3.6.2-fast/arch/parisc/include/asm/barrier.h	2012-10-18 17:46:24.000000000 +0200
@@ -29,6 +29,7 @@
 #define smp_wmb()	mb()
 #define smp_read_barrier_depends()	do { } while(0)
 #define read_barrier_depends()		do { } while(0)
+#define smp_release_before_store()	mb ()
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
Index: linux-3.6.2-fast/arch/sparc/include/asm/barrier_32.h
===================================================================
--- linux-3.6.2-fast.orig/arch/sparc/include/asm/barrier_32.h	2012-10-18 17:45:13.000000000 +0200
+++ linux-3.6.2-fast/arch/sparc/include/asm/barrier_32.h	2012-10-18 17:56:48.000000000 +0200
@@ -11,5 +11,6 @@
 #define smp_rmb()	__asm__ __volatile__("":::"memory")
 #define smp_wmb()	__asm__ __volatile__("":::"memory")
 #define smp_read_barrier_depends()	do { } while(0)
+#define smp_release_before_store()	smp_mb()
 
 #endif /* !(__SPARC_BARRIER_H) */
Index: linux-3.6.2-fast/arch/sparc/include/asm/barrier_64.h
===================================================================
--- linux-3.6.2-fast.orig/arch/sparc/include/asm/barrier_64.h	2012-10-18 17:45:13.000000000 +0200
+++ linux-3.6.2-fast/arch/sparc/include/asm/barrier_64.h	2012-10-18 17:46:24.000000000 +0200
@@ -53,4 +53,6 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 
 
 #define smp_read_barrier_depends()	do { } while(0)
 
+#define smp_release_before_store()	__asm__ __volatile__("":::"memory")
+
 #endif /* !(__SPARC64_BARRIER_H) */
Index: linux-3.6.2-fast/arch/x86/include/asm/barrier.h
===================================================================
--- linux-3.6.2-fast.orig/arch/x86/include/asm/barrier.h	2012-10-18 17:45:13.000000000 +0200
+++ linux-3.6.2-fast/arch/x86/include/asm/barrier.h	2012-10-18 17:46:24.000000000 +0200
@@ -100,6 +100,12 @@
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif
 
+#ifdef CONFIG_X86_PPRO_FENCE
+#define smp_release_before_store()	smp_mb()
+#else
+#define smp_release_before_store()	smp_wmb()
+#endif
+
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
  * (or get_cycles or vread that possibly accesses the TSC) in a defined
Index: linux-3.6.2-fast/include/linux/percpu-rwsem.h
===================================================================
--- linux-3.6.2-fast.orig/include/linux/percpu-rwsem.h	2012-10-18 17:45:13.000000000 +0200
+++ linux-3.6.2-fast/include/linux/percpu-rwsem.h	2012-10-18 17:46:24.000000000 +0200
@@ -28,18 +28,7 @@ static inline void percpu_down_read(stru
 
 static inline void percpu_up_read(struct percpu_rw_semaphore *p)
 {
-	/*
-	 * On X86, write operation in this_cpu_dec serves as a memory unlock
-	 * barrier (i.e. memory accesses may be moved before the write, but
-	 * no memory accesses are moved past the write).
-	 * On other architectures this may not be the case, so we need smp_mb()
-	 * there.
-	 */
-#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
-	barrier();
-#else
-	smp_mb();
-#endif
+	smp_release_before_store();
 	this_cpu_dec(*p->counters);
 }
 
Index: linux-3.6.2-fast/Documentation/memory-barriers.txt
===================================================================
--- linux-3.6.2-fast.orig/Documentation/memory-barriers.txt	2012-10-18 17:45:13.000000000 +0200
+++ linux-3.6.2-fast/Documentation/memory-barriers.txt	2012-10-18 17:46:24.000000000 +0200
@@ -1056,11 +1056,16 @@ The Linux kernel has eight basic CPU mem
 	WRITE		wmb()			smp_wmb()
 	READ		rmb()			smp_rmb()
 	DATA DEPENDENCY	read_barrier_depends()	smp_read_barrier_depends()
+	UNLOCK BARRIER	-			smp_release_before_store()
 
 
 All memory barriers except the data dependency barriers imply a compiler
 barrier. Data dependencies do not impose any additional compiler ordering.
 
+smp_release_before_store() together with the following store operation implies
+an unlock barrier. That is - memory accesses may be moved before the unlock
+barrier, but no memory accesses are moved past the unlock barrier.
+
 Aside: In the case of data dependencies, the compiler would be expected to
 issue the loads in the correct order (eg. `a[b]` would have to load the value
 of b before loading a[b]), however there is no guarantee in the C specification
