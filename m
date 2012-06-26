Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab2FZBST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:18:19 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:48996 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2FZBSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:18:17 -0400
Subject: [PATCH] sched: fix fork() error path to not crash.
To: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
From: Salman Qazi <sqazi@google.com>
Date: Mon, 25 Jun 2012 18:18:15 -0700
Message-ID: <20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dup_task_struct, if arch_dup_task_struct fails, the clean up
code fails to clean up correctly.  That's because the clean up
code depends on unininitalized ti->task pointer.  We fix this
by making sure that the task and thread_info know about each other
before we attempt to take the error path.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 kernel/fork.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ab5211b..f00e319 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -304,12 +304,17 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	}
 
 	err = arch_dup_task_struct(tsk, orig);
-	if (err)
-		goto out;
 
+	/*
+	 * We defer looking at err, because we will need this setup
+	 * for the clean up path to work correctly.
+	 */
 	tsk->stack = ti;
-
 	setup_thread_stack(tsk, orig);
+
+	if (err)
+		goto out;
+
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);

