Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0K3CYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 21:24:15 -0500
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:64415 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739Ab0K3CYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 21:24:14 -0500
X-AuditID: 1209190f-b7c1dae000000a2b-ff-4cf4604d3d11
From: Nelson Elhage <nelhage@ksplice.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH] mm_release: Do a set_fs(USER_DS) before handling clear_child_tid.
Date: Mon, 29 Nov 2010 21:19:16 -0500
Message-Id: <1291083556-5894-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.1.31.g6297e
X-Brightmail-Tracker: AAAAARbCok4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user manages to trigger a kernel BUG() or page fault with fs set to
KERNEL_DS, fs is not otherwise reset before do_exit(), allowing the user to
write a 0 to an arbitrary address in kernel memory.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
AFAICT this is presently only triggerable in the presence of another bug, but
this potentially turns a lot of DoS bugs into privilege escalation, so it's
worth fixing. Among other things, sock_no_sendpage and the kernel_{read,write}v
calls in splice.c make it easy to call an awful lot of the kernel under
KERNEL_DS.

This isn't the only way we could fix this -- we could put the set_fs() at the
start of do_exit, or in all the callers that might call potentially do_exit with
KERNEL_DS set, or else we could do an access_ok inside fork(). I'm happy to put
together one of those patches if someone thinks another approach makes more
sense.

 kernel/fork.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..a68445e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -636,7 +636,12 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 			/*
 			 * We don't check the error code - if userspace has
 			 * not set up a proper pointer then tough luck.
+			 *
+			 * We do set_fs() explicitly in case this task
+			 * exited while inside set_fs(KERNEL_DS) for
+			 * some reason (e.g. on a BUG()).
 			 */
+			set_fs(USER_DS);
 			put_user(0, tsk->clear_child_tid);
 			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
 					1, NULL, NULL, 0);
-- 
1.7.1.31.g6297e

