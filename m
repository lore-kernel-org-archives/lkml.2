Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0ESCIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:08:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0ESCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:08:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2 3/5] perf probe: Fix some error exit paths
Date: Tue, 18 May 2010 23:08:18 -0300
Message-Id: <1274234900-12162-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274234900-12162-1-git-send-email-acme@infradead.org>
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That could leave filedescriptors open and leak memory. Also stop using
xmalloc, use malloc and handle results just like other error cases in
the same routine that used it.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 93583eb..d964cb1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -743,32 +743,36 @@ static int find_lazy_match_lines(struct list_head *head,
 				 const char *fname, const char *pat)
 {
 	char *fbuf, *p1, *p2;
-	int fd, ret, line, nlines = 0;
+	int fd, line, nlines = -1;
 	struct stat st;
 
 	fd = open(fname, O_RDONLY);
 	if (fd < 0) {
 		pr_warning("Failed to open %s: %s\n", fname, strerror(-fd));
-		return fd;
+		return -errno;
 	}
 
-	ret = fstat(fd, &st);
-	if (ret < 0) {
+	if (fstat(fd, &st) < 0) {
 		pr_warning("Failed to get the size of %s: %s\n",
 			   fname, strerror(errno));
-		return ret;
+		nlines = -errno;
+		goto out_close;
 	}
-	fbuf = xmalloc(st.st_size + 2);
-	ret = read(fd, fbuf, st.st_size);
-	if (ret < 0) {
+
+	nlines = -ENOMEM;
+	fbuf = malloc(st.st_size + 2);
+	if (fbuf == NULL)
+		goto out_close;
+	if (read(fd, fbuf, st.st_size) < 0) {
 		pr_warning("Failed to read %s: %s\n", fname, strerror(errno));
-		return ret;
+		nlines = -errno;
+		goto out_free_fbuf;
 	}
-	close(fd);
 	fbuf[st.st_size] = '\n';	/* Dummy line */
 	fbuf[st.st_size + 1] = '\0';
 	p1 = fbuf;
 	line = 1;
+	nlines = 0;
 	while ((p2 = strchr(p1, '\n')) != NULL) {
 		*p2 = '\0';
 		if (strlazymatch(p1, pat)) {
@@ -778,7 +782,10 @@ static int find_lazy_match_lines(struct list_head *head,
 		line++;
 		p1 = p2 + 1;
 	}
+out_free_fbuf:
 	free(fbuf);
+out_close:
+	close(fd);
 	return nlines;
 }
 
@@ -955,6 +962,8 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	if (!dbg) {
 		pr_warning("No dwarf info found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		free(pf.tevs);
+		*tevs = NULL;
 		return -EBADF;
 	}
 
-- 
1.6.2.5

