Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab1CWWxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:53:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:53626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab1CWWw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:52:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Dave Martin <dave.martin@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/3] perf symbols: Look at .dynsym again if .symtab not found
Date: Wed, 23 Mar 2011 19:52:47 -0300
Message-Id: <1300920767-936-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300920767-936-1-git-send-email-acme@infradead.org>
References: <1300920767-936-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The original intent of the code was to repeat the search with
want_symtab = 0. But as the code stands now, we never hit the "default"
case of the switch statement. Which means we never repeat the search.

Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reported-by: Arun Sharma <asharma@fb.com>
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Dave Martin <dave.martin@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 651dbfe..17df793 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1486,7 +1486,9 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 * On the first pass, only load images if they have a full symtab.
 	 * Failing that, do a second pass where we accept .dynsym also
 	 */
-	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE, want_symtab = 1;
+	want_symtab = 1;
+restart:
+	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE;
 	     self->symtab_type != SYMTAB__NOT_FOUND;
 	     self->symtab_type++) {
 		switch (self->symtab_type) {
@@ -1536,17 +1538,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
 				 self->long_name);
 			break;
-
-		default:
-			/*
-			 * If we wanted a full symtab but no image had one,
-			 * relax our requirements and repeat the search.
-			 */
-			if (want_symtab) {
-				want_symtab = 0;
-				self->symtab_type = SYMTAB__BUILD_ID_CACHE;
-			} else
-				continue;
+		default:;
 		}
 
 		/* Name is now the name of the next image to try */
@@ -1573,6 +1565,15 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 		}
 	}
 
+	/*
+	 * If we wanted a full symtab but no image had one,
+	 * relax our requirements and repeat the search.
+	 */
+	if (ret <= 0 && want_symtab) {
+		want_symtab = 0;
+		goto restart;
+	}
+
 	free(name);
 	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
 		return 0;
-- 
1.6.2.5

