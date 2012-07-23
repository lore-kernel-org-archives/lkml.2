Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2GWI3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab2GWI0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 06/16] GFS2: Cache last hash bucket for glock seq_files
Date: Mon, 23 Jul 2012 09:00:56 +0100
Message-Id: <1343030466-3053-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the glocks and glstats seq_files, which are exposed via debugfs
we should cache the most recent hash bucket, along with the offset
into that bucket. This allows us to restart from that point, rather
than having to begin at the beginning each time.

This is an idea from Eric Dumazet, however I've slightly extended it
so that if the position from which we are due to start is at any
point beyond the last cached point, we start from the last cached
point, plus whatever is the appropriate offset. I don't really expect
people to be lseeking around these files, but if they did so with only
positive offsets, then we'd still get some of the benefit of using a
cached offset.

With my simple test of around 200k entries in the file, I'm seeing
an approx 10x speed up.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1c4cddf..3ad8cb3 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -46,10 +46,12 @@
 #include "trace_gfs2.h"
 
 struct gfs2_glock_iter {
-	int hash;			/* hash bucket index         */
-	struct gfs2_sbd *sdp;		/* incore superblock         */
-	struct gfs2_glock *gl;		/* current glock struct      */
-	char string[512];		/* scratch space             */
+	int hash;			/* hash bucket index           */
+	unsigned nhash;			/* Index within current bucket */
+	struct gfs2_sbd *sdp;		/* incore superblock           */
+	struct gfs2_glock *gl;		/* current glock struct        */
+	loff_t last_pos;		/* last position               */
+	char string[512];		/* scratch space               */
 };
 
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
@@ -950,7 +952,7 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 	if (seq) {
 		struct gfs2_glock_iter *gi = seq->private;
 		vsprintf(gi->string, fmt, args);
-		seq_printf(seq, gi->string);
+		seq_puts(seq, gi->string);
 	} else {
 		vaf.fmt = fmt;
 		vaf.va = &args;
@@ -1854,8 +1856,14 @@ static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 		gl = gi->gl;
 		if (gl) {
 			gi->gl = glock_hash_next(gl);
+			gi->nhash++;
 		} else {
+			if (gi->hash >= GFS2_GL_HASH_SIZE) {
+				rcu_read_unlock();
+				return 1;
+			}
 			gi->gl = glock_hash_chain(gi->hash);
+			gi->nhash = 0;
 		}
 		while (gi->gl == NULL) {
 			gi->hash++;
@@ -1864,6 +1872,7 @@ static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 				return 1;
 			}
 			gi->gl = glock_hash_chain(gi->hash);
+			gi->nhash = 0;
 		}
 	/* Skip entries for other sb and dead entries */
 	} while (gi->sdp != gi->gl->gl_sbd || atomic_read(&gi->gl->gl_ref) == 0);
@@ -1876,7 +1885,12 @@ static void *gfs2_glock_seq_start(struct seq_file *seq, loff_t *pos)
 	struct gfs2_glock_iter *gi = seq->private;
 	loff_t n = *pos;
 
-	gi->hash = 0;
+	if (gi->last_pos <= *pos)
+		n = gi->nhash + (*pos - gi->last_pos);
+	else
+		gi->hash = 0;
+
+	gi->nhash = 0;
 	rcu_read_lock();
 
 	do {
@@ -1884,6 +1898,7 @@ static void *gfs2_glock_seq_start(struct seq_file *seq, loff_t *pos)
 			return NULL;
 	} while (n--);
 
+	gi->last_pos = *pos;
 	return gi->gl;
 }
 
@@ -1893,7 +1908,7 @@ static void *gfs2_glock_seq_next(struct seq_file *seq, void *iter_ptr,
 	struct gfs2_glock_iter *gi = seq->private;
 
 	(*pos)++;
-
+	gi->last_pos = *pos;
 	if (gfs2_glock_iter_next(gi))
 		return NULL;
 
-- 
1.7.4

