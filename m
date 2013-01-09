Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab3AIU42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:56:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:43670 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933949Ab3AIUkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>, Joe Perches <joe@perches.com>,
        Sylvain Munaut <s.munaut@whatever-company.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 091/123] printk: fix incorrect length from print_time() when seconds > 99999
Date: Wed,  9 Jan 2013 12:35:30 -0800
Message-Id: <20130109201510.303251754@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 35dac27cedd14c3b6fcd4ba7bc3c31738cfd1831 upstream.

print_prefix() passes a NULL buf to print_time() to get the length of
the time prefix; when printk times are enabled, the current code just
returns the constant 15, which matches the format "[%5lu.%06lu] " used
to print the time value.  However, this is obviously incorrect when the
whole seconds part of the time gets beyond 5 digits (100000 seconds is a
bit more than a day of uptime).

The simple fix is to use snprintf(NULL, 0, ...) to calculate the actual
length of the time prefix.  This could be micro-optimized but it seems
better to have simpler, more readable code here.

The bug leads to the syslog system call miscomputing which messages fit
into the userspace buffer.  If there are enough messages to fill
log_buf_len and some have a timestamp >= 100000, dmesg may fail with:

    # dmesg
    klogctl: Bad address

When this happens, strace shows that the failure is indeed EFAULT due to
the kernel mistakenly accessing past the end of dmesg's buffer, since
dmesg asks the kernel how big a buffer it needs, allocates a bit more,
and then gets an error when it asks the kernel to fill it:

    syslog(0xa, 0, 0)                       = 1048576
    mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa4d25d2000
    syslog(0x3, 0x7fa4d25d2010, 0x100008)   = -1 EFAULT (Bad address)

As far as I can see, the bug has been there as long as print_time(),
which comes from commit 084681d14e42 ("printk: flush continuation lines
immediately to console") in 3.5-rc5.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Sylvain Munaut <s.munaut@whatever-company.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -847,10 +847,11 @@ static size_t print_time(u64 ts, char *b
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


