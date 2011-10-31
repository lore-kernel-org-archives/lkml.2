Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab1JaTFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:05:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58132 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JaTFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:37 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/17] freezer: fix current->state restoration race in refrigerator()
Date: Mon, 31 Oct 2011 12:05:12 -0700
Message-Id: <1320087928-32307-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refrigerator() saves current->state before entering frozen state and
restores it before returning using __set_current_state(); however,
this is racy, for example, please consider the following sequence.

	set_current_state(TASK_INTERRUPTIBLE);
	try_to_freeze();
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
index 66a594e..19a20b2 100644
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
1.7.3.1

