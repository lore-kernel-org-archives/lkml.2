Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2FKKWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:22:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab2FKKWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:22:20 -0400
Subject: [PATCH] Add seq_vprintf and use in gfs2 (was Re: GFS2: Cache last
 hash bucket for glock seq_files)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1339404517.6001.1767.camel@edumazet-glaptop>
References: <1339152726.2752.3.camel@menhir>
	 <1339230731.6001.159.camel@edumazet-glaptop>
	 <1339403377.2734.7.camel@menhir>
	 <1339404517.6001.1767.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Jun 2012 11:21:12 +0100
Message-ID: <1339410072.2734.17.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-06-11 at 10:48 +0200, Eric Dumazet wrote:
> On Mon, 2012-06-11 at 09:29 +0100, Steven Whitehouse wrote:
> > > 
> > That is on top of the almost 8x from increasing the buffer size with a
> > patch that Al Viro had suggested as a response to our earlier
> > discussion:
> 
> Ah OK, I understand ;)
> 
> > 
> > http://git.kernel.org/?p=linux/kernel/git/steve/gfs2-3.0-nmw.git;a=commitdiff;h=df5d2f5560a9c33129391a136ed9f0ac26abe69b
> 
> 
> Hmm, this patch seems overkill if PAGE_SIZE=65536 ?
> 
> #define GFS2_SEQ_GOODSIZE   \
> 	min(PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER, 65536)
> 
> 
Thats true, but are there any arches with a 64k page size? In any case
I'll follow up with another patch for that rather than try to combine it
with this one...

Here is a patch to add seq_vprintf and make use of it. It does speed
things up a bit, but not hugely (from approx 1.3 to approx 1.2 seconds
for my test). I can split this up into two bit if required, but lets see
what Al thinks is the best way to apply this. I'm happy to keep it in
the GFS2 tree if there are no objections - that should reduce conflicts
and complications, I hope.

Copying in lkml again, since this has ventured back into generic code
once more.

This patch adds an seq_vprintf function and then uses this in the GFS2
code in order to remove the need for a temporary buffer in the
glock/glstats file iteration state.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 10ae164..4d5d63d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -51,7 +51,6 @@ struct gfs2_glock_iter {
 	struct gfs2_sbd *sdp;		/* incore superblock           */
 	struct gfs2_glock *gl;		/* current glock struct        */
 	loff_t last_pos;		/* last position               */
-	char string[512];		/* scratch space               */
 };
 
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
@@ -951,9 +950,7 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 	va_start(args, fmt);
 
 	if (seq) {
-		struct gfs2_glock_iter *gi = seq->private;
-		vsprintf(gi->string, fmt, args);
-		seq_puts(seq, gi->string);
+		seq_vprintf(seq, fmt, args);
 	} else {
 		vaf.fmt = fmt;
 		vaf.va = &args;
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 0cbd049..14cf9de 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -385,15 +385,12 @@ int seq_escape(struct seq_file *m, const char *s, const char *esc)
 }
 EXPORT_SYMBOL(seq_escape);
 
-int seq_printf(struct seq_file *m, const char *f, ...)
+int seq_vprintf(struct seq_file *m, const char *f, va_list args)
 {
-	va_list args;
 	int len;
 
 	if (m->count < m->size) {
-		va_start(args, f);
 		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
-		va_end(args);
 		if (m->count + len < m->size) {
 			m->count += len;
 			return 0;
@@ -402,6 +399,19 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 	seq_set_overflow(m);
 	return -1;
 }
+EXPORT_SYMBOL(seq_vprintf);
+
+int seq_printf(struct seq_file *m, const char *f, ...)
+{
+	int ret;
+	va_list args;
+
+	va_start(args, f);
+	ret = seq_vprintf(m, f, args);
+	va_end(args);
+
+	return ret;
+}
 EXPORT_SYMBOL(seq_printf);
 
 /**
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index fc61854..83c44ee 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -86,6 +86,7 @@ int seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
+__printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
 
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);


