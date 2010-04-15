Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0DOFaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:30:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:59429 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754204Ab0DOFaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:30:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cFtZ3zLac2ro3ftTBi4PYLjisBkwGUk0UodOec3
	eFjb31bEW1Z5hj
Subject: Re: linux-next: build warning after merge of the final tree (tip
 tree related)
From: Mike Galbraith <efault@gmx.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100415143609.834da268.sfr@canb.auug.org.au>
References: <20100415143609.834da268.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 15 Apr 2010 07:29:59 +0200
Message-Id: <1271309399.14779.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 14:36 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) produced this warning:
> 
> kernel/sched.c:1875: warning: 'update_avg' defined but not used
> 
> Introduced by commit e12f31d3e5d36328c7fbd0fce40a95e70b59152c ("sched:
> Remove avg_overlap") which left the only call to this function protected
> by CONFIG_SMP.

Oops.

sched: fix UP update_avg() build warning.

update_avg() is only used for SMP builds, move it to the nearest SMP block.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

diff --git a/kernel/sched.c b/kernel/sched.c
index 3acf694..95eaecc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1872,12 +1872,6 @@ static void set_load_weight(struct task_struct *p)
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
-static void update_avg(u64 *avg, u64 sample)
-{
-	s64 diff = sample - *avg;
-	*avg += diff >> 3;
-}
-
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
@@ -2289,6 +2283,12 @@ int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_
 
 	return cpu;
 }
+
+static void update_avg(u64 *avg, u64 sample)
+{
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+}
 #endif
 
 /***


