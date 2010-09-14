Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0INU3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:29:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0INU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:28:47 -0400
X-Authority-Analysis: v=1.1 cv=0gh5jMB3jHrmQHbUKMg9KP0ZqNkm6dXs7xuA8CfKDuU= c=1 sm=0 a=DuSnYepWJMEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=QQRhV8QiBSji24LS2sIA:9 a=UldM1WQsxmZZuIZUyxoA:7 a=OGISZ6UjAysQTkKR88-0r8f4rfgA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100914202843.128294711@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 16:27:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] tracing: Fix reading of set_ftrace_filter across lists
References: <20100914202714.376849326@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-reading-of-set_ftrace_filter-across-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If we do:

 # cd /sys/kernel/debug
 # echo 'do_IRQ:traceon schedule:traceon sys_write:traceon' > \
    set_ftrace_filter
 # cat set_ftrace_filter

We get the following output:

 #### all functions enabled ####
 sys_write:traceon:unlimited
 schedule:traceon:unlimited
 do_IRQ:traceon:unlimited

This outputs two lists. One is the fact that all functions are
currently enabled for function tracing, the other has three probed
functions, which happen to have 'traceon' as their commands.

Currently, when reading the first list (functions enabled) the
seq_file code will receive a "NULL" from the t_next() function
causing it to exit early. This makes "read()" from userspace stop
reading the code at this boarder. Although read is allowed to do this,
some (broken) applications might consider this an end of file and
stop early.

This patch adds the start of the second list to t_next() when it
finishes the first list. It is a simple change and gives the
set_ftrace_filter file nicer reading ability.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2d51166..1884cf5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1477,10 +1477,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 	(*pos)++;
 	iter->pos = *pos;
-	iter->func_pos = *pos;
 
 	if (iter->flags & FTRACE_ITER_PRINTALL)
-		return NULL;
+		return t_hash_start(m, pos);
 
  retry:
 	if (iter->idx >= iter->pg->index) {
@@ -1510,8 +1509,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	}
 
 	if (!rec)
-		return NULL;
+		return t_hash_start(m, pos);
 
+	iter->func_pos = *pos;
 	iter->func = rec;
 
 	return iter;
-- 
1.7.1


