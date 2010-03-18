Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab0CRSzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0CRSzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:55:15 -0400
Date: Thu, 18 Mar 2010 19:53:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ia64: ptrace_attach_sync_user_rbs: avoid "task->signal
	!= NULL" checks
Message-ID: <20100318185307.GA18352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

It doesn't matter which pointer we check under tasklist to ensure
the task was not released, ->signal or ->sighand. But we are going
to make ->signal refcountable, change the code to use ->sighand.

Note: this code doesn't need this check and tasklist_lock at all,
it should be converted to use lock_task_sighand(). And, the code
under SIGNAL_STOP_STOPPED check looks wrong.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/ia64/kernel/ptrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 34-rc1/arch/ia64/kernel/ptrace.c~6_IA64_DONT_CHECK_SIGNAL	2010-03-11 13:11:48.000000000 +0100
+++ 34-rc1/arch/ia64/kernel/ptrace.c	2010-03-18 19:12:45.000000000 +0100
@@ -639,7 +639,7 @@ ptrace_attach_sync_user_rbs (struct task
 	 */
 
 	read_lock(&tasklist_lock);
-	if (child->signal) {
+	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_STOPPED &&
 		    !test_and_set_tsk_thread_flag(child, TIF_RESTORE_RSE)) {
@@ -663,7 +663,7 @@ ptrace_attach_sync_user_rbs (struct task
 	 * job control stop, so that SIGCONT can be used to wake it up.
 	 */
 	read_lock(&tasklist_lock);
-	if (child->signal) {
+	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_TRACED &&
 		    (child->signal->flags & SIGNAL_STOP_STOPPED)) {

