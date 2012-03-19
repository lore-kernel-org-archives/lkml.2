Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032915Ab2CSUEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:04:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39995 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032761Ab2CSUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:04:21 -0400
Date: Mon, 19 Mar 2012 13:03:59 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-938a23ae7f656ffde9dd67e83dddf4406f85d773@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1331887855-874-3-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-3-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Add 's'
  key to filter by symbol name
Git-Commit-ID: 938a23ae7f656ffde9dd67e83dddf4406f85d773
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:04:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  938a23ae7f656ffde9dd67e83dddf4406f85d773
Gitweb:     http://git.kernel.org/tip/938a23ae7f656ffde9dd67e83dddf4406f85d773
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 16 Mar 2012 17:50:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 16:34:13 -0300

perf ui browser: Add 's' key to filter by symbol name

Now user can enter symbol name interested via ui_browser__input_window,
and perf can process it using hists__filter_by_symbol(). Giving empty
symbol (by pressing 's' followed by ENTER) will disable the filtering.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index de8ece8..c4173c9 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -879,6 +879,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char *options[16];
 	int nr_options = 0;
 	int key = -1;
+	char buf[64];
 
 	if (browser == NULL)
 		return -1;
@@ -933,6 +934,16 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
+		case 's':
+			if (ui_browser__input_window("Symbol to show",
+					"Please enter the name of symbol you want to see",
+					buf, "ENTER: OK, ESC: Cancel",
+					delay_secs * 2) == K_ENTER) {
+				self->symbol_filter_str = *buf ? buf : NULL;
+				hists__filter_by_symbol(self);
+				hist_browser__reset(browser);
+			}
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -950,7 +961,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"C             Collapse all callchains\n"
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread");
+					"t             Zoom into current Thread\n"
+					"s             Filter symbol by name");
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
