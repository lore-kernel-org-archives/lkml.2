Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259Ab2EOCqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:46:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53444 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878Ab2EOCRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 111/179] SUNRPC: Fix a race between work-queue and rpc_killall_tasks
Date: Mon, 14 May 2012 22:13:27 -0400
Message-ID: <1337048075-6132-112-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b55c59892e1f3b6c7d4b9ccffb4263e1486fb990 upstream.

Since rpc_killall_tasks may modify the rpc_task's tk_action field
without any locking, we need to be careful when dereferencing it.

Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/sched.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 03a5c9e..416ca5e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -628,30 +628,25 @@ static void __rpc_execute(struct rpc_task *task)
 	BUG_ON(RPC_IS_QUEUED(task));
 
 	for (;;) {
+		void (*do_action)(struct rpc_task *);
 
 		/*
-		 * Execute any pending callback.
+		 * Execute any pending callback first.
 		 */
-		if (task->tk_callback) {
-			void (*save_callback)(struct rpc_task *);
-
-			/*
-			 * We set tk_callback to NULL before calling it,
-			 * in case it sets the tk_callback field itself:
-			 */
-			save_callback = task->tk_callback;
-			task->tk_callback = NULL;
-			save_callback(task);
-		} else {
+		do_action = task->tk_callback;
+		task->tk_callback = NULL;
+		if (do_action == NULL) {
 			/*
 			 * Perform the next FSM step.
-			 * tk_action may be NULL when the task has been killed
-			 * by someone else.
+			 * tk_action may be NULL if the task has been killed.
+			 * In particular, note that rpc_killall_tasks may
+			 * do this at any time, so beware when dereferencing.
 			 */
-			if (task->tk_action == NULL)
+			do_action = task->tk_action;
+			if (do_action == NULL)
 				break;
-			task->tk_action(task);
 		}
+		do_action(task);
 
 		/*
 		 * Lockless check for whether task is sleeping or not.
-- 
1.7.9.6

