Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0FQAyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:54:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55004 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0FQAyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:54:14 -0400
Date: Wed, 16 Jun 2010 17:54:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, mingo@elte.hu, miles.lane@gmail.com,
       eric.dumazet@gmail.com
Subject: [PATCH] vfs repost: fix RCU-lockdep false positive due to /proc
 access
Message-ID: <20100617005410.GA8729@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100511172356.GA11103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511172356.GA11103@linux.vnet.ibm.com>
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
