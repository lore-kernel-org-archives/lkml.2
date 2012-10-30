Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab2J3MKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:10:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2J3MKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:10:18 -0400
Date: Tue, 30 Oct 2012 05:09:47 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-cdbab7c201ab38f7b8d248ebf289025381166526@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351569369-26732-6-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-6-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Integrate script browser into main hists browser
Git-Commit-ID: cdbab7c201ab38f7b8d248ebf289025381166526
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:09:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdbab7c201ab38f7b8d248ebf289025381166526
Gitweb:     http://git.kernel.org/tip/cdbab7c201ab38f7b8d248ebf289025381166526
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 30 Oct 2012 11:56:06 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:56:19 -0200

perf hists browser: Integrate script browser into main hists browser

Integrate the script browser into "perf report" framework, users can use
function key 'r' or the drop down menu to list all perf scripts and
select one of them, just like they did for the annotation.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351569369-26732-6-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

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
