Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2I1IkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:40:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:38861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab2I1IhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188630"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 5/8] perf ui/browser: Integrate script browser into main hists browser
Date: Fri, 28 Sep 2012 16:30:37 +0800
Message-Id: <1348821040-9724-6-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
References: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate the script browser into "perf report" framework, users can
use function key 'r' or the drop down menu to list all perf scripts
and select one of them, just like they did for the annotation.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/hists.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a21f40b..edada57 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1139,6 +1139,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	int nr_options = 0;
 	int key = -1;
 	char buf[64];
+	char script_opt[64];
 
 	if (browser == NULL)
 		return -1;
@@ -1157,6 +1158,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
+		int scripts_comm = -2, scripts_symbol = -2, scripts_all = -2;
 
 		nr_options = 0;
 
@@ -1209,6 +1211,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				hist_browser__reset(browser);
 			}
 			continue;
+		case 'r':
+			goto do_scripts;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1227,6 +1231,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
+					"r             Run available scripts\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
@@ -1315,6 +1320,25 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
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
@@ -1409,6 +1433,20 @@ zoom_out_thread:
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
1.7.1

