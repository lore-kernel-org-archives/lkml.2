Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0EKRYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:24:01 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43612 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0EKRX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:23:59 -0400
Date: Tue, 11 May 2010 10:23:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, mingo@elte.hu, miles.lane@gmail.com,
       eric.dumazet@gmail.com
Subject: [PATCH] vfs: fix RCU-lockdep false positive due to /proc access
Message-ID: <20100511172356.GA11103@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a single-threaded process does a file-descriptor operation, and
some other process accesses that same file descriptor via /proc,
the current rcu_dereference_check_fdtable() can give a false-positive
RCU-lockdep splat due to the reference count being increased by the
/proc access after the reference-count check in fget_light() but before
the check in rcu_dereference_check_fdtable().

This commit prevents this false positive by checking for a single-threaded
process.  To avoid #include hell, this commit uses the wrapper for
thread_group_empty(current) defined by rcu_my_thread_group_empty()
provided in a separate commit.

Located-by: Miles Lane <miles.lane@gmail.com>
Located-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 fdtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..d147461 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -61,7 +61,8 @@ struct files_struct {
 	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1))
+			       atomic_read(&(files)->count) == 1 || \
+			       rcu_my_thread_group_empty()))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
