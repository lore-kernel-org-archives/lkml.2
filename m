Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2FKM5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2FKM5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:57:18 -0400
Subject: Re: [Cluster-devel] [PATCH] Add seq_vprintf and use in gfs2 (was
 Re: GFS2: Cache last hash bucket for glock seq_files)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1339410072.2734.17.camel@menhir>
References: <1339152726.2752.3.camel@menhir>
	 <1339230731.6001.159.camel@edumazet-glaptop>
	 <1339403377.2734.7.camel@menhir>
	 <1339404517.6001.1767.camel@edumazet-glaptop>
	 <1339410072.2734.17.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Jun 2012 13:56:09 +0100
Message-ID: <1339419369.2734.26.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've split that original patch into two, and I'll carry both bits in the
GFS2 -nmw tree for now. Here are the (hopefully) final versions of the
two patches. I'll follow up with a buffer sizing patch too a bit later,

Steve.

-------------------------------------------------------------------------------
>From a4808147dcf1ecf2f76212a78fd9692b3c112f47 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 11 Jun 2012 13:16:35 +0100
Subject: [PATCH 1/2] seq_file: Add seq_vprintf function and export it

The existing seq_printf function is rewritten in terms of the new
seq_vprintf which is also exported to modules. This allows GFS2
(and potentially other seq_file users) to have a vprintf based
interface and to avoid an extra copy into a temporary buffer in
some cases.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/seq_file.c            |   18 ++++++++++++++----
 include/linux/seq_file.h |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

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



