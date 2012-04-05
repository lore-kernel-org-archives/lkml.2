Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab2DEX3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:29:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:54143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2DEX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:29:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/5] perf annotate: Validate addr in symbol__inc_addr_samples
Date: Thu,  5 Apr 2012 20:28:52 -0300
Message-Id: <1333668532-3624-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333668532-3624-1-git-send-email-acme@infradead.org>
References: <1333668532-3624-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This routine was checking only if the provided address was after
sym->end, not if it was before sym->start.

Fix that by checking for both and return in both cases -ERANGE, so that
tools can communicate this to the user properly, or if they chose so, to
abort.

This problem was reported previously but the fixes involved either doing
what was being done for the > end case, i.e. silently drop the sample,
returning 0, or aborting at this function, which is in a lib (or better,
is slated to be at some point) and shouldn't abort.

The 'report' tool already checks this value and uses pr_debug to warn
the user.

This patch makes the 'top' tool check it too and warn once per map where
such range problem takes place.

Reported-by: David Miller <davem@davemloft.net>
Reported-by: Sorin Dumitru <dumitru.sorin87@gmail.com>
Reported-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-lw8gs7p9i9nhldilo82tzpne@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c   |   35 ++++++++++++++++++++++++++++++++++-
 tools/perf/util/annotate.c |    4 ++--
 tools/perf/util/map.c      |    1 +
 tools/perf/util/map.h      |    1 +
 4 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fab0a1c..8ef59f8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -42,6 +42,7 @@
 #include "util/debug.h"
 
 #include <assert.h>
+#include <elf.h>
 #include <fcntl.h>
 
 #include <stdio.h>
@@ -59,6 +60,7 @@
 #include <sys/prctl.h>
 #include <sys/wait.h>
 #include <sys/uio.h>
+#include <sys/utsname.h>
 #include <sys/mman.h>
 
 #include <linux/unistd.h>
@@ -162,12 +164,40 @@ static void __zero_source_counters(struct hist_entry *he)
 	symbol__annotate_zero_histograms(sym);
 }
 
+static void ui__warn_map_erange(struct map *map, struct symbol *sym, u64 ip)
+{
+	struct utsname uts;
+	int err = uname(&uts);
+
+	ui__warning("Out of bounds address found:\n\n"
+		    "Addr:   %" PRIx64 "\n"
+		    "DSO:    %s %c\n"
+		    "Map:    %" PRIx64 "-%" PRIx64 "\n"
+		    "Symbol: %" PRIx64 "-%" PRIx64 " %c %s\n"
+		    "Arch:   %s\n"
+		    "Kernel: %s\n"
+		    "Tools:  %s\n\n"
+		    "Not all samples will be on the annotation output.\n\n"
+		    "Please report to linux-kernel@vger.kernel.org\n",
+		    ip, map->dso->long_name, dso__symtab_origin(map->dso),
+		    map->start, map->end, sym->start, sym->end,
+		    sym->binding == STB_GLOBAL ? 'g' :
+		    sym->binding == STB_LOCAL  ? 'l' : 'w', sym->name,
+		    err ? "[unknown]" : uts.machine,
+		    err ? "[unknown]" : uts.release, perf_version_string);
+	if (use_browser <= 0)
+		sleep(5);
+	
+	map->erange_warned = true;
+}
+
 static void perf_top__record_precise_ip(struct perf_top *top,
 					struct hist_entry *he,
 					int counter, u64 ip)
 {
 	struct annotation *notes;
 	struct symbol *sym;
+	int err;
 
 	if (he == NULL || he->ms.sym == NULL ||
 	    ((top->sym_filter_entry == NULL ||
@@ -189,9 +219,12 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 	}
 
 	ip = he->ms.map->map_ip(he->ms.map, ip);
-	symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
+	err = symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
+
+	if (err == -ERANGE && !he->ms.map->erange_warned)
+		ui__warn_map_erange(he->ms.map, sym, ip);
 }
 
 static void perf_top__show_details(struct perf_top *top)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 70f5a4d..08c6d13 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -64,8 +64,8 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr > sym->end)
-		return 0;
+	if (addr < sym->start || addr > sym->end)
+		return -ERANGE;
 
 	offset = addr - sym->start;
 	h = annotation__histogram(notes, evidx);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index dea6d1c..35ae568 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -38,6 +38,7 @@ void map__init(struct map *self, enum map_type type,
 	RB_CLEAR_NODE(&self->rb_node);
 	self->groups   = NULL;
 	self->referenced = false;
+	self->erange_warned = false;
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index b100c20..81371ba 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -33,6 +33,7 @@ struct map {
 	u64			end;
 	u8 /* enum map_type */	type;
 	bool			referenced;
+	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
 
-- 
1.7.9.2.358.g22243

