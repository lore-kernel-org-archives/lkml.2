Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0K2R4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:56:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:58356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0K2R4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:56:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Ming Lei <tom.leiming@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf symbols: Fix kallsyms kernel/module map splitting
Date: Mon, 29 Nov 2010 15:56:11 -0200
Message-Id: <1291053372-13592-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291053372-13592-1-git-send-email-acme@infradead.org>
References: <1291053372-13592-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

On ARM, module addresss space is ahead of kernel space, so the module
symbols are handled before kernel symbol in dso__split_kallsyms, then
was causing one map to be created for each kernel symbol.

Reported-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Ming Lei <tom.leiming@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20101124144540.GB15875@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0500895..2af4d7d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -532,7 +532,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 	struct machine *machine = kmaps->machine;
 	struct map *curr_map = map;
 	struct symbol *pos;
-	int count = 0;
+	int count = 0, moved = 0;	
 	struct rb_root *root = &self->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
@@ -590,6 +590,11 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
+			if (count == 0) {
+				curr_map = map;
+				goto filter_symbol;
+			}
+
 			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
@@ -615,7 +620,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
 		}
-
+filter_symbol:
 		if (filter && filter(curr_map, pos)) {
 discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
@@ -623,8 +628,9 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 			if (curr_map != map) {
 				rb_erase(&pos->rb_node, root);
 				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
-			}
-			count++;
+				++moved;
+			} else
+				++count;
 		}
 	}
 
@@ -634,7 +640,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 		dso__set_loaded(curr_map->dso, curr_map->type);
 	}
 
-	return count;
+	return count + moved;
 }
 
 int dso__load_kallsyms(struct dso *self, const char *filename,
-- 
1.6.2.5

