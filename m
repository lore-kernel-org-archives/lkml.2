Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1G1XtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:49:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:50848 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab1G1Xoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32809009"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: Trond.Myklebust@netapp.com, greearb@candelatech.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [33/50] SUNRPC: Fix a race between work-queue and rpc_killall_tasks
Message-Id: <20110728234437.DCE062403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ upstream commit b55c59892e1f3b6c7d4b9ccffb4263e1486fb990 ]

Since rpc_killall_tasks may modify the rpc_task's tk_action field
without any locking, we need to be careful when dereferencing it.

Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/sunrpc/sched.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/sched.c
+++ linux-2.6.35.y/net/sunrpc/sched.c
@@ -623,30 +623,25 @@ static void __rpc_execute(struct rpc_tas
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
