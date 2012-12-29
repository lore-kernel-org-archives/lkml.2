Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2L2EXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 23:23:13 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:54065 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751016Ab2L2EXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 23:23:11 -0500
From: Roland Dreier <roland@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>
Subject: [PATCH] printk: Fix incorrect length from print_time() when seconds > 99999
Date: Fri, 28 Dec 2012 20:23:04 -0800
Message-Id: <1356754984-13917-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

print_prefix() passes a NULL buf to print_time() to get the length of
the time prefix; when printk times are enabled, the current code just
returns the constant 15, which matches the format "[%5lu.%06lu] " used
to print the time value.  However, this is obviously incorrect when
the whole seconds part of the time gets beyond 5 digits (100000
seconds is a bit more than a day of uptime).

The simple fix is to use snprintf(NULL, 0, ...) to calculate the
actual length of the time prefix.  This could be micro-optimized but
it seems better to have simpler, more readable code here.

The bug leads to the syslog system call miscomputing which messages
fit into the userspace buffer.  If there are enough messages to fill
log_buf_len and some have a timestamp >= 100000, dmesg may fail with:

    # dmesg
    klogctl: Bad address

When this happens, strace shows that the failure is indeed EFAULT due
to the kernel mistakenly accessing past the end of dmesg's buffer,
since dmesg asks the kernel how big a buffer it needs, allocates a bit
more, and then gets an error when it asks the kernel to fill it:

    syslog(0xa, 0, 0)                       = 1048576
    mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa4d25d2000
    syslog(0x3, 0x7fa4d25d2010, 0x100008)   = -1 EFAULT (Bad address)

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 kernel/printk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 19c0d7b..357f714 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -870,10 +870,11 @@ static size_t print_time(u64 ts, char *buf)
 	if (!printk_time)
 		return 0;
 
+	rem_nsec = do_div(ts, 1000000000);
+
 	if (!buf)
-		return 15;
+		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
 
-	rem_nsec = do_div(ts, 1000000000);
 	return sprintf(buf, "[%5lu.%06lu] ",
 		       (unsigned long)ts, rem_nsec / 1000);
 }
-- 
1.8.0

