Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1JRSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:16:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1JRSQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:16:25 -0400
Date: Tue, 18 Oct 2011 20:14:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20111018181449.GA21666@elte.hu>
References: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <1318847658.6594.40.camel@twins>
 <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
 <1318874090.4172.84.camel@twins>
 <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
 <1318879396.4172.92.camel@twins>
 <alpine.LFD.2.02.1110172237030.3240@ionos>
 <alpine.LFD.2.02.1110181037120.3240@ionos>
 <1318928713.21167.4.camel@twins>
 <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git timers-urgent-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      cputimer: Cure lock inversion


 kernel/posix-cpu-timers.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c8008dd..640ded8 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -274,9 +274,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 	struct task_cputime sum;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
 	if (!cputimer->running) {
-		cputimer->running = 1;
 		/*
 		 * The POSIX timer interface allows for absolute time expiry
 		 * values through the TIMER_ABSTIME flag, therefore we have
@@ -284,8 +282,11 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * it.
 		 */
 		thread_group_cputime(tsk, &sum);
+		spin_lock_irqsave(&cputimer->lock, flags);
+		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
-	}
+	} else
+		spin_lock_irqsave(&cputimer->lock, flags);
 	*times = cputimer->cputime;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
