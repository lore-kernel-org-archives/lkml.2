Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2LZRn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 12:43:59 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44653 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752287Ab2LZRnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 12:43:55 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 12:43:55 EST
Date: Wed, 26 Dec 2012 12:33:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu, libc-alpha@sourceware.org
Subject: [RFC PATCH Userspace RCU] Discourage use of pthread_atfork() for
	call_rcu handlers
Message-ID: <20121226173318.GA22298@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discourage use of glibc pthread_atfork() for call_rcu handlers due to
its inappropriate assumptions about single-threadedness while pthread
atfork handlers are executing. This results in hangs within the glibc
memory allocator.
    
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
diff --git a/README b/README
index 83330ea..2d29c1d 100644
--- a/README
+++ b/README
@@ -273,7 +273,20 @@ Interaction with fork()
 	must invoke call_rcu_before_fork() before the fork() and
 	call_rcu_after_fork_parent() after the fork().  The child
 	process must invoke call_rcu_after_fork_child().
-	These three APIs are suitable for passing to pthread_atfork().
+	Even though these three APIs are suitable for passing to
+	pthread_atfork(), use of pthread_atfork() is *STRONGLY
+	DISCOURAGED* for programs calling the glibc memory allocator
+	(malloc(), calloc(), free(), ...) within call_rcu callbacks.
+	This is due to limitations in the way glibc memory allocator
+	handles calls to the memory allocator from concurrent threads
+	while the pthread_atfork() handlers are executing.
+	Combining e.g.:
+	* call to free() from callbacks executed within call_rcu worker
+	  threads,
+	* executing call_rcu atfork handlers within the glibc pthread
+	  atfork mechanism,
+	will sometimes trigger interesting process hangs. This usually
+	hangs on a memory allocator lock within glibc.
 
 Thread Local Storage (TLS)
 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
