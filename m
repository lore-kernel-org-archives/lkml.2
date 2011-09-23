Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1IWOT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:19:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1IWOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:19:25 -0400
From: penberg@cs.helsinki.fi
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/2] tracing: Kill uninitialized warning in trace_printk.c
Date: Fri, 23 Sep 2011 17:19:06 +0300
Message-Id: <1316787547-1971-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.7.6.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

This patch kill the following bogus warning issued by GCC by shuffling the code
around:

    CC      fs/ext4/balloc.o
  kernel/trace/trace_printk.c: In function ‘module_trace_bprintk_format_notify’:
  kernel/trace/trace_printk.c:65:14: warning: ‘fmt’ may be used uninitialized in this function [-Wuninitialized]
  kernel/trace/trace_printk.c:52:8: note: ‘fmt’ was declared here

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 kernel/trace/trace_printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 1f06468..25e34f5 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -49,7 +49,7 @@ static
 void hold_module_trace_bprintk_format(const char **start, const char **end)
 {
 	const char **iter;
-	char *fmt;
+	char *fmt = NULL;
 
 	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
@@ -62,7 +62,7 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
 		if (tb_fmt)
 			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
-		if (tb_fmt && fmt) {
+		if (fmt) {
 			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
 			strcpy(fmt, *iter);
 			tb_fmt->fmt = fmt;
-- 
1.7.6.2

