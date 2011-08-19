Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1HSOQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:16:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1HSOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:33 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/16] freezer: fix current->state restoration race in refrigerator()
Date: Fri, 19 Aug 2011 16:16:07 +0200
Message-Id: <1313763382-12341-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refrigerator() saves current->state before entering frozen state and
restores it before returning using __set_current_state(); however,
this is racy, for example, please consider the following sequence.

	set_current_state(TASK_INTERRUPTIBLE);
	try_to_sleep();
	if (kthread_should_stop())
		break;
	schedule();

If kthread_stop() races with ->state restoration, the restoration can
restore ->state to TASK_INTERRUPTIBLE after kthread_stop() sets it to
TASK_RUNNING but kthread_should_stop() may still see zero
->should_stop because there's no memory barrier between restoring
TASK_INTERRUPTIBLE and kthread_should_stop() test.

This isn't restricted to kthread_should_stop().  current->state is
often used in memory barrier based synchronization and silently
restoring it w/o mb breaks them.

Use set_current_state() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/freezer.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 7b01de9..575f863 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -58,7 +58,13 @@ void refrigerator(void)
 	current->flags &= ~PF_FREEZING;
 
 	pr_debug("%s left refrigerator\n", current->comm);
-	__set_current_state(save);
+
+	/*
+	 * Restore saved task state before returning.  The mb'd version
+	 * needs to be used; otherwise, it might silently break
+	 * synchronization which depends on ordered task state change.
+	 */
+	set_current_state(save);
 }
 EXPORT_SYMBOL(refrigerator);
 
-- 
1.7.6

