Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2GFGTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:19:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GFGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:19:07 -0400
Date: Thu, 5 Jul 2012 23:18:47 -0700
From: tip-bot for Salman Qazi <sqazi@google.com>
Message-ID: <tip-164c33c6adee609b8b9062cce4c10f764d0dce13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, sqazi@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sqazi@google.com, tglx@linutronix.de
In-Reply-To: <20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com>
References: <20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix fork() error path to not crash
Git-Commit-ID: 164c33c6adee609b8b9062cce4c10f764d0dce13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:18:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  164c33c6adee609b8b9062cce4c10f764d0dce13
Gitweb:     http://git.kernel.org/tip/164c33c6adee609b8b9062cce4c10f764d0dce13
Author:     Salman Qazi <sqazi@google.com>
AuthorDate: Mon, 25 Jun 2012 18:18:15 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 20:57:32 +0200

sched: Fix fork() error path to not crash

In dup_task_struct(), if arch_dup_task_struct() fails, the clean up
code fails to clean up correctly.  That's because the clean up
code depends on unininitalized ti->task pointer.  We fix this
by making sure that the task and thread_info know about each other
before we attempt to take the error path.

Signed-off-by: Salman Qazi <sqazi@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
