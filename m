Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0LVLcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:32:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:34767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0LVLcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:32:13 -0500
Date: Wed, 22 Dec 2010 11:31:56 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Don't always consider EOF as an error when listing source code
Message-ID: <tip-fde52dbd7f71934aba4e150f3d1d51e826a08850@git.kernel.org>
Git-Commit-ID: fde52dbd7f71934aba4e150f3d1d51e826a08850
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:31:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fde52dbd7f71934aba4e150f3d1d51e826a08850
Gitweb:     http://git.kernel.org/tip/fde52dbd7f71934aba4e150f3d1d51e826a08850
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Mon, 20 Dec 2010 15:18:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 16:20:12 -0200

perf probe: Don't always consider EOF as an error when listing source code

When listing a whole file or a function which is located at the end,
perf-probe -L output wrongly: "Source file is shorter than expected.".

This is because show_one_line() always consider EOF as an error.

This patch fixes this by not considering EOF as an error when dumping
the trailing lines. Otherwise it's still an error and perf-probe still
outputs its warning.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3ba9c53..80cc0bc 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -287,7 +287,7 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
 #define LINEBUF_SIZE 256
 #define NR_ADDITIONAL_LINES 2
 
-static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
+static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
 	const char *color = show_num ? "" : PERF_COLOR_BLUE;
@@ -306,16 +306,30 @@ static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
 
 	} while (strchr(buf, '\n') == NULL);
 
-	return 0;
+	return 1;
 error:
-	if (feof(fp))
+	if (ferror(fp)) {
 		pr_warning("Source file is shorter than expected.\n");
-	else
-		pr_warning("File read error: %s\n", strerror(errno));
+		return -1;
+	}
+	return 0;
+}
 
-	return -1;
+static int _show_one_line(FILE *fp, int l, bool skip, bool show_num)
+{
+	int rv = __show_one_line(fp, l, skip, show_num);
+	if (rv == 0) {
+		pr_warning("Source file is shorter than expected.\n");
+		rv = -1;
+	}
+	return rv;
 }
 
+#define show_one_line_with_num(f,l)	_show_one_line(f,l,false,true)
+#define show_one_line(f,l)		_show_one_line(f,l,false,false)
+#define skip_one_line(f,l)		_show_one_line(f,l,true,false)
+#define show_one_line_or_eof(f,l)	__show_one_line(f,l,false,false)
+
 /*
  * Show line-range always requires debuginfo to find source file and
  * line number.
@@ -374,27 +388,27 @@ int show_line_range(struct line_range *lr, const char *module)
 	}
 	/* Skip to starting line number */
 	while (l < lr->start) {
-		ret = show_one_line(fp, l++, true, false);
+		ret = skip_one_line(fp, l++);
 		if (ret < 0)
 			goto end;
 	}
 
 	list_for_each_entry(ln, &lr->line_list, list) {
 		for (; ln->line > l; l++) {
-			ret = show_one_line(fp, l - lr->offset, false, false);
+			ret = show_one_line(fp, l - lr->offset);
 			if (ret < 0)
 				goto end;
 		}
-		ret = show_one_line(fp, l++ - lr->offset, false, true);
+		ret = show_one_line_with_num(fp, l++ - lr->offset);
 		if (ret < 0)
 			goto end;
 	}
 
 	if (lr->end == INT_MAX)
 		lr->end = l + NR_ADDITIONAL_LINES;
-	while (l <= lr->end && !feof(fp)) {
-		ret = show_one_line(fp, l++ - lr->offset, false, false);
-		if (ret < 0)
+	while (l <= lr->end) {
+		ret = show_one_line_or_eof(fp, l++ - lr->offset);
+		if (ret <= 0)
 			break;
 	}
 end:
