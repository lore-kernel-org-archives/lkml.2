Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1CCCJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:09:25 -0500
Received: from mout.perfora.net ([74.208.4.195]:55741 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab1CCCJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:09:24 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH] Enable writing to /proc/PID/mem.
Date: Wed,  2 Mar 2011 21:07:54 -0500
Message-Id: <1299118074-13342-1-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
X-Provags-ID: V02:K0:E8LRVyaXk9RoiMVl68RFgXJ1oiDmF7lqcoAbHYr2j4B
 75ogtQeZMGQJb7FEnDLHCNPMwJpdCjRa6+lUTFkHfapLGd5Bm+
 Yhg8PFhQvhYSAqyvO5apbRUPFYl/TPkOREBix/C1q9mCos0HI4
 ub1/4SScYRb1Ar6R0R4JXl6PFOZf24chxeSwvnz70U7jFo/WXh
 mo4QbcZreGz1kaiZqarCrrNKU8wH9xLn3VycXmgzrQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a long time /proc/PID/mem has provided a read-only interface, at least since
2.4.0.  However, a write capability has existed "forever" in tree via the
function mem_write, disabled with an #ifdef along with the comment "this is a
security hazard".  Charles Wright, back in 2006, gave some history on the
subject:

    http://lkml.org/lkml/2006/3/10/224

Later, in commit 638fa202c, Roland McGrath updated mem_write to call
check_mem_permission which ensures an identical security policy for
/proc/PID/mem as for ptrace().  IOW, the proc interface provides a simpler, more
efficient, but otherwise equivalent mechanism for probing a processes memory as
available via ptrace.

There is no longer a security hazard and the world can safely use read/write
instead of ptrace PEEK/POKE's.  Remove the #ifdef.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/base.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..70fc4db 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -829,10 +829,6 @@ out_no_task:
 	return ret;
 }
 
-#define mem_write NULL
-
-#ifndef mem_write
-/* This is a security hazard */
 static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -880,7 +876,6 @@ out:
 out_no_task:
 	return copied;
 }
-#endif
 
 loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
-- 
1.7.3.5

