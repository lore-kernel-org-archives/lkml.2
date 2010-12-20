Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0LTOSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:18:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab0LTOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wlfFkM2QMHpyLNggPtOuoDQBbvP6ThJmE3wDPSxRMgFYt69c7WfCicBY9sXlaCqk42
         kHLko8rJLEOQVKEVofpokrAlqzJfjTpqbThSX+QnkUnkUhCnMSp0M44FNCP+glUiZHED
         NdUQIVQQtyaPtej+tJg/7j9Q/qAgppjmfSz6E=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] perf-probe: clean up redundant tests in show_line_range()
Date: Mon, 20 Dec 2010 15:18:02 +0100
Message-Id: <1292854685-8230-4-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

It also removes some superflous parentheses.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 5cc8f6b..3c92b92 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -383,26 +383,30 @@ int show_line_range(struct line_range *lr, const char *module)
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
-- 
1.7.3.2

