Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830Ab1FXQAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:00:14 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:40861 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab1FXQAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:00:11 -0400
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH v2] futex: Fix regression with read only mappings
Date: Fri, 24 Jun 2011 10:59:46 -0500
Message-Id: <1308931186-28707-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>
References: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>
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

While fixing the regression this patch opens up two possible bad
scenarios as identified by KOSAKI Motohiro:

1) This patch also allows FUTEX_WAIT on RO private mappings which have
the following corner case.

  Thread-A: call futex(FUTEX_WAIT, memory-region-A).
            get_futex_key() return inode based key.
            sleep on the key
  Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
  Thread-B: write memory-region-A.
            COW happen. This process's memory-region-A become related
            to new COWed private (ie PageAnon=1) page.
  Thread-B: call futex(FUETX_WAKE, memory-region-A).
            get_futex_key() return mm based key.
            IOW, we fail to wake up Thread-A.

2) Current futex code doesn't handle zero page properly.

  Read mode get_user_pages() can return zero page, but current futex
  code doesn't handle it at all. Then, zero page makes infinite loop
  internally.

This Patch is based on Peter Zijlstra's initial patch with modifications to
only allow RO mappings for futex operations that need VERIFY_READ access.

Reported-by: David Oliver <david@rgmadvisors.com>
Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---

Consolidated fshared and rw into flags.  Moved clearing of err closer to
get_user_pages_fast() call.  Clairified corner cases that this patch
opens up in the commit log.

 kernel/futex.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..6f828bc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -75,6 +75,7 @@ int __read_mostly futex_cmpxchg_enabled;
 #define FLAGS_SHARED		0x01
 #define FLAGS_CLOCKRT		0x02
 #define FLAGS_HAS_TIMEOUT	0x04
+#define FLAGS_WRITE		0x08
 
 /*
  * Priority Inheritance state:
@@ -216,7 +217,7 @@ static void drop_futex_key_refs(union futex_key *key)
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
- * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
+ * @flags:	futex flags (FLAGS_SHARED, etc.)
  * @key:	address where result is stored.
  *
  * Returns a negative error code or 0
@@ -229,12 +230,12 @@ static void drop_futex_key_refs(union futex_key *key)
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int
-get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
+get_futex_key(u32 __user *uaddr, int flags, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err;
+	int err, ro = 0;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -251,7 +252,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 	 * Note : We do have to check 'uaddr' is a valid user address,
 	 *        but access_ok() should be faster than find_vma()
 	 */
-	if (!fshared) {
+	if (!(flags & FLAGS_SHARED)) {
 		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
 			return -EFAULT;
 		key->private.mm = mm;
@@ -262,8 +263,14 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 
 again:
 	err = get_user_pages_fast(address, 1, 1, &page);
+	if (err == -EFAULT && !(flags & FLAGS_WRITE)) {
+		err = get_user_pages_fast(address, 1, 0, &page);
+		ro = 1;
+	}
 	if (err < 0)
 		return err;
+	else
+		err = 0;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page_head = page;
@@ -316,6 +323,11 @@ again:
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
@@ -327,9 +339,10 @@ again:
 
 	get_futex_key_refs(key);
 
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
+	ret = get_futex_key(uaddr, flags, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -986,10 +999,10 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	int ret, op_ret;
 
 retry:
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret = get_futex_key(uaddr1, flags, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags | FLAGS_WRITE, &key2);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1243,10 +1256,11 @@ retry:
 		pi_state = NULL;
 	}
 
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
+	ret = get_futex_key(uaddr1, flags, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, requeue_pi ? flags | FLAGS_WRITE : flags,
+	                    &key2);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1790,7 +1804,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 * while the syscall executes.
 	 */
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
+	ret = get_futex_key(uaddr, flags, &q->key);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1941,7 +1955,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 	}
 
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
+	ret = get_futex_key(uaddr, flags | FLAGS_WRITE, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2060,7 +2074,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != vpid)
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags | FLAGS_WRITE, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2249,7 +2263,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags | FLAGS_WRITE, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
-- 
1.6.5.2



---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

