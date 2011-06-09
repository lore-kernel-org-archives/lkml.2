Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1FILhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:37:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53407 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1FILhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:37:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF0B072.8060204@jp.fujitsu.com>
Date: Thu, 09 Jun 2011 20:37:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: dvhart@linux.intel.com
CC: david@rgmadvisors.com, kyle@moffetthome.net, luto@mit.edu,
        eric.dumazet@gmail.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, sbohrer@rgmadvisors.com,
        zvonler@rgmadvisors.com, hughd@google.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	<1307373819.3098.40.camel@edumazet-laptop>	<1307376672.2322.167.camel@twins>	<1307376989.2322.171.camel@twins>	<1307377349.3098.65.camel@edumazet-laptop>	<1307377782.2322.183.camel@twins>	<1307378564.3098.67.camel@edumazet-laptop>	<4DED1421.5000300@linux.intel.com>	<1307383898.3098.90.camel@edumazet-laptop>	<4DED976C.90009@linux.intel.com>	<4DEE3944.5020005@mit.edu>	<1307462300.3091.39.camel@edumazet-laptop>	<BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>	<BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com>	<BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>	<BANLkTi=vwJBgkKSY_Cq_jQS-71gH6uOPaw@mail.gmail.com> <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com> <4DEFA18A.2000808@linux.intel.com>
In-Reply-To: <4DEFA18A.2000808@linux.intel.com>
Content-Type: multipart/mixed;
 boundary="------------020007070804060709010708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020007070804060709010708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi

I'm sorry for the long delay.

>> Having a new call is inelegant from a futex(2) user perspective, as
>> the need for a change is due to the kernel implementation and/or mutex
>> requirements. The futex() system call, as documented, is ideal for a
>> single producer to signal multiple receivers of state updates.
>>
>> If it is truly necessary to add new variants to futex() to protect
>> applications that allow untrusted applications read access to their
>> mutexes, I would avoid both the names suggested, as consumption of
>> wakeups is not an obvious issue to users, and POLL suggests waiting
>> for multiple entities as in poll(2) (which is not provided), or
>> returning immediately (which is orthogonally provided by the timeout
>> parameter). What is being provided from the user point of view is a
>> FUTEX_WAIT per the man page, which doesn't require write access. How
>> about FUTEX_WAIT_RDONLY?
>>
>> Alternatively, use the current call and document that when process
>> performing a FUTEX_WAIT on read-only memory are woken, they do not
>> count towards the number reported as being woken.
>>
>> Best, IMHO, would be to document that providing read access to mutexes
>> to untrusted software is unsafe behavior, and restore read only access
>> to readers of futexes.
> 
> I'm inclined to agree with this approach.

Honestly says, I didn't thought RO mapping users are there in real world.
I'm sorry. I did hope to fix COW issue, not intended to break David Oliver's
workload.

And, I now also recognized this is hard to fix issue. Any fix might screw up
Perter's long time performance improvement effort. Hmm....

Personally, I also incline to agree with FUTEX_WAIT_RDONLY approach. But I
also hope to remove David's head pain. I now have big dilemma. Could you
please give me a chance to show my fixing idea once? If anybody dislike
my idea, I'll drop my opinion quickly.

Today, I've made one concept proof patch. The idea is

1) check the pte of the target address is RW attribute.
 2-1) if yes, it has no COW chance. we can safely use gup result.
 2-2) if no, we have to fallback slow vma walk. maybe, it's okey.
      both RO mappings and COW are rare situation.

I'm not futex expert and I really hope and have to get Darren't review.
I hope to hear somebody's comments.

0001-Revert-futexes-Remove-rw-parameter-from-get_futex_ke.patch
0002-make-slowpath.patch
	Alternative fixing idea. Just RFC.

0001-FUTEX_WAIT-read-only.patch
	testcase for Darren't futextest git tree.

performance.txt
	performance result of Darren't performance test in futextest git.
	This seems no significant performance loss.


Again, I have no strong opinion. If anyone put objection, I'll drop this
proposal immediately.


Thanks.




--------------020007070804060709010708
Content-Type: text/plain;
 name="0001-FUTEX_WAIT-read-only.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-FUTEX_WAIT-read-only.patch"

>From 7936ff2c763154f05588e0d35e0cd231774e8aa9 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 9 Jun 2011 20:20:17 +0900
Subject: [PATCH] FUTEX_WAIT read only

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 functional/Makefile        |    3 +-
 functional/futex_wait_ro.c |  152 ++++++++++++++++++++++++++++++++++++++++++++
 functional/run.sh          |    2 +
 3 files changed, 156 insertions(+), 1 deletions(-)
 create mode 100644 functional/futex_wait_ro.c

diff --git a/functional/Makefile b/functional/Makefile
index 6ecb42c..aec23e5 100644
--- a/functional/Makefile
+++ b/functional/Makefile
@@ -10,7 +10,8 @@ TARGETS := \
 	futex_requeue_pi_signal_restart \
 	futex_requeue_pi_mismatched_ops \
 	futex_wait_uninitialized_heap \
-	futex_wait_private_mapped_file
+	futex_wait_private_mapped_file \
+	futex_wait_ro
 
 .PHONY: all clean
 all: $(TARGETS)
diff --git a/functional/futex_wait_ro.c b/functional/futex_wait_ro.c
new file mode 100644
index 0000000..59bf2e7
--- /dev/null
+++ b/functional/futex_wait_ro.c
@@ -0,0 +1,152 @@
+/******************************************************************************
+ *
+ * Copyright FUJITSU LIMITED 2011
+ * Copyright KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
+ *      futex_wait_ro.c
+ *
+ * DESCRIPTION
+ *
+ * AUTHOR
+ *      KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *
+ * HISTORY
+ *      2011-Jun-9: Initial version by KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+ *
+ *****************************************************************************/
+
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/futex.h>
+#include <libgen.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include "logging.h"
+#include "futextest.h"
+
+#define WAIT_US 500000
+
+static int child_blocked = 1;
+static int child_ret;
+
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+void *wait_thread(void *arg)
+{
+	int res;
+	int fd = (int)(unsigned long)arg;
+	futex_t *futex;
+	int i;
+
+	futex = mmap(0, sizeof(int), PROT_READ, MAP_SHARED, fd, 0);
+	child_ret = RET_PASS;
+
+	res = futex_wait(futex, *futex, NULL, 0);
+	child_blocked = 0;
+
+	if (res != 0) {
+		error("futex failure\n", errno);
+		child_ret = RET_ERROR;
+	}
+	pthread_exit(NULL);
+}
+
+
+int main(int argc, char **argv)
+{
+	int c, ret = RET_PASS;
+	long page_size;
+	pthread_t thr;
+	futex_t *futex;
+	int fd;
+
+	while ((c = getopt(argc, argv, "chv:")) != -1) {
+		switch(c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	page_size = sysconf(_SC_PAGESIZE);
+
+	fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
+	write(fd, "\1\1\1\1", 4);
+
+
+	printf("%s: Test FUTEX_WAIT read only mapping futex \n",
+	       basename(argv[0]));
+
+	ret = pthread_create(&thr, NULL, wait_thread, (void*)(unsigned long)fd);
+	if (ret) {
+		error("pthread_create\n", errno);
+		ret = RET_ERROR;
+		goto out;
+	}
+
+	usleep(1000);
+
+	futex = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
+		   MAP_SHARED, fd, 0);
+	if (futex == (void *)-1) {
+		error("mmap\n", errno);
+		exit(1);
+	}
+	*futex = 0;
+	futex_wake(futex, 1, 0);
+
+	info("waiting %dus for child to return\n", WAIT_US);
+	usleep(WAIT_US);
+
+	if (child_blocked) {
+		fail("child blocked in kernel\n");
+		ret = RET_FAIL;
+	} else {
+		ret = child_ret;
+	}
+
+ out:
+	print_result(ret);
+	return ret;
+}
diff --git a/functional/run.sh b/functional/run.sh
index 571a4a4..b82c32d 100755
--- a/functional/run.sh
+++ b/functional/run.sh
@@ -90,3 +90,5 @@ echo
 ./futex_wait_uninitialized_heap $COLOR
 ./futex_wait_private_mapped_file $COLOR
 
+echo
+./futex_wait_ro $COLOR
\ No newline at end of file
-- 
1.7.3.1


--------------020007070804060709010708
Content-Type: text/plain;
 name="0001-Revert-futexes-Remove-rw-parameter-from-get_futex_ke.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Revert-futexes-Remove-rw-parameter-from-get_futex_ke.pa";
 filename*1="tch"

>From 7c44963ec734f9bf04135ce68dfe0768f75e6daf Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 8 Jun 2011 09:21:59 +0900
Subject: [PATCH 1/2] Revert "futexes: Remove rw parameter from get_futex_key()"

This reverts commit 7485d0d3758e8e6491a5c9468114e74dc050785d.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/futex.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..1a91ea2 100644
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
@@ -229,7 +231,7 @@ static void drop_futex_key_refs(union futex_key *key)
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int
-get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
+get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -252,7 +254,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 	 *        but access_ok() should be faster than find_vma()
 	 */
 	if (!fshared) {
-		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
+		if (unlikely(!access_ok(rw, uaddr, sizeof(u32))))
 			return -EFAULT;
 		key->private.mm = mm;
 		key->private.address = address;
@@ -261,7 +263,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 	}
 
 again:
-	err = get_user_pages_fast(address, 1, 1, &page);
+	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
 	if (err < 0)
 		return err;
 
@@ -940,7 +942,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -986,10 +988,10 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
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
 
@@ -1243,10 +1245,11 @@ retry:
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
 
@@ -1790,7 +1793,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 * while the syscall executes.
 	 */
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1941,7 +1944,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 	}
 
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2060,7 +2063,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != vpid)
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2249,7 +2252,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
+	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
-- 
1.7.3.1


--------------020007070804060709010708
Content-Type: text/plain;
 name="0002-make-slowpath.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-make-slowpath.patch"

>From afce8c6e41e215c7e3ba2272c8431a9acf71305a Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 9 Jun 2011 16:19:33 +0900
Subject: [PATCH 2/2] make slowpath

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/futex.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 1a91ea2..5382c05 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -213,6 +213,58 @@ static void drop_futex_key_refs(union futex_key *key)
 	}
 }
 
+static noinline int
+get_futex_key_slowpath(unsigned long address, union futex_key *key, int rw)
+{
+	int err;
+	struct mm_struct *mm = current->mm;
+	struct page *page;
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_extend_vma(mm, address);
+	err = -EFAULT;
+	if (unlikely(!vma))
+		goto err_out;
+
+	err = -EACCES;
+	if (!(vma->vm_flags & (rw==VERIFY_READ ? VM_READ : VM_WRITE)))
+		goto err_out;
+
+	err = 0;
+	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
+		key->both.offset |= FUT_OFF_MMSHARED;
+		key->private.mm = mm;
+		key->private.address = address;
+		goto out;
+	}
+
+	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
+		key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
+		key->both.offset |= FUT_OFF_INODE;
+		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
+				     + vma->vm_pgoff);
+		goto out;
+	}
+
+	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
+	if (err < 0)
+		goto err_out;
+
+	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
+	key->both.offset |= FUT_OFF_INODE;
+	key->shared.pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	put_page(page);
+
+ out:
+	get_futex_key_refs(key);
+ err_out:
+	up_read(&current->mm->mmap_sem);
+
+	return err;
+}
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -236,7 +288,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err;
+	int ret;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -263,9 +315,9 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	}
 
 again:
-	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
-	if (err < 0)
-		return err;
+	ret = __get_user_pages_fast(address, 1, 1, &page);
+	if (unlikely(!ret))
+		return get_futex_key_slowpath(address, key, rw);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page_head = page;
-- 
1.7.3.1


--------------020007070804060709010708
Content-Type: text/plain;
 name="performance.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="performance.txt"

<without patch>

futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=1
Result: 39683 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=2
Result: 12804 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=3
Result: 12626 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=4
Result: 12453 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=5
Result: 12453 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=6
Result: 12484 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=8
Result: 12531 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=10
Result: 12392 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=12
Result: 12610 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=16
Result: 12469 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=24
Result: 12422 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=32
Result: 12500 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=64
Result: 12346 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=128
Result: 12484 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=256
Result: 12330 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=512
Result: 11628 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=1024
Result: 8285 Kiter/s


<with patch>

futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=1
Result: 39683 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=2
Result: 12500 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=3
Result: 13055 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=4
Result: 12438 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=5
Result: 12453 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=6
Result: 12755 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=8
Result: 12547 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=10
Result: 12516 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=12
Result: 12407 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=16
Result: 12469 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=24
Result: 12453 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=32
Result: 12453 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=64
Result: 12330 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=128
Result: 12407 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=256
Result: 12346 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=512
Result: 11876 Kiter/s
futex_wait: Measure FUTEX_WAIT operations per second
        Arguments: iterations=100000000 threads=1024
Result: 9107 Kiter/s


--------------020007070804060709010708--

