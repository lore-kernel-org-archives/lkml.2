Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0HMUzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:55:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0HMUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:55:10 -0400
X-Authority-Analysis: v=1.1 cv=lkxCD/5/46GCnpIirYorSQYl6SFYRu3AvdhUIdWuqHk= c=1 sm=0 a=oC6nfymtsbUA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=MXK2Ef5vOhNAgs8QZVMA:9 a=AVB56uzOcn3CwX2NMaEA:7 a=QjhhHKUI10q-9ZOTEKU4w9Foo08A:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: [PATCH][GIT PULL] tracing: Sanitize value returned from
 write(trace_marker, "...", len)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 13 Aug 2010 16:55:07 -0400
Message-ID: <1281732907.3058.77.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I had this sitting in my quilt queue, and did not realize I never
committed it. This is on top of my previous two pull requests.

Thanks,

-- Steve

Please pull the latest tip/perf/urgent-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-3


Marcin Slusarz (1):
      tracing: Sanitize value returned from write(trace_marker, "...", len)

----
 kernel/trace/trace.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)
---------------------------
commit 1aa54bca6ee0d07ebcafb8ca8074b624d80724aa
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Wed Jul 28 01:18:01 2010 +0200

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


