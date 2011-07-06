Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1GFXpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:45:35 -0400
Received: from mx2.netapp.com ([216.240.18.37]:44102 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1GFXpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:45:33 -0400
X-IronPort-AV: E=Sophos;i="4.65,489,1304319600"; 
   d="scan'208";a="560862970"
Subject: Re: [RFC] sunrpc:  Fix race between work-queue and
 rpc_killall_tasks.
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: greearb@candelatech.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Jul 2011 19:45:32 -0400
In-Reply-To: <1309992581-25199-1-git-send-email-greearb@candelatech.com>
References: <1309992581-25199-1-git-send-email-greearb@candelatech.com>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1309995932.5447.6.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jul 2011 23:45:33.0402 (UTC) FILETIME=[CBEBA3A0:01CC3C36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 15:49 -0700, greearb@candelatech.com wrote: 
> From: Ben Greear <greearb@candelatech.com>
> 
> The rpc_killall_tasks logic is not locked against
> the work-queue thread, but it still directly modifies
> function pointers and data in the task objects.
> 
> This patch changes the killall-tasks logic to set a flag
> that tells the work-queue thread to terminate the task
> instead of directly calling the terminate logic.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> NOTE:  This needs review, as I am still struggling to understand
> the rpc code, and it's quite possible this patch either doesn't
> fully fix the problem or actually causes other issues.  That said,
> my nfs stress test seems to run a bit more stable with this patch applied.

Yes, but I don't see why you are adding a new flag, nor do I see why we
want to keep checking for that flag in the rpc_execute() loop.
rpc_killall_tasks() is not a frequent operation that we want to optimise
for.

How about the following instead?

8<---------------------------------------------------------------------------------- 
>From ecb7244b661c3f9d2008ef6048733e5cea2f98ab Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 6 Jul 2011 19:44:52 -0400
Subject: [PATCH] SUNRPC: Fix a race between work-queue and rpc_killall_tasks

Since rpc_killall_tasks may modify the rpc_task's tk_action field
without any locking, we need to be careful when dereferencing it.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 net/sunrpc/sched.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index a27406b..4814e24 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -616,30 +616,25 @@ static void __rpc_execute(struct rpc_task *task)
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
1.7.6


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

