Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0HBHwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:52:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:60304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0HBHvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:51:24 -0400
Date: Mon, 2 Aug 2010 07:51:04 GMT
From: tip-bot for Dave Martin <dave.martin@linaro.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.martin@linaro.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Don't abbreviate file paths relative to the cwd
Message-ID: <tip-361d13462585474267a0c41e956f1a1c19a93f17@git.kernel.org>
Git-Commit-ID: 361d13462585474267a0c41e956f1a1c19a93f17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:51:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  361d13462585474267a0c41e956f1a1c19a93f17
Gitweb:     http://git.kernel.org/tip/361d13462585474267a0c41e956f1a1c19a93f17
Author:     Dave Martin <dave.martin@linaro.org>
AuthorDate: Tue, 27 Jul 2010 16:40:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Jul 2010 11:39:04 -0300

perf report: Don't abbreviate file paths relative to the cwd

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
