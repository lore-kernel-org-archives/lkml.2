Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0G0XJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:09:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0G0XJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Go0vV0Xn2NR/fY+8yAsW4hbEbKjX55WZituQQQTWmzxbR9pKOahKOEy/y1a8rkHQ9K
         czjMFg+SC0tkLOsdLC9migdfncstlLKuQevdy0boDe/3IO6KAs1DKos8jLATtmgluZNq
         d10b2eUR6uTxPfbqhrzp6dXYFqenXaE6FsNo4=
Date: Wed, 28 Jul 2010 01:06:36 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Emil Velikov <eeydev@nottingham.ac.uk>
Subject: [PATCH] tracing: sanitize value returned from write(trace_marker,
 "...", len)
Message-ID: <20100727230636.GA2826@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 02e04c8..6b39aa8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3499,6 +3499,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	char *buf;
+	size_t written;
 
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3520,11 +3521,15 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
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
-- 
1.7.1.1

