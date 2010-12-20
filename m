Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0LTOSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:18:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab0LTOS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:18:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KbAr3LtQ7+KW5ZWN+5rvbNik9EdLYNN/6mnsISV3/QWeqZxVOB+MTCW7RoiWu9WfKJ
         lReBIkhkNIJy8VrOwj++4ohWZbY2Gk0pjiB7zN7wK+kNsFZ9SL1Z1qk+O81087B9Wgl/
         gASNPFHm3f8psR0Yw/+1scglqvkDWA5uyiZgM=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] perf-probe: don't always consider EOF as an error when listing source code
Date: Mon, 20 Dec 2010 15:18:04 +0100
Message-Id: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

When listing a whole file or a function which is located at the end,
perf-probe -L output wrongly: "Source file is shorter than expected.".

This is because show_one_line() always consider EOF as an error.

This patch fixes this by not considering EOF as an error when dumping
the trailing lines. Otherwise it's still an error and perf-probe still
outputs its warning.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 8e5f5ff..1e81936 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -297,7 +297,7 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
 #define LINEBUF_SIZE 256
 #define NR_ADDITIONAL_LINES 2
 
-static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
+static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
 	const char *color = show_num ? "" : PERF_COLOR_BLUE;
@@ -316,16 +316,30 @@ static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
 
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
@@ -384,27 +398,27 @@ int show_line_range(struct line_range *lr, const char *module)
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
-- 
1.7.3.2

