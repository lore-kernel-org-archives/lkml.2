Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0HPRcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:32:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0HPRcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:32:17 -0400
Date: Mon, 16 Aug 2010 17:31:58 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, marcin.slusarz@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        marcin.slusarz@gmail.com
In-Reply-To: <20100727231801.GB2826@joi.lan>
References: <20100727231801.GB2826@joi.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Sanitize value returned from write(trace_marker, "...", len)
Message-ID: <tip-1aa54bca6ee0d07ebcafb8ca8074b624d80724aa@git.kernel.org>
Git-Commit-ID: 1aa54bca6ee0d07ebcafb8ca8074b624d80724aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 17:31:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1aa54bca6ee0d07ebcafb8ca8074b624d80724aa
Gitweb:     http://git.kernel.org/tip/1aa54bca6ee0d07ebcafb8ca8074b624d80724aa
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Wed, 28 Jul 2010 01:18:01 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 13 Aug 2010 15:23:16 -0400

tracing: Sanitize value returned from write(trace_marker, "...", len)

When userspace code writes non-new-line-terminated string to trace_marker
file, write handler appends new-line and returns number of bytes written
to trace buffer, so
write(fd, "abc", 3) will return 4

That's unexpected and unfortunately it confuses glibc's fprintf function.

Example:
int main() {
  fprintf(stderr, "abc");
  return 0;
}

$ gcc test.c -o test
$ echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
$ ./test 2>/sys/kernel/debug/tracing/trace_marker

results in infinite loop:
write(fd, "abc", 3) = 4
write(fd, "", 1) = 0
write(fd, "", 1) = 0
write(fd, "", 1) = 0
write(fd, "", 1) = 0
write(fd, "", 1) = 0
write(fd, "", 1) = 0
write(fd, "", 1) = 0
(...)

...and kernel trace buffer full of empty markers.

Fix it by sanitizing write return value.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
LKML-Reference: <20100727231801.GB2826@joi.lan>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..88b42d1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3498,6 +3498,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	char *buf;
+	size_t written;
 
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3519,11 +3520,15 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	} else
 		buf[cnt] = '\0';
 
-	cnt = mark_printk("%s", buf);
+	written = mark_printk("%s", buf);
 	kfree(buf);
-	*fpos += cnt;
+	*fpos += written;
 
-	return cnt;
+	/* don't tell userspace we wrote more - it might confuse them */
+	if (written > cnt)
+		written = cnt;
+
+	return written;
 }
 
 static int tracing_clock_show(struct seq_file *m, void *v)
