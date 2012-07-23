Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2GWI0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab2GWI0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:22 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/16] seq_file: Add seq_vprintf function and export it
Date: Mon, 23 Jul 2012 09:00:58 +0100
Message-Id: <1343030466-3053-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing seq_printf function is rewritten in terms of the new
seq_vprintf which is also exported to modules. This allows GFS2
(and potentially other seq_file users) to have a vprintf based
interface and to avoid an extra copy into a temporary buffer in
some cases.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>

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
-- 
1.7.4

