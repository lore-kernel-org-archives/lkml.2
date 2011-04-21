Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1DUFIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:08:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43935 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1DUFI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:08:29 -0400
Date: Wed, 20 Apr 2011 22:08:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110421050823.GA4487@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTikd2MpRPF37R+vCwnb7Lzzd6EiS7A@mail.gmail.com>
 <BANLkTinq=mC9rs5R3U8FPLCp-GgCJris_g@mail.gmail.com>
 <BANLkTimT9OhHLL5NaPOP30MdiMfmmmEcyQ@mail.gmail.com>
 <BANLkTikVW9Z=WxD7=w9c=Z6kHO-Za2ru8A@mail.gmail.com>
 <20110414224411.GF2141@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20110414224411.GF2141@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 14, 2011 at 03:44:11PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 15, 2011 at 12:19:34AM +0200, Sedat Dilek wrote:
> > On Thu, Apr 14, 2011 at 12:19 PM, Sedat Dilek
> > <sedat.dilek@googlemail.com> wrote:
> > > On Thu, Apr 14, 2011 at 11:16 AM, Sedat Dilek
> > > <sedat.dilek@googlemail.com> wrote:
> > >> [ Adding CC to RCU maintainer (Hi Paul :-)) ]
> > >>
> > >> Helping me for now with (see also Documentation/RCU/stallwarn.txt):
> > >>
> > >> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
> > >> 0
> > >>
> > >> # echo "1" > /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
> > >>
> > >> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
> > >> 1
> > >>
> > >> - Sedat -
> > >>
> > >
> > > That workaround helped till a system-freeze when generating a tarball
> > > from my current kernel-tree.
> > > I switched back to my yesterday's linux-next kernel.
> > >
> > > - Sedat -
> > >
> > 
> > I isolated the culprit so far:
> > 
> > commit 900507fc62d5ba0164c07878dbc36ac97866a858
> > "rcu: move TREE_RCU from softirq to kthread"
> > 
> > With this revert my system does not show the symptoms I have reported.
> 
> Hmmm...  I never was able to reproduce this, but did find a workload
> that slowed up the grace periods.  I fixed that (which turned out to
> be a wakeup problem), but my hopes that it would also fix your problem
> were clearly unfounded.  I have once again stopped exporting this commit
> to -next.

I have added some debug tracing, which are available at branch
"sedat.2011.04.19a" in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

Alternatively, if it is easier, the shown below can be used.  FWIW,
this patch is against 2.6.39-rc3.

Either way, if you get a chance to run your tests on this, could you
please run the attached script (collectdebugfs.sh) and capture its output?
Sample output is attached as well (collectdebugfs.sh.out):  the script
should output something vaguely like the sample output every 15 seconds
or so.

The script assumes that debugfs is enabled (along with CONFIG_RCU_TRACE=y)
and mounted as follows:

	mount -t debugfs none /sys/kernel/debug/

Or if you mount debugfs somewhere else, please set the script's DEBUGFS_MP
variable accordingly.

							Thanx, Paul

------------------------------------------------------------------------

 Documentation/RCU/00-INDEX          |    2 
 Documentation/RCU/stallwarn.txt     |   23 -
 Documentation/RCU/trace.txt         |  265 +++++++++++----
 Documentation/filesystems/proc.txt  |    1 
 include/linux/interrupt.h           |    1 
 include/linux/rcupdate.h            |   14 
 include/linux/rcutree.h             |    3 
 include/trace/events/irq.h          |    3 
 init/Kconfig                        |    2 
 kernel/rcupdate.c                   |   32 +
 kernel/rcutorture.c                 |   20 -
 kernel/rcutree.c                    |  633 +++++++++++++++++++++++++++++-------
 kernel/rcutree.h                    |  113 +++++-
 kernel/rcutree_plugin.h             |  531 +++++++++++++++++++++++++-----
 kernel/rcutree_trace.c              |  188 +++++++++-
 kernel/softirq.c                    |    2 
 lib/Kconfig.debug                   |   32 -
 tools/perf/util/trace-event-parse.c |    1 
 18 files changed, 1501 insertions(+), 365 deletions(-)

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 71b6f50..1d7a885 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -21,7 +21,7 @@ rcu.txt
 RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
 stallwarn.txt
-	- RCU CPU stall warnings (CONFIG_RCU_CPU_STALL_DETECTOR)
+	- RCU CPU stall warnings (module parameter rcu_cpu_stall_suppress)
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
 trace.txt
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 862c08e..4e95920 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -1,22 +1,25 @@
 Using RCU's CPU Stall Detector
 
-The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
-RCU's CPU stall detector, which detects conditions that unduly delay
-RCU grace periods.  The stall detector's idea of what constitutes
-"unduly delayed" is controlled by a set of C preprocessor macros:
+The rcu_cpu_stall_suppress module parameter enables RCU's CPU stall
+detector, which detects conditions that unduly delay RCU grace periods.
+This module parameter enables CPU stall detection by default, but
+may be overridden via boot-time parameter or at runtime via sysfs.
+The stall detector's idea of what constitutes "unduly delayed" is
+controlled by a set of kernel configuration variables and cpp macros:
 
-RCU_SECONDS_TILL_STALL_CHECK
+CONFIG_RCU_CPU_STALL_TIMEOUT
 
-	This macro defines the period of time that RCU will wait from
-	the beginning of a grace period until it issues an RCU CPU
-	stall warning.	This time period is normally ten seconds.
+	This kernel configuration parameter defines the period of time
+	that RCU will wait from the beginning of a grace period until it
+	issues an RCU CPU stall warning.  This time period is normally
+	ten seconds.
 
 RCU_SECONDS_TILL_STALL_RECHECK
 
 	This macro defines the period of time that RCU will wait after
 	issuing a stall warning until it issues another stall warning
-	for the same stall.  This time period is normally set to thirty
-	seconds.
+	for the same stall.  This time period is normally set to three
+	times the check interval plus thirty seconds.
 
 RCU_STALL_RAT_DELAY
 
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 6a8c73f..0346d3c 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -10,34 +10,37 @@ for rcutree and next for rcutiny.
 
 CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-These implementations of RCU provides five debugfs files under the
+These implementations of RCU provides seven debugfs files under the
 top-level directory RCU: rcu/rcudata (which displays fields in struct
 rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
 rcu/rcudata), rcu/rcugp (which displays grace-period counters),
-rcu/rcuhier (which displays the struct rcu_node hierarchy), and
+rcu/rcuhier (which displays the struct rcu_node hierarchy),
 rcu/rcu_pending (which displays counts of the reasons that the
-rcu_pending() function decided that there was core RCU work to do).
+rcu_pending() function decided that there was core RCU work to do),
+rcu/rcutorture (which displays rcutorture test progress), and, if the
+kernel is built with CONFIG_RCU_BOOST, rcu/rcuboost (which displays RCU
+boosting statistics).
 
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
-  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
-  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
-  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
-  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
-  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
-  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
-  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
+  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 qs=.... kt=0/W b=10 ci=1460693 co=1648 ca=6448
+  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 qs=.... kt=0/W b=10 ci=1459002 co=1614 ca=3310
+  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 qs=.... kt=0/W b=10 ci=1610701 co=2015 ca=2378
+  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 qs=.... kt=0/W b=10 ci=1427543 co=1430 ca=897
+  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 qs=.... kt=0/W b=10 ci=1562249 co=1896 ca=533
+  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 qs=.... kt=0/W b=10 ci=1777260 co=2137 ca=274
+  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 qs=.... kt=0/W b=10 ci=1471186 co=1530 ca=243
+  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 qs=N.W. kt=0/W b=10 ci=4026154 co=1948 ca=135
 rcu_bh:
-  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
-  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
-  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
-  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
-  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
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
@@ -52,17 +55,18 @@ o	The number at the beginning of each line is the CPU number.
 	substantially larger than the number of actual CPUs.
 
 o	"c" is the count of grace periods that this CPU believes have
-	completed.  CPUs in dynticks idle mode may lag quite a ways
-	behind, for example, CPU 4 under "rcu_sched" above, which has
-	slept through the past 25 RCU grace periods.  It is not unusual
-	to see CPUs lagging by thousands of grace periods.
+	completed.  Offlined CPUs and CPUs in dynticks idle mode may
+	lag quite a ways behind, for example, CPU 6 under "rcu_sched"
+	above, which has been offline through not quite 40,000 RCU grace
+	periods.  It is not unusual to see CPUs lagging by thousands of
+	grace periods.
 
 o	"g" is the count of grace periods that this CPU believes have
-	started.  Again, CPUs in dynticks idle mode may lag behind.
-	If the "c" and "g" values are equal, this CPU has already
-	reported a quiescent state for the last RCU grace period that
-	it is aware of, otherwise, the CPU believes that it owes RCU a
-	quiescent state.
+	started.  Again, offlined CPUs and CPUs in dynticks idle mode
+	may lag behind.  If the "c" and "g" values are equal, this CPU
+	has already reported a quiescent state for the last RCU grace
+	period that it is aware of, otherwise, the CPU believes that it
+	owes RCU a quiescent state.
 
 o	"pq" indicates that this CPU has passed through a quiescent state
 	for the current grace period.  It is possible for "pq" to be
@@ -81,22 +85,16 @@ o	"pqc" indicates which grace period the last-observed quiescent
 	the next grace period!
 
 o	"qp" indicates that RCU still expects a quiescent state from
-	this CPU.
+	this CPU.  Offlined CPUs and CPUs in dyntick idle mode might
+	well have qp=1, which is OK: RCU is still ignoring them.
 
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
-	scheduler or by irq.  The number after the "/" is the interrupt
-	nesting depth when in dyntick-idle state, or one greater than
-	the interrupt-nesting depth otherwise.
-
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
-o	"dn" is the current value of the dyntick counter that is incremented
-	when entering or leaving dynticks idle state via NMI.  If both
-	the "dt" and "dn" values are even, then this CPU is in dynticks
-	idle mode and may be ignored by RCU.  If either of these two
-	counters is odd, then RCU must be alert to the possibility of
-	an RCU read-side critical section running on this CPU.
+	scheduler or by irq.  This number is even if the CPU is in
+	dyntick idle mode and odd otherwise.  The number after the first
+	"/" is the interrupt nesting depth when in dyntick-idle state,
+	or one greater than the interrupt-nesting depth otherwise.
+	The number after the second "/" is the NMI nesting depth.
 
 	This field is displayed only for CONFIG_NO_HZ kernels.
 
@@ -108,7 +106,7 @@ o	"df" is the number of times that some other CPU has forced a
 
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
-	offline.  In a perfect world, this might neve happen, but it
+	offline.  In a perfect world, this might never happen, but it
 	turns out that offlining and onlining a CPU can take several grace
 	periods, and so there is likely to be an extended period of time
 	when RCU believes that the CPU is online when it really is not.
@@ -125,6 +123,49 @@ o	"ql" is the number of RCU callbacks currently residing on
 	of what state they are in (new, waiting for grace period to
 	start, waiting for grace period to end, ready to invoke).
 
+o	"qs" gives an indication of the state of the callback queue
+	with four characters:
+
+	"N"	Indicates that there are callbacks queued that are not
+		ready to be handled by the next grace period, and thus
+		will be handled by the grace period following the next
+		one.
+
+	"R"	Indicates that there are callbacks queued that are
+		ready to be handled by the next grace period.
+
+	"W"	Indicates that there are callbacks queued that are
+		waiting on the current grace period.
+
+	"D"	Indicates that there are callbacks queued that have
+		already been handled by a prior grace period, and are
+		thus waiting to be invoked.  Note that callbacks in
+		the process of being invoked are not counted here.
+		Callbacks in the process of being invoked are those
+		that have been removed from the rcu_data structures
+		queues by rcu_do_batch(), but which have not yet been
+		invoked.
+
+	If there are no callbacks in a given one of the above states,
+	the corresponding character is replaced by ".".
+
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
@@ -174,14 +215,14 @@ o	"gpnum" is the number of grace periods that have started.  It is
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
 c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
-1/1 .>. 0:127 ^0    
-3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
-3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
+1/1 ..>. 0:127 ^0
+3/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
+3/3f ..>. 0:5 ^0    2/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 rcu_bh:
 c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
-0/1 .>. 0:127 ^0    
-0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
-0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
+0/1 ..>. 0:127 ^0
+0/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
+0/3f ..>. 0:5 ^0    0/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 
 This is once again split into "rcu_sched" and "rcu_bh" portions,
 and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
@@ -240,13 +281,20 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		current grace period.
 
 	o	The characters separated by the ">" indicate the state
-		of the blocked-tasks lists.  A "T" preceding the ">"
+		of the blocked-tasks lists.  A "G" preceding the ">"
 		indicates that at least one task blocked in an RCU
 		read-side critical section blocks the current grace
-		period, while a "." preceding the ">" indicates otherwise.
-		The character following the ">" indicates similarly for
-		the next grace period.  A "T" should appear in this
-		field only for rcu-preempt.
+		period, while a "E" preceding the ">" indicates that
+		at least one task blocked in an RCU read-side critical
+		section blocks the current expedited grace period.
+		A "T" character following the ">" indicates that at
+		least one task is blocked within an RCU read-side
+		critical section, regardless of whether any current
+		grace period (expedited or normal) is inconvenienced.
+		A "." character appears if the corresponding condition
+		does not hold, so that "..>." indicates that no tasks
+		are blocked.  In contrast, "GE>T" indicates maximal
+		inconvenience from blocked tasks.
 
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
@@ -328,6 +376,113 @@ o	"nn" is the number of times that this CPU needed nothing.  Alert
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
@@ -394,9 +549,9 @@ o	"neb" is the number of expedited grace periods that have had
 o	"nnb" is the number of normal grace periods that have had
 	to resort to RCU priority boosting since boot.
 
-o	"j" is the low-order 12 bits of the jiffies counter in hexadecimal.
+o	"j" is the low-order 16 bits of the jiffies counter in hexadecimal.
 
-o	"bt" is the low-order 12 bits of the value that the jiffies counter
+o	"bt" is the low-order 16 bits of the value that the jiffies counter
 	will have at the next time that boosting is scheduled to begin.
 
 o	In the line beginning with "normal balk", the fields are as follows:
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index b0b814d..60740e8 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -836,7 +836,6 @@ Provides counts of softirq handlers serviced since boot time, for each cpu.
  TASKLET:          0          0          0        290
    SCHED:      27035      26983      26971      26746
  HRTIMER:          0          0          0          0
-     RCU:       1678       1769       2178       2250
 
 
 1.3 IDE devices in /proc/ide
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index bea0ac7..6c12989 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -414,7 +414,6 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
-	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
 };
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ff422d2..c7aeacf 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,6 +47,18 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+extern void rcutorture_record_test_transition(void);
+extern void rcutorture_record_progress(unsigned long vernum);
+#else
+static inline void rcutorture_record_test_transition(void)
+{
+}
+static inline void rcutorture_record_progress(unsigned long vernum)
+{
+}
+#endif
+
 #define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
 #define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
@@ -68,7 +80,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
-extern int sched_expedited_torture_stats(char *page);
 
 static inline void __rcu_read_lock_bh(void)
 {
@@ -774,6 +785,7 @@ extern struct debug_obj_descr rcuhead_debug_descr;
 
 static inline void debug_rcu_head_queue(struct rcu_head *head)
 {
+	WARN_ON_ONCE((unsigned long)head & 0x3);
 	debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3a93348..284dad1 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -58,9 +58,12 @@ static inline void synchronize_rcu_bh_expedited(void)
 
 extern void rcu_barrier(void);
 
+extern unsigned long rcutorture_testseq;
+extern unsigned long rcutorture_vernum;
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
+
 extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 1c09820..ae045ca 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -20,8 +20,7 @@ struct softirq_action;
 			 softirq_name(BLOCK_IOPOLL),	\
 			 softirq_name(TASKLET),		\
 			 softirq_name(SCHED),		\
-			 softirq_name(HRTIMER),		\
-			 softirq_name(RCU))
+			 softirq_name(HRTIMER))
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..8fc00ef 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -485,7 +485,7 @@ config TREE_RCU_TRACE
 
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
-	depends on RT_MUTEXES && TINY_PREEMPT_RCU
+	depends on RT_MUTEXES && PREEMPT_RCU
 	default n
 	help
 	  This option boosts the priority of preempted RCU readers that
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f3240e9..7784bd2 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -142,10 +142,17 @@ static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON_ONCE(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
@@ -184,10 +191,17 @@ static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON_ONCE(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
@@ -214,15 +228,17 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
 		 * Ensure that queued callbacks are all executed.
 		 * If we detect that we are nested in a RCU read-side critical
 		 * section, we should simply fail, otherwise we would deadlock.
-		 * Note that the machinery to reliably determine whether
-		 * or not we are in an RCU read-side critical section
-		 * exists only in the preemptible RCU implementations
-		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
-		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
+		 * In !PREEMPT configurations, there is no way to tell if we are
+		 * in a RCU read-side critical section or not, so we never
+		 * attempt any fixup and just print a warning.
 		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON_ONCE(1);
+		return 0;
+#endif
 		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
 		    irqs_disabled()) {
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			return 0;
 		}
 		rcu_barrier();
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index c224da4..60984262 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -131,7 +131,7 @@ struct rcu_torture {
 
 static LIST_HEAD(rcu_torture_freelist);
 static struct rcu_torture __rcu *rcu_torture_current;
-static long rcu_torture_current_version;
+static unsigned long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
 static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
@@ -163,11 +163,11 @@ static int stutter_pause_test;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
-#ifdef CONFIG_RCU_BOOST
+#if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
 #define rcu_can_boost() 1
-#else /* #ifdef CONFIG_RCU_BOOST */
+#else /* #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 #define rcu_can_boost() 0
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
+#endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
@@ -751,6 +751,7 @@ static int rcu_torture_boost(void *arg)
 		n_rcu_torture_boost_rterror++;
 	}
 
+	init_rcu_head_on_stack(&rbi.rcu);
 	/* Each pass through the following loop does one boost-test cycle. */
 	do {
 		/* Wait for the next test interval. */
@@ -810,6 +811,7 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 
 	/* Clean up and exit. */
 	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
+	destroy_rcu_head_on_stack(&rbi.rcu);
 	rcutorture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
@@ -886,7 +888,7 @@ rcu_torture_writer(void *arg)
 			old_rp->rtort_pipe_count++;
 			cur_ops->deferred_free(old_rp);
 		}
-		rcu_torture_current_version++;
+		rcutorture_record_progress(++rcu_torture_current_version);
 		oldbatch = cur_ops->completed();
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
@@ -1066,8 +1068,8 @@ rcu_torture_printk(char *page)
 	}
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
-		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
+		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
+		       "rtmbe: %d rtbke: %ld rtbre: %ld "
 		       "rtbf: %ld rtb: %ld nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
@@ -1078,8 +1080,6 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
 		       n_rcu_torture_boost_rterror,
-		       n_rcu_torture_boost_allocerror,
-		       n_rcu_torture_boost_afferror,
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
@@ -1331,6 +1331,7 @@ rcu_torture_cleanup(void)
 	int i;
 
 	mutex_lock(&fullstop_mutex);
+	rcutorture_record_test_transition();
 	if (fullstop == FULLSTOP_SHUTDOWN) {
 		printk(KERN_WARNING /* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
@@ -1624,6 +1625,7 @@ rcu_torture_init(void)
 		}
 	}
 	register_reboot_notifier(&rcutorture_shutdown_nb);
+	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd4aea8..05ef3a9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -47,6 +47,8 @@
 #include <linux/mutex.h>
 #include <linux/time.h>
 #include <linux/kernel_stat.h>
+#include <linux/wait.h>
+#include <linux/kthread.h>
 
 #include "rcutree.h"
 
@@ -79,10 +81,39 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+static struct rcu_state *rcu_state;
+
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 /*
+ * Control variables for per-CPU and per-rcu_node kthreads.  These
+ * handle all flavors of RCU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
+DEFINE_PER_CPU(char, rcu_cpu_has_work);
+static char rcu_kthreads_spawnable;
+
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
+static void invoke_rcu_cpu_kthread(void);
+
+#define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
+
+/*
+ * Track the rcutorture test sequence number and the update version
+ * number within a given test.  The rcutorture_testseq is incremented
+ * on every rcutorture module load and unload, so has an odd value
+ * when a test is running.  The rcutorture_vernum is set to zero
+ * when rcutorture starts and is incremented on each rcutorture update.
+ * These variables enable correlating rcutorture output with the
+ * RCU tracing information.
+ */
+unsigned long rcutorture_testseq;
+unsigned long rcutorture_vernum;
+
+/*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
  * structure's ->lock, but of course results can be subject to change.
@@ -128,7 +159,7 @@ void rcu_note_context_switch(int cpu)
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
-	.dynticks = 1,
+	.dynticks = ATOMIC_INIT(1),
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
@@ -140,10 +171,8 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-int rcu_cpu_stall_suppress __read_mostly = RCU_CPU_STALL_SUPPRESS_INIT;
+int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
@@ -176,6 +205,31 @@ void rcu_bh_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
 /*
+ * Record the number of times rcutorture tests have been initiated and
+ * terminated.  This information allows the debugfs tracing stats to be
+ * correlated to the rcutorture messages, even when the rcutorture module
+ * is being repeatedly loaded and unloaded.  In other words, we cannot
+ * store this state in rcutorture itself.
+ */
+void rcutorture_record_test_transition(void)
+{
+	rcutorture_testseq++;
+	rcutorture_vernum = 0;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
+
+/*
+ * Record the number of writer passes through the current rcutorture test.
+ * This is also used to correlate debugfs tracing stats with the rcutorture
+ * messages.
+ */
+void rcutorture_record_progress(unsigned long vernum)
+{
+	rcutorture_vernum++;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_progress);
+
+/*
  * Force a quiescent state for RCU-sched.
  */
 void rcu_sched_force_quiescent_state(void)
@@ -264,13 +318,25 @@ void rcu_enter_nohz(void)
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	rdtp->dynticks++;
-	rdtp->dynticks_nesting--;
-	WARN_ON_ONCE(rdtp->dynticks & 0x1);
+	if (--rdtp->dynticks_nesting) {
+		local_irq_restore(flags);
+		return;
+	}
+	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
+	smp_mb__before_atomic_inc();  /* See above. */
+	atomic_inc(&rdtp->dynticks);
+	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 	local_irq_restore(flags);
+
+	/* If the interrupt queued a callback, get out of dyntick mode. */
+	if (in_irq() &&
+	    (__get_cpu_var(rcu_sched_data).nxtlist ||
+	     __get_cpu_var(rcu_bh_data).nxtlist ||
+	     rcu_preempt_needs_cpu(smp_processor_id())))
+		set_need_resched();
 }
 
 /*
@@ -286,11 +352,16 @@ void rcu_exit_nohz(void)
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	rdtp->dynticks++;
-	rdtp->dynticks_nesting++;
-	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
+	if (rdtp->dynticks_nesting++) {
+		local_irq_restore(flags);
+		return;
+	}
+	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
+	atomic_inc(&rdtp->dynticks);
+	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
+	smp_mb__after_atomic_inc();  /* See above. */
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	local_irq_restore(flags);
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
 /**
@@ -304,11 +375,15 @@ void rcu_nmi_enter(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks & 0x1)
+	if (rdtp->dynticks_nmi_nesting == 0 &&
+	    (atomic_read(&rdtp->dynticks) & 0x1))
 		return;
-	rdtp->dynticks_nmi++;
-	WARN_ON_ONCE(!(rdtp->dynticks_nmi & 0x1));
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+	rdtp->dynticks_nmi_nesting++;
+	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
+	atomic_inc(&rdtp->dynticks);
+	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
+	smp_mb__after_atomic_inc();  /* See above. */
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 }
 
 /**
@@ -322,11 +397,14 @@ void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks & 0x1)
+	if (rdtp->dynticks_nmi_nesting == 0 ||
+	    --rdtp->dynticks_nmi_nesting != 0)
 		return;
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	rdtp->dynticks_nmi++;
-	WARN_ON_ONCE(rdtp->dynticks_nmi & 0x1);
+	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
+	smp_mb__before_atomic_inc();  /* See above. */
+	atomic_inc(&rdtp->dynticks);
+	smp_mb__after_atomic_inc();  /* Force delay to next write. */
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
 /**
@@ -337,13 +415,7 @@ void rcu_nmi_exit(void)
  */
 void rcu_irq_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
-
-	if (rdtp->dynticks_nesting++)
-		return;
-	rdtp->dynticks++;
-	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+	rcu_exit_nohz();
 }
 
 /**
@@ -355,18 +427,7 @@ void rcu_irq_enter(void)
  */
 void rcu_irq_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
-
-	if (--rdtp->dynticks_nesting)
-		return;
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	rdtp->dynticks++;
-	WARN_ON_ONCE(rdtp->dynticks & 0x1);
-
-	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (__this_cpu_read(rcu_sched_data.nxtlist) ||
-	    __this_cpu_read(rcu_bh_data.nxtlist))
-		set_need_resched();
+	rcu_enter_nohz();
 }
 
 #ifdef CONFIG_SMP
@@ -378,19 +439,8 @@ void rcu_irq_exit(void)
  */
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
-	int ret;
-	int snap;
-	int snap_nmi;
-
-	snap = rdp->dynticks->dynticks;
-	snap_nmi = rdp->dynticks->dynticks_nmi;
-	smp_mb();	/* Order sampling of snap with end of grace period. */
-	rdp->dynticks_snap = snap;
-	rdp->dynticks_nmi_snap = snap_nmi;
-	ret = ((snap & 0x1) == 0) && ((snap_nmi & 0x1) == 0);
-	if (ret)
-		rdp->dynticks_fqs++;
-	return ret;
+	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+	return 0;
 }
 
 /*
@@ -401,16 +451,11 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
-	long curr;
-	long curr_nmi;
-	long snap;
-	long snap_nmi;
+	unsigned long curr;
+	unsigned long snap;
 
-	curr = rdp->dynticks->dynticks;
-	snap = rdp->dynticks_snap;
-	curr_nmi = rdp->dynticks->dynticks_nmi;
-	snap_nmi = rdp->dynticks_nmi_snap;
-	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+	curr = (unsigned long)atomic_add_return(0, &rdp->dynticks->dynticks);
+	snap = (unsigned long)rdp->dynticks_snap;
 
 	/*
 	 * If the CPU passed through or entered a dynticks idle phase with
@@ -420,8 +465,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * read-side critical section that started before the beginning
 	 * of the current RCU grace period.
 	 */
-	if ((curr != snap || (curr & 0x1) == 0) &&
-	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
+	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -450,8 +494,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -587,26 +629,6 @@ static void __init check_cpu_stall_init(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
 }
 
-#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-static void record_gp_stall_check_time(struct rcu_state *rsp)
-{
-}
-
-static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-}
-
-void rcu_cpu_stall_reset(void)
-{
-}
-
-static void __init check_cpu_stall_init(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
@@ -809,6 +831,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
+		rcu_preempt_boost_start_gp(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -844,6 +867,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
+		rcu_preempt_boost_start_gp(rnp);
 		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -864,7 +888,18 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
+	unsigned long gp_duration;
+
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
+
+	/*
+	 * Ensure that all grace-period and pre-grace-period activity
+	 * is seen before the assignment to rsp->completed.
+	 */
+	smp_mb(); /* See above block comment. */
+	gp_duration = jiffies - rsp->gp_start;
+	if (gp_duration > rsp->gp_max)
+		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -894,7 +929,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
-		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+		if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 
 			/* Other bits still set at this level, so done. */
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1037,6 +1072,8 @@ static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 /*
  * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
  * and move all callbacks from the outgoing CPU to the current one.
+ * There can only be one CPU hotplug operation at a time, so no other
+ * CPU can be attempting to update rcu_cpu_kthread_task.
  */
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
@@ -1045,6 +1082,14 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
+	struct task_struct *t;
+
+	/* Stop the CPU's kthread. */
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t != NULL) {
+		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
+		kthread_stop(t);
+	}
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -1082,6 +1127,22 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
+
+	/*
+	 * If there are no more online CPUs for this rcu_node structure,
+	 * kill the rcu_node structure's kthread.  Otherwise, adjust its
+	 * affinity.
+	 */
+	t = rnp->node_kthread_task;
+	if (t != NULL &&
+	    rnp->qsmaskinit == 0) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rnp->node_kthread_task = NULL;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		kthread_stop(t);
+		rcu_stop_boost_kthread(rnp);
+	} else
+		rcu_node_kthread_setaffinity(rnp, -1);
 }
 
 /*
@@ -1179,7 +1240,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cpu_kthread();
 }
 
 /*
@@ -1225,7 +1286,7 @@ void rcu_check_callbacks(int cpu, int user)
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cpu_kthread();
 }
 
 #ifdef CONFIG_SMP
@@ -1233,6 +1294,8 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
+ * Also initiate boosting for any threads blocked on the root rcu_node.
+ *
  * The caller must have suppressed start of new grace periods.
  */
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
@@ -1251,6 +1314,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 			return;
 		}
 		if (rnp->qsmask == 0) {
+			rcu_initiate_boost(rnp);
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
 		}
@@ -1269,6 +1333,11 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
+	rnp = rcu_get_root(rsp);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (rnp->qsmask == 0)
+		rcu_initiate_boost(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -1389,31 +1458,358 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Do softirq processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
-	/*
-	 * Memory references from any prior RCU read-side critical sections
-	 * executed by the interrupted code must be seen before any RCU
-	 * grace-period manipulations below.
-	 */
-	smp_mb(); /* See above block comment. */
-
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
 
-	/*
-	 * Memory references from any later RCU read-side critical sections
-	 * executed by the interrupted code must be seen after any RCU
-	 * grace-period manipulations above.
-	 */
-	smp_mb(); /* See above block comment. */
-
 	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
 	rcu_needs_cpu_flush();
 }
 
+/*
+ * Wake up the current CPU's kthread.  This replaces raise_softirq()
+ * in earlier versions of RCU.  Note that because we are running on
+ * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
+ * cannot disappear out from under us.
+ */
+static void invoke_rcu_cpu_kthread(void)
+{
+	unsigned long flags;
+	wait_queue_head_t *q;
+	int cpu;
+
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	per_cpu(rcu_cpu_has_work, cpu) = 1;
+	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
+		local_irq_restore(flags);
+		return;
+	}
+	q = &per_cpu(rcu_cpu_wq, cpu);
+	wake_up(q);
+	local_irq_restore(flags);
+}
+
+/*
+ * Wake up the specified per-rcu_node-structure kthread.
+ * The caller must hold ->lock.
+ */
+static void invoke_rcu_node_kthread(struct rcu_node *rnp)
+{
+	struct task_struct *t;
+
+	t = rnp->node_kthread_task;
+	if (t != NULL)
+		wake_up_process(t);
+}
+
+/*
+ * Set the specified CPU's kthread to run RT or not, as specified by
+ * the to_rt argument.  The CPU-hotplug locks are held, so the task
+ * is not going away.
+ */
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+{
+	int policy;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t == NULL)
+		return;
+	if (to_rt) {
+		policy = SCHED_NORMAL;
+		sp.sched_priority = RCU_KTHREAD_PRIO;
+	} else {
+		policy = SCHED_FIFO;
+		sp.sched_priority = 0;
+	}
+	sched_setscheduler_nocheck(t, policy, &sp);
+}
+
+/*
+ * Timer handler to initiate the waking up of per-CPU kthreads that
+ * have yielded the CPU due to excess numbers of RCU callbacks.
+ * We wake up the per-rcu_node kthread, which in turn will wake up
+ * the booster kthread.
+ */
+static void rcu_cpu_kthread_timer(unsigned long arg)
+{
+	unsigned long flags;
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
+	struct rcu_node *rnp = rdp->mynode;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	rnp->wakemask |= rdp->grpmask;
+	invoke_rcu_node_kthread(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Drop to non-real-time priority and yield, but only after posting a
+ * timer that will cause us to regain our real-time priority if we
+ * remain preempted.  Either way, we restore our real-time priority
+ * before returning.
+ */
+static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
+{
+	struct sched_param sp;
+	struct timer_list yield_timer;
+
+	setup_timer(&yield_timer, f, arg);
+	mod_timer(&yield_timer, jiffies + 2);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
+	schedule();
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+	del_timer(&yield_timer);
+}
+
+/*
+ * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
+ * This can happen while the corresponding CPU is either coming online
+ * or going offline.  We cannot wait until the CPU is fully online
+ * before starting the kthread, because the various notifier functions
+ * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
+ * the corresponding CPU is online.
+ *
+ * Return 1 if the kthread needs to stop, 0 otherwise.
+ *
+ * Caller must disable bh.  This function can momentarily enable it.
+ */
+static int rcu_cpu_kthread_should_stop(int cpu)
+{
+	while (cpu_is_offline(cpu) ||
+	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
+	       smp_processor_id() != cpu) {
+		if (kthread_should_stop())
+			return 1;
+		local_bh_enable();
+		schedule_timeout_uninterruptible(1);
+		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
+			set_cpus_allowed_ptr(current, cpumask_of(cpu));
+		local_bh_disable();
+	}
+	return 0;
+}
+
+/*
+ * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
+ * earlier RCU softirq.
+ */
+static int rcu_cpu_kthread(void *arg)
+{
+	int cpu = (int)(long)arg;
+	unsigned long flags;
+	int spincnt = 0;
+	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
+	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
+	char work;
+	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
+
+	for (;;) {
+		*statusp = RCU_KTHREAD_WAITING;
+		wait_event_interruptible(*wqp,
+					 *workp != 0 || kthread_should_stop());
+		local_bh_disable();
+		if (rcu_cpu_kthread_should_stop(cpu)) {
+			local_bh_enable();
+			break;
+		}
+		*statusp = RCU_KTHREAD_RUNNING;
+		local_irq_save(flags);
+		work = *workp;
+		*workp = 0;
+		local_irq_restore(flags);
+		if (work)
+			rcu_process_callbacks();
+		local_bh_enable();
+		if (*workp != 0)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			*statusp = RCU_KTHREAD_YIELDING;
+			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
+			spincnt = 0;
+		}
+	}
+	*statusp = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Spawn a per-CPU kthread, setting up affinity and priority.
+ * Because the CPU hotplug lock is held, no other CPU will be attempting
+ * to manipulate rcu_cpu_kthread_task.  There might be another CPU
+ * attempting to access it during boot, but the locking in kthread_bind()
+ * will enforce sufficient ordering.
+ */
+static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
+{
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
+		return 0;
+	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	kthread_bind(t, cpu);
+	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
+	per_cpu(rcu_cpu_kthread_task, cpu) = t;
+	wake_up_process(t);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
+}
+
+/*
+ * Per-rcu_node kthread, which is in charge of waking up the per-CPU
+ * kthreads when needed.  We ignore requests to wake up kthreads
+ * for offline CPUs, which is OK because force_quiescent_state()
+ * takes care of this case.
+ */
+static int rcu_node_kthread(void *arg)
+{
+	int cpu;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	for (;;) {
+		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
+		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
+						       kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		mask = rnp->wakemask;
+		rnp->wakemask = 0;
+		rcu_initiate_boost(rnp);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
+			if ((mask & 0x1) == 0)
+				continue;
+			preempt_disable();
+			t = per_cpu(rcu_cpu_kthread_task, cpu);
+			if (!cpu_online(cpu) || t == NULL) {
+				preempt_enable();
+				continue;
+			}
+			per_cpu(rcu_cpu_has_work, cpu) = 1;
+			sp.sched_priority = RCU_KTHREAD_PRIO;
+			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+			preempt_enable();
+		}
+	}
+	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Set the per-rcu_node kthread's affinity to cover all CPUs that are
+ * served by the rcu_node in question.  The CPU hotplug lock is still
+ * held, so the value of rnp->qsmaskinit will be stable.
+ *
+ * We don't include outgoingcpu in the affinity set, use -1 if there is
+ * no outgoing CPU.  If there are no CPUs left in the affinity set,
+ * this function allows the kthread to execute on any CPU.
+ */
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
+{
+	cpumask_var_t cm;
+	int cpu;
+	unsigned long mask = rnp->qsmaskinit;
+
+	if (rnp->node_kthread_task == NULL || mask == 0)
+		return;
+	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
+		return;
+	cpumask_clear(cm);
+	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
+		if ((mask & 0x1) && cpu != outgoingcpu)
+			cpumask_set_cpu(cpu, cm);
+	if (cpumask_weight(cm) == 0) {
+		cpumask_setall(cm);
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
+			cpumask_clear_cpu(cpu, cm);
+		WARN_ON_ONCE(cpumask_weight(cm) == 0);
+	}
+	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
+	rcu_boost_kthread_setaffinity(rnp, cm);
+	free_cpumask_var(cm);
+}
+
+/*
+ * Spawn a per-rcu_node kthread, setting priority and affinity.
+ * Called during boot before online/offline can happen, or, if
+ * during runtime, with the main CPU-hotplug locks held.  So only
+ * one of these can be executing at a time.
+ */
+static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
+						struct rcu_node *rnp)
+{
+	unsigned long flags;
+	int rnp_index = rnp - &rsp->node[0];
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    rnp->qsmaskinit == 0)
+		return 0;
+	if (rnp->node_kthread_task == NULL) {
+		t = kthread_create(rcu_node_kthread, (void *)rnp,
+				   "rcun%d", rnp_index);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rnp->node_kthread_task = t;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		wake_up_process(t);
+		sp.sched_priority = 99;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	}
+	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
+}
+
+/*
+ * Spawn all kthreads -- called as soon as the scheduler is running.
+ */
+static int __init rcu_spawn_kthreads(void)
+{
+	int cpu;
+	struct rcu_node *rnp;
+
+	rcu_kthreads_spawnable = 1;
+	for_each_possible_cpu(cpu) {
+		init_waitqueue_head(&per_cpu(rcu_cpu_wq, cpu));
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+		if (cpu_online(cpu))
+			(void)rcu_spawn_one_cpu_kthread(cpu);
+	}
+	rnp = rcu_get_root(rcu_state);
+	init_waitqueue_head(&rnp->node_wq);
+	rcu_init_boost_waitqueue(rnp);
+	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	if (NUM_RCU_NODES > 1)
+		rcu_for_each_leaf_node(rcu_state, rnp) {
+			init_waitqueue_head(&rnp->node_wq);
+			rcu_init_boost_waitqueue(rnp);
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+		}
+	return 0;
+}
+early_initcall(rcu_spawn_kthreads);
+
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	   struct rcu_state *rsp)
@@ -1813,6 +2209,19 @@ static void __cpuinit rcu_online_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
+static void __cpuinit rcu_online_kthreads(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
+
+	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
+	if (rcu_kthreads_spawnable) {
+		(void)rcu_spawn_one_cpu_kthread(cpu);
+		if (rnp->node_kthread_task == NULL)
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	}
+}
+
 /*
  * Handle CPU online/offline notification events.
  */
@@ -1820,11 +2229,23 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
+		rcu_online_kthreads(cpu);
+		break;
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		rcu_node_kthread_setaffinity(rnp, -1);
+		rcu_cpu_kthread_setrt(cpu, 1);
+		break;
+	case CPU_DOWN_PREPARE:
+		rcu_node_kthread_setaffinity(rnp, cpu);
+		rcu_cpu_kthread_setrt(cpu, 0);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -1943,10 +2364,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 					      j / rsp->levelspread[i - 1];
 			}
 			rnp->level = i;
-			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[2]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
+			INIT_LIST_HEAD(&rnp->blkd_tasks);
 		}
 	}
 
@@ -1968,7 +2386,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e8f057e..346a676 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,13 +84,18 @@
  * Dynticks per-CPU state.
  */
 struct rcu_dynticks {
-	int dynticks_nesting;	/* Track nesting level, sort of. */
-	int dynticks;		/* Even value for dynticks-idle, else odd. */
-	int dynticks_nmi;	/* Even value for either dynticks-idle or */
-				/*  not in nmi handler, else odd.  So this */
-				/*  remains even for nmi from irq handler. */
+	int dynticks_nesting;	/* Track irq/process nesting level. */
+	int dynticks_nmi_nesting; /* Track NMI nesting level. */
+	atomic_t dynticks;	/* Even value for dynticks-idle, else odd. */
 };
 
+/* RCU's kthread states for tracing. */
+#define RCU_KTHREAD_STOPPED  0
+#define RCU_KTHREAD_RUNNING  1
+#define RCU_KTHREAD_WAITING  2
+#define RCU_KTHREAD_YIELDING 3
+#define RCU_KTHREAD_MAX      3
+
 /*
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
@@ -109,10 +114,11 @@ struct rcu_node {
 				/*  an rcu_data structure, otherwise, each */
 				/*  bit corresponds to a child rcu_node */
 				/*  structure. */
-	unsigned long expmask;	/* Groups that have ->blocked_tasks[] */
+	unsigned long expmask;	/* Groups that have ->blkd_tasks */
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
+	unsigned long wakemask; /* CPUs whose kthread needs to be awakened. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
@@ -122,11 +128,68 @@ struct rcu_node {
 	u8	grpnum;		/* CPU/group number for next level up. */
 	u8	level;		/* root is at level 0. */
 	struct rcu_node *parent;
-	struct list_head blocked_tasks[4];
-				/* Tasks blocked in RCU read-side critsect. */
-				/*  Grace period number (->gpnum) x blocked */
-				/*  by tasks on the (x & 0x1) element of the */
-				/*  blocked_tasks[] array. */
+	struct list_head blkd_tasks;
+				/* Tasks blocked in RCU read-side critical */
+				/*  section.  Tasks are placed at the head */
+				/*  of this list and age towards the tail. */
+	struct list_head *gp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current grace period, or NULL if there */
+				/*  is no such task. */
+	struct list_head *exp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current expedited grace period, or NULL */
+				/*  if there is no such task.  If there */
+				/*  is no current expedited grace period, */
+				/*  then there can cannot be any such task. */
+#ifdef CONFIG_RCU_BOOST
+	struct list_head *boost_tasks;
+				/* Pointer to first task that needs to be */
+				/*  priority boosted, or NULL if no priority */
+				/*  boosting is needed for this rcu_node */
+				/*  structure.  If there are no tasks */
+				/*  queued on this rcu_node structure that */
+				/*  are blocking the current grace period, */
+				/*  there can be no such task. */
+	unsigned long boost_time;
+				/* When to start boosting (jiffies). */
+	struct task_struct *boost_kthread_task;
+				/* kthread that takes care of priority */
+				/*  boosting for this rcu_node structure. */
+	wait_queue_head_t boost_wq;
+				/* Wait queue on which to park the boost */
+				/*  kthread. */
+	unsigned int boost_kthread_status;
+				/* State of boost_kthread_task for tracing. */
+	unsigned long n_tasks_boosted;
+				/* Total number of tasks boosted. */
+	unsigned long n_exp_boosts;
+				/* Number of tasks boosted for expedited GP. */
+	unsigned long n_normal_boosts;
+				/* Number of tasks boosted for normal GP. */
+	unsigned long n_balk_blkd_tasks;
+				/* Refused to boost: no blocked tasks. */
+	unsigned long n_balk_exp_gp_tasks;
+				/* Refused to boost: nothing blocking GP. */
+	unsigned long n_balk_boost_tasks;
+				/* Refused to boost: already boosting. */
+	unsigned long n_balk_notblocked;
+				/* Refused to boost: RCU RS CS still running. */
+	unsigned long n_balk_notyet;
+				/* Refused to boost: not yet time. */
+	unsigned long n_balk_nos;
+				/* Refused to boost: not sure why, though. */
+				/*  This can happen due to race conditions. */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	struct task_struct *node_kthread_task;
+				/* kthread that takes care of this rcu_node */
+				/*  structure, for example, awakening the */
+				/*  per-CPU kthreads as needed. */
+	wait_queue_head_t node_wq;
+				/* Wait queue on which to park the per-node */
+				/*  kthread. */
+	unsigned int node_kthread_status;
+				/* State of node_kthread_task for tracing. */
 } ____cacheline_internodealigned_in_smp;
 
 /*
@@ -218,7 +281,6 @@ struct rcu_data {
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
 #endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
@@ -254,7 +316,6 @@ struct rcu_data {
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA	       (5 * HZ)
@@ -272,13 +333,6 @@ struct rcu_data {
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
-#define RCU_CPU_STALL_SUPPRESS_INIT 0
-#else
-#define RCU_CPU_STALL_SUPPRESS_INIT 1
-#endif
-
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
@@ -325,12 +379,12 @@ struct rcu_state {
 						/*  due to lock unavailable. */
 	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
 						/*  due to no GP active. */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	unsigned long gp_start;			/* Time at which GP started, */
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+	unsigned long gp_max;			/* Maximum GP duration in */
+						/*  jiffies. */
 	char *name;				/* Name of structure. */
 };
 
@@ -361,16 +415,14 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
-static int rcu_preempted_readers(struct rcu_node *rnp);
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_stall_reset(void);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
@@ -390,5 +442,16 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
+static void rcu_initiate_boost(struct rcu_node *rnp);
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm);
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index);
+#ifdef CONFIG_HOTPLUG_CPU
+static void rcu_stop_boost_kthread(struct rcu_node *rnp);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a363871..a21413d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -54,10 +54,6 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
-#ifndef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO
-	       "\tRCU-based detection of stalled CPUs is disabled.\n");
-#endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
@@ -70,6 +66,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+static struct rcu_state *rcu_state = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
@@ -134,12 +131,12 @@ static void rcu_preempt_qs(int cpu)
  * We have entered the scheduler, and the current task might soon be
  * context-switched away from.  If this task is in an RCU read-side
  * critical section, we will no longer be able to rely on the CPU to
- * record that fact, so we enqueue the task on the appropriate entry
- * of the blocked_tasks[] array.  The task will dequeue itself when
- * it exits the outermost enclosing RCU read-side critical section.
- * Therefore, the current grace period cannot be permitted to complete
- * until the blocked_tasks[] entry indexed by the low-order bit of
- * rnp->gpnum empties.
+ * record that fact, so we enqueue the task on the blkd_tasks list.
+ * The task will dequeue itself when it exits the outermost enclosing
+ * RCU read-side critical section.  Therefore, the current grace period
+ * cannot be permitted to complete until the blkd_tasks list entries
+ * predating the current grace period drain, in other words, until
+ * rnp->gp_tasks becomes NULL.
  *
  * Caller must disable preemption.
  */
@@ -147,7 +144,6 @@ static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
-	int phase;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
@@ -169,15 +165,30 @@ static void rcu_preempt_note_context_switch(int cpu)
 		 * (i.e., this CPU has not yet passed through a quiescent
 		 * state for the current grace period), then as long
 		 * as that task remains queued, the current grace period
-		 * cannot end.
+		 * cannot end.  Note that there is some uncertainty as
+		 * to exactly when the current grace period started.
+		 * We take a conservative approach, which can result
+		 * in unnecessarily waiting on tasks that started very
+		 * slightly after the current grace period began.  C'est
+		 * la vie!!!
 		 *
 		 * But first, note that the current CPU must still be
 		 * on line!
 		 */
 		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
 		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
-		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
-		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
+		if ((rnp->qsmask & rdp->grpmask) && rnp->gp_tasks != NULL) {
+			list_add(&t->rcu_node_entry, rnp->gp_tasks->prev);
+			rnp->gp_tasks = &t->rcu_node_entry;
+#ifdef CONFIG_RCU_BOOST
+			if (rnp->boost_tasks != NULL)
+				rnp->boost_tasks = rnp->gp_tasks;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+		} else {
+			list_add(&t->rcu_node_entry, &rnp->blkd_tasks);
+			if (rnp->qsmask & rdp->grpmask)
+				rnp->gp_tasks = &t->rcu_node_entry;
+		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
@@ -212,12 +223,9 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
  */
-static int rcu_preempted_readers(struct rcu_node *rnp)
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
-	int phase = rnp->gpnum & 0x1;
-
-	return !list_empty(&rnp->blocked_tasks[phase]) ||
-	       !list_empty(&rnp->blocked_tasks[phase + 2]);
+	return rnp->gp_tasks != NULL;
 }
 
 /*
@@ -233,7 +241,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	unsigned long mask;
 	struct rcu_node *rnp_p;
 
-	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+	if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;  /* Still need more quiescent states! */
 	}
@@ -257,6 +265,21 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
+ * Advance a ->blkd_tasks-list pointer to the next entry, instead
+ * returning NULL if at the end of the list.
+ */
+static struct list_head *rcu_next_node_entry(struct task_struct *t,
+					     struct rcu_node *rnp)
+{
+	struct list_head *np;
+
+	np = t->rcu_node_entry.next;
+	if (np == &rnp->blkd_tasks)
+		np = NULL;
+	return np;
+}
+
+/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
@@ -266,6 +289,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	int empty;
 	int empty_exp;
 	unsigned long flags;
+	struct list_head *np;
 	struct rcu_node *rnp;
 	int special;
 
@@ -306,10 +330,19 @@ static void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
-		empty = !rcu_preempted_readers(rnp);
+		empty = !rcu_preempt_blocked_readers_cgp(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
+		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		if (&t->rcu_node_entry == rnp->gp_tasks)
+			rnp->gp_tasks = np;
+		if (&t->rcu_node_entry == rnp->exp_tasks)
+			rnp->exp_tasks = np;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rnp->boost_tasks)
+			rnp->boost_tasks = np;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		t->rcu_blocked_node = NULL;
 
 		/*
@@ -322,6 +355,15 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		else
 			rcu_report_unblock_qs_rnp(rnp, flags);
 
+#ifdef CONFIG_RCU_BOOST
+		/* Unboost if we were boosted. */
+		if (special & RCU_READ_UNLOCK_BOOSTED) {
+			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
+			rt_mutex_unlock(t->rcu_boost_mutex);
+			t->rcu_boost_mutex = NULL;
+		}
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 		/*
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
@@ -356,8 +398,6 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
 /*
@@ -367,18 +407,16 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct list_head *lp;
-	int phase;
 	struct task_struct *t;
 
-	if (rcu_preempted_readers(rnp)) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		phase = rnp->gpnum & 0x1;
-		lp = &rnp->blocked_tasks[phase];
-		list_for_each_entry(t, lp, rcu_node_entry)
-			sched_show_task(t);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	}
+	if (!rcu_preempt_blocked_readers_cgp(rnp))
+		return;
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	t = list_entry(rnp->gp_tasks,
+		       struct task_struct, rcu_node_entry);
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+		sched_show_task(t);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -408,16 +446,14 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	struct list_head *lp;
-	int phase;
 	struct task_struct *t;
 
-	if (rcu_preempted_readers(rnp)) {
-		phase = rnp->gpnum & 0x1;
-		lp = &rnp->blocked_tasks[phase];
-		list_for_each_entry(t, lp, rcu_node_entry)
-			printk(" P%d", t->pid);
-	}
+	if (!rcu_preempt_blocked_readers_cgp(rnp))
+		return;
+	t = list_entry(rnp->gp_tasks,
+		       struct task_struct, rcu_node_entry);
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+		printk(" P%d", t->pid);
 }
 
 /*
@@ -430,18 +466,21 @@ static void rcu_preempt_stall_reset(void)
 	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Check that the list of blocked tasks for the newly completed grace
  * period is in fact empty.  It is a serious bug to complete a grace
  * period that still has RCU readers blocked!  This function must be
  * invoked -before- updating this rnp's ->gpnum, and the rnp's ->lock
  * must be held by the caller.
+ *
+ * Also, if there are blocked tasks on the list, they automatically
+ * block the newly created grace period, so set up ->gp_tasks accordingly.
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
-	WARN_ON_ONCE(rcu_preempted_readers(rnp));
+	WARN_ON_ONCE(rcu_preempt_blocked_readers_cgp(rnp));
+	if (!list_empty(&rnp->blkd_tasks))
+		rnp->gp_tasks = rnp->blkd_tasks.next;
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
@@ -465,45 +504,63 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp)
 {
-	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
 	int retval = 0;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
-	struct task_struct *tp;
+	struct task_struct *t;
 
 	if (rnp == rnp_root) {
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
 		return 0;  /* Shouldn't happen: at least one CPU online. */
 	}
-	WARN_ON_ONCE(rnp != rdp->mynode &&
-		     (!list_empty(&rnp->blocked_tasks[0]) ||
-		      !list_empty(&rnp->blocked_tasks[1]) ||
-		      !list_empty(&rnp->blocked_tasks[2]) ||
-		      !list_empty(&rnp->blocked_tasks[3])));
+
+	/* If we are on an internal node, complain bitterly. */
+	WARN_ON_ONCE(rnp != rdp->mynode);
 
 	/*
-	 * Move tasks up to root rcu_node.  Rely on the fact that the
-	 * root rcu_node can be at most one ahead of the rest of the
-	 * rcu_nodes in terms of gp_num value.  This fact allows us to
-	 * move the blocked_tasks[] array directly, element by element.
+	 * Move tasks up to root rcu_node.  Don't try to get fancy for
+	 * this corner-case operation -- just put this node's tasks
+	 * at the head of the root node's list, and update the root node's
+	 * ->gp_tasks and ->exp_tasks pointers to those of this node's,
+	 * if non-NULL.  This might result in waiting for more tasks than
+	 * absolutely necessary, but this is a good performance/complexity
+	 * tradeoff.
 	 */
-	if (rcu_preempted_readers(rnp))
+	if (rcu_preempt_blocked_readers_cgp(rnp))
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
-	for (i = 0; i < 4; i++) {
-		lp = &rnp->blocked_tasks[i];
-		lp_root = &rnp_root->blocked_tasks[i];
-		while (!list_empty(lp)) {
-			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
-			raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-			list_del(&tp->rcu_node_entry);
-			tp->rcu_blocked_node = rnp_root;
-			list_add(&tp->rcu_node_entry, lp_root);
-			raw_spin_unlock(&rnp_root->lock); /* irqs remain disabled */
-		}
+	lp = &rnp->blkd_tasks;
+	lp_root = &rnp_root->blkd_tasks;
+	while (!list_empty(lp)) {
+		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
+		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+		list_del(&t->rcu_node_entry);
+		t->rcu_blocked_node = rnp_root;
+		list_add(&t->rcu_node_entry, lp_root);
+		if (&t->rcu_node_entry == rnp->gp_tasks)
+			rnp_root->gp_tasks = rnp->gp_tasks;
+		if (&t->rcu_node_entry == rnp->exp_tasks)
+			rnp_root->exp_tasks = rnp->exp_tasks;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rnp->boost_tasks)
+			rnp_root->boost_tasks = rnp->boost_tasks;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 	}
+
+#ifdef CONFIG_RCU_BOOST
+	/* In case root is being boosted and leaf is not. */
+	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+	if (rnp_root->boost_tasks != NULL &&
+	    rnp_root->boost_tasks != rnp_root->gp_tasks)
+		rnp_root->boost_tasks = rnp_root->gp_tasks;
+	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+	rnp->gp_tasks = NULL;
+	rnp->exp_tasks = NULL;
 	return retval;
 }
 
@@ -594,8 +651,7 @@ static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
  */
 static int rcu_preempted_readers_exp(struct rcu_node *rnp)
 {
-	return !list_empty(&rnp->blocked_tasks[2]) ||
-	       !list_empty(&rnp->blocked_tasks[3]);
+	return rnp->exp_tasks != NULL;
 }
 
 /*
@@ -655,12 +711,14 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 static void
 sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	int must_wait;
+	int must_wait = 0;
 
 	raw_spin_lock(&rnp->lock); /* irqs already disabled */
-	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
-	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
-	must_wait = rcu_preempted_readers_exp(rnp);
+	if (!list_empty(&rnp->blkd_tasks)) {
+		rnp->exp_tasks = rnp->blkd_tasks.next;
+		rcu_initiate_boost(rnp);
+		must_wait = 1;
+	}
 	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 	if (!must_wait)
 		rcu_report_exp_rnp(rsp, rnp);
@@ -669,9 +727,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 /*
  * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
  * is to invoke synchronize_sched_expedited() to push all the tasks to
- * the ->blocked_tasks[] lists, move all entries from the first set of
- * ->blocked_tasks[] lists to the second set, and finally wait for this
- * second set to drain.
+ * the ->blkd_tasks lists and wait for this list to drain.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -703,7 +759,7 @@ void synchronize_rcu_expedited(void)
 	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
 		goto unlock_mb_ret; /* Others did our work for us. */
 
-	/* force all RCU readers onto blocked_tasks[]. */
+	/* force all RCU readers onto ->blkd_tasks lists. */
 	synchronize_sched_expedited();
 
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -715,7 +771,7 @@ void synchronize_rcu_expedited(void)
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
 
-	/* Snapshot current state of ->blocked_tasks[] lists. */
+	/* Snapshot current state of ->blkd_tasks lists. */
 	rcu_for_each_leaf_node(rsp, rnp)
 		sync_rcu_preempt_exp_init(rsp, rnp);
 	if (NUM_RCU_NODES > 1)
@@ -723,7 +779,7 @@ void synchronize_rcu_expedited(void)
 
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 
-	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
+	/* Wait for snapshotted ->blkd_tasks lists to drain. */
 	rnp = rcu_get_root(rsp);
 	wait_event(sync_rcu_preempt_exp_wq,
 		   sync_rcu_preempt_exp_done(rnp));
@@ -807,6 +863,8 @@ void exit_rcu(void)
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+static struct rcu_state *rcu_state = &rcu_sched_state;
+
 /*
  * Tell them what RCU they are running.
  */
@@ -847,7 +905,7 @@ static void rcu_preempt_note_context_switch(int cpu)
  * Because preemptable RCU does not exist, there are never any preempted
  * RCU readers.
  */
-static int rcu_preempted_readers(struct rcu_node *rnp)
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
 	return 0;
 }
@@ -862,8 +920,6 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 /*
  * Because preemptable RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
@@ -888,8 +944,6 @@ static void rcu_preempt_stall_reset(void)
 {
 }
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Because there is no preemptable RCU, there can be no readers blocked,
  * so there is no need to check for blocked tasks.  So check only for
@@ -1015,6 +1069,302 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+
+#include "rtmutex_common.h"
+
+#ifdef CONFIG_RCU_TRACE
+
+static void rcu_initiate_boost_trace(struct rcu_node *rnp)
+{
+	if (list_empty(&rnp->blkd_tasks))
+		rnp->n_balk_blkd_tasks++;
+	else if (rnp->exp_tasks == NULL && rnp->gp_tasks == NULL)
+		rnp->n_balk_exp_gp_tasks++;
+	else if (rnp->gp_tasks != NULL && rnp->boost_tasks != NULL)
+		rnp->n_balk_boost_tasks++;
+	else if (rnp->gp_tasks != NULL && rnp->qsmask != 0)
+		rnp->n_balk_notblocked++;
+	else if (rnp->gp_tasks != NULL &&
+		 ULONG_CMP_LT(jiffies, rnp->boost_time))
+		rnp->n_balk_notyet++;
+	else
+		rnp->n_balk_nos++;
+}
+
+#else /* #ifdef CONFIG_RCU_TRACE */
+
+static void rcu_initiate_boost_trace(struct rcu_node *rnp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+/*
+ * Carry out RCU priority boosting on the task indicated by ->exp_tasks
+ * or ->boost_tasks, advancing the pointer to the next task in the
+ * ->blkd_tasks list.
+ *
+ * Note that irqs must be enabled: boosting the task can block.
+ * Returns 1 if there are more tasks needing to be boosted.
+ */
+static int rcu_boost(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct rt_mutex mtx;
+	struct task_struct *t;
+	struct list_head *tb;
+
+	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
+		return 0;  /* Nothing left to boost. */
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+
+	/*
+	 * Recheck under the lock: all tasks in need of boosting
+	 * might exit their RCU read-side critical sections on their own.
+	 */
+	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return 0;
+	}
+
+	/*
+	 * Preferentially boost tasks blocking expedited grace periods.
+	 * This cannot starve the normal grace periods because a second
+	 * expedited grace period must boost all blocked tasks, including
+	 * those blocking the pre-existing normal grace period.
+	 */
+	if (rnp->exp_tasks != NULL) {
+		tb = rnp->exp_tasks;
+		rnp->n_exp_boosts++;
+	} else {
+		tb = rnp->boost_tasks;
+		rnp->n_normal_boosts++;
+	}
+	rnp->n_tasks_boosted++;
+
+	/*
+	 * We boost task t by manufacturing an rt_mutex that appears to
+	 * be held by task t.  We leave a pointer to that rt_mutex where
+	 * task t can find it, and task t will release the mutex when it
+	 * exits its outermost RCU read-side critical section.  Then
+	 * simply acquiring this artificial rt_mutex will boost task
+	 * t's priority.  (Thanks to tglx for suggesting this approach!)
+	 *
+	 * Note that task t must acquire rnp->lock to remove itself from
+	 * the ->blkd_tasks list, which it will do from exit() if from
+	 * nowhere else.  We therefore are guaranteed that task t will
+	 * stay around at least until we drop rnp->lock.  Note that
+	 * rnp->lock also resolves races between our priority boosting
+	 * and task t's exiting its outermost RCU read-side critical
+	 * section.
+	 */
+	t = container_of(tb, struct task_struct, rcu_node_entry);
+	rt_mutex_init_proxy_locked(&mtx, t);
+	t->rcu_boost_mutex = &mtx;
+	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
+	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+
+	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
+}
+
+/*
+ * Timer handler to initiate waking up of boost kthreads that
+ * have yielded the CPU due to excessive numbers of tasks to
+ * boost.  We wake up the per-rcu_node kthread, which in turn
+ * will wake up the booster kthread.
+ */
+static void rcu_boost_kthread_timer(unsigned long arg)
+{
+	unsigned long flags;
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	invoke_rcu_node_kthread(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Priority-boosting kthread.  One per leaf rcu_node and one for the
+ * root rcu_node.
+ */
+static int rcu_boost_kthread(void *arg)
+{
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+	int spincnt = 0;
+	int more2boost;
+
+	for (;;) {
+		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
+		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
+							rnp->exp_tasks ||
+							kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
+		more2boost = rcu_boost(rnp);
+		if (more2boost)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
+			spincnt = 0;
+		}
+	}
+	rnp->boost_kthread_status = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Check to see if it is time to start boosting RCU readers that are
+ * blocking the current grace period, and, if so, tell the per-rcu_node
+ * kthread to start boosting them.  If there is an expedited grace
+ * period in progress, it is always time to boost.
+ *
+ * The caller must hold rnp->lock.
+ */
+static void rcu_initiate_boost(struct rcu_node *rnp)
+{
+	struct task_struct *t;
+
+	if (!rcu_preempt_blocked_readers_cgp(rnp) && rnp->exp_tasks == NULL) {
+		rnp->n_balk_exp_gp_tasks++;
+		return;
+	}
+	if (rnp->exp_tasks != NULL ||
+	    (rnp->gp_tasks != NULL &&
+	     rnp->boost_tasks == NULL &&
+	     rnp->qsmask == 0 &&
+	     ULONG_CMP_GE(jiffies, rnp->boost_time))) {
+		if (rnp->exp_tasks == NULL)
+			rnp->boost_tasks = rnp->gp_tasks;
+		t = rnp->boost_kthread_task;
+		if (t != NULL)
+			wake_up_process(t);
+	} else
+		rcu_initiate_boost_trace(rnp);
+}
+
+/*
+ * Set the affinity of the boost kthread.  The CPU-hotplug locks are
+ * held, so no one should be messing with the existence of the boost
+ * kthread.
+ */
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm)
+{
+	struct task_struct *t;
+
+	t = rnp->boost_kthread_task;
+	if (t != NULL)
+		set_cpus_allowed_ptr(rnp->boost_kthread_task, cm);
+}
+
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
+
+/*
+ * Do priority-boost accounting for the start of a new grace period.
+ */
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
+{
+	rnp->boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
+}
+
+/*
+ * Initialize the RCU-boost waitqueue.
+ */
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
+{
+	init_waitqueue_head(&rnp->boost_wq);
+}
+
+/*
+ * Create an RCU-boost kthread for the specified node if one does not
+ * already exist.  We only create this kthread for preemptible RCU.
+ * Returns zero if all is well, a negated errno otherwise.
+ */
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index)
+{
+	unsigned long flags;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (&rcu_preempt_state != rsp)
+		return 0;
+	if (rnp->boost_kthread_task != NULL)
+		return 0;
+	t = kthread_create(rcu_boost_kthread, (void *)rnp,
+			   "rcub%d", rnp_index);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	rnp->boost_kthread_task = t;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	wake_up_process(t);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void rcu_stop_boost_kthread(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct task_struct *t;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	t = rnp->boost_kthread_task;
+	rnp->boost_kthread_task = NULL;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (t != NULL)
+		kthread_stop(t);
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static void rcu_initiate_boost(struct rcu_node *rnp)
+{
+}
+
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm)
+{
+}
+
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
+{
+}
+
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
+{
+}
+
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index)
+{
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void rcu_stop_boost_kthread(struct rcu_node *rnp)
+{
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 #ifndef CONFIG_SMP
 
 void synchronize_sched_expedited(void)
@@ -1187,14 +1537,13 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
- * raise_softirq() to cause rcu_process_callbacks() to be invoked later.
- * The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ * invoke_rcu_cpu_kthread() to cause rcu_process_callbacks() to be invoked
+ * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
 {
 	int c = 0;
 	int snap;
-	int snap_nmi;
 	int thatcpu;
 
 	/* Check for being in the holdoff period. */
@@ -1205,10 +1554,10 @@ int rcu_needs_cpu(int cpu)
 	for_each_online_cpu(thatcpu) {
 		if (thatcpu == cpu)
 			continue;
-		snap = per_cpu(rcu_dynticks, thatcpu).dynticks;
-		snap_nmi = per_cpu(rcu_dynticks, thatcpu).dynticks_nmi;
+		snap = atomic_add_return(0, &per_cpu(rcu_dynticks,
+						     thatcpu).dynticks);
 		smp_mb(); /* Order sampling of snap with end of grace period. */
-		if (((snap & 0x1) != 0) || ((snap_nmi & 0x1) != 0)) {
+		if ((snap & 0x1) != 0) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
@@ -1239,7 +1588,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cpu_kthread();
 	return c;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index c8e9785..f629dd4 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,16 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DECLARE_PER_CPU(char, rcu_cpu_has_work);
+
+static char convert_kthread_status(unsigned int kthread_status)
+{
+	if (kthread_status > RCU_KTHREAD_MAX)
+		return '?';
+	return "SRWY"[kthread_status];
+}
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -57,14 +67,26 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
-	seq_printf(m, " dt=%d/%d dn=%d df=%lu",
-		   rdp->dynticks->dynticks,
+	seq_printf(m, " dt=%d/%d/%d df=%lu",
+		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi,
+		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c b=%ld",
+		   rdp->qlen,
+		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
+		        rdp->nxttail[RCU_NEXT_TAIL]],
+		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
+		        rdp->nxttail[RCU_NEXT_READY_TAIL]],
+		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
+		        rdp->nxttail[RCU_WAIT_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   per_cpu(rcu_cpu_has_work, rdp->cpu),
+		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
+		   			  rdp->cpu)),
+		   rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -115,13 +137,24 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
-		   rdp->dynticks->dynticks,
+		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi,
+		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%ld,\"%c%c%c%c\",%d,\"%c\",%ld", rdp->qlen,
+		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
+		        rdp->nxttail[RCU_NEXT_TAIL]],
+		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
+		        rdp->nxttail[RCU_NEXT_READY_TAIL]],
+		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
+		        rdp->nxttail[RCU_WAIT_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   per_cpu(rcu_cpu_has_work, rdp->cpu),
+		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
+		   			  rdp->cpu)),
+		   rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -130,7 +163,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
 #ifdef CONFIG_NO_HZ
-	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
+	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -157,11 +190,76 @@ static const struct file_operations rcudata_csv_fops = {
 	.release = single_release,
 };
 
+#ifdef CONFIG_RCU_BOOST
+
+static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
+{
+	seq_printf(m,  "%d:%d tasks=%c%c%c%c kt=%c ntb=%lu neb=%lu nnb=%lu "
+		   "j=%04x bt=%04x\n",
+		   rnp->grplo, rnp->grphi,
+		   "T."[list_empty(&rnp->blkd_tasks)],
+		   "N."[!rnp->gp_tasks],
+		   "E."[!rnp->exp_tasks],
+		   "B."[!rnp->boost_tasks],
+		   convert_kthread_status(rnp->boost_kthread_status),
+		   rnp->n_tasks_boosted, rnp->n_exp_boosts,
+		   rnp->n_normal_boosts,
+		   (int)(jiffies & 0xffff),
+		   (int)(rnp->boost_time & 0xffff));
+	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu nb=%lu ny=%lu nos=%lu\n",
+		   "     balk",
+		   rnp->n_balk_blkd_tasks,
+		   rnp->n_balk_exp_gp_tasks,
+		   rnp->n_balk_boost_tasks,
+		   rnp->n_balk_notblocked,
+		   rnp->n_balk_notyet,
+		   rnp->n_balk_nos);
+}
+
+static int show_rcu_node_boost(struct seq_file *m, void *unused)
+{
+	struct rcu_node *rnp;
+
+	rcu_for_each_leaf_node(&rcu_preempt_state, rnp)
+		print_one_rcu_node_boost(m, rnp);
+	return 0;
+}
+
+static int rcu_node_boost_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcu_node_boost, NULL);
+}
+
+static const struct file_operations rcu_node_boost_fops = {
+	.owner = THIS_MODULE,
+	.open = rcu_node_boost_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/*
+ * Create the rcuboost debugfs entry.  Standard error return.
+ */
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return !debugfs_create_file("rcuboost", 0444, rcudir, NULL,
+				    &rcu_node_boost_fops);
+}
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return 0;  /* There cannot be an error if we didn't create it! */
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
 	unsigned long gpnum;
 	int level = 0;
-	int phase;
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
@@ -178,13 +276,11 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		phase = gpnum & 0x1;
-		seq_printf(m, "%lx/%lx %c%c>%c%c %d:%d ^%d    ",
+		seq_printf(m, "%lx/%lx %c%c>%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
-			   "T."[list_empty(&rnp->blocked_tasks[phase])],
-			   "E."[list_empty(&rnp->blocked_tasks[phase + 2])],
-			   "T."[list_empty(&rnp->blocked_tasks[!phase])],
-			   "E."[list_empty(&rnp->blocked_tasks[!phase + 2])],
+			   ".G"[rnp->gp_tasks != NULL],
+			   ".E"[rnp->exp_tasks != NULL],
+			   ".T"[!list_empty(&rnp->blkd_tasks)],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");
@@ -216,16 +312,35 @@ static const struct file_operations rcuhier_fops = {
 	.release = single_release,
 };
 
+static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	unsigned long completed;
+	unsigned long gpnum;
+	unsigned long gpage;
+	unsigned long gpmax;
+	struct rcu_node *rnp = &rsp->node[0];
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	completed = rsp->completed;
+	gpnum = rsp->gpnum;
+	if (rsp->completed == rsp->gpnum)
+		gpage = 0;
+	else
+		gpage = jiffies - rsp->gp_start;
+	gpmax = rsp->gp_max;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	seq_printf(m, "%s: completed=%ld  gpnum=%lu  age=%ld  max=%ld\n",
+		   rsp->name, completed, gpnum, gpage, gpmax);
+}
+
 static int show_rcugp(struct seq_file *m, void *unused)
 {
 #ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%lu\n",
-		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
+	show_one_rcugp(m, &rcu_preempt_state);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%lu\n",
-		   rcu_sched_state.completed, rcu_sched_state.gpnum);
-	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%lu\n",
-		   rcu_bh_state.completed, rcu_bh_state.gpnum);
+	show_one_rcugp(m, &rcu_sched_state);
+	show_one_rcugp(m, &rcu_bh_state);
 	return 0;
 }
 
@@ -298,6 +413,29 @@ static const struct file_operations rcu_pending_fops = {
 	.release = single_release,
 };
 
+static int show_rcutorture(struct seq_file *m, void *unused)
+{
+	seq_printf(m, "rcutorture test sequence: %lu %s\n",
+		   rcutorture_testseq >> 1,
+		   (rcutorture_testseq & 0x1) ? "(test in progress)" : "");
+	seq_printf(m, "rcutorture update version number: %lu\n",
+		   rcutorture_vernum);
+	return 0;
+}
+
+static int rcutorture_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcutorture, NULL);
+}
+
+static const struct file_operations rcutorture_fops = {
+	.owner = THIS_MODULE,
+	.open = rcutorture_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 static struct dentry *rcudir;
 
 static int __init rcutree_trace_init(void)
@@ -318,6 +456,9 @@ static int __init rcutree_trace_init(void)
 	if (!retval)
 		goto free_out;
 
+	if (rcu_boost_trace_create_file(rcudir))
+		goto free_out;
+
 	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
 	if (!retval)
 		goto free_out;
@@ -331,6 +472,11 @@ static int __init rcutree_trace_init(void)
 						NULL, &rcu_pending_fops);
 	if (!retval)
 		goto free_out;
+
+	retval = debugfs_create_file("rcutorture", 0444, rcudir,
+						NULL, &rcutorture_fops);
+	if (!retval)
+		goto free_out;
 	return 0;
 free_out:
 	debugfs_remove_recursive(rcudir);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 174f976..1396017 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -58,7 +58,7 @@ DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
-	"TASKLET", "SCHED", "HRTIMER",	"RCU"
+	"TASKLET", "SCHED", "HRTIMER"
 };
 
 /*
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..3aa2780 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -337,7 +337,7 @@ config DEBUG_OBJECTS_WORK
 
 config DEBUG_OBJECTS_RCU_HEAD
 	bool "Debug RCU callbacks objects"
-	depends on DEBUG_OBJECTS && PREEMPT
+	depends on DEBUG_OBJECTS
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
 
@@ -875,22 +875,9 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
-config RCU_CPU_STALL_DETECTOR
-	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
-	default y
-	help
-	  This option causes RCU to printk information on which
-	  CPUs are delaying the current grace period, but only when
-	  the grace period extends for excessive time periods.
-
-	  Say N if you want to disable such checks.
-
-	  Say Y if you are unsure.
-
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on RCU_CPU_STALL_DETECTOR
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	range 3 300
 	default 60
 	help
@@ -899,22 +886,9 @@ config RCU_CPU_STALL_TIMEOUT
 	  RCU grace period persists, additional CPU stall warnings are
 	  printed at more widely spaced intervals.
 
-config RCU_CPU_STALL_DETECTOR_RUNNABLE
-	bool "RCU CPU stall checking starts automatically at boot"
-	depends on RCU_CPU_STALL_DETECTOR
-	default y
-	help
-	  If set, start checking for RCU CPU stalls immediately on
-	  boot.  Otherwise, RCU CPU stall checking must be manually
-	  enabled.
-
-	  Say Y if you are unsure.
-
-	  Say N if you wish to suppress RCU CPU stall checking during boot.
-
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
-	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
+	depends on TREE_PREEMPT_RCU
 	default y
 	help
 	  This option causes RCU to printk detailed per-task information
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..1e88485 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2187,7 +2187,6 @@ static const struct flag flags[] = {
 	{ "TASKLET_SOFTIRQ", 6 },
 	{ "SCHED_SOFTIRQ", 7 },
 	{ "HRTIMER_SOFTIRQ", 8 },
-	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },

--wac7ysb48OaltWcw
Content-Type: application/x-sh
Content-Description: collectdebugfs.sh
Content-Disposition: attachment; filename="collectdebugfs.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A#=0A# Collect RCU-related debugfs data.  Set DEBUGFS_MP to the =
debugfs=0A# mount point, defaults to /sys/kernel/debug.=0A#=0A# This progra=
m is free software; you can redistribute it and/or modify=0A# it under the =
terms of the GNU General Public License as published by=0A# the Free Softwa=
re Foundation; either version 2 of the License, or=0A# (at your option) any=
 later version.=0A#=0A# This program is distributed in the hope that it wil=
l be useful,=0A# but WITHOUT ANY WARRANTY; without even the implied warrant=
y of=0A# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A# =
GNU General Public License for more details.=0A#=0A# You should have receiv=
ed a copy of the GNU General Public License=0A# along with this program; if=
 not, write to the Free Software=0A# Foundation, Inc., 59 Temple Place - Su=
ite 330, Boston, MA 02111-1307, USA.=0A#=0A# Copyright (C) IBM Corporation,=
 2010=0A#=0A# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>=0A=0AD=
EBUGFS_MP=3D/sys/kernel/debug=0ADRCU=3D$DEBUGFS_MP/rcu=0A=0Awhile :=0Ado=0A=
	date=0A	cat $DRCU/rcugp || echo no rcugp=0A	cat $DRCU/rcuhier || echo no r=
cuhier=0A	cat $DRCU/rcudata || echo no rcudata=0A	cat $DRCU/rcu_pending || =
echo no rcu_pending=0A	cat $DRCU/rcutorture || echo no rcutorture=0A	cat $D=
RCU/rcuboost || echo no rcuboost=0A	echo=0A	sleep 15=0Adone=0A
--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Description: collectdebugfs.sh.out
Content-Disposition: attachment; filename="sampleoutput.txt"

Thu Apr 21 00:58:27 EDT 2011
rcu_sched_state: completed=10011  gpnum=10011  age=0  max=647
rcu_bh_state: completed=2865  gpnum=2865  age=0  max=586
rcu_sched:
c=10011 g=10011 s=0 jfq=-492 j=55cf nfqs=20550/nfqsng=0(20550) fqlh=2689
0/ff ..>. 0:7 ^0    
rcu_bh:
c=2865 g=2865 s=0 jfq=-34 j=55cf nfqs=6361/nfqsng=0(6361) fqlh=46
0/ff ..>. 0:7 ^0    
rcu_sched:
  0 c=10011 g=10011 pq=1 pqc=10010 qp=0 dt=44539/1/0 df=2728 of=0 ri=175 ql=25 qs=N... kt=0/W b=10 ci=171769 co=0 ca=0
  1 c=10011 g=10011 pq=1 pqc=10010 qp=0 dt=150541/1/0 df=5893 of=0 ri=35 ql=10 qs=N... kt=0/W b=10 ci=64385 co=0 ca=0
  2 c=9990 g=9991 pq=1 pqc=9990 qp=1 dt=8920/0/0 df=9969 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=5067 co=0 ca=0
  3 c=9962 g=9963 pq=1 pqc=9962 qp=1 dt=9114/0/0 df=10144 of=0 ri=1 ql=0 qs=.... kt=0/W b=10 ci=1492 co=0 ca=0
  4 c=10011 g=10011 pq=1 pqc=10010 qp=0 dt=38353/1/0 df=5639 of=0 ri=16 ql=30 qs=N... kt=0/W b=10 ci=122803 co=0 ca=0
  5 c=10011 g=10011 pq=1 pqc=10010 qp=0 dt=14063/1/0 df=6175 of=0 ri=11 ql=10 qs=N... kt=0/W b=10 ci=62040 co=0 ca=0
  6 c=9909 g=9910 pq=1 pqc=9909 qp=1 dt=10460/0/0 df=9920 of=0 ri=1 ql=0 qs=.... kt=0/W b=10 ci=4820 co=0 ca=0
  7 c=9914 g=9914 pq=1 pqc=9913 qp=0 dt=8192/0/0 df=10137 of=0 ri=2 ql=0 qs=.... kt=0/W b=10 ci=1412 co=0 ca=0
rcu_bh:
  0 c=2865 g=2865 pq=1 pqc=2864 qp=0 dt=44539/1/0 df=2956 of=0 ri=3 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
  1 c=2864 g=2865 pq=1 pqc=2864 qp=1 dt=150541/1/0 df=1145 of=0 ri=26 ql=0 qs=.... kt=0/W b=10 ci=1590 co=0 ca=0
  2 c=2861 g=2861 pq=1 pqc=2860 qp=0 dt=8920/0/0 df=3165 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
  3 c=2861 g=2861 pq=1 pqc=2860 qp=0 dt=9114/0/0 df=3165 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
  4 c=2865 g=2865 pq=1 pqc=2864 qp=0 dt=38353/1/0 df=3021 of=0 ri=4 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
  5 c=2861 g=2861 pq=1 pqc=2860 qp=0 dt=14063/1/0 df=3069 of=0 ri=1 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
  6 c=2847 g=2847 pq=1 pqc=2846 qp=0 dt=10460/0/0 df=3164 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
  7 c=2847 g=2847 pq=1 pqc=2836 qp=0 dt=8192/0/0 df=3164 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
rcu_sched:
  0 np=38932 qsp=1 rpq=5416 cbr=0 cng=564 gpc=2564 gps=332 nf=6835 nn=23221
  1 np=33739 qsp=1 rpq=4813 cbr=0 cng=431 gpc=2733 gps=327 nf=5646 nn=19789
  2 np=2414 qsp=0 rpq=419 cbr=0 cng=1 gpc=397 gps=16 nf=234 nn=1347
  3 np=1002 qsp=0 rpq=234 cbr=0 cng=1 gpc=261 gps=23 nf=86 nn=397
  4 np=38173 qsp=0 rpq=5434 cbr=0 cng=467 gpc=3051 gps=279 nf=6627 nn=22315
  5 np=32056 qsp=0 rpq=4783 cbr=0 cng=175 gpc=2294 gps=130 nf=5847 nn=18827
  6 np=2759 qsp=0 rpq=460 cbr=0 cng=1 gpc=385 gps=25 nf=414 nn=1474
  7 np=1056 qsp=0 rpq=248 cbr=0 cng=2 gpc=254 gps=15 nf=89 nn=448
rcu_bh:
  0 np=23221 qsp=0 rpq=2227 cbr=0 cng=0 gpc=299 gps=17 nf=70 nn=20608
  1 np=19789 qsp=1 rpq=2709 cbr=0 cng=78 gpc=89 gps=0 nf=88 nn=16825
  2 np=1347 qsp=0 rpq=1194 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=153
  3 np=397 qsp=0 rpq=396 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
  4 np=22315 qsp=0 rpq=2213 cbr=0 cng=0 gpc=346 gps=12 nf=62 nn=19682
  5 np=18827 qsp=0 rpq=1746 cbr=0 cng=0 gpc=62 gps=12 nf=45 nn=16962
  6 np=1474 qsp=0 rpq=1183 cbr=0 cng=0 gpc=0 gps=0 nf=1 nn=290
  7 np=448 qsp=0 rpq=448 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
rcutorture test sequence: 0 
rcutorture update version number: 0
cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
no rcuboost


--wac7ysb48OaltWcw--
