Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2IXPa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:30:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:56118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab2IXPap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:30:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196413263"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 9/9] perf report: Enable the runtime switching of perf data file
Date: Mon, 24 Sep 2012 23:24:11 +0800
Message-Id: <1348500251-9937-10-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for tui browser only. This patch will check the returned
key of tui hists browser, if it's K_SWITH_INPUT_DATA, then recreate
a session for the new selected data file.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-report.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e4b2246..b4d216b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -426,8 +426,14 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (use_browser > 0) {
 		if (use_browser == 1) {
-			perf_evlist__tui_browse_hists(session->evlist, help,
-						      NULL, NULL, 0);
+			ret = perf_evlist__tui_browse_hists(session->evlist,
+						help, NULL, NULL, 0);
+			/*
+			 * Usually "ret" is the last pressed key, and we only
+			 * care whether we need to switch data file
+			 */
+			if (ret != K_SWITCH_INPUT_DATA)
+				ret = 0;
 		} else if (use_browser == 2) {
 			perf_evlist__gtk_browse_hists(session->evlist, help,
 						      NULL, NULL, 0);
@@ -661,6 +667,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		else
 			input_name = "perf.data";
 	}
+
+repeat:
 	session = perf_session__new(input_name, O_RDONLY,
 				    report.force, false, &report.tool);
 	if (session == NULL)
@@ -761,6 +769,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
1.7.1

