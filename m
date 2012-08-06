Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2HFN7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:59:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36174 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756183Ab2HFN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:59:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Puztip++PEydpN1YM5qbDjDE6evQo6hslqBItKK
	wRoCRoa/DWt7rI
Message-ID: <1344261539.6853.1.camel@marge.simpson.net>
Subject: [parch] sched: task_times() explosion avoidance for tasks with >
 2^32 acrued ticks
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 06 Aug 2012 15:58:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If stime + utime > 2^32, and lower 32 are 0 when user calls getrusage(),
you've got a dead box.

Signed-off-by: Mike Galbraith <efault@gmx.de>

 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 82ad284..0ac2cac 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3151,7 +3151,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 */
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
-	if (total) {
+	if (total && total == (__force u32) total) {
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) utime;
@@ -3184,7 +3184,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	total = cputime.utime + cputime.stime;
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
-	if (total) {
+	if (total && total == (__force u32) total) {
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) cputime.utime;


