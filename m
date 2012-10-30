Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2J2D6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:58:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:42679 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab2J2D5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="210544437"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 5/8] perf ui/browser: Integrate script browser into main hists browser
Date: Tue, 30 Oct 2012 11:56:06 +0800
Message-Id: <1351569369-26732-6-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate the script browser into "perf report" framework, users can
use function key 'r' or the drop down menu to list all perf scripts
and select one of them, just like they did for the annotation.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/hists.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ef2f93c..fe62284 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1141,6 +1141,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	int nr_options = 0;
 	int key = -1;
 	char buf[64];
+	char script_opt[64];
 
 	if (browser == NULL)
 		return -1;
@@ -1159,6 +1160,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
+		int scripts_comm = -2, scripts_symbol = -2, scripts_all = -2;
 
 		nr_options = 0;
 
@@ -1211,6 +1213,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				hist_browser__reset(browser);
 			}
 			continue;
+		case 'r':
+			goto do_scripts;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1229,6 +1233,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
+					"r             Run available scripts\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
@@ -1317,6 +1322,25 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		    browser->selection->map != NULL &&
 		    asprintf(&options[nr_options], "Browse map details") > 0)
 			browse_map = nr_options++;
+
+		/* perf script support */
+		if (browser->he_selection) {
+			struct symbol *sym;
+
+			if (asprintf(&options[nr_options], "Run scripts for samples of thread [%s]",
+				browser->he_selection->thread->comm) > 0)
+				scripts_comm = nr_options++;
+
+			sym = browser->he_selection->ms.sym;
+			if (sym && sym->namelen &&
+				asprintf(&options[nr_options], "Run scripts for samples of symbol [%s]",
+						sym->name) > 0)
+				scripts_symbol = nr_options++;
+		}
+
+		if (asprintf(&options[nr_options], "Run scripts for all samples") > 0)
+			scripts_all = nr_options++;
+
 add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 retry_popup_menu:
@@ -1411,6 +1435,20 @@ zoom_out_thread:
 			hists__filter_by_thread(hists);
 			hist_browser__reset(browser);
 		}
+		/* perf scripts support */
+		else if (choice == scripts_all || choice == scripts_comm ||
+				choice == scripts_symbol) {
+do_scripts:
+			memset(script_opt, 0, 64);
+
+			if (choice == scripts_comm)
+				sprintf(script_opt, " -c %s ", browser->he_selection->thread->comm);
+
+			if (choice == scripts_symbol)
+				sprintf(script_opt, " -S %s ", browser->he_selection->ms.sym->name);
+
+			script_browse(script_opt);
+		}
 	}
 out_free_stack:
 	pstack__delete(fstack);
-- 
1.7.9.5

