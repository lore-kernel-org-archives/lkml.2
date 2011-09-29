Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab1I2Wto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:49:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:43965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab1I2WsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/16] perf symbols: Treat all memory maps without dso file as loaded
Date: Thu, 29 Sep 2011 19:48:10 -0300
Message-Id: <1317336490-19437-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The stack/vdso/heap memory maps dont have any dso file.  Setting the
perf dso objects as 'loaded' for these maps, we avoid unnecessary
warnings like:

  "Failed to open [stack], continuing without symbols"

All map__find_* functions still return NULL when searching for symbols
in these maps.

Link: http://lkml.kernel.org/r/20110824131834.GA2007@jolsa.brq.redhat.com
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index aa2f9fd..9cf0d43 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -18,6 +18,13 @@ static inline int is_anon_memory(const char *filename)
 	return strcmp(filename, "//anon") == 0;
 }
 
+static inline int is_no_dso_memory(const char *filename)
+{
+	return !strcmp(filename, "[stack]") ||
+	       !strcmp(filename, "[vdso]")  ||
+	       !strcmp(filename, "[heap]");
+}
+
 void map__init(struct map *self, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
@@ -42,9 +49,10 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (self != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon;
+		int anon, no_dso;
 
 		anon = is_anon_memory(filename);
+		no_dso = is_no_dso_memory(filename);
 
 		if (anon) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
@@ -57,12 +65,16 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 
 		map__init(self, type, start, start + len, pgoff, dso);
 
-		if (anon) {
-set_identity:
+		if (anon || no_dso) {
 			self->map_ip = self->unmap_ip = identity__map_ip;
-		} else if (strcmp(filename, "[vdso]") == 0) {
-			dso__set_loaded(dso, self->type);
-			goto set_identity;
+
+			/*
+			 * Set memory without DSO as loaded. All map__find_*
+			 * functions still return NULL, and we avoid the
+			 * unnecessary map__load warning.
+			 */
+			if (no_dso)
+				dso__set_loaded(dso, self->type);
 		}
 	}
 	return self;
-- 
1.6.2.5

