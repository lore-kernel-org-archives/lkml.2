Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0DBUsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:48:55 -0400
Received: from toro.web-alm.net ([62.245.132.31]:44747 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0DBUsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:48:35 -0400
Message-Id: <20100402204331.715783034@osadl.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Apr 2010 22:40:20 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Veen <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pradyumna Sampath <pradysam@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-users <linux-rt-users@vger.kernel.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 2/2] let-message-queue-timeout-use-hrtimer.patch
References: <20100402204018.575140584@osadl.org>
Content-Disposition: inline; filename=let-message-queue-timeout-use-hrtimer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message queue functions mq_timedsend() and mq_timedreceive()
have not yet been converted to use the hrtimer interface.

This patch replaces the call to schedule_timeout() by a call to
schedule_hrtimeout() and transforms the expiration time from
timespec to ktime as required.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Veen <arjan@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Pradyumna Sampath <pradysam@gmail.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 ipc/mqueue.c |   74 +++++++++++++++++++----------------------------------------
 1 file changed, 25 insertions(+), 49 deletions(-)

Index: head/ipc/mqueue.c
===================================================================
--- head.orig/ipc/mqueue.c
+++ head/ipc/mqueue.c
@@ -428,7 +428,7 @@ static void wq_add(struct mqueue_inode_i
  * sr: SEND or RECV
  */
 static int wq_sleep(struct mqueue_inode_info *info, int sr,
-			long timeout, struct ext_wait_queue *ewp)
+		    ktime_t *timeout, struct ext_wait_queue *ewp)
 {
 	int retval;
 	signed long time;
@@ -439,7 +439,8 @@ static int wq_sleep(struct mqueue_inode_
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
-		time = schedule_timeout(timeout);
+		time = schedule_hrtimeout_range_clock(timeout,
+		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
@@ -551,31 +552,16 @@ static void __do_notify(struct mqueue_in
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
@@ -861,22 +847,21 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	struct ext_wait_queue *receiver;
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
-	struct timespec ts, *p = NULL;
-	long timeout;
+ 	ktime_t expires, *timeout = NULL;
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
@@ -918,9 +903,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
@@ -953,24 +935,23 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
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
+   	ktime_t expires, *timeout = NULL;
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
@@ -1002,11 +983,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
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

