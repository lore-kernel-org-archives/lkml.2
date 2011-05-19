Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1ESJP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1ESJKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/32] GFS2: Improve tracing support (adds two flags)
Date: Thu, 19 May 2011 09:47:06 +0100
Message-Id: <1305794847-3291-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for two new flags. One keeps track of whether
the glock is on the LRU list or not. The other isn't really a
flag as such, but an indication of whether the glock has an
attached object or not. This indication is reported without
any locking, which is ok since we do not dereference the object
pointer but merely report whether it is NULL or not.

Also, this fixes one place where a tracepoint was missing, which
was at the point we remove deallocated blocks from the journal.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1019183..0c6c690 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -170,6 +170,7 @@ void gfs2_glock_add_to_lru(struct gfs2_glock *gl)
 		atomic_inc(&lru_count);
 
 	list_add_tail(&gl->gl_lru, &lru_list);
+	set_bit(GLF_LRU, &gl->gl_flags);
 	spin_unlock(&lru_lock);
 }
 
@@ -1364,6 +1365,7 @@ static int gfs2_shrink_glock_memory(struct shrinker *shrink, int nr, gfp_t gfp_m
 	while(nr && !list_empty(&lru_list)) {
 		gl = list_entry(lru_list.next, struct gfs2_glock, gl_lru);
 		list_del_init(&gl->gl_lru);
+		clear_bit(GLF_LRU, &gl->gl_flags);
 		atomic_dec(&lru_count);
 
 		/* Test for being demotable */
@@ -1386,6 +1388,7 @@ static int gfs2_shrink_glock_memory(struct shrinker *shrink, int nr, gfp_t gfp_m
 		}
 		nr_skipped++;
 		list_add(&gl->gl_lru, &skipped);
+		set_bit(GLF_LRU, &gl->gl_flags);
 	}
 	list_splice(&skipped, &lru_list);
 	atomic_add(nr_skipped, &lru_count);
@@ -1598,9 +1601,11 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 	return 0;
 }
 
-static const char *gflags2str(char *buf, const unsigned long *gflags)
+static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 {
+	const unsigned long *gflags = &gl->gl_flags;
 	char *p = buf;
+
 	if (test_bit(GLF_LOCK, gflags))
 		*p++ = 'l';
 	if (test_bit(GLF_DEMOTE, gflags))
@@ -1623,6 +1628,10 @@ static const char *gflags2str(char *buf, const unsigned long *gflags)
 		*p++ = 'F';
 	if (test_bit(GLF_QUEUED, gflags))
 		*p++ = 'q';
+	if (test_bit(GLF_LRU, gflags))
+		*p++ = 'L';
+	if (gl->gl_object)
+		*p++ = 'o';
 	*p = 0;
 	return buf;
 }
@@ -1661,7 +1670,7 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 		  state2str(gl->gl_state),
 		  gl->gl_name.ln_type,
 		  (unsigned long long)gl->gl_name.ln_number,
-		  gflags2str(gflags_buf, &gl->gl_flags),
+		  gflags2str(gflags_buf, gl),
 		  state2str(gl->gl_target),
 		  state2str(gl->gl_demote_state), dtime,
 		  atomic_read(&gl->gl_ail_count),
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 870a89d..48eb1ee 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -200,6 +200,8 @@ enum {
 	GLF_INITIAL			= 10,
 	GLF_FROZEN			= 11,
 	GLF_QUEUED			= 12,
+	GLF_LRU				= 13,
+	GLF_OBJECT			= 14, /* Used only for tracing */
 };
 
 struct gfs2_glock {
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 675349b..747238c 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -31,6 +31,7 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
+#include "trace_gfs2.h"
 
 static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wbc)
 {
@@ -310,6 +311,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	struct gfs2_bufdata *bd = bh->b_private;
 
 	if (test_clear_buffer_pinned(bh)) {
+		trace_gfs2_pin(bd, 0);
 		atomic_dec(&sdp->sd_log_pinned);
 		list_del_init(&bd->bd_le.le_list);
 		if (meta) {
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index cedb0bb..9133d0a 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -40,7 +40,9 @@
 	{(1UL << GLF_REPLY_PENDING),		"r" },		\
 	{(1UL << GLF_INITIAL),			"I" },		\
 	{(1UL << GLF_FROZEN),			"F" },		\
-	{(1UL << GLF_QUEUED),			"q" })
+	{(1UL << GLF_QUEUED),			"q" },		\
+	{(1UL << GLF_LRU),			"L" },		\
+	{(1UL << GLF_OBJECT),			"o" })
 
 #ifndef NUMPTY
 #define NUMPTY
@@ -94,7 +96,7 @@ TRACE_EVENT(gfs2_glock_state_change,
 		__entry->new_state	= glock_trace_state(new_state);
 		__entry->tgt_state	= glock_trace_state(gl->gl_target);
 		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
-		__entry->flags		= gl->gl_flags;
+		__entry->flags		= gl->gl_flags | (gl->gl_object ? (1UL<<GLF_OBJECT) : 0);
 	),
 
 	TP_printk("%u,%u glock %d:%lld state %s to %s tgt:%s dmt:%s flags:%s",
@@ -127,7 +129,7 @@ TRACE_EVENT(gfs2_glock_put,
 		__entry->gltype		= gl->gl_name.ln_type;
 		__entry->glnum		= gl->gl_name.ln_number;
 		__entry->cur_state	= glock_trace_state(gl->gl_state);
-		__entry->flags		= gl->gl_flags;
+		__entry->flags		= gl->gl_flags  | (gl->gl_object ? (1UL<<GLF_OBJECT) : 0);
 	),
 
 	TP_printk("%u,%u glock %d:%lld state %s => %s flags:%s",
@@ -161,7 +163,7 @@ TRACE_EVENT(gfs2_demote_rq,
 		__entry->glnum		= gl->gl_name.ln_number;
 		__entry->cur_state	= glock_trace_state(gl->gl_state);
 		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
-		__entry->flags		= gl->gl_flags;
+		__entry->flags		= gl->gl_flags  | (gl->gl_object ? (1UL<<GLF_OBJECT) : 0);
 	),
 
 	TP_printk("%u,%u glock %d:%lld demote %s to %s flags:%s",
-- 
1.7.4

