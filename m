Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0CRSzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:55:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0CRSzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:55:09 -0400
Date: Thu, 18 Mar 2010 19:53:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] posix-cpu-timers: avoid "task->signal != NULL" checks
Message-ID: <20100318185304.GA18348@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

posix-cpu-timers.c checks task->signal != NULL to ensure this task
is alive and didn't pass __exit_signal(). This is correct but we
are going to change the lifetime rules for ->signal and never reset
this pointer.

Change the code to check ->sighand instead, it doesn't matter which
pointer we check under tasklist, they both are cleared simultaneously.

As Roland pointed out, some of these changes are not strictly needed
and probably it makes sense to revert them later, when ->signal will
be pinned to task_struct. But this patch tries to ensure the subsequent
changes in fork/exit can't make any visible impact on posix cpu timers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/posix-cpu-timers.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- 34-rc1/kernel/posix-cpu-timers.c~5_PCT_DONT_CHECK_SIGNAL	2010-03-11 13:11:50.000000000 +0100
+++ 34-rc1/kernel/posix-cpu-timers.c	2010-03-18 17:49:17.000000000 +0100
@@ -364,7 +364,7 @@ int posix_cpu_clock_get(const clockid_t 
 				}
 			} else {
 				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->signal) {
+				if (thread_group_leader(p) && p->sighand) {
 					error =
 					    cpu_clock_sample_group(which_clock,
 							           p, &rtn);
@@ -440,7 +440,7 @@ int posix_cpu_timer_del(struct k_itimer 
 
 	if (likely(p != NULL)) {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * We raced with the reaping of the task.
 			 * The deletion should have cleared us off the list.
@@ -736,10 +736,10 @@ int posix_cpu_timer_set(struct k_itimer 
 	read_lock(&tasklist_lock);
 	/*
 	 * We need the tasklist_lock to protect against reaping that
-	 * clears p->signal.  If p has just been reaped, we can no
+	 * clears p->sighand.  If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
-	if (unlikely(p->signal == NULL)) {
+	if (unlikely(p->sighand == NULL)) {
 		read_unlock(&tasklist_lock);
 		put_task_struct(p);
 		timer->it.cpu.task = NULL;
@@ -908,7 +908,7 @@ void posix_cpu_timer_get(struct k_itimer
 		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
@@ -1268,7 +1268,7 @@ void posix_cpu_timer_schedule(struct k_i
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
 	} else {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.

