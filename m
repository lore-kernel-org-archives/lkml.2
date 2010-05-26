Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426Ab0EZVbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:31:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:43400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab0EZVbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:31:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf symbols: Add the build id cache to the vmlinux path
Date: Wed, 26 May 2010 18:30:49 -0300
Message-Id: <1274909449-10977-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274909449-10977-1-git-send-email-acme@infradead.org>
References: <1274909449-10977-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that if the kernel DSO has a build id because record inserted it in
the perf.data build id table in the header, or a BUILD_ID event was
inserted in the stream, we first look at the build id cache
($HOME/.debug/).

If we find it there, try to use it, allowing offline annotation in
addition to 'perf report'.

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
 tools/perf/builtin-top.c |    2 +-
 tools/perf/util/symbol.c |   27 +++++++++++++++++++++++----
 tools/perf/util/symbol.h |    2 +-
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 397290a..a66f427 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1060,7 +1060,7 @@ static void event__process_sample(const event_t *self,
 			pr_err("Can't annotate %s", sym->name);
 			if (sym_filter_entry->map->dso->origin == DSO__ORIG_KERNEL) {
 				pr_err(": No vmlinux file was found in the path:\n");
-				vmlinux_path__fprintf(stderr);
+				machine__fprintf_vmlinux_path(machine, stderr);
 			} else
 				pr_err(".\n");
 			exit(1);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index aaa51ba..7fd6b15 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1695,9 +1695,20 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			   symbol_filter_t filter)
 {
 	int i, err = 0;
+	char *filename;
 
 	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
-		 vmlinux_path__nr_entries);
+		 vmlinux_path__nr_entries + 1);
+
+	filename = dso__build_id_filename(self, NULL, 0);
+	if (filename != NULL) {
+		err = dso__load_vmlinux(self, map, filename, filter);
+		if (err > 0) {
+			dso__set_long_name(self, filename);
+			goto out;
+		}
+		free(filename);
+	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
 		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
@@ -1706,7 +1717,7 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			break;
 		}
 	}
-
+out:
 	return err;
 }
 
@@ -2102,13 +2113,21 @@ out_fail:
 	return -1;
 }
 
-size_t vmlinux_path__fprintf(FILE *fp)
+size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp)
 {
 	int i;
 	size_t printed = 0;
+	struct dso *kdso = self->vmlinux_maps[MAP__FUNCTION]->dso;
+
+	if (kdso->has_build_id) {
+		char filename[PATH_MAX];
+		if (dso__build_id_filename(kdso, filename, sizeof(filename)))
+			printed += fprintf(fp, "[0] %s\n", filename);
+	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i)
-		printed += fprintf(fp, "[%d] %s\n", i, vmlinux_path[i]);
+		printed += fprintf(fp, "[%d] %s\n",
+				   i + kdso->has_build_id, vmlinux_path[i]);
 
 	return printed;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5d25b5e..5e02d2c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -216,6 +216,6 @@ int machines__create_guest_kernel_maps(struct rb_root *self);
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-size_t vmlinux_path__fprintf(FILE *fp);
+size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
 
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

