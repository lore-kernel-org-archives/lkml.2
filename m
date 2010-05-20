Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0ETQLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:11:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:52037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0ETQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:11:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf annotate: Use build-ids to find the right DSO
Date: Thu, 20 May 2010 13:10:45 -0300
Message-Id: <1274371845-27784-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274371845-27784-1-git-send-email-acme@infradead.org>
References: <1274371845-27784-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were still using the pathname found on the MMAP event, that could not
be the one we used when recording, so use the build-id cache for that,
only falling back to use the pathname in the MMAP event if no build-ids
are available.

With this we now also are able to do secure, seamless offline annotation.

Example:

[root@doppio linux-2.6-tip]# perf report -g none -v 2> /dev/null | head -10
     8.12%     Xorg  /usr/lib64/libpixman-1.so.0.14.0       0x0000000000026d02 B [.] pixman_rasterize_edges
     4.68%  firefox  /usr/lib64/xulrunner-1.9.1/libxul.so   0x00000000005dbdba B [.] 0x000000005dbdba
     3.70%  swapper  /lib/modules/2.6.34-rc6/build/vmlinux  0xffffffff81022cea ! [k] read_hpet
     2.96%     init  /lib/modules/2.6.34-rc6/build/vmlinux  0xffffffff81022cea ! [k] read_hpet
     2.73%  swapper  /lib/modules/2.6.34-rc6/build/vmlinux  0xffffffff8100a738 ! [k] mwait_idle_with_hints
[root@doppio linux-2.6-tip]# perf annotate -v pixman_rasterize_edges 2>&1 | grep Executing
Executing: objdump --start-address=0x000000371ce26670 --stop-address=0x000000371ce2709f -dS /root/.debug/.build-id/bd/6ac5199137aaeb279f864717d8d061477466c1|grep -v /root/.debug/.build-id/bd/6ac5199137aaeb279f864717d8d061477466c1|expand
[root@doppio linux-2.6-tip]# perf buildid-list | grep libpixman-1.so.0.14.0
bd6ac5199137aaeb279f864717d8d061477466c1 /usr/lib64/libpixman-1.so.0.14.0
[root@doppio linux-2.6-tip]#

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/build-id.c  |   22 ++++++++++++++++++++++
 tools/perf/util/build-id.h  |    2 ++
 tools/perf/util/callchain.c |    1 +
 tools/perf/util/callchain.h |    1 -
 tools/perf/util/hist.c      |   34 ++++++++++++++++++++++++++--------
 tools/perf/util/symbol.c    |   12 +++---------
 6 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 0f60a39..70c5cf8 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2009, 2010 Red Hat Inc.
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
+#include "util.h"
+#include <stdio.h>
 #include "build-id.h"
 #include "event.h"
 #include "symbol.h"
@@ -37,3 +39,23 @@ struct perf_event_ops build_id__mark_dso_hit_ops = {
 	.mmap	= event__process_mmap,
 	.fork	= event__process_task,
 };
+
+char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
+{
+	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+	const char *home;
+
+	if (!self->has_build_id)
+		return NULL;
+
+	build_id__sprintf(self->build_id, sizeof(self->build_id), build_id_hex);
+	home = getenv("HOME");
+	if (bf == NULL) {
+		if (asprintf(&bf, "%s/%s/.build-id/%.2s/%s", home,
+			     DEBUG_CACHE_DIR, build_id_hex, build_id_hex + 2) < 0)
+			return NULL;
+	} else
+		snprintf(bf, size, "%s/%s/.build-id/%.2s/%s", home,
+			 DEBUG_CACHE_DIR, build_id_hex, build_id_hex + 2);
+	return bf;
+}
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 1d981d6..5dafb00 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -5,4 +5,6 @@
 
 extern struct perf_event_ops build_id__mark_dso_hit_ops;
 
+char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
+
 #endif
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 21a52e0..62b69ad 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <math.h>
 
+#include "util.h"
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain, event_t *event)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1cba1f5..1ca73e4 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -5,7 +5,6 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include "event.h"
-#include "util.h"
 #include "symbol.h"
 
 enum chain_mode {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9a71c94..739c39f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,3 +1,4 @@
+#include "build-id.h"
 #include "util.h"
 #include "hist.h"
 #include "session.h"
@@ -988,22 +989,35 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 	struct symbol *sym = self->ms.sym;
 	struct map *map = self->ms.map;
 	struct dso *dso = map->dso;
-	const char *filename = dso->long_name;
+	char *filename = dso__build_id_filename(dso, NULL, 0);
 	char command[PATH_MAX * 2];
 	FILE *file;
+	int err = -1;
 	u64 len;
 
-	if (!filename)
-		return -1;
+	if (filename == NULL) {
+		if (dso->has_build_id) {
+			pr_err("Can't annotate %s: not enough memory\n",
+			       sym->name);
+			return -1;
+		}
+		/*
+		 * If we don't have build-ids, well, lets hope that this
+		 * DSO is the same as when 'perf record' ran.
+		 */
+		filename = dso->long_name;
+	}
 
 	if (dso->origin == DSO__ORIG_KERNEL) {
-		if (dso->annotate_warned)
-			return 0;
+		if (dso->annotate_warned) {
+			err = 0;
+			goto out_free_filename;
+		}
 		dso->annotate_warned = 1;
 		pr_err("Can't annotate %s: No vmlinux file was found in the "
 		       "path:\n", sym->name);
 		vmlinux_path__fprintf(stderr);
-		return -1;
+		goto out_free_filename;
 	}
 
 	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
@@ -1025,14 +1039,18 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 
 	file = popen(command, "r");
 	if (!file)
-		return -1;
+		goto out_free_filename;
 
 	while (!feof(file))
 		if (hist_entry__parse_objdump_line(self, file, head) < 0)
 			break;
 
 	pclose(file);
-	return 0;
+	err = 0;
+out_free_filename:
+	if (dso->has_build_id)
+		free(filename);
+	return err;
 }
 
 void hists__inc_nr_events(struct hists *self, u32 type)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 96bff0e..aaa51ba 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -11,6 +11,7 @@
 #include <sys/param.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include "build-id.h"
 #include "symbol.h"
 #include "strlist.h"
 
@@ -1293,7 +1294,6 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	int size = PATH_MAX;
 	char *name;
 	u8 build_id[BUILD_ID_SIZE];
-	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = -1;
 	int fd;
 	struct machine *machine;
@@ -1325,15 +1325,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	}
 
 	self->origin = DSO__ORIG_BUILD_ID_CACHE;
-
-	if (self->has_build_id) {
-		build_id__sprintf(self->build_id, sizeof(self->build_id),
-				  build_id_hex);
-		snprintf(name, size, "%s/%s/.build-id/%.2s/%s",
-			 getenv("HOME"), DEBUG_CACHE_DIR,
-			 build_id_hex, build_id_hex + 2);
+	if (dso__build_id_filename(self, name, size) != NULL)
 		goto open_file;
-	}
 more:
 	do {
 		self->origin++;
@@ -1349,6 +1342,7 @@ more:
 		case DSO__ORIG_BUILDID:
 			if (filename__read_build_id(self->long_name, build_id,
 						    sizeof(build_id))) {
+				char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 				build_id__sprintf(build_id, sizeof(build_id),
 						  build_id_hex);
 				snprintf(name, size,
-- 
1.6.2.5

