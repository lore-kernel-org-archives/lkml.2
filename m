Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0LVLbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:31:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:34720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0LVLbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:31:09 -0500
Date: Wed, 22 Dec 2010 11:30:52 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1292854685-8230-3-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-3-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Rewrite show_one_line() to make it simpler
Message-ID: <tip-befe341468f4e61ecaf337a0237f2aab76817437@git.kernel.org>
Git-Commit-ID: befe341468f4e61ecaf337a0237f2aab76817437
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:30:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  befe341468f4e61ecaf337a0237f2aab76817437
Gitweb:     http://git.kernel.org/tip/befe341468f4e61ecaf337a0237f2aab76817437
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Mon, 20 Dec 2010 15:18:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 16:20:11 -0200

perf probe: Rewrite show_one_line() to make it simpler

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1292854685-8230-3-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0163fc0..327604c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -290,28 +290,21 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
 static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
-	const char *color = PERF_COLOR_BLUE;
+	const char *color = show_num ? "" : PERF_COLOR_BLUE;
+	const char *prefix = NULL;
 
-	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
-		goto error;
-	if (!skip) {
-		if (show_num)
-			fprintf(stdout, "%7d  %s", l, buf);
-		else
-			color_fprintf(stdout, color, "         %s", buf);
-	}
-
-	while (strlen(buf) == LINEBUF_SIZE - 1 &&
-	       buf[LINEBUF_SIZE - 2] != '\n') {
+	do {
 		if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
 			goto error;
-		if (!skip) {
-			if (show_num)
-				fprintf(stdout, "%s", buf);
-			else
-				color_fprintf(stdout, color, "%s", buf);
+		if (skip)
+			continue;
+		if (!prefix) {
+			prefix = show_num ? "%7d  " : "         ";
+			color_fprintf(stdout, color, prefix, l);
 		}
-	}
+		color_fprintf(stdout, color, "%s", buf);
+
+	} while (strchr(buf, '\n') == NULL);
 
 	return 0;
 error:
