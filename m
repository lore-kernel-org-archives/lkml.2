Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0LLQsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:48:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:45354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0LLQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:48:40 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] init: don't call flush_scheduled_work() from do_initcalls()
Date: Sun, 12 Dec 2010 17:48:14 +0100
Message-Id: <1292172499-21633-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:48:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to flush_scheduled_work() in do_initcalls() is there to make
sure all works queued to system_wq by initcalls finish before the init
sections are dropped.

However, the call doesn't make much sense at this point - there
already are multiple different workqueues and different subsystems are
free to create and use their own.  Ordering requirements are and
should be expressed explicitly.

Drop the call to prepare for the deprecation and removal of
flush_scheduled_work().

Andrew suggested adding sanity check where the workqueue code checks
whether any pending or running work has the work function in the init
text section.  However, checking this for running works requires the
worker to keep track of the current function being executed, and
checking only the pending works will miss most cases.  As a violation
will almost always be caught by the usual page fault mechanism, I
don't think it would be worthwhile to make the workqueue code track
extra state just for this.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
This is part of a series to remove flush_scheduled_work() usage to
prepare for deprecation of flush_scheduled_work().  Patches in this
series are self contained and mostly straight-forward.

Please feel free to take it into the appropriate tree, or just ack it.
In the latter case, I'll merge the patch through the workqueue tree
during the next merge window.

Thank you.

 init/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8646401..5421e8f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -775,9 +775,6 @@ static void __init do_initcalls(void)
 
 	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
 		do_one_initcall(*fn);
-
-	/* Make sure there is no pending stuff from the initcall sequence */
-	flush_scheduled_work();
 }
 
 /*
-- 
1.7.1

