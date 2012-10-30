Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2J2D5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:57:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:42679 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab2J2D5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="210544464"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 8/8] perf report: Enable the runtime switching of perf data file
Date: Tue, 30 Oct 2012 11:56:09 +0800
Message-Id: <1351569369-26732-9-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for tui browser only. This patch will check the returned
key of tui hists browser, if it's K_SWITH_INPUT_DATA, then recreate
a session for the new selected data file.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-report.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f07eae7..3665a9a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -427,8 +427,14 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (use_browser > 0) {
 		if (use_browser == 1) {
-			perf_evlist__tui_browse_hists(session->evlist, help,
-						      NULL, NULL, 0);
+			ret = perf_evlist__tui_browse_hists(session->evlist,
+						help, NULL, NULL, 0);
+			/*
+			 * Usually "ret" is the last pressed key, and we only
+			 * care if the key notifies us to switch data file.
+			 */
+			if (ret != K_SWITCH_INPUT_DATA)
+				ret = 0;
 		} else if (use_browser == 2) {
 			perf_evlist__gtk_browse_hists(session->evlist, help,
 						      NULL, NULL, 0);
@@ -662,6 +668,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		else
 			input_name = "perf.data";
 	}
+
+repeat:
 	session = perf_session__new(input_name, O_RDONLY,
 				    report.force, false, &report.tool);
 	if (session == NULL)
@@ -768,6 +776,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	ret = __cmd_report(&report);
+	if (ret == K_SWITCH_INPUT_DATA) {
+		perf_session__delete(session);
+		goto repeat;
+	} else
+		ret = 0;
+
 error:
 	perf_session__delete(session);
 	return ret;
-- 
1.7.9.5

