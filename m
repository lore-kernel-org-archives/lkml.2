Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2FPNVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:21:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:49028 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab2FPNVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112820481"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: wfg@linux.intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] printk: use mutex lock to stop syslog_seq from going wild
Date: Sat, 16 Jun 2012 21:21:51 +0800
Message-Id: <1339852911-29481-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although syslog_seq and log_next_seq stuff are protected by logbuf_lock
spin log, it's not enough. Say we have two processes A and B, and let
syslog_seq = N, while log_next_seq = N + 1, and the two processes both
come to syslog_print at almost the same time. And No matter which
process get the spin lock first, it will increase syslog_seq by one,
then release spin lock; thus later, another process increase syslog_seq
by one again. In this case, syslog_seq is bigger than syslog_next_seq.
And latter, it would make:
   wait_event_interruptiable(log_wait, syslog != log_next_seq)
don't wait any more even there is no new write comes. Thus it introduce
a infinite loop reading.

I can easily see this kind of issue by the following steps:
  # cat /proc/kmsg # at meantime, I don't kill rsyslog
                   # So they are the two processes.
  # xinit          # I added drm.debug=6 in the kernel parameter line,
                   # so that it will produce lots of message and let that
                   # issue happen

It's 100% reproducable on my side. And my disk will be filled up by
/var/log/messages in a quite short time.

So, introduce a mutex_lock to stop syslog_seq from going wild just like
what devkmsg_read() does. It does fix this issue as expected.

v2: use mutex_lock_interruptiable() instead (comments from Kay)

Cc: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/printk.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..ce7c5b7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -414,7 +414,9 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	if (!user)
 		return -EBADF;
 
-	mutex_lock(&user->lock);
+	ret = mutex_lock_interruptible(&user->lock);
+	if (ret)
+		return ret;
 	raw_spin_lock(&logbuf_lock);
 	while (user->seq == log_next_seq) {
 		if (file->f_flags & O_NONBLOCK) {
@@ -974,6 +976,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	bool clear = false;
 	static int saved_console_loglevel = -1;
+	static DEFINE_MUTEX(syslog_mutex);
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -1000,11 +1003,17 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			error = -EFAULT;
 			goto out;
 		}
+		error = mutex_lock_interruptible(&syslog_mutex);
+		if (error)
+			goto out;
 		error = wait_event_interruptible(log_wait,
 						 syslog_seq != log_next_seq);
-		if (error)
+		if (error) {
+			mutex_unlock(&syslog_mutex);
 			goto out;
+		}
 		error = syslog_print(buf, len);
+		mutex_unlock(&syslog_mutex);
 		break;
 	/* Read/clear last kernel messages */
 	case SYSLOG_ACTION_READ_CLEAR:
-- 
1.7.7.6

