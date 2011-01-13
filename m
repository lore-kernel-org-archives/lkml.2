Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1AMKSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:18:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56826 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1AMKSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=aTXpEzGGUBjrc2Cqh4YoRnTi3JMr0bRUgru95X4xhV/ZNLdcXBIfRREBZ5+i7xaLcN
         T9gcZgNXAikIXivRHcA0vd9crPzamNgHZEtpo4HatjkDHi+R/tX2IOm8wFSja91NTYDL
         MKCJ4Qmuw2b6/H0yce0ePtOda0TwskNizHI3k=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf-probe: rewrite find_lazy_match_lines() by using getline(3)
Date: Thu, 13 Jan 2011 11:18:30 +0100
Message-ID: <m3d3o185u1.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-finder.c |   70 +++++++++++++++------------------------
 1 files changed, 27 insertions(+), 43 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ddf4d45..4221738 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1092,51 +1092,38 @@ static int find_probe_point_by_line(struct probe_finder *pf)
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
-	}
-out_free_fbuf:
-	free(fbuf);
-out_close:
-	close(fd);
-	return nlines;
+		linenum++;
+	}
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
 
 /* Find probe points from lazy pattern  */
@@ -1154,10 +1141,7 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
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
1.7.3.2
