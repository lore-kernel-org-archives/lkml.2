Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2EOLwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:52:44 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:32809 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757851Ab2EOLwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:52:43 -0400
Message-ID: <1337082726.1898.14.camel@castor.rsk>
Subject: [PATCH] perf: reorder perf_event_context to remove 8 bytes of
 padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Tue, 15 May 2012 12:52:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder structure perf_event_context to remove 8 bytes of padding on 64
bit builds, which also shrinks structure perf_cpu_context by 8 bytes.
Reducing its size to 256 bytes so allowing it to fit into one fewer
cache lines.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against v3.4-rc7
compiled and tested on x86_64

I have given this patch some light testing and perf still seems to work
OK.

perf_pin_task_context() increments both the pin_count and the refcount
so it seems a sensible place to put pin_count so there isn't any padding
after refcount. Obviously we can reorder this structure in other ways if
you prefer.

regards
Richard


diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ddbb6a9..964c0cf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1027,6 +1027,7 @@ struct perf_event_context {
 	int				nr_freq;
 	int				rotate_disable;
 	atomic_t			refcount;
+	int				pin_count;
 	struct task_struct		*task;
 
 	/*
@@ -1036,13 +1037,12 @@ struct perf_event_context {
 	u64				timestamp;
 
 	/*
-	 * These fields let us detect when two contexts have both
-	 * been cloned (inherited) from a common ancestor.
+	 * These fields (with pin_count) let us detect when two contexts
+	 * have both been cloned (inherited) from a common ancestor.
 	 */
 	struct perf_event_context	*parent_ctx;
 	u64				parent_gen;
 	u64				generation;
-	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
 	int				nr_branch_stack; /* branch_stack evt */
 	struct rcu_head			rcu_head;


