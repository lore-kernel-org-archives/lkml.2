Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0EXBb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:31:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0EXBbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:31:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf annotate: Fix up usage of the build id cache
Date: Sun, 23 May 2010 22:31:11 -0300
Message-Id: <1274664671-27385-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274664671-27385-1-git-send-email-acme@infradead.org>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was assuming that the cache was always available and also wasn't
checking if the file found in the build id cache was just a kallsyms
file, that is not supported by objdump for disassembly.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 682a6d8..cbf7eae 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -990,6 +990,7 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 	struct map *map = self->ms.map;
 	struct dso *dso = map->dso;
 	char *filename = dso__build_id_filename(dso, NULL, 0);
+	bool free_filename = true;
 	char command[PATH_MAX * 2];
 	FILE *file;
 	int err = 0;
@@ -1001,11 +1002,19 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 			       sym->name);
 			return -ENOMEM;
 		}
+		goto fallback;
+	} else if (readlink(filename, command, sizeof(command)) < 0 ||
+		   strstr(command, "[kernel.kallsyms]") ||
+		   access(filename, R_OK)) {
+		free(filename);
+fallback:
 		/*
-		 * If we don't have build-ids, well, lets hope that this
+		 * If we don't have build-ids or the build-id file isn't in the
+		 * cache, or is just a kallsyms file, well, lets hope that this
 		 * DSO is the same as when 'perf record' ran.
 		 */
 		filename = dso->long_name;
+		free_filename = false;
 	}
 
 	if (dso->origin == DSO__ORIG_KERNEL) {
@@ -1045,7 +1054,7 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 
 	pclose(file);
 out_free_filename:
-	if (dso->has_build_id)
+	if (free_filename)
 		free(filename);
 	return err;
 }
-- 
1.6.2.5

