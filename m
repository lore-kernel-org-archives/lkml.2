Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0LVLb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:31:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:34730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0LVLbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:31:22 -0500
Date: Wed, 22 Dec 2010 11:31:13 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1292854685-8230-4-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-4-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Clean up redundant tests in show_line_range()
Message-ID: <tip-44b81e929b0c00e703a31a3d634b668bb27eb1c8@git.kernel.org>
Git-Commit-ID: 44b81e929b0c00e703a31a3d634b668bb27eb1c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:31:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44b81e929b0c00e703a31a3d634b668bb27eb1c8
Gitweb:     http://git.kernel.org/tip/44b81e929b0c00e703a31a3d634b668bb27eb1c8
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Mon, 20 Dec 2010 15:18:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 16:20:12 -0200

perf probe: Clean up redundant tests in show_line_range()

It also removes some superflous parentheses.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1292854685-8230-4-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 327604c..b812f14 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -373,26 +373,30 @@ int show_line_range(struct line_range *lr, const char *module)
 		return -errno;
 	}
 	/* Skip to starting line number */
-	while (l < lr->start && ret >= 0)
+	while (l < lr->start) {
 		ret = show_one_line(fp, l++, true, false);
-	if (ret < 0)
-		goto end;
+		if (ret < 0)
+			goto end;
+	}
 
 	list_for_each_entry(ln, &lr->line_list, list) {
-		while (ln->line > l && ret >= 0)
-			ret = show_one_line(fp, (l++) - lr->offset,
-					    false, false);
-		if (ret >= 0)
-			ret = show_one_line(fp, (l++) - lr->offset,
-					    false, true);
+		for (; ln->line > l; l++) {
+			ret = show_one_line(fp, l - lr->offset, false, false);
+			if (ret < 0)
+				goto end;
+		}
+		ret = show_one_line(fp, l++ - lr->offset, false, true);
 		if (ret < 0)
 			goto end;
 	}
 
 	if (lr->end == INT_MAX)
 		lr->end = l + NR_ADDITIONAL_LINES;
-	while (l <= lr->end && !feof(fp) && ret >= 0)
-		ret = show_one_line(fp, (l++) - lr->offset, false, false);
+	while (l <= lr->end && !feof(fp)) {
+		ret = show_one_line(fp, l++ - lr->offset, false, false);
+		if (ret < 0)
+			break;
+	}
 end:
 	fclose(fp);
 	return ret;
