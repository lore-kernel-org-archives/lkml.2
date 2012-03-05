Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2CEWNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:13:00 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:63742 "EHLO
	intmgw001.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756592Ab2CEWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:12:57 -0500
Date: Mon, 5 Mar 2012 14:12:54 -0800
From: Arun Sharma <asharma@fb.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [RFC] Sort inclusive
Message-ID: <20120305221253.GA30250@dev3310.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some of our users have been asking for the ability to sort samples by
inclusive time (time spent in the function + all of the callees in the
callgraph).

While something like this is possible via tools such as:

perf script | gprof2dot.py -f perf

a simpler, text only tool seems desirable.

The attached patch seems to work ok on some test programs in
order=caller mode. The idea is simple:

For each input callchain such as:

main -> a -> b -> c

We create histogram entries for:

main -> a -> b -> c (original callchain)
a -> b -> c (inclusive callchain)
b -> c (inclusive callchain)
c (inclusive callchain)

When computing hists->stats.total_period, the patch ignores the inclusive
callchains and considers only the original callchain.

However, this doesn't work very well for order=callee, mainly because
the patch doesn't compute total_period correctly. The number of samples
look ok (and should be the same as order=caller) for each symbol.

If the input stream had:

c <- b <- a <- main 

everything would've worked just fine. But when I step through the code,
I see:

some <- kernel <- funcs <- c <- b <- a <- main (original)
kernel <- funcs <- c <- b <- a <- main (inclusive)
funcs <- c <- b <- a <- main (inclusive)
c <- b <- a <- main (inclusive <- but should be the original callchain)
b <- a <- main (inclusive)
a <- main (inclusive)
main (inclusive)

I tried a couple of hacks (eg: comparing event->ip.ip to al->addr) to
tell the original callchain from inclusive ones, so the inclusive chains
can be used for histogram display/sorting, but ignored for other
purposes.

I hope others find --sort inclusive functionality useful. Any comments
on how to solve the order=callee case would be great. I suspect this has
something to do with histogram output collapsing/resorting.

 -Arun

commit 29e659f0ca2041f2f1681a0072739165220d7c64
Author: Arun Sharma <asharma@fb.com>
Date:   Wed Feb 29 21:40:47 2012 +0000

    perf: Add a new sort order: SORT_INCLUSIVE
    
    Each entry that used to get added once to the histogram, now is added
    chain->nr times, each time with one less entry in the
    callchain.
    
    This will result in a non-leaf function that appears in a lot of
    samples to get a histogram entry with lots of hits.
    
    The user can then drill down into the callchains of functions that
    have high inclusive times.
    
    Signed-off-by: Arun Sharma <asharma@fb.com>

diff --git a/builtin-report.c b/builtin-report.c
index 25d34d4..4bcd169 100644
--- a/builtin-report.c
+++ b/builtin-report.c
@@ -60,7 +60,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct symbol *parent = NULL;
 	int err = 0;
-	struct hist_entry *he;
+	struct hist_entry *he = NULL;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
@@ -69,16 +69,47 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
-	if (he == NULL)
-		return -ENOMEM;
+	if ((sort__first_dimension == SORT_INCLUSIVE) && (symbol_conf.use_callchain)) {
+		struct callchain_cursor *cursor = &evsel->hists.callchain_cursor;
+		struct callchain_cursor iter = *cursor;
+		struct callchain_cursor new_cursor = *cursor;
+		u64 i;
+
+		iter.pos = 0;
+		iter.curr = iter.first;
+		for (i = 0; i < cursor->nr; i++) {
+			struct addr_location al_child = *al;
+
+			err = callchain_get(&iter, &al_child);
+			if (err)
+				return err;
+			he = __hists__add_entry(&evsel->hists, &al_child, parent, sample->period);
+			if (he == NULL)
+				return -ENOMEM;
+
+			new_cursor.first = iter.curr;
+			new_cursor.nr = cursor->nr - i;
+			if (i != 0) 
+				he->inclusive = 1;
+			err = callchain_append(he->callchain,
+					       &new_cursor,
+					       sample->period);
+			if (err)
+				return err;
+			callchain_cursor_advance(&iter);
+		}
+	} else {
+		he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+		if (he == NULL)
+			return -ENOMEM;
 
-	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &evsel->hists.callchain_cursor,
-				       sample->period);
-		if (err)
-			return err;
+		if (symbol_conf.use_callchain) {
+			err = callchain_append(he->callchain,
+					       &evsel->hists.callchain_cursor,
+					       sample->period);
+			if (err)
+				return err;
+		}
 	}
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
@@ -595,6 +626,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "inclusive", stdout);
 
 	return __cmd_report(&report);
 }
diff --git a/util/callchain.c b/util/callchain.c
index 9f7106a..aa4acde 100644
--- a/util/callchain.c
+++ b/util/callchain.c
@@ -459,3 +459,17 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 
 	return 0;
 }
+
+int callchain_get(struct callchain_cursor *cursor,
+		  struct addr_location *al)
+{
+	struct callchain_cursor_node *node = cursor->curr;
+
+	if (node == NULL) return -1;
+
+	al->map = node->map;
+	al->sym = node->sym;
+	al->addr = node->ip;
+
+	return 0;
+}
diff --git a/util/callchain.h b/util/callchain.h
index 7f9c0f1..dcff6ec 100644
--- a/util/callchain.h
+++ b/util/callchain.h
@@ -103,9 +103,13 @@ int callchain_merge(struct callchain_cursor *cursor,
 
 struct ip_callchain;
 union perf_event;
+struct addr_location;
 
 bool ip_callchain__valid(struct ip_callchain *chain,
 			 const union perf_event *event);
+
+int callchain_get(struct callchain_cursor *cursor, struct addr_location *al);
+
 /*
  * Initialize a cursor before adding entries inside, but keep
  * the previously allocated entries as a cache.
diff --git a/util/hist.c b/util/hist.c
index 6f505d1..0eebe46 100644
--- a/util/hist.c
+++ b/util/hist.c
@@ -174,6 +174,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
+		he->inclusive = false;
 	}
 
 	return he;
@@ -181,7 +182,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
-	if (!h->filtered) {
+	if (!h->filtered && !h->inclusive) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
 		hists->stats.total_period += h->period;
diff --git a/util/sort.c b/util/sort.c
index 16da30d..1440ad4 100644
--- a/util/sort.c
+++ b/util/sort.c
@@ -259,6 +259,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "symbol",	.entry = &sort_sym,	},
 	{ .name = "parent",	.entry = &sort_parent,	},
 	{ .name = "cpu",	.entry = &sort_cpu,	},
+	{ .name = "inclusive",	.entry = &sort_sym, 	},
 };
 
 int sort_dimension__add(const char *tok)
@@ -298,6 +299,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_DSO;
 			else if (!strcmp(sd->name, "symbol"))
 				sort__first_dimension = SORT_SYM;
+			else if (!strcmp(sd->name, "inclusive"))
+				sort__first_dimension = SORT_INCLUSIVE;
 			else if (!strcmp(sd->name, "parent"))
 				sort__first_dimension = SORT_PARENT;
 			else if (!strcmp(sd->name, "cpu"))
diff --git a/util/sort.h b/util/sort.h
index 3f67ae3..2d35c11 100644
--- a/util/sort.h
+++ b/util/sort.h
@@ -65,6 +65,7 @@ struct hist_entry {
 	bool			init_have_children;
 	char			level;
 	bool			used;
+	bool			inclusive;
 	u8			filtered;
 	struct symbol		*parent;
 	union {
@@ -82,6 +83,7 @@ enum sort_type {
 	SORT_SYM,
 	SORT_PARENT,
 	SORT_CPU,
+	SORT_INCLUSIVE,
 };
 
 /*
