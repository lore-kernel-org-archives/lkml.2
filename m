Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab0HKX72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:28 -0400
Received: from kroah.org ([198.145.64.141]:43596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238Ab0HKX7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:07 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:03 2010
Message-Id: <20100811235503.383348158@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, xiyou.wangcong@gmail.com,
        Spencer Candland <spencer@bluehost.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [085/111] sched: Fix granularity of task_u/stime()
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit 761b1d26df542fd5eb348837351e4d2f3bc7bffe upstream.

Originally task_s/utime() were designed to return clock_t but
later changed to return cputime_t by following commit:

  commit efe567fc8281661524ffa75477a7c4ca9b466c63
  Author: Christian Borntraeger <borntraeger@de.ibm.com>
  Date:   Thu Aug 23 15:18:02 2007 +0200

It only changed the type of return value, but not the
implementation. As the result the granularity of task_s/utime()
is still that of clock_t, not that of cputime_t.

So using task_s/utime() in __exit_signal() makes values
accumulated to the signal struct to be rounded and coarse
grained.

This patch removes casts to clock_t in task_u/stime(), to keep
granularity of cputime_t over the calculation.

v2:
  Use div_u64() to avoid error "undefined reference to `__udivdi3`"
  on some 32bit systems.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: xiyou.wangcong@gmail.com
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
LKML-Reference: <4AFB9029.9000208@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5216,41 +5216,45 @@ cputime_t task_stime(struct task_struct
 	return p->stime;
 }
 #else
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs) \
+	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
+#endif
+
 cputime_t task_utime(struct task_struct *p)
 {
-	clock_t utime = cputime_to_clock_t(p->utime),
-		total = utime + cputime_to_clock_t(p->stime);
+	cputime_t utime = p->utime, total = utime + p->stime;
 	u64 temp;
 
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+	temp = (u64)nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
 		temp *= utime;
 		do_div(temp, total);
 	}
-	utime = (clock_t)temp;
+	utime = (cputime_t)temp;
 
-	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	p->prev_utime = max(p->prev_utime, utime);
 	return p->prev_utime;
 }
 
 cputime_t task_stime(struct task_struct *p)
 {
-	clock_t stime;
+	cputime_t stime;
 
 	/*
 	 * Use CFS's precise accounting. (we subtract utime from
 	 * the total, to make sure the total observed by userspace
 	 * grows monotonically - apps rely on that):
 	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
+	stime = nsecs_to_cputime(p->se.sum_exec_runtime) - task_utime(p);
 
 	if (stime >= 0)
-		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+		p->prev_stime = max(p->prev_stime, stime);
 
 	return p->prev_stime;
 }


