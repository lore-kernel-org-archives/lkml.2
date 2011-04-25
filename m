Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1DYVtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:49:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56597 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1DYVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:49:37 -0400
Date: Mon, 25 Apr 2011 14:49:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110425214933.GO2468@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110425111705.786ef0c5@neptune.home>
 <BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
 <20110425180450.1ede0845@neptune.home>
 <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
 <20110425190032.7904c95d@neptune.home>
 <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>
 <20110425203606.4e78246c@neptune.home>
 <20110425191607.GL2468@linux.vnet.ibm.com>
 <20110425231016.34b4293e@neptune.home>
 <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 02:30:02PM -0700, Linus Torvalds wrote:
> 2011/4/25 Bruno Prémont <bonbons@linux-vserver.org>:
> >
> > Between 1-slabinfo and 2-slabinfo some values increased (a lot) while a few
> > ones did decrease. Don't know which ones are RCU-affected and which ones are
> > not.
> 
> It really sounds as if the tiny-rcu kthread somehow just stops
> handling callbacks. The ones that keep increasing do seem to be all
> rcu-free'd (but I didn't really check).
> 
> The thing is shown as running:
> 
> root         6  0.0  0.0      0     0 ?        R    22:14   0:00  \_
> [rcu_kthread]
> 
> but nothing seems to happen and the CPU time hasn't increased at all.
> 
> I dunno. Makes no  sense to me, but yeah, I'm definitely blaming
> tiny-rcu. Paul, any ideas?

So the only ways I know for something to be runnable but not run on
a uniprocessor are:

1.	The CPU is continually busy with higher-priority work.
	This doesn't make sense in this case because the system
	is idle much of the time.

2.	The system is hibernating.  This doesn't make sense, otherwise
	"ps" wouldn't run either.

Any others ideas on how the heck a process can get into this state?
(I have thus far been completely unable to reproduce it.)

The process in question has a loop in rcu_kthread() in kernel/rcutiny.c.
This loop contains a wait_event_interruptible(), waits for a global flag
to become non-zero.

It is awakened by invoke_rcu_kthread() in that same file, which
simply sets the flag to 1 and does a wake_up(), all with hardirqs
disabled.

Hmmm...  One "hail mary" patch below.  What it does is make rcu_kthread
run at normal priority rather than at real-time priority.  This is
not for inclusion -- it breaks RCU priority boosting.  But well worth
trying.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0c343b9..4551824 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -314,11 +314,15 @@ EXPORT_SYMBOL_GPL(rcu_barrier_sched);
  */
 static int __init rcu_spawn_kthreads(void)
 {
+#if 0
 	struct sched_param sp;
+#endif
 
 	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
+#if 0
 	sp.sched_priority = RCU_BOOST_PRIO;
 	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
+#endif
 	return 0;
 }
 early_initcall(rcu_spawn_kthreads);
