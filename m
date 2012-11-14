Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423183Ab2KNQse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:48:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43345 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423059Ab2KNQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:48:31 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] perf report: Run dynamic loaded GTK browser
Date: Thu, 15 Nov 2012 01:47:44 +0900
Message-Id: <1352911664-24620-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
References: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run GTK hist browser using libdl.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile         |    3 ++-
 tools/perf/builtin-report.c |   16 +++++++++++++---
 tools/perf/ui/gtk/gtk.h     |    5 +++++
 tools/perf/util/hist.h      |   13 -------------
 4 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 502080cc1b3d..af4c88311371 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -641,7 +641,8 @@ ifndef NO_GTK2
 		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
 			GTK_CFLAGS = -DHAVE_GTK_INFO_BAR
 		endif
-		GTK_CFLAGS += $(ALL_CFLAGS) -DGTK2_SUPPORT
+		BASIC_CFLAGS += -DGTK2_SUPPORT
+		GTK_CFLAGS += $(ALL_CFLAGS)
 		GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
 		GTK_LIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 		GTK_OBJS := $(OUTPUT)ui/gtk/browser.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fc251005dd3d..ac5d8915d8c5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -7,8 +7,9 @@
  */
 #include "builtin.h"
 
-#include "util/util.h"
+#include <dlfcn.h>
 
+#include "util/util.h"
 #include "util/annotate.h"
 #include "util/color.h"
 #include <linux/list.h>
@@ -431,8 +432,17 @@ static int __cmd_report(struct perf_report *rep)
 						      NULL,
 						      &session->header.env);
 		} else if (use_browser == 2) {
-			perf_evlist__gtk_browse_hists(session->evlist, help,
-						      NULL);
+			int (*hist_browser)(struct perf_evlist *,
+					    const char *,
+					    struct hist_browser_timer *);
+
+			hist_browser = dlsym(perf_gtk_handle,
+					     "perf_evlist__gtk_browse_hists");
+			if (hist_browser == NULL) {
+				ui__error("GTK browser not found!\n");
+				goto out_delete;
+			}
+			hist_browser(session->evlist, help, NULL);
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 8ed6a1288969..bcd7a10d9525 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -43,4 +43,9 @@ static inline GtkWidget *perf_gtk__setup_info_bar(void)
 }
 #endif
 
+struct perf_evlist;
+struct hist_browser_timer;
+
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  struct hist_browser_timer *hbt);
 #endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a51e4a2..1e9b6f2ba48e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -204,19 +204,6 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #define K_RIGHT -2
 #endif
 
-#ifdef GTK2_SUPPORT
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  struct hist_browser_timer *hbt __maybe_unused);
-#else
-static inline
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
-				  const char *help __maybe_unused,
-				  struct hist_browser_timer *hbt __maybe_unused)
-{
-	return 0;
-}
-#endif
-
 unsigned int hists__sort_list_width(struct hists *self);
 
 double perf_diff__compute_delta(struct hist_entry *he);
-- 
1.7.9.2

