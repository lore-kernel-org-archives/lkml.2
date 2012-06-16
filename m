Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2FPMmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 08:42:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41376 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2FPMmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 08:42:45 -0400
Message-ID: <1339850558.905.10.camel@foo>
Subject: Re: [PATCH 1/2] printk: use logbuf_mutex_lock to stop syslog_seq
 from going wild
From: Kay Sievers <kay@vrfy.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, wfg@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 16 Jun 2012 14:42:38 +0200
In-Reply-To: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.2 (3.5.2-2.fc18)
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-16 at 12:40 +0800, Yuanhan Liu wrote:
> Although syslog_seq and log_next_seq stuff are protected by logbuf_lock
> spin log, it's not enough. Say we have two processes A and B, and let
> syslog_seq = N, while log_next_seq = N + 1, and the two processes both
> come to syslog_print at almost the same time. And No matter which
> process get the spin lock first, it will increase syslog_seq by one,
> then release spin lock; thus later, another process increase syslog_seq
> by one again. In this case, syslog_seq is bigger than syslog_next_seq.
> And latter, it would make:
>    wait_event_interruptiable(log_wait, syslog != log_next_seq)
> don't wait any more even there is no new write comes. Thus it introduce
> a infinite loop reading.

Oh, multiple readers on the same shared file descriptor are not useful,
but sure, that needs fixing. Thanks for tracking that down!

Looks like the same issue existed in the original code already, it's
just that it was granular at a single character level, and not a line,
and the seqnum which icreases one-by-one, so the issue was hard to
trigger.

We better make the mutexes interruptible, right? Something like this?

Thanks,
Kay


diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..5a01420 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -414,7 +414,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	if (!user)
 		return -EBADF;
 
-	mutex_lock(&user->lock);
+	ret = mutex_lock_interruptible(&user->lock);
+	if (ret)
+		return ret;
+
 	raw_spin_lock(&logbuf_lock);
 	while (user->seq == log_next_seq) {
 		if (file->f_flags & O_NONBLOCK) {
@@ -974,6 +977,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	bool clear = false;
 	static int saved_console_loglevel = -1;
+	static DEFINE_MUTEX(syslog_mutex);
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -1000,11 +1004,17 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
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

