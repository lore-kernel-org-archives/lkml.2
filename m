Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab2FPEko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 00:40:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:57664 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2FPEkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 00:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157049084"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: wfg@linux.intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] printk: use logbuf_mutex_lock to stop syslog_seq from going wild
Date: Sat, 16 Jun 2012 12:40:54 +0800
Message-Id: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
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

Cc: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/printk.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..d2ddb83 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -206,6 +206,7 @@ struct log {
  * used in interesting ways to provide interlocking in console_unlock();
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
+static DEFINE_MUTEX(logbuf_mutex_lock);
 
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
@@ -1000,11 +1001,15 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			error = -EFAULT;
 			goto out;
 		}
+		mutex_lock(&logbuf_mutex_lock);
 		error = wait_event_interruptible(log_wait,
 						 syslog_seq != log_next_seq);
-		if (error)
+		if (error) {
+			mutex_unlock(&logbuf_mutex_lock);
 			goto out;
+		}
 		error = syslog_print(buf, len);
+		mutex_unlock(&logbuf_mutex_lock);
 		break;
 	/* Read/clear last kernel messages */
 	case SYSLOG_ACTION_READ_CLEAR:
-- 
1.7.3.1

