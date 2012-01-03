Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2ACWlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:35 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47986 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2ACWl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:26 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] hung_task: fix false positive during vfork
Date: Tue,  3 Jan 2012 14:41:13 -0800
Message-Id: <1325630473-27477-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325344394.28904.43.camel@lappy>
References: <1325344394.28904.43.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfork parent uninterruptibly and unkillably waits for its child to
exec/exit. This wait is of unbounded length. Ignore such waits
in the hung_task detector.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
LKML-Reference: <1325344394.28904.43.camel@lappy>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Kacur <jkacur@redhat.com>
---
 kernel/hung_task.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 8b1748d..2e48ec0 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -74,11 +74,17 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	/*
 	 * Ensure the task is not frozen.
-	 * Also, when a freshly created task is scheduled once, changes
-	 * its state to TASK_UNINTERRUPTIBLE without having ever been
-	 * switched out once, it musn't be checked.
+	 * Also, skip vfork and any other user process that freezer should skip.
 	 */
-	if (unlikely(t->flags & PF_FROZEN || !switch_count))
+	if (unlikely(t->flags & (PF_FROZEN | PF_FREEZER_SKIP)))
+	    return;
+
+	/*
+	 * When a freshly created task is scheduled once, changes its state to
+	 * TASK_UNINTERRUPTIBLE without having ever been switched out once, it
+	 * musn't be checked.
+	 */
+	if (unlikely(!switch_count))
 		return;
 
 	if (switch_count != t->last_switch_count) {
-- 
1.7.3.1

