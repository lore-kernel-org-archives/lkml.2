Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1BHPQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:16:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:43474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab1BHPQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:16:47 -0500
Date: Tue, 8 Feb 2011 15:16:30 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <m3d3o185u1.fsf@gmail.com>
References: <m3d3o185u1.fsf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Rewrite find_lazy_match_lines() by using getline(3)
Message-ID: <tip-f50c2169bd054984e976e67e8651d28f3caf6ba3@git.kernel.org>
Git-Commit-ID: f50c2169bd054984e976e67e8651d28f3caf6ba3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 15:16:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f50c2169bd054984e976e67e8651d28f3caf6ba3
Gitweb:     http://git.kernel.org/tip/f50c2169bd054984e976e67e8651d28f3caf6ba3
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Thu, 13 Jan 2011 11:18:30 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Feb 2011 09:12:42 -0200

perf probe: Rewrite find_lazy_match_lines() by using getline(3)

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
 
