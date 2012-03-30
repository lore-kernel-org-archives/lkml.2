Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936535Ab2C3Wc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:32:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935509Ab2C3VJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:52 -0400
Message-Id: <20120330194837.742712078@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [ 022/149] futex: Cover all PI opcodes with cmpxchg enabled check
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 59263b513c11398cd66a52d4c5b2b118ce1e0359 upstream.

Some of the newer futex PI opcodes do not check the cmpxchg enabled
variable and call unconditionally into the handling functions. Cover
all PI opcodes in a separate check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2641,6 +2641,16 @@ long do_futex(u32 __user *uaddr, int op,
 	}
 
 	switch (cmd) {
+	case FUTEX_LOCK_PI:
+	case FUTEX_UNLOCK_PI:
+	case FUTEX_TRYLOCK_PI:
+	case FUTEX_WAIT_REQUEUE_PI:
+	case FUTEX_CMP_REQUEUE_PI:
+		if (!futex_cmpxchg_enabled)
+			return -ENOSYS;
+	}
+
+	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
@@ -2661,16 +2671,13 @@ long do_futex(u32 __user *uaddr, int op,
 		ret = futex_wake_op(uaddr, flags, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, flags, val, timeout, 0);
+		ret = futex_lock_pi(uaddr, flags, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_unlock_pi(uaddr, flags);
+		ret = futex_unlock_pi(uaddr, flags);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, flags, 0, timeout, 1);
+		ret = futex_lock_pi(uaddr, flags, 0, timeout, 1);
 		break;
 	case FUTEX_WAIT_REQUEUE_PI:
 		val3 = FUTEX_BITSET_MATCH_ANY;


