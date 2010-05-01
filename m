Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0EAA1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:27:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35426 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab0EAA0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:26:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 10/10] vfs: fix RCU-lockdep false positive due to /proc access
Date: Fri, 30 Apr 2010 17:26:14 -0700
Message-Id: <1272673574-27797-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100501002548.GA27375@linux.vnet.ibm.com>
References: <20100501002548.GA27375@linux.vnet.ibm.com>
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
process.

Located-by: Miles Lane <miles.lane@gmail.com>
Located-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/fdtable.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..e4a6d31 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -61,7 +61,8 @@ struct files_struct {
 	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&(files)->count) == 1))
+			       atomic_read(&(files)->count) == 1 || \
+			       thread_group_empty(current)))
 
 #define files_fdtable(files) \
 		(rcu_dereference_check_fdtable((files), (files)->fdt))
-- 
1.7.0

