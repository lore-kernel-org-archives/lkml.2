Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2GCSRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:17:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64854 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2GCSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:17:22 -0400
Message-ID: <1341339437.815.4.camel@mop>
Subject: [PATCH] kmsg: properly handle concurrent non-blocking read() from
 /proc/kmsg
From: Kay Sievers <kay@vrfy.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Jan Beulich <JBeulich@suse.com>
Date: Tue, 03 Jul 2012 20:17:17 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: properly handle concurrent non-blocking read() from /proc/kmsg

The /proc/kmsg read() interface is internally simply wired up to a sequence
of syslog() syscalls, which might are racy between their checks and actions,
regarding concurrency.

In the (very uncommon) case of concurrent readers of /dev/kmsg, relying on
usual O_NONBLOCK behavior, the recently introduced mutex might block an
O_NONBLOCK reader in read(), when poll() returns for it, but another process
has already read the data in the meantime. We've seen that while running
artificial test setups and tools that "fight" about /proc/kmsg data.

This restores the original /proc/kmsg behavior, where in case of concurrent
read()s, poll() might wake up but the read() syscall will just return 0 to
the caller, while another process has "stolen" the data.

This is in the general case not the expected behavior, but it is the exact
same one, that can easily be triggered with a 3.4 kernel, and some tools
might just rely on it.

The mutex is not needed, the original integrity issue which introduced it,
is in the meantime covered by:
  "fill buffer with more than a single message for SYSLOG_ACTION_READ"
  116e90b23f74d303e8d607c7a7d54f60f14ab9f2

Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 kernel/printk.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1019,7 +1019,6 @@ int do_syslog(int type, char __user *buf
 {
 	bool clear = false;
 	static int saved_console_loglevel = -1;
-	static DEFINE_MUTEX(syslog_mutex);
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -1046,17 +1045,11 @@ int do_syslog(int type, char __user *buf
 			error = -EFAULT;
 			goto out;
 		}
-		error = mutex_lock_interruptible(&syslog_mutex);
-		if (error)
-			goto out;
 		error = wait_event_interruptible(log_wait,
 						 syslog_seq != log_next_seq);
-		if (error) {
-			mutex_unlock(&syslog_mutex);
+		if (error)
 			goto out;
-		}
 		error = syslog_print(buf, len);
-		mutex_unlock(&syslog_mutex);
 		break;
 	/* Read/clear last kernel messages */
 	case SYSLOG_ACTION_READ_CLEAR:


