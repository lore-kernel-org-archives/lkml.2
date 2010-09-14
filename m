Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0INTVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:21:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54585 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0INTVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:21:45 -0400
Date: Mon, 13 Sep 2010 17:33:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100914003351.GA8300@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <201009072200.59509.arnd@arndb.de>
 <20100907205015.GJ2448@linux.vnet.ibm.com>
 <201009091714.44013.arnd@arndb.de>
 <20100910034603.GA2612@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910034603.GA2612@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 08:46:03PM -0700, Paul E. McKenney wrote:
> On Thu, Sep 09, 2010 at 05:14:43PM +0200, Arnd Bergmann wrote:
> > On Tuesday 07 September 2010, Paul E. McKenney wrote:
> > > On Tue, Sep 07, 2010 at 10:00:58PM +0200, Arnd Bergmann wrote:
> > > > On Tuesday 07 September 2010 21:21:55 Kulikov Vasiliy wrote:
> > > > > #define __rcu_dereference_check(p, c, space) \
> > > > >         ({ \
> > > > >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> > > > >                                                                    ^
> > > > >                 rcu_lockdep_assert(c); \
> > > > >                 (void) (((typeof (*p) space *)p) == p); \
> > > > >                                       ^     ^
> > > > >                 smp_read_barrier_depends(); \
> > > > >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> > > > >         })
> > > > > 
> > > > > If I understand this, it is evaluated three times, right?
> > > > 
> > > > Yes, that looks like my own fault, I added that :(
> > > > 
> > > > This patch seems to fix it, but I need to think about it some more
> > > > to make sure it still does everything we need.
> > > 
> > > Let me know when you are satisfied with it, and then I will pick it up.
> > 
> > I guess it would be good to put it in now. I haven't had the time
> > to try out all cases, but the current code in -next is definitely
> > broken, so please put the fix in now.
> 
> Hmmm...  One approach would be have a secondary macro that was:
> 
> 	#define __rcu_dereference_check_sparse(p, space) \
> 		(void) (((typeof (*p) space *)p) == p);
> 
> when running sparse and:
> 
> 	#define __rcu_dereference_check_sparse(p, space)
> 
> otherwise.
> 
> Would that do the trick?

Here is a patch that more fully describes what I had in mind.  I have
done light compile/sparse testing, but this should be considered to be
full of bugs.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

commit 493a0a1001137f7058da0e01c3d05b0fcb92841d
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Sep 13 17:24:21 2010 -0700

    rcu: only one evaluation of arg in rcu_dereference_check() unless sparse
    
    The current version of the __rcu_access_pointer(), __rcu_dereference_check(),
    and __rcu_dereference_protected() macros evaluate their "p" argument
    three times, not counting typeof()s.  This is bad news if that argument
    contains a side effect.  This commit therefore evaluates this argument
    only once in normal kernel builds.  However, the straightforward approach
    defeats sparse's RCU-pointer checking, so this commit also adds a
    KBUILD_CHECKSRC symbol defined when running a checker.  Therefore, when
    this new KBUILD_CHECKSRC symbol is defined, the additional pair of
    evaluations of the "p" argument are performed in order to permit sparse
    to detect misuse of RCU-protected pointers.
    
    This commit also fixes some sparse complaints in rcutorture.c.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>

diff --git a/Makefile b/Makefile
index f3bdff8..1c4984d 100644
--- a/Makefile
+++ b/Makefile
@@ -330,7 +330,7 @@ PERL		= perl
 CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
-		  -Wbitwise -Wno-return-void $(CF)
+		  -Wbitwise -Wno-return-void -DKBUILD_CHECKSRC $(CF)
 CFLAGS_MODULE   =
 AFLAGS_MODULE   =
 LDFLAGS_MODULE  =
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 682bf4c..9fda1e6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -309,24 +309,32 @@ extern int rcu_my_thread_group_empty(void);
  * (e.g., __rcu_bh, * __rcu_sched, and __srcu), should this make sense in
  * the future.
  */
+
+#ifdef KBUILD_CHECKSRC
+#define rcu_dereference_sparse(p, space) \
+	((void)(((typeof(*p) space *)p) == p))
+#else /* #ifdef KBUILD_CHECKSRC */
+#define rcu_dereference_sparse(p, space)
+#endif /* #else #ifdef KBUILD_CHECKSRC */
+
 #define __rcu_access_pointer(p, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		(void) (((typeof (*p) space *)p) == p); \
+		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
 		rcu_lockdep_assert(c); \
-		(void) (((typeof (*p) space *)p) == p); \
+		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
 		rcu_lockdep_assert(c); \
-		(void) (((typeof (*p) space *)p) == p); \
+		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 439ddab..adb09cb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -131,7 +131,7 @@ struct rcu_torture {
 };
 
 static LIST_HEAD(rcu_torture_freelist);
-static struct rcu_torture *rcu_torture_current;
+static struct rcu_torture __rcu *rcu_torture_current;
 static long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
@@ -171,7 +171,7 @@ int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 #endif /* #else #ifdef CONFIG_BOOST_RCU */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
-DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+static DEFINE_MUTEX(boost_mutex);	/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
 
 /* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
@@ -180,7 +180,8 @@ DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 #define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
 #define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
 static int fullstop = FULLSTOP_RMMOD;
-DEFINE_MUTEX(fullstop_mutex);	/* Protect fullstop transitions and spawning */
+static DEFINE_MUTEX(fullstop_mutex);
+				/* Protect fullstop transitions and spawning */
 				/*  of kthreads. */
 
 /*
@@ -873,7 +874,8 @@ rcu_torture_writer(void *arg)
 			continue;
 		rp->rtort_pipe_count = 0;
 		udelay(rcu_random(&rand) & 0x3ff);
-		old_rp = rcu_torture_current;
+		old_rp = rcu_dereference_check(rcu_torture_current,
+					       current == writer_task);
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
 		smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
