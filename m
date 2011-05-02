Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab1EBVhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:37:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56846 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab1EBVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:36:56 -0400
Date: Mon, 2 May 2011 09:18:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 17/86] rcu: fix boost-tracing bug and
 update tracing documentation
Message-ID: <20110502161824.GB6524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501154310.GD14829@feather>
 <20110502083301.GY2297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502083301.GY2297@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:33:01AM -0700, Paul E. McKenney wrote:
> On Sun, May 01, 2011 at 08:43:10AM -0700, Josh Triplett wrote:
> > The bugfix here should really go in a separate commit from the updated
> > documentation.  Also:
> > 
> > On Sun, May 01, 2011 at 06:20:57AM -0700, Paul E. McKenney wrote:
> > > --- a/Documentation/RCU/trace.txt
> > > +++ b/Documentation/RCU/trace.txt
> > > @@ -10,34 +10,37 @@ for rcutree and next for rcutiny.
> > >  
> > >  CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
> > >  
> > > -These implementations of RCU provides five debugfs files under the
> > > +These implementations of RCU provides seven debugfs files under the
> > 
> > s/seven/several/, so this doesn't continue to need updates as you add
> > more tracing?  It doesn't seem entirely accurate even now, given that
> > the set of files available now depends on CONFIG_RCU_BOOST.
> 
> Good point, will fix.
> 
> > >  top-level directory RCU: rcu/rcudata (which displays fields in struct
> > 
> > RCU or rcu?
> 
> Indeed, "rcu".  Will fix.
> 
> > >  rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
> > >  rcu/rcudata), rcu/rcugp (which displays grace-period counters),
> > > -rcu/rcuhier (which displays the struct rcu_node hierarchy), and
> > > +rcu/rcuhier (which displays the struct rcu_node hierarchy),
> > >  rcu/rcu_pending (which displays counts of the reasons that the
> > > -rcu_pending() function decided that there was core RCU work to do).
> > > +rcu_pending() function decided that there was core RCU work to do),
> > > +rcu/rcutorture (which displays rcutorture test progress), and, if the
> > > +kernel is built with CONFIG_RCU_BOOST, rcu/rcuboost (which displays RCU
> > > +boosting statistics).
> > 
> > I think this would work better as a list:
> > 
> > rcu/rcudata:
> >     Displays fields in struct rcu_data.
> > rcu/rcudata.csv:
> >     Comma-separated values spreadsheet version of rcudata.
> > rcu/rcugp:
> >     Displays grace-period counters.
> > rcu/rcuhier
> >     Displays the struct rcu_node hierarchy.
> > rcu/rcu_pending:
> >     Displays counts of the reasons rcu_pending() decided that RCU had
> >     work to do.
> > rcu/rcutorture:
> >     Displays rcutorture test progress.
> > rcu/rcuboost
> >     Displays RCU boosting statistics. Only present if
> >     CONFIG_RCU_BOOST=y.
> > 
> > Feel free to put the descriptions on the same lines as the filenames if
> > you prefer; however, I thought this style worked better for the
> > descriptions longer than one line.
> 
> Makes sense, will do a list.
> 
> > Also, does rcu/rcutorture appear with rcutorture not loaded?  Hopefully
> > not, since rcutorture shouldn't take up any additional resources when
> > not loaded.
> 
> Not much choice, unfortunately.  If I put the info into rcutorture, then
> I lose it when rcutorture is unloaded.  This is problematic in automated
> tests that repeatedly load and unload rcutorture.
> 
> But the amount of data is small, and I set things up so that TINY_RCU
> can omit this.  TREE_RCU is big enough that it doesn't really matter.
> 
> > > --- a/kernel/rcutree_plugin.h
> > > +++ b/kernel/rcutree_plugin.h
> > > @@ -1086,7 +1086,7 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
> > >  	else if (rnp->gp_tasks != NULL && rnp->qsmask != 0)
> > >  		rnp->n_balk_notblocked++;
> > >  	else if (rnp->gp_tasks != NULL &&
> > > -		 ULONG_CMP_GE(jiffies, rnp->boost_time))
> > > +		 ULONG_CMP_LT(jiffies, rnp->boost_time))
> > >  		rnp->n_balk_notyet++;
> > >  	else
> > >  		rnp->n_balk_nos++;
> > 
> > This bugfix should go in a separate commit.
> 
> Excellent point, will fix.

Here is the updated documentation update.

							Thanx, Paul

------------------------------------------------------------------------

rcu: update tracing documentation for new rcutorture and rcuboost

This commit documents the new debugfs rcu/rcutorture and rcu/rcuboost
trace files.  The description has been updated as suggested by Josh
Triplett.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 5aefd5f..40b530d 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -10,34 +10,46 @@ for rcutree and next for rcutiny.
 
 CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-These implementations of RCU provides five debugfs files under the
-top-level directory RCU: rcu/rcudata (which displays fields in struct
-rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
-rcu/rcudata), rcu/rcugp (which displays grace-period counters),
-rcu/rcuhier (which displays the struct rcu_node hierarchy), and
-rcu/rcu_pending (which displays counts of the reasons that the
-rcu_pending() function decided that there was core RCU work to do).
+These implementations of RCU provides several debugfs files under the
+top-level directory "rcu":
+
+rcu/rcudata:
+	Displays fields in struct rcu_data.
+rcu/rcudata.csv:
+	Comma-separated values spreadsheet version of rcudata.
+rcu/rcugp:
+	Displays grace-period counters.
+rcu/rcuhier:
+	Displays the struct rcu_node hierarchy.
+rcu/rcu_pending:
+	Displays counts of the reasons rcu_pending() decided that RCU had
+	work to do.
+rcu/rcutorture:
+	Displays rcutorture test progress.
+rcu/rcuboost:
+	Displays RCU boosting statistics.  Only present if
+	CONFIG_RCU_BOOST=y.
 
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 qs=.... b=10 ci=1460693 co=1648 ca=6448
-  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 qs=.... b=10 ci=1459002 co=1614 ca=3310
-  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 qs=.... b=10 ci=1610701 co=2015 ca=2378
-  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 qs=.... b=10 ci=1427543 co=1430 ca=897
-  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 qs=.... b=10 ci=1562249 co=1896 ca=533
-  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 qs=.... b=10 ci=1777260 co=2137 ca=274
-  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 qs=.... b=10 ci=1471186 co=1530 ca=243
-  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 qs=N.W. b=10 ci=4026154 co=1948 ca=135
+  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 qs=.... kt=0/W b=10 ci=1460693 co=1648 ca=6448
+  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 qs=.... kt=0/W b=10 ci=1459002 co=1614 ca=3310
+  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 qs=.... kt=0/W b=10 ci=1610701 co=2015 ca=2378
+  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 qs=.... kt=0/W b=10 ci=1427543 co=1430 ca=897
+  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 qs=.... kt=0/W b=10 ci=1562249 co=1896 ca=533
+  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 qs=.... kt=0/W b=10 ci=1777260 co=2137 ca=274
+  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 qs=.... kt=0/W b=10 ci=1471186 co=1530 ca=243
+  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 qs=N.W. kt=0/W b=10 ci=4026154 co=1948 ca=135
 rcu_bh:
-  0!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=86475/1/0 df=11 of=0 ri=0 ql=0 qs=.... b=10 ci=112 co=0 ca=0
-  1!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=90875/1/0 df=15 of=0 ri=0 ql=0 qs=.... b=10 ci=143 co=0 ca=0
-  2!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=69661/1/0 df=21 of=0 ri=1 ql=0 qs=.... b=10 ci=88 co=0 ca=0
-  3!c=18446744073709551494 g=18446744073709551494 pq=1 pqc=18446744073709551493 qp=0 dt=70349/1/0 df=13 of=0 ri=0 ql=0 qs=....  b=10 ci=100 co=0 ca=0
-  4!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=38935/1/0 df=17 of=0 ri=0 ql=0 qs=....  b=10 ci=36 co=0 ca=0
-  5!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=25127/1/0 df=7 of=0 ri=0 ql=0 qs=....  b=10 ci=32 co=0 ca=0
-  6!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=22639/1/0 df=9 of=0 ri=0 ql=0 qs=....  b=10 ci=44 co=0 ca=0
-  7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 qs=....  b=10 ci=627 co=0 ca=0
+  0!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=86475/1/0 df=11 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=112 co=0 ca=0
+  1!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=90875/1/0 df=15 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=143 co=0 ca=0
+  2!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=69661/1/0 df=21 of=0 ri=1 ql=0 qs=.... kt=0/W b=10 ci=88 co=0 ca=0
+  3!c=18446744073709551494 g=18446744073709551494 pq=1 pqc=18446744073709551493 qp=0 dt=70349/1/0 df=13 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=100 co=0 ca=0
+  4!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=38935/1/0 df=17 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=36 co=0 ca=0
+  5!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=25127/1/0 df=7 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=32 co=0 ca=0
+  6!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=22639/1/0 df=9 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=44 co=0 ca=0
+  7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 qs=....  kt=0/W b=10 ci=627 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -146,6 +158,23 @@ o	"qs" gives an indication of the state of the callback queue
 	If there are no callbacks in a given one of the above states,
 	the corresponding character is replaced by ".".
 
+o	"kt" is the per-CPU kernel-thread state.  The digit preceding
+	the slash is zero if there is no work pending and 1 otherwise.
+	The character after the slash is as follows:
+
+	"S"	The kernel thread is stopped, in other words, all
+		CPUs corresponding to this rcu_node structure are
+		offline.
+
+	"R"	The kernel thread is running.
+
+	"W"	The kernel thread is waiting because there is no work
+		for it to do.
+
+	"Y"	The kernel thread is yielding to avoid hogging CPU.
+
+	"?"	Unknown value, indicates a bug.
+
 o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
@@ -356,6 +385,113 @@ o	"nn" is the number of times that this CPU needed nothing.  Alert
 	is due to short-circuit evaluation in rcu_pending().
 
 
+The output of "cat rcu/rcutorture" looks as follows:
+
+rcutorture test sequence: 0 (test in progress)
+rcutorture update version number: 615
+
+The first line shows the number of rcutorture tests that have completed
+since boot.  If a test is currently running, the "(test in progress)"
+string will appear as shown above.  The second line shows the number of
+update cycles that the current test has started, or zero if there is
+no test in progress.
+
+
+The output of "cat rcu/rcuboost" looks as follows:
+
+0:5 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=2f95 bt=300f
+     balk: nt=0 egt=989 bt=0 nb=0 ny=0 nos=16
+6:7 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=2f95 bt=300f
+     balk: nt=0 egt=225 bt=0 nb=0 ny=0 nos=6
+
+This information is output only for rcu_preempt.  Each two-line entry
+corresponds to a leaf rcu_node strcuture.  The fields are as follows:
+
+o	"n:m" is the CPU-number range for the corresponding two-line
+	entry.  In the sample output above, the first entry covers
+	CPUs zero through five and the second entry covers CPUs 6
+	and 7.
+
+o	"tasks=TNEB" gives the state of the various segments of the
+	rnp->blocked_tasks list:
+
+	"T"	This indicates that there are some tasks that blocked
+		while running on one of the corresponding CPUs while
+		in an RCU read-side critical section.
+
+	"N"	This indicates that some of the blocked tasks are preventing
+		the current normal (non-expedited) grace period from
+		completing.
+
+	"E"	This indicates that some of the blocked tasks are preventing
+		the current expedited grace period from completing.
+
+	"B"	This indicates that some of the blocked tasks are in
+		need of RCU priority boosting.
+
+	Each character is replaced with "." if the corresponding
+	condition does not hold.
+
+o	"kt" is the state of the RCU priority-boosting kernel
+	thread associated with the corresponding rcu_node structure.
+	The state can be one of the following:
+
+	"S"	The kernel thread is stopped, in other words, all
+		CPUs corresponding to this rcu_node structure are
+		offline.
+
+	"R"	The kernel thread is running.
+
+	"W"	The kernel thread is waiting because there is no work
+		for it to do.
+
+	"Y"	The kernel thread is yielding to avoid hogging CPU.
+
+	"?"	Unknown value, indicates a bug.
+
+o	"ntb" is the number of tasks boosted.
+
+o	"neb" is the number of tasks boosted in order to complete an
+	expedited grace period.
+
+o	"nnb" is the number of tasks boosted in order to complete a
+	normal (non-expedited) grace period.  When boosting a task
+	that was blocking both an expedited and a normal grace period,
+	it is counted against the expedited total above.
+
+o	"j" is the low-order 16 bits of the jiffies counter in
+	hexadecimal.
+
+o	"bt" is the low-order 16 bits of the value that the jiffies
+	counter will have when we next start boosting, assuming that
+	the current grace period does not end beforehand.  This is
+	also in hexadecimal.
+
+o	"balk: nt" counts the number of times we didn't boost (in
+	other words, we balked) even though it was time to boost because
+	there were no blocked tasks to boost.  This situation occurs
+	when there is one blocked task on one rcu_node structure and
+	none on some other rcu_node structure.
+
+o	"egt" counts the number of times we balked because although
+	there were blocked tasks, none of them were blocking the
+	current grace period, whether expedited or otherwise.
+
+o	"bt" counts the number of times we balked because boosting
+	had already been initiated for the current grace period.
+
+o	"nb" counts the number of times we balked because there
+	was at least one task blocking the current non-expedited grace
+	period that never had blocked.  If it is already running, it
+	just won't help to boost its priority!
+
+o	"ny" counts the number of times we balked because it was
+	not yet time to start boosting.
+
+o	"nos" counts the number of times we balked for other
+	reasons, e.g., the grace period ended first.
+
+
 CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
 
 These implementations of RCU provides a single debugfs file under the
@@ -422,9 +558,9 @@ o	"neb" is the number of expedited grace periods that have had
 o	"nnb" is the number of normal grace periods that have had
 	to resort to RCU priority boosting since boot.
 
-o	"j" is the low-order 12 bits of the jiffies counter in hexadecimal.
+o	"j" is the low-order 16 bits of the jiffies counter in hexadecimal.
 
-o	"bt" is the low-order 12 bits of the value that the jiffies counter
+o	"bt" is the low-order 16 bits of the value that the jiffies counter
 	will have at the next time that boosting is scheduled to begin.
 
 o	In the line beginning with "normal balk", the fields are as follows:
