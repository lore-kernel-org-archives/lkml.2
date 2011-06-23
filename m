Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab1FWRiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:35280 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab1FWRh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 192/247] SUNRPC: Ensure we always run the tk_callback before tk_action
Date: Thu, 23 Jun 2011 13:34:20 -0400
Message-Id: <1308850515-15242-133-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e020c6800c9621a77223bf2c1ff68180e41e8ebf upstream.

This fixes a race in which the task->tk_callback() puts the rpc_task
to sleep, setting a new callback. Under certain circumstances, the current
code may end up executing the task->tk_action before it gets round to the
callback.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/sched.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index aae6907..03a5c9e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -642,14 +642,12 @@ static void __rpc_execute(struct rpc_task *task)
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
-- 
1.7.4.4

