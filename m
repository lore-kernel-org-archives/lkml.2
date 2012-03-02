Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab2CBH4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:56:22 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:32839 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab2CBH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:56:21 -0500
X-Greylist: delayed 877 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2012 02:56:20 EST
Date: Fri, 02 Mar 2012 16:42:35 +0900
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout parameter when message can be performed immediately
Cc: torvalds@linux-foundation.org
Message-Id: <20120302164234.4938.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up the regression problem of mq_timed{send,receive} syscall.

When a message of mqueue can be performed immediately,
the validity of abs_timeout parameter should not be checked.

According to the manpage of mq_timedreceive:
    Under no circumstance shall the operation fail with a timeout
    if a message can be removed from the message queue immediately.
    The validity of the abstime parameter need not be checked
    if a message can be removed from the message queue immediately.

On 2.6.35+ kernel, mq_timed{send,receive} returns EINVAL incorrectly,
in this situation.

I found this problem during the OPTS testcase
"conformance/interfaces/mq_timedreceive/10-2":

    # ./10-2.test
    FAIL: the validity of abs_timeout is checked
    Test FAILED

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
---
 ipc/mqueue.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 86ee272..7cd4411 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -861,14 +861,22 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
 	ktime_t expires, *timeout = NULL;
+	int timeout_param_error = 0;
 	struct timespec ts;
 	int ret;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
 		if (res)
-			return res;
-		timeout = &expires;
+			/*
+			 * The validity of the abs_timeout parameter need not be
+			 * checked when there is sufficient room in the queue.
+			 * So, do not return here, even if the parameter is
+			 * invalid.
+			 */
+			timeout_param_error = res;
+		else
+			timeout = &expires;
 	}
 
 	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
@@ -916,6 +924,9 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
+		} else if (unlikely(timeout_param_error)) {
+			spin_unlock(&info->lock);
+			ret = timeout_param_error;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
@@ -955,13 +966,21 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
 	ktime_t expires, *timeout = NULL;
+	int timeout_param_error = 0;
 	struct timespec ts;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
 		if (res)
-			return res;
-		timeout = &expires;
+			/*
+			 * The validity of the abs_timeout parameter need not be
+			 * checked if a message can be removed from the message
+			 * queue immediately. So, do not return here, even if
+			 * the parameter is invalid.
+			 */
+			timeout_param_error = res;
+		else
+			timeout = &expires;
 	}
 
 	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
@@ -996,6 +1015,10 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
+		} else if (unlikely(timeout_param_error)) {
+			spin_unlock(&info->lock);
+			ret = timeout_param_error;
+			msg_ptr = NULL; /* just for shutting up warning */
 		} else {
 			wait.task = current;
 			wait.state = STATE_NONE;
-- 
1.7.4.1


