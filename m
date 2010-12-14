Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0LNB2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:28:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0LNB2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:28:47 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=NU75trCksyEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=qPVcLjWimzal_P6VtREA:9 a=CK27FpIHn3TW52LvifXvQ8ugYQQA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214012845.980133529@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 20:28:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] sched: Remove unlikely() from rt_policy() in sched.c
References: <20101214012803.142630411@goodmis.org>
Content-Disposition: inline; filename=0003-sched-Remove-unlikely-from-rt_policy-in-sched.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The rt_policy() has an unlikely() that the policy it is checking is
of RT priority (SCHED_FIFO or SCHED_RR).

According to the annotate branch profiler it is incorrect most of the time:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
   36667   654674  94 rt_policy                      sched.c              126

This makes sense because the rt_policy() is used by the sched_set_scheduler()
and nice(). Although users may use sys_nice a bit, all RT users use
the sched_set_scheduler() to set their RT priority, including kernel
threads.

The above numbers were from a normal desktop computer running
firefox, evolution, xchat and was part of a distcc compile farm.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..269a045 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -123,7 +123,7 @@
 
 static inline int rt_policy(int policy)
 {
-	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
+	if (policy == SCHED_FIFO || policy == SCHED_RR)
 		return 1;
 	return 0;
 }
-- 
1.7.2.3


