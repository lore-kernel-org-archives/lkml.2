Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1C3Jdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:33:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41716 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab1C3Jdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:33:31 -0400
X-AuditID: b753bd60-a454dba0000001d0-94-4d92f8e8191c
X-AuditID: b753bd60-a454dba0000001d0-94-4d92f8e8191c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 12/12] perf: Export debuginfo object without dwarf support
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:26:46 +0900
Message-ID: <20110330092646.2132.38892.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export debuginfo object interfaces without dwarf support.
This allows other objects to include debuginfo object.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/probe-finder.h |   56 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index c478b42..ffa6377 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "util.h"
+#include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 
 #define MAX_PATH_LEN		 256
@@ -15,12 +16,12 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
+struct debuginfo;
+
 #ifdef DWARF_SUPPORT
 
 #include "dwarf-aux.h"
 
-/* TODO: export debuginfo data structure even if no dwarf support */
-
 /* debug information structure */
 struct debuginfo {
 	Dwarf		*dbg;
@@ -103,6 +104,57 @@ struct line_finder {
 	int			found;
 };
 
+#else
+
+static inline struct debuginfo *debuginfo__new(const char *path __unused)
+{
+	return NULL;
+}
+
+static inline struct debuginfo *
+debuginfo__new_online_kernel(unsigned long addr __unused)
+{
+	return NULL;
+}
+
+static inline void debuginfo__delete(struct debuginfo *self __unused)
+{
+	return;
+}
+
+static inline int debuginfo__find_trace_events(struct debuginfo *self __unused,
+				struct perf_probe_event *pev __unused,
+				struct probe_trace_event **tevs __unused,
+				int max_tevs __unused)
+{
+	return -ENOTSUP;
+}
+
+/* Find a perf_probe_point from debuginfo */
+static inline int debuginfo__find_probe_point(struct debuginfo *self __unused,
+					unsigned long addr __unused,
+					struct perf_probe_point *ppt __unused)
+{
+	return -ENOTSUP;
+}
+
+/* Find a line range */
+static inline int debuginfo__find_line_range(struct debuginfo *self __unused,
+					     struct line_range *lr __unused)
+{
+	return -ENOTSUP;
+}
+/* Find available variables */
+static inline int debuginfo__find_available_vars_at(
+					struct debuginfo *self __unused,
+					struct perf_probe_event *pev __unused,
+					struct variable_list **vls __unused,
+					int max_points __unused,
+					bool externs __unused)
+{
+	return -ENOTSUP;
+}
+
 #endif /* DWARF_SUPPORT */
 
 #endif /*_PROBE_FINDER_H */

