Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0KINpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:45:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:42748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0KINpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:45:49 -0500
Subject: Re: [bisected] Clocksource tsc unstable git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, avi@redhat.com,
        mtosatti@redhat.com
In-Reply-To: <20101109132138.GA3110@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
	 <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de>
	 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
	 <1288120736.2645.9.camel@localhost>
	 <20101027142622.GA1555@arch.trippelsdorf.de>
	 <20101027182608.GA1580@arch.trippelsdorf.de>
	 <1288208215.3673.16.camel@laptop>
	 <20101109125842.GA8636@osiris.boeblingen.de.ibm.com>
	 <20101109132138.GA3110@arch.trippelsdorf.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 14:45:33 +0100
Message-ID: <1289310333.2191.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 14:21 +0100, Markus Trippelsdorf wrote:
> 
> You've missed the fact that Peter already has a patch that fixes the
> problem, but he never bothered to post it in this thread.
> 
Right, forgot about that, sorry.

Still Heiko has a good point, I've queued the below after I realized
that PREEMPT_ACTIVE would still require two tests and the on_rq bit is
actually sufficient.

---
Subject: sched: Fix runnable condition for stoptask
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Nov 09 14:36:52 CET 2010

Heiko reported that the TASK_RUNNING check is not sufficient for
CONFIG_PREEMPT=y since we can get preempted with !TASK_RUNNING.

He suggested adding a ->se.on_rq test to the existing TASK_RUNNING
one, however TASK_RUNNING will always have ->se.on_rq, so we might as
well reduce that to a single test.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched_stoptask.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- linux-2.6.orig/kernel/sched_stoptask.c
+++ linux-2.6/kernel/sched_stoptask.c
@@ -26,7 +26,7 @@ static struct task_struct *pick_next_tas
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->state == TASK_RUNNING)
+	if (stop && stop->se.on_rq)
 		return stop;
 
 	return NULL;

