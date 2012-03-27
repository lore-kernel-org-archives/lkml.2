Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2C0Sgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:36:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54416 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2C0Sgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:36:46 -0400
Date: Tue, 27 Mar 2012 15:36:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Sorin Dumitru <dumitru.sorin87@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Validate address in symbol__inc_addr_samples().
Message-ID: <20120327183640.GB7374@infradead.org>
References: <20120325.162808.1311176271259118121.davem@davemloft.net>
 <20120327141523.GA6931@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327141523.GA6931@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 27, 2012 at 11:15:23AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Sun, Mar 25, 2012 at 04:28:08PM -0400, David Miller escreveu:
> > If addr < sym->start then we are going to access past the end of the
> > h->addr[] array, since the offset calculated will be huge.
> > 
> > Trigger an assertion instead of randomly scribbling memory when this
> > situation occurs.
> 
> I'm applying this one instead, please check if you have any concerns
> with this approach:

Patch in my perf/core tree now:

commit ebb914bd5b93b4556cffd48eee9e7b493fb0b8cb
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue Mar 27 12:55:57 2012 -0300

    perf annotate: Validate addr in symbol__inc_addr_samples
    
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

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63ae..2994d6c 100644
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
index e5a462f..23312ac 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -64,8 +64,8 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr >= sym->end)
-		return 0;
+	if (addr < sym->start || addr >= sym->end)
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
 

