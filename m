Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0CXTkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:40:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0CXTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:40:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 2/6] perf symbols: Avoid unnecessary symbol loading when dso list is specified
Date: Wed, 24 Mar 2010 16:40:15 -0300
Message-Id: <1269459619-982-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269459619-982-1-git-send-email-acme@infradead.org>
References: <1269459619-982-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were performing the full thread__find_addr_location operation, i.e.
resolving to a map/dso _and_ loading its symbols when we can optimize it
by first calling thread__find_addr_map to find just the map/dso, check
if it is one that we are interested in (passed via --dsos/-d in 'perf
annotate', 'perf report', etc) and if not avoid loading the symtab.

Nice speedup when we know which DSO we're interested in.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 705ec63..c2808ad 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -513,24 +513,32 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	thread__find_addr_location(thread, session, cpumode, MAP__FUNCTION,
-				   self->ip.ip, al, filter);
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      self->ip.ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
-	/*
-	 * We have to do this here as we may have a dso with no symbol hit that
-	 * has a name longer than the ones with symbols sampled.
-	 */
-	if (al->map && !sort_dso.elide && !al->map->dso->slen_calculated)
-		dso__calc_col_width(al->map->dso);
-
-	if (symbol_conf.dso_list &&
-	    (!al->map || !al->map->dso ||
-	     !(strlist__has_entry(symbol_conf.dso_list, al->map->dso->short_name) ||
-	       (al->map->dso->short_name != al->map->dso->long_name &&
-		strlist__has_entry(symbol_conf.dso_list, al->map->dso->long_name)))))
-		goto out_filtered;
+	al->sym = NULL;
+
+	if (al->map) {
+		if (symbol_conf.dso_list &&
+		    (!al->map || !al->map->dso ||
+		     !(strlist__has_entry(symbol_conf.dso_list,
+					  al->map->dso->short_name) ||
+		       (al->map->dso->short_name != al->map->dso->long_name &&
+			strlist__has_entry(symbol_conf.dso_list,
+					   al->map->dso->long_name)))))
+			goto out_filtered;
+		/*
+		 * We have to do this here as we may have a dso with no symbol
+		 * hit that has a name longer than the ones with symbols
+		 * sampled.
+		 */
+		if (!sort_dso.elide && !al->map->dso->slen_calculated)
+			dso__calc_col_width(al->map->dso);
+
+		al->sym = map__find_symbol(al->map, al->addr, filter);
+	}
 
 	if (symbol_conf.sym_list && al->sym &&
 	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
-- 
1.6.2.5

