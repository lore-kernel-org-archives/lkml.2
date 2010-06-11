Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab0FKSG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671Ab0FKSG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:06:26 -0400
Date: Fri, 11 Jun 2010 20:04:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/5] fix the racy usage of thread_group_cputimer() in
	fastpath_timer_check()
Message-ID: <20100611180446.GA13025@redhat.com>
References: <20100610231018.GA25942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610231018.GA25942@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastpath_timer_check()->thread_group_cputimer() is racy and
unneeded.

It is racy because another thread can clear ->running before
thread_group_cputimer() takes cputimer->lock. In this case
thread_group_cputimer() will set ->running = true again and call
thread_group_cputime(). But since we do not hold tasklist or
siglock, we can race with fork/exit and copy the wrong results
into cputimer->cputime.

It is unneeded because if ->running == true we can just use
the numbers in cputimer->cputime we already have.

Change fastpath_timer_check() to copy cputimer->cputime into
the local variable under cputimer->lock. We do not re-check
->running under cputimer->lock, run_posix_cpu_timers() does
this check later.

Note: we can add more optimizations on top of this change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/posix-cpu-timers.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 35-rc2/kernel/posix-cpu-timers.c~6_FPTC_DONT_SET_RUNNING	2010-06-11 01:08:03.000000000 +0200
+++ 35-rc2/kernel/posix-cpu-timers.c	2010-06-11 19:40:22.000000000 +0200
@@ -1287,7 +1287,10 @@ static inline int fastpath_timer_check(s
 	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
-		thread_group_cputimer(tsk, &group_sample);
+		spin_lock(&sig->cputimer.lock);
+		group_sample = sig->cputimer.cputime;
+		spin_unlock(&sig->cputimer.lock);
+
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}

