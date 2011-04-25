Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab1DYUtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:49:32 -0400
Received: from 1wt.eu ([62.212.114.60]:34165 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab1DYUYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:32 -0400
Message-Id: <20110425200237.079370858@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 094/173] SUNRPC: Ensure we always run the tk_callback before tk_action
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e020c6800c9621a77223bf2c1ff68180e41e8ebf upstream.

This fixes a race in which the task->tk_callback() puts the rpc_task
to sleep, setting a new callback. Under certain circumstances, the current
code may end up executing the task->tk_action before it gets round to the
callback.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/sched.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -627,14 +627,12 @@ static void __rpc_execute(struct rpc_tas
 			save_callback = task->tk_callback;
 			task->tk_callback = NULL;
 			save_callback(task);
-		}
-
-		/*
-		 * Perform the next FSM step.
-		 * tk_action may be NULL when the task has been killed
-		 * by someone else.
-		 */
-		if (!RPC_IS_QUEUED(task)) {
+		} else {
+			/*
+			 * Perform the next FSM step.
+			 * tk_action may be NULL when the task has been killed
+			 * by someone else.
+			 */
 			if (task->tk_action == NULL)
 				break;
 			task->tk_action(task);


