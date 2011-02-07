Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1BGPAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:00:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1BGPAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf probe: Rewrite find_lazy_match_lines() by using getline(3)
Date: Mon,  7 Feb 2011 13:00:06 -0200
Message-Id: <1297090812-10782-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
LKML-Reference: <m3d3o185u1.fsf@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   70 +++++++++++++++------------------------
 1 files changed, 27 insertions(+), 43 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 69215bf..46addfb 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1234,51 +1234,38 @@ static int find_probe_point_by_line(struct probe_finder *pf)
 static int find_lazy_match_lines(struct list_head *head,
 				 const char *fname, const char *pat)
 {
-	char *fbuf, *p1, *p2;
-	int fd, line, nlines = -1;
-	struct stat st;
-
-	fd = open(fname, O_RDONLY);
-	if (fd < 0) {
-		pr_warning("Failed to open %s: %s\n", fname, strerror(-fd));
+	FILE *fp;
+	char *line = NULL;
+	size_t line_len;
+	ssize_t len;
+	int count = 0, linenum = 1;
+
+	fp = fopen(fname, "r");
+	if (!fp) {
+		pr_warning("Failed to open %s: %s\n", fname, strerror(errno));
 		return -errno;
 	}
 
-	if (fstat(fd, &st) < 0) {
-		pr_warning("Failed to get the size of %s: %s\n",
-			   fname, strerror(errno));
-		nlines = -errno;
-		goto out_close;
-	}
-
-	nlines = -ENOMEM;
-	fbuf = malloc(st.st_size + 2);
-	if (fbuf == NULL)
-		goto out_close;
-	if (read(fd, fbuf, st.st_size) < 0) {
-		pr_warning("Failed to read %s: %s\n", fname, strerror(errno));
-		nlines = -errno;
-		goto out_free_fbuf;
-	}
-	fbuf[st.st_size] = '\n';	/* Dummy line */
-	fbuf[st.st_size + 1] = '\0';
-	p1 = fbuf;
-	line = 1;
-	nlines = 0;
-	while ((p2 = strchr(p1, '\n')) != NULL) {
-		*p2 = '\0';
-		if (strlazymatch(p1, pat)) {
-			line_list__add_line(head, line);
-			nlines++;
+	while ((len = getline(&line, &line_len, fp)) > 0) {
+
+		if (line[len - 1] == '\n')
+			line[len - 1] = '\0';
+
+		if (strlazymatch(line, pat)) {
+			line_list__add_line(head, linenum);
+			count++;
 		}
-		line++;
-		p1 = p2 + 1;
+		linenum++;
 	}
-out_free_fbuf:
-	free(fbuf);
-out_close:
-	close(fd);
-	return nlines;
+
+	if (ferror(fp))
+		count = -errno;
+	free(line);
+	fclose(fp);
+
+	if (count == 0)
+		pr_debug("No matched lines found in %s.\n", fname);
+	return count;
 }
 
 static int probe_point_lazy_walker(const char *fname, int lineno,
@@ -1312,10 +1299,7 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 		/* Matching lazy line pattern */
 		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
 					    pf->pev->point.lazy_line);
-		if (ret == 0) {
-			pr_debug("No matched lines found in %s.\n", pf->fname);
-			return 0;
-		} else if (ret < 0)
+		if (ret <= 0)
 			return ret;
 	}
 
-- 
1.6.2.5

