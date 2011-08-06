Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab1HFA1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:27:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1HFAIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:08:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:49 2011
Message-Id: <20110806000249.573906795@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [07/55] SUNRPC: Fix a race between work-queue and rpc_killall_tasks
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b55c59892e1f3b6c7d4b9ccffb4263e1486fb990 upstream.

Since rpc_killall_tasks may modify the rpc_task's tk_action field
without any locking, we need to be careful when dereferencing it.

Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/sched.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -613,30 +613,25 @@ static void __rpc_execute(struct rpc_tas
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


