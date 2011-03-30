Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127Ab1C3VJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:33350 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964903Ab1C3VJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278727"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [209/275] SUNRPC: Ensure we always run the tk_callback before tk_action
Message-Id: <20110330210733.BCBEB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e020c6800c9621a77223bf2c1ff68180e41e8ebf upstream.

This fixes a race in which the task->tk_callback() puts the rpc_task
to sleep, setting a new callback. Under certain circumstances, the current
code may end up executing the task->tk_action before it gets round to the
callback.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sunrpc/sched.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/net/sunrpc/sched.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/sched.c	2011-03-29 22:50:35.157358829 -0700
+++ linux-2.6.35.y/net/sunrpc/sched.c	2011-03-29 23:03:02.613233304 -0700
@@ -637,14 +637,12 @@
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
