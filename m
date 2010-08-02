Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0HBBM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:12:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0HBBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/19] perf symbols: Precisely specify if dso->{long,short}_name should be freed
Date: Sun,  1 Aug 2010 22:08:47 -0300
Message-Id: <1280711334-30000-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    1 +
 tools/perf/util/symbol.c |    5 ++++-
 tools/perf/util/symbol.h |    4 +++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5b81bb2..8151d23 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -456,6 +456,7 @@ static int event__process_kernel_mmap(event_t *self,
 			goto out_problem;
 
 		map->dso->short_name = name;
+		map->dso->sname_alloc = 1;
 		map->end = map->start + self->mmap.len;
 	} else if (is_kernel_mmap) {
 		const char *symbol_name = (self->mmap.filename +
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index bc6e7e8..242d2b2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -224,7 +224,9 @@ void dso__delete(struct dso *self)
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		symbols__delete(&self->symbols[i]);
-	if (self->long_name != self->name)
+	if (self->sname_alloc)
+		free((char *)self->short_name);
+	if (self->lname_alloc)
 		free(self->long_name);
 	free(self);
 }
@@ -1530,6 +1532,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 			if (long_name == NULL)
 				goto failure;
 			dso__set_long_name(map->dso, long_name);
+			map->dso->lname_alloc = 1;
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6452a07..f29f73c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -126,12 +126,14 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	enum dso_kernel_type	kernel;
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
-	enum dso_kernel_type	kernel;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
+	u8		 sname_alloc:1;
+	u8		 lname_alloc:1;
 	unsigned char	 origin;
 	u8		 sorted_by_name;
 	u8		 loaded;
-- 
1.6.2.5

