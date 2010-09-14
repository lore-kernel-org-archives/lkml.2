Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0INU2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:28:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab0INU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:28:44 -0400
X-Authority-Analysis: v=1.1 cv=FR6uSFBUsHpo/LPxUdUfz19YCIdHKFi4UJmy4GdSgrg= c=1 sm=0 a=_Lu3Q-jRvoQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1-M7dxTs6ixKejpz0HgA:9 a=VbOvdZeNZOqQc5ULAgGuC5jvV94A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100914202842.282284832@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 16:27:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] tracing: Do not reset *pos in set_ftrace_filter
References: <20100914202714.376849326@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Do-not-reset-pos-in-set_ftrace_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

After the filtered functions are read, the probed functions are read
from the hash in set_ftrace_filter. When the hashed probed functions
are read, the *pos passed in is reset. Instead of modifying the pos
given to the read function, just record the pos where the filtered
functions ended and subtract from that.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fa7ece6..585ea27 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1368,6 +1368,7 @@ enum {
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
+	loff_t			func_pos;
 	struct ftrace_page	*pg;
 	int			hidx;
 	int			idx;
@@ -1418,12 +1419,15 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 	loff_t l;
 
 	if (!(iter->flags & FTRACE_ITER_HASH))
-		*pos = 0;
+		iter->func_pos = *pos;
+
+	if (iter->func_pos > *pos)
+		return NULL;
 
 	iter->flags |= FTRACE_ITER_HASH;
 
 	iter->hidx = 0;
-	for (l = 0; l <= *pos; ) {
+	for (l = 0; l <= (*pos - iter->func_pos); ) {
 		p = t_hash_next(m, p, &l);
 		if (!p)
 			break;
-- 
1.7.1


