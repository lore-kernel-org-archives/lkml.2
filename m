Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0CYW7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:59:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0CYW7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:59:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/6] perf symbols: Pass the mmap parameters instead of using mmap_event
Date: Thu, 25 Mar 2010 19:58:57 -0300
Message-Id: <1269557941-15617-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269557941-15617-1-git-send-email-acme@infradead.org>
References: <1269557941-15617-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To reduce the coupling of the symbol system with the rest of perf.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    3 ++-
 tools/perf/util/map.c   |   11 ++++-------
 tools/perf/util/map.h   |    5 ++---
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index c2808ad..052eaec 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -393,7 +393,8 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 	}
 
 	thread = perf_session__findnew(session, self->mmap.pid);
-	map = map__new(&self->mmap, MAP__FUNCTION,
+	map = map__new(self->mmap.start, self->mmap.len, self->mmap.pgoff,
+		       self->mmap.pid, self->mmap.filename, MAP__FUNCTION,
 		       session->cwd, session->cwdlen);
 
 	if (thread == NULL || map == NULL)
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index e509cd5..a9b4227 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -1,4 +1,3 @@
-#include "event.h"
 #include "symbol.h"
 #include <stdlib.h>
 #include <string.h>
@@ -38,13 +37,12 @@ void map__init(struct map *self, enum map_type type,
 	RB_CLEAR_NODE(&self->rb_node);
 }
 
-struct map *map__new(struct mmap_event *event, enum map_type type,
-		     char *cwd, int cwdlen)
+struct map *map__new(u64 start, u64 len, u64 pgoff, u32 pid, char *filename,
+		     enum map_type type, char *cwd, int cwdlen)
 {
 	struct map *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
-		const char *filename = event->filename;
 		char newfilename[PATH_MAX];
 		struct dso *dso;
 		int anon;
@@ -62,7 +60,7 @@ struct map *map__new(struct mmap_event *event, enum map_type type,
 		anon = is_anon_memory(filename);
 
 		if (anon) {
-			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", event->pid);
+			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
 		}
 
@@ -70,8 +68,7 @@ struct map *map__new(struct mmap_event *event, enum map_type type,
 		if (dso == NULL)
 			goto out_delete;
 
-		map__init(self, type, event->start, event->start + event->len,
-			  event->pgoff, dso);
+		map__init(self, type, start, start + len, pgoff, dso);
 
 		if (anon) {
 set_identity:
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index b756368..a4a5bc4 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -68,14 +68,13 @@ u64 map__rip_2objdump(struct map *map, u64 rip);
 u64 map__objdump_2ip(struct map *map, u64 addr);
 
 struct symbol;
-struct mmap_event;
 
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *self, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
-struct map *map__new(struct mmap_event *event, enum map_type,
-		     char *cwd, int cwdlen);
+struct map *map__new(u64 start, u64 len, u64 pgoff, u32 pid, char *filename,
+		     enum map_type type, char *cwd, int cwdlen);
 void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
-- 
1.6.2.5

