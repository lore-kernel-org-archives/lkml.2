Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0HBBJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0HBBJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/19] perf report: Don't abbreviate file paths relative to the cwd
Date: Sun,  1 Aug 2010 22:08:43 -0300
Message-Id: <1280711334-30000-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

This avoids around some problems where the full path is executables and DSOs it
needed for finding debug symbols on platforms with separated debug symbol files
such as Ubuntu.  This is simpler than tracking an extra name for each image.

The only impact should be that paths in verbose output from the perf tools
become absolute, instead of relative to .

LKML-Reference: <new-submission>
Signed-off-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    2 +-
 tools/perf/util/map.c   |   22 +---------------------
 tools/perf/util/map.h   |    2 +-
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 121339f..5b81bb2 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -517,7 +517,7 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 	map = map__new(&machine->user_dsos, self->mmap.start,
 			self->mmap.len, self->mmap.pgoff,
 			self->mmap.pid, self->mmap.filename,
-			MAP__FUNCTION, session->cwd, session->cwdlen);
+			MAP__FUNCTION);
 
 	if (thread == NULL || map == NULL)
 		goto out_problem;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index e672f2f..37cab90 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -17,16 +17,6 @@ static inline int is_anon_memory(const char *filename)
 	return strcmp(filename, "//anon") == 0;
 }
 
-static int strcommon(const char *pathname, char *cwd, int cwdlen)
-{
-	int n = 0;
-
-	while (n < cwdlen && pathname[n] == cwd[n])
-		++n;
-
-	return n;
-}
-
 void map__init(struct map *self, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
@@ -43,7 +33,7 @@ void map__init(struct map *self, enum map_type type,
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type, char *cwd, int cwdlen)
+		     enum map_type type)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -52,16 +42,6 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		struct dso *dso;
 		int anon;
 
-		if (cwd) {
-			int n = strcommon(filename, cwd, cwdlen);
-
-			if (n == cwdlen) {
-				snprintf(newfilename, sizeof(newfilename),
-					 ".%s", filename + n);
-				filename = newfilename;
-			}
-		}
-
 		anon = is_anon_memory(filename);
 
 		if (anon) {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f391345..3b2f706 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -106,7 +106,7 @@ void map__init(struct map *self, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type, char *cwd, int cwdlen);
+		     enum map_type type);
 void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
-- 
1.6.2.5

