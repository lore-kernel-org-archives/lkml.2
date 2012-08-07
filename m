Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2HGGaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:30:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37258 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751523Ab2HGGaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:30:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/nj2xBY/3nKzLhb7GQEz5QnnW12lF19//8WYBUtp
	Rtv5v6xfirw6zw
Message-ID: <1344321010.6968.10.camel@marge.simpson.net>
Subject: Re: [parch] sched: task_times() explosion avoidance for tasks with
 > 2^32 acrued ticks
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 07 Aug 2012 08:30:10 +0200
In-Reply-To: <1344261539.6853.1.camel@marge.simpson.net>
References: <1344261539.6853.1.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong xx.

sched: task_times() explosion avoidance for tasks with > 2^32 accrued ticks

If stime + utime > 2^32, and lower 32 are 0 when user calls getrusage(),
you've got a dead box.

Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 82ad284..b0b0d29 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3155,7 +3155,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) utime;
-		do_div(temp, (__force u32) total);
+		temp = div64_u64(temp, (__force u64) total);
 		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
@@ -3188,7 +3188,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) cputime.utime;
-		do_div(temp, (__force u32) total);
+		temp = div64_u64(temp, (__force u64) total);
 		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;


