Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0LGCOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:14:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0LGCNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:13:32 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=CTAM43dMmdwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=u3tpQZKja4MypRY0GqAA:9 a=zjpdu7LmVJVIUjEjO4xvlQtuk3UA:4 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101207021330.050417380@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 20:58:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 07/10] x86: Remove unlikey()s from sched_switch segment tests
References: <20101207015834.196176991@goodmis.org>
Content-Disposition: inline; filename=0007-x86-Remove-unlikey-s-from-sched_switch-segment-tests.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On a 64bit distro, the chances of having a process using segment registers
is very unlikely. But if the userspace is 32bit running on top of
a 64bit kernel (very common), then this will be very likely that
processes have segment registers in use.

Running on my main desktop (which is a 32bit userspace on top of
a 64bit kernel) the annotated branch profiler showed the following:

 correct incorrect  %        Function             File              Line
 ------- ---------  -        --------             ----              ----
25522442 304125815  92 __switch_to               process_64.c         408
25522430 304123341  92 __switch_to               process_64.c         412
25743877 303891250  92 __switch_to               process_64.c         464

Instead of punishing 32bit userspace systems with an unlikely, just remove
the unlikely and let gcc optimize for what it thinks is good and let
the branch prediction (hopefully) work.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..22de90c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -405,11 +405,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
-	if (unlikely(next->es | prev->es))
+	if (next->es | prev->es)
 		loadsegment(es, next->es);
 
 	savesegment(ds, prev->ds);
-	if (unlikely(next->ds | prev->ds))
+	if (next->ds | prev->ds)
 		loadsegment(ds, next->ds);
 
 
@@ -461,7 +461,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_FS_BASE, next->fs);
 	prev->fsindex = fsindex;
 
-	if (unlikely(gsindex | next->gsindex | prev->gs)) {
+	if (gsindex | next->gsindex | prev->gs) {
 		load_gs_index(next->gsindex);
 		if (gsindex)
 			prev->gs = 0;
-- 
1.7.2.3


