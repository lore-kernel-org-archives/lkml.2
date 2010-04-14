Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0DNNA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab0DNNAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:00:23 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] tracing: supress lost events message for iterator "trace"
Date: Wed, 14 Apr 2010 15:00:05 +0200
Message-Id: <1271250005-11434-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
References: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I noticed LOST EVENTS messages in the iterator "trace" file.
According to the comment from commit bc21b478 this won't work.

<comment>
    Note, it does not work with the iterator "trace" file, since it requires
    the use of consuming the page from the ring buffer to determine how many
    events were lost, which the iterator does not do.
</comment>

The change supress the LOST EVENTS message for iterator "trace".

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bf00438..536e573 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1630,10 +1630,11 @@ struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
-static void *find_next_entry_inc(struct trace_iterator *iter)
+static void *find_next_entry_inc(struct trace_iterator *iter,
+				 unsigned long *missing_events)
 {
 	iter->ent = __find_next_entry(iter, &iter->cpu,
-				      &iter->lost_events, &iter->ts);
+				      missing_events, &iter->ts);
 
 	if (iter->ent)
 		trace_iterator_increment(iter);
@@ -1665,12 +1666,12 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 		return NULL;
 
 	if (iter->idx < 0)
-		ent = find_next_entry_inc(iter);
+		ent = find_next_entry_inc(iter, NULL);
 	else
 		ent = iter;
 
 	while (ent && iter->idx < i)
-		ent = find_next_entry_inc(iter);
+		ent = find_next_entry_inc(iter, NULL);
 
 	iter->pos = *pos;
 
@@ -3187,7 +3188,7 @@ waitagain:
 
 	trace_event_read_lock();
 	trace_access_lock(iter->cpu_file);
-	while (find_next_entry_inc(iter) != NULL) {
+	while (find_next_entry_inc(iter, &iter->lost_events) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
 
@@ -3270,7 +3271,7 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 		rem -= count;
-		if (!find_next_entry_inc(iter))	{
+		if (!find_next_entry_inc(iter, &iter->lost_events))	{
 			rem = 0;
 			iter->ent = NULL;
 			break;
@@ -3323,7 +3324,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	if (ret <= 0)
 		goto out_err;
 
-	if (!iter->ent && !find_next_entry_inc(iter)) {
+	if (!iter->ent && !find_next_entry_inc(iter, &iter->lost_events)) {
 		ret = -EFAULT;
 		goto out_err;
 	}
@@ -4460,7 +4461,7 @@ static void __ftrace_dump(bool disable_tracing)
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
 		iter.pos = -1;
 
-		if (find_next_entry_inc(&iter) != NULL) {
+		if (find_next_entry_inc(&iter, &iter.lost_events) != NULL) {
 			int ret;
 
 			ret = print_trace_line(&iter);
-- 
1.6.6.1

