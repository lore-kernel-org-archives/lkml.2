Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0C3XUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:44 -0400
Received: from kroah.org ([198.145.64.141]:45893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab0C3XTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:47 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:44 2010
Message-Id: <20100330224744.268370574@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>,
       =?ISO-8859-15?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= 
	<fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [037/156] perf annotate: Defer allocating sym_priv->hist array
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnaldo Carvalho de Melo <acme@infradead.org>

commit 628ada0cb03666dd463f7c25947eaccdf440c309 upstream

Because symbol->end is not fixed up at symbol_filter time, only
after all symbols for a DSO are loaded, and that, for asm
symbols, may be bogus, causing segfaults when hits happen in
these symbols.

Backported-from: 628ada0
Reported-by: David Miller <davem@davemloft.net>
Reported-by: Anton Blanchard <anton@samba.org>
Acked-by: David Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20100225155740.GB8553@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/builtin-annotate.c |   65 +++++++++++++++++++++---------------------
 tools/perf/util/symbol.c      |    2 -
 tools/perf/util/symbol.h      |    2 +
 3 files changed, 36 insertions(+), 33 deletions(-)

--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -53,32 +53,20 @@ struct sym_priv {
 
 static const char *sym_hist_filter;
 
-static int symbol_filter(struct map *map __used, struct symbol *sym)
+static int sym__alloc_hist(struct symbol *self)
 {
-	if (sym_hist_filter == NULL ||
-	    strcmp(sym->name, sym_hist_filter) == 0) {
-		struct sym_priv *priv = symbol__priv(sym);
-		const int size = (sizeof(*priv->hist) +
-				  (sym->end - sym->start) * sizeof(u64));
-
-		priv->hist = malloc(size);
-		if (priv->hist)
-			memset(priv->hist, 0, size);
-		return 0;
-	}
-	/*
-	 * FIXME: We should really filter it out, as we don't want to go thru symbols
-	 * we're not interested, and if a DSO ends up with no symbols, delete it too,
-	 * but right now the kernel loading routines in symbol.c bail out if no symbols
-	 * are found, fix it later.
-	 */
-	return 0;
+	struct sym_priv *priv = symbol__priv(self);
+	const int size = (sizeof(*priv->hist) +
+			  (self->end - self->start) * sizeof(u64));
+
+	priv->hist = zalloc(size);
+	return priv->hist == NULL ? -1 : 0;
 }
 
 /*
  * collect histogram counts
  */
-static void hist_hit(struct hist_entry *he, u64 ip)
+static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 {
 	unsigned int sym_size, offset;
 	struct symbol *sym = he->sym;
@@ -88,11 +76,11 @@ static void hist_hit(struct hist_entry *
 	he->count++;
 
 	if (!sym || !he->map)
-		return;
+		return 0;
 
 	priv = symbol__priv(sym);
-	if (!priv->hist)
-		return;
+	if (priv->hist == NULL && sym__alloc_hist(sym) < 0)
+		return -ENOMEM;
 
 	sym_size = sym->end - sym->start;
 	offset = ip - sym->start;
@@ -102,7 +90,7 @@ static void hist_hit(struct hist_entry *
 			he->map->unmap_ip(he->map, ip));
 
 	if (offset >= sym_size)
-		return;
+		return 0;
 
 	h = priv->hist;
 	h->sum++;
@@ -114,18 +102,31 @@ static void hist_hit(struct hist_entry *
 			he->sym->name,
 			(void *)(unsigned long)ip, ip - he->sym->start,
 			h->ip[offset]);
+	return 0;
 }
 
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
 {
-	bool hit;
-	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
-							       count, &hit);
-	if (he == NULL)
-		return -ENOMEM;
-	hist_hit(he, al->addr);
-	return 0;
+ 	bool hit;
+	struct hist_entry *he;
+
+	if (sym_hist_filter != NULL &&
+	    (al->sym == NULL || strcmp(sym_hist_filter, al->sym->name) != 0)) {
+		/* We're only interested in a symbol named sym_hist_filter */
+		if (al->sym != NULL) {
+			rb_erase(&al->sym->rb_node,
+				 &al->map->dso->symbols[al->map->type]);
+			symbol__delete(al->sym);
+		}
+		return 0;
+	}
+
+	he = __perf_session__add_hist_entry(self, al, NULL, count, &hit);
+ 	if (he == NULL)
+ 		return -ENOMEM;
+
+	return annotate__hist_hit(he, al->addr);
 }
 
 static int process_sample_event(event_t *event, struct perf_session *session)
@@ -135,7 +136,7 @@ static int process_sample_event(event_t
 	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
 		    event->ip.pid, (void *)(long)event->ip.ip);
 
-	if (event__preprocess_sample(event, session, &al, symbol_filter) < 0) {
+	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -149,7 +149,7 @@ static struct symbol *symbol__new(u64 st
 	return self;
 }
 
-static void symbol__delete(struct symbol *self)
+void symbol__delete(struct symbol *self)
 {
 	free(((void *)self) - symbol_conf.priv_size);
 }
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -49,6 +49,8 @@ struct symbol {
 	char		name[0];
 };
 
+void symbol__delete(struct symbol *self);
+
 struct strlist;
 
 struct symbol_conf {


