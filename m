Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2DNKyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:54:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51847 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2DNKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:54:22 -0400
Date: Sat, 14 Apr 2012 12:54:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120414105416.GA3981@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: a7ca08038b990e2cbed324948664b2d8940fd782 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Misc fixes.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf top: Add intel_idle to the skip list
      perf annotate: Fix hist decay
      perf annotate: Validate addr in symbol__inc_addr_samples

David Miller (1):
      perf hists: Catch and handle out-of-date hist entry maps.

Jiri Olsa (1):
      perf hists browser: Fix NULL deref in hists browsing code

Nikunj A. Dadhania (1):
      perf kvm: Finding struct machine fails for PERF_RECORD_MMAP


 tools/perf/builtin-top.c            |   36 ++++++++++++++++++++++++++++++++++-
 tools/perf/util/annotate.c          |   16 +++++---------
 tools/perf/util/hist.c              |   12 +++++++++++
 tools/perf/util/map.c               |    1 +
 tools/perf/util/map.h               |    1 +
 tools/perf/util/session.c           |   12 +++++++++-
 tools/perf/util/ui/browsers/hists.c |    3 ++
 7 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63ae..8ef59f8 100644
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
@@ -615,6 +648,7 @@ process_hotkey:
 
 /* Tag samples to be skipped. */
 static const char *skip_symbols[] = {
+	"intel_idle",
 	"default_idle",
 	"native_safe_halt",
 	"cpu_idle",
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 199f69e..08c6d13 100644
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
@@ -561,16 +561,12 @@ void symbol__annotate_decay_histogram(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
-	struct objdump_line *pos;
-	int len = sym->end - sym->start;
+	int len = sym->end - sym->start, offset;
 
 	h->sum = 0;
-
-	list_for_each_entry(pos, &notes->src->source, node) {
-		if (pos->offset != -1 && pos->offset < len) {
-			h->addr[pos->offset] = h->addr[pos->offset] * 7 / 8;
-			h->sum += h->addr[pos->offset];
-		}
+	for (offset = 0; offset < len; ++offset) {
+		h->addr[offset] = h->addr[offset] * 7 / 8;
+		h->sum += h->addr[offset];
 	}
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2ec4b60..9f6d630 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -256,6 +256,18 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		if (!cmp) {
 			he->period += period;
 			++he->nr_events;
+
+			/* If the map of an existing hist_entry has
+			 * become out-of-date due to an exec() or
+			 * similar, update it.  Otherwise we will
+			 * mis-adjust symbol addresses when computing
+			 * the history counter to increment.
+			 */
+			if (he->ms.map != entry->ms.map) {
+				he->ms.map = entry->ms.map;
+				if (he->ms.map)
+					he->ms.map->referenced = true;
+			}
 			goto out;
 		}
 
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
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9412e3b..00923cd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -826,8 +826,16 @@ static struct machine *
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest)
-		return perf_session__find_machine(session, event->ip.pid);
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
+		u32 pid;
+
+		if (event->header.type == PERF_RECORD_MMAP)
+			pid = event->mmap.pid;
+		else
+			pid = event->ip.pid;
+
+		return perf_session__find_machine(session, pid);
+	}
 
 	return perf_session__find_host_machine(session);
 }
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index d7a1c4a..2f83e5d 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -125,6 +125,9 @@ static int callchain__count_rows(struct rb_root *chain)
 
 static bool map_symbol__toggle_fold(struct map_symbol *self)
 {
+	if (!self)
+		return false;
+
 	if (!self->has_children)
 		return false;
 
