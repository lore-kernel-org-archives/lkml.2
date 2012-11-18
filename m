Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2KRPZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:25:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58821 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2KRPZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:25:38 -0500
From: Hitoshi Mitake <h.mitake@gmail.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Hitoshi Mitake <h.mitake@gmail.com>,
        Darren Hart <dvhltc@us.ibm.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=201/3=5D=20tools=3A=20add=20new=20headers=20for=20futex=20and=20atomic=20operations?=
Date: Mon, 19 Nov 2012 00:24:30 +0900
Message-Id: <1353252272-5480-2-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1353252272-5480-1-git-send-email-h.mitake@gmail.com>
References: <1353252272-5480-1-git-send-email-h.mitake@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new header files in tools/ directory. The purpose
of adding these two headers is supporting futextest and perf bench
futex in the kernel tree. But these can be utilized by other purposes
because they are generalized enough.

This patch produces 4 checkpatch warns because of typedefing and
volatile declaration. But I think these warns are not essential
problems. If these are not acceptable, I'll seek other way.

Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 tools/include/tools/atomic.h |   95 ++++++++++++++
 tools/include/tools/futex.h  |  278 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 373 insertions(+), 0 deletions(-)
 create mode 100644 tools/include/tools/atomic.h
 create mode 100644 tools/include/tools/futex.h

diff --git a/tools/include/tools/atomic.h b/tools/include/tools/atomic.h
new file mode 100644
index 0000000..8e52957
--- /dev/null
+++ b/tools/include/tools/atomic.h
@@ -0,0 +1,95 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      atomic.h
+ *
+ * DESCRIPTION
+ *      GCC atomic builtin wrappers
+ *      http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-17: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *
+ *****************************************************************************/
+
+#ifndef _ATOMIC_H
+#define _ATOMIC_H
+
+typedef struct {
+	volatile int val;
+} atomic_t;
+
+#define ATOMIC_INITIALIZER { 0 }
+
+/**
+ * atomic_cmpxchg() - Atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Return the old value of addr->val.
+ */
+static inline int
+atomic_cmpxchg(atomic_t *addr, int oldval, int newval)
+{
+	return __sync_val_compare_and_swap(&addr->val, oldval, newval);
+}
+
+/**
+ * atomic_inc() - Atomic incrememnt
+ * @addr:	Address of the variable to increment
+ *
+ * Return the new value of addr->val.
+ */
+static inline int
+atomic_inc(atomic_t *addr)
+{
+	return __sync_add_and_fetch(&addr->val, 1);
+}
+
+/**
+ * atomic_dec() - Atomic decrement
+ * @addr:	Address of the variable to decrement
+ *
+ * Return the new value of addr-val.
+ */
+static inline int
+atomic_dec(atomic_t *addr)
+{
+	return __sync_sub_and_fetch(&addr->val, 1);
+}
+
+/**
+ * atomic_set() - Atomic set
+ * @addr:	Address of the variable to set
+ * @newval:	New value for the atomic_t
+ *
+ * Return the new value of addr->val.
+ */
+static inline int
+atomic_set(atomic_t *addr, int newval)
+{
+	addr->val = newval;
+	return newval;
+}
+
+#endif
diff --git a/tools/include/tools/futex.h b/tools/include/tools/futex.h
new file mode 100644
index 0000000..9986189
--- /dev/null
+++ b/tools/include/tools/futex.h
@@ -0,0 +1,278 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futex.h
+ *
+ * DESCRIPTION
+ *      Glibc independent futex library for testing kernel functionality.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-6: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *
+ *****************************************************************************/
+
+#ifndef _FUTEX_H
+#define _FUTEX_H
+
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <linux/futex.h>
+
+typedef volatile u_int32_t futex_t;
+#define FUTEX_INITIALIZER 0
+
+/* Define the newer op codes if the system header file is not up to date. */
+#ifndef FUTEX_WAIT_BITSET
+#define FUTEX_WAIT_BITSET		9
+#endif
+#ifndef FUTEX_WAKE_BITSET
+#define FUTEX_WAKE_BITSET		10
+#endif
+#ifndef FUTEX_WAIT_REQUEUE_PI
+#define FUTEX_WAIT_REQUEUE_PI		11
+#endif
+#ifndef FUTEX_CMP_REQUEUE_PI
+#define FUTEX_CMP_REQUEUE_PI		12
+#endif
+#ifndef FUTEX_WAIT_REQUEUE_PI_PRIVATE
+#define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#endif
+#ifndef FUTEX_REQUEUE_PI_PRIVATE
+#define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#endif
+
+/**
+ * futex() - SYS_futex syscall wrapper
+ * @uaddr:	address of first futex
+ * @op:		futex op code
+ * @val:	typically expected value of uaddr, but varies by op
+ * @timeout:	typically an absolute struct timespec (except where noted
+ *		otherwise). Overloaded by some ops
+ * @uaddr2:	address of second futex for some ops\
+ * @val3:	varies by op
+ * @opflags:	flags to be bitwise OR'd with op, such as FUTEX_PRIVATE_FLAG
+ *
+ * futex() is used by all the following futex op wrappers. It can also be
+ * used for misuse and abuse testing. Generally, the specific op wrappers
+ * should be used instead. It is a macro instead of an static inline function as
+ * some of the types over overloaded (timeout is used for nr_requeue for
+ * example).
+ *
+ * These argument descriptions are the defaults for all
+ * like-named arguments in the following wrappers except where noted below.
+ */
+#define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
+	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
+
+/**
+ * futex_wait() - block on uaddr with optional timeout
+ * @timeout:	relative timeout
+ */
+static inline int
+futex_wait(futex_t *uaddr, futex_t val, struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT, val, timeout, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake() - wake one or more tasks blocked on uaddr
+ * @nr_wake:	wake up to this many tasks
+ */
+static inline int
+futex_wake(futex_t *uaddr, int nr_wake, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_wait_bitset() - block on uaddr with bitset
+ * @bitset:	bitset to be used with futex_wake_bitset
+ */
+static inline int
+futex_wait_bitset(futex_t *uaddr, futex_t val, struct timespec *timeout,
+		  u_int32_t bitset, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT_BITSET, val, timeout, NULL, bitset,
+		     opflags);
+}
+
+/**
+ * futex_wake_bitset() - wake one or more tasks blocked on uaddr with bitset
+ * @bitset:	bitset to compare with that used in futex_wait_bitset
+ */
+static inline int
+futex_wake_bitset(futex_t *uaddr, int nr_wake, u_int32_t bitset, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE_BITSET, nr_wake, NULL, NULL, bitset,
+		     opflags);
+}
+
+/**
+ * futex_lock_pi() - block on uaddr as a PI mutex
+ * @detect:	whether (1) or not (0) to perform deadlock detection
+ */
+static inline int
+futex_lock_pi(futex_t *uaddr, struct timespec *timeout, int detect,
+	      int opflags)
+{
+	return futex(uaddr, FUTEX_LOCK_PI, detect, timeout, NULL, 0, opflags);
+}
+
+/**
+ * futex_unlock_pi() - release uaddr as a PI mutex, waking the top waiter
+ */
+static inline int
+futex_unlock_pi(futex_t *uaddr, int opflags)
+{
+	return futex(uaddr, FUTEX_UNLOCK_PI, 0, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake_op() - FIXME: COME UP WITH A GOOD ONE LINE DESCRIPTION
+ */
+static inline int
+futex_wake_op(futex_t *uaddr, futex_t *uaddr2, int nr_wake, int nr_wake2,
+	      int wake_op, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE_OP, nr_wake, nr_wake2, uaddr2, wake_op,
+		     opflags);
+}
+
+/**
+ * futex_requeue() - requeue without expected value comparison, deprecated
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ *
+ * Due to its inherently racy implementation, futex_requeue() is deprecated in
+ * favor of futex_cmp_requeue().
+ */
+static inline int
+futex_requeue(futex_t *uaddr, futex_t *uaddr2, int nr_wake, int nr_requeue,
+	      int opflags)
+{
+	return futex(uaddr, FUTEX_REQUEUE, nr_wake, nr_requeue, uaddr2, 0,
+		     opflags);
+}
+
+/**
+ * futex_cmp_requeue() - requeue tasks from uaddr to uaddr2
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ */
+static inline int
+futex_cmp_requeue(futex_t *uaddr, futex_t val, futex_t *uaddr2, int nr_wake,
+		  int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE, nr_wake, nr_requeue, uaddr2,
+		     val, opflags);
+}
+
+/**
+ * futex_wait_requeue_pi() - block on uaddr and prepare to requeue to uaddr2
+ * @uaddr:	non-PI futex source
+ * @uaddr2:	PI futex target
+ *
+ * This is the first half of the requeue_pi mechanism. It shall always be
+ * paired with futex_cmp_requeue_pi().
+ */
+static inline int
+futex_wait_requeue_pi(futex_t *uaddr, futex_t val, futex_t *uaddr2,
+		      struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT_REQUEUE_PI, val, timeout, uaddr2, 0,
+		     opflags);
+}
+
+/**
+ * futex_cmp_requeue_pi() - requeue tasks from uaddr to uaddr2 (PI aware)
+ * @uaddr:	non-PI futex source
+ * @uaddr2:	PI futex target
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ */
+static inline int
+futex_cmp_requeue_pi(futex_t *uaddr, futex_t val, futex_t *uaddr2, int nr_wake,
+		     int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE_PI, nr_wake, nr_requeue, uaddr2,
+		val, opflags);
+}
+
+/**
+ * futex_cmpxchg() - atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Implement cmpxchg using gcc atomic builtins.
+ * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
+ *
+ * Return the old futex value.
+ */
+static inline u_int32_t
+futex_cmpxchg(futex_t *uaddr, u_int32_t oldval, u_int32_t newval)
+{
+	return __sync_val_compare_and_swap(uaddr, oldval, newval);
+}
+
+/**
+ * futex_dec() - atomic decrement of the futex value
+ * @uaddr:	The address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_dec(futex_t *uaddr)
+{
+	return __sync_sub_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_inc() - atomic increment of the futex value
+ * @uaddr:	the address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_inc(futex_t *uaddr)
+{
+	return __sync_add_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_set() - atomic decrement of the futex value
+ * @uaddr:	the address of the futex to be modified
+ * @newval:	New value for the atomic_t
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_set(futex_t *uaddr, u_int32_t newval)
+{
+	*uaddr = newval;
+	return newval;
+}
+
+#endif	/* _FUTEX_H */
-- 
1.7.5.1

