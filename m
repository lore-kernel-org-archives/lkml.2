Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1FVTTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:19:51 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:42456 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248Ab1FVTTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:19:50 -0400
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH RFC] futex: Fix regression with read only mappings
Date: Wed, 22 Jun 2011 14:19:00 -0500
Message-Id: <1308770340-21895-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4DF8FFF6.4060000@linux.intel.com>
References: <4DF8FFF6.4060000@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
parameter from get_futex_key()) in 2.6.33 introduced a user-mode
regression in that it additionally prevented futex operations on a
region within a read only memory mapped file.  For example this breaks
workloads that have one or more reader processes doing a FUTEX_WAIT on a
futex within a read only shared mapping, and a writer processes that has
a writable mapping issuing the FUTEX_WAKE.

This fixes the regression for futex operations that should be valid on
RO mappings by trying a RO get_user_pages_fast() when the RW
get_user_pages_fast() fails so as not to slow down the common path of
writable anonymous maps and bailing when we used the RO path on
anonymous memory.

Patch based on Peter Zijlstra's initial patch with modifications to only
allow RO mappings for futex operations that need VERIFY_READ access.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---

Interestingly this patch also allows doing a FUTEX_WAIT on a RO private
mapping.  Where my tests on 2.6.18 show that this used to wait
indefinitely.  Performing a FUTEX_WAIT on a RW private mapping waits
indefinitely in 2.6.18, 3.0.0, and with this patch applied.  It is
unclear to me if this is a good thing or a bug.

 kernel/futex.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..e8cd532 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -218,6 +218,8 @@ static void drop_futex_key_refs(union futex_key *key)
  * @uaddr:	virtual address of the futex
  * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
  * @key:	address where result is stored.
+ * @rw:		mapping needs to be read/write (values: VERIFY_READ,
+ *		VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -229,12 +231,12 @@ static void drop_futex_key_refs(union futex_key *key)
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int
-get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
+get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err;
+	int err, ro = 0;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -262,6 +264,10 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 
 again:
 	err = get_user_pages_fast(address, 1, 1, &page);
+	if (err == -EFAULT && rw == VERIFY_READ) {
+		err = get_user_pages_fast(address, 1, 0, &page);
+		ro = 1;
+	}
 	if (err < 0)
 		return err;
 
@@ -316,6 +322,11 @@ again:
 	 * the object not the particular process.
 	 */
 	if (PageAnon(page_head)) {
+		if (ro) {
+			err = -EFAULT;
+			goto out;
+		}
+
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
@@ -327,9 +338,11 @@ again:
 
 	get_futex_key_refs(key);
 
+	err = 0;
+out:
 	unlock_page(page_head);
 	put_page(page_head);
-	return 0;
+	return err;
 }
 
 static inline void put_futex_key(union futex_key *key)
@@ -940,7 +953,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -986,10 +999,10 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	int ret, op_ret;
 
 retry:
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1243,10 +1256,11 @@ retry:
 		pi_state = NULL;
 	}
 
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2,
+			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1790,7 +1804,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 * while the syscall executes.
 	 */
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1941,7 +1955,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 	}
 
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2060,7 +2074,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != vpid)
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2249,7 +2263,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
-- 
1.6.5.2



---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

