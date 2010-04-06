Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0DFT43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:56:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:37377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab0DFT4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:56:22 -0400
Date: Tue, 6 Apr 2010 19:55:15 GMT
From: tip-bot for Carsten Emde <C.Emde@osadl.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       pradysam@gmail.com, arjan@infradead.org, akpm@linux-foundation.org,
       tglx@linutronix.de, C.Emde@osadl.org
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, pradysam@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, C.Emde@osadl.org
In-Reply-To: <20100402204331.715783034@osadl.org>
References: <20100402204331.715783034@osadl.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] mqueue: Convert message queue timeout to use hrtimers
Message-ID: <tip-9ca7d8e6834c40a99622bbe4a88aaf64313ae43c@git.kernel.org>
Git-Commit-ID: 9ca7d8e6834c40a99622bbe4a88aaf64313ae43c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 19:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ca7d8e6834c40a99622bbe4a88aaf64313ae43c
Gitweb:     http://git.kernel.org/tip/9ca7d8e6834c40a99622bbe4a88aaf64313ae43c
Author:     Carsten Emde <C.Emde@osadl.org>
AuthorDate: Fri, 2 Apr 2010 22:40:20 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 6 Apr 2010 21:50:03 +0200

mqueue: Convert message queue timeout to use hrtimers

The message queue functions mq_timedsend() and mq_timedreceive()
have not yet been converted to use the hrtimer interface.

This patch replaces the call to schedule_timeout() by a call to
schedule_hrtimeout() and transforms the expiration time from
timespec to ktime as required.

[ tglx: Fixed whitespace wreckage ]

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Tested-by: Pradyumna Sampath <pradysam@gmail.com>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20100402204331.715783034@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 ipc/mqueue.c |   74 +++++++++++++++++++--------------------------------------
 1 files changed, 25 insertions(+), 49 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index e4e3f04..a9d8b0c 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -428,7 +428,7 @@ static void wq_add(struct mqueue_inode_info *info, int sr,
  * sr: SEND or RECV
  */
 static int wq_sleep(struct mqueue_inode_info *info, int sr,
-			long timeout, struct ext_wait_queue *ewp)
+		    ktime_t *timeout, struct ext_wait_queue *ewp)
 {
 	int retval;
 	signed long time;
@@ -439,7 +439,8 @@ static int wq_sleep(struct mqueue_inode_info *info, int sr,
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
-		time = schedule_timeout(timeout);
+		time = schedule_hrtimeout_range_clock(timeout,
+		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
@@ -551,31 +552,16 @@ static void __do_notify(struct mqueue_inode_info *info)
 	wake_up(&info->wait_q);
 }
 
-static long prepare_timeout(struct timespec *p)
+static int prepare_timeout(const struct timespec __user *u_abs_timeout,
+			   ktime_t *expires, struct timespec *ts)
 {
-	struct timespec nowts;
-	long timeout;
-
-	if (p) {
-		if (unlikely(p->tv_nsec < 0 || p->tv_sec < 0
-			|| p->tv_nsec >= NSEC_PER_SEC))
-			return -EINVAL;
-		nowts = CURRENT_TIME;
-		/* first subtract as jiffies can't be too big */
-		p->tv_sec -= nowts.tv_sec;
-		if (p->tv_nsec < nowts.tv_nsec) {
-			p->tv_nsec += NSEC_PER_SEC;
-			p->tv_sec--;
-		}
-		p->tv_nsec -= nowts.tv_nsec;
-		if (p->tv_sec < 0)
-			return 0;
-
-		timeout = timespec_to_jiffies(p) + 1;
-	} else
-		return MAX_SCHEDULE_TIMEOUT;
+	if (copy_from_user(ts, u_abs_timeout, sizeof(struct timespec)))
+		return -EFAULT;
+	if (!timespec_valid(ts))
+		return -EINVAL;
 
-	return timeout;
+	*expires = timespec_to_ktime(*ts);
+	return 0;
 }
 
 static void remove_notification(struct mqueue_inode_info *info)
@@ -861,22 +847,21 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	struct ext_wait_queue *receiver;
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
-	struct timespec ts, *p = NULL;
-	long timeout;
+	ktime_t expires, *timeout = NULL;
+	struct timespec ts;
 	int ret;
 
 	if (u_abs_timeout) {
-		if (copy_from_user(&ts, u_abs_timeout, 
-					sizeof(struct timespec)))
-			return -EFAULT;
-		p = &ts;
+		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
+		if (res)
+			return res;
+		timeout = &expires;
 	}
 
 	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
 		return -EINVAL;
 
-	audit_mq_sendrecv(mqdes, msg_len, msg_prio, p);
-	timeout = prepare_timeout(p);
+	audit_mq_sendrecv(mqdes, msg_len, msg_prio, timeout ? &ts : NULL);
 
 	filp = fget(mqdes);
 	if (unlikely(!filp)) {
@@ -918,9 +903,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
@@ -953,24 +935,23 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		size_t, msg_len, unsigned int __user *, u_msg_prio,
 		const struct timespec __user *, u_abs_timeout)
 {
-	long timeout;
 	ssize_t ret;
 	struct msg_msg *msg_ptr;
 	struct file *filp;
 	struct inode *inode;
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
-	struct timespec ts, *p = NULL;
+	ktime_t expires, *timeout = NULL;
+	struct timespec ts;
 
 	if (u_abs_timeout) {
-		if (copy_from_user(&ts, u_abs_timeout, 
-					sizeof(struct timespec)))
-			return -EFAULT;
-		p = &ts;
+		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
+		if (res)
+			return res;
+		timeout = &expires;
 	}
 
-	audit_mq_sendrecv(mqdes, msg_len, 0, p);
-	timeout = prepare_timeout(p);
+	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
 
 	filp = fget(mqdes);
 	if (unlikely(!filp)) {
@@ -1002,11 +983,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-			msg_ptr = NULL;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
-			msg_ptr = NULL;
 		} else {
 			wait.task = current;
 			wait.state = STATE_NONE;
