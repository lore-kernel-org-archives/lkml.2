Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2LFNWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:22:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab2LFNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:22:45 -0500
Date: Thu, 6 Dec 2012 14:22:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf diff: Removing displacement output option
Message-ID: <20121206132228.GB1080@krava.brq.redhat.com>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
 <1354690603-31364-3-git-send-email-namhyung@kernel.org>
 <20121205190646.GB1037@krava.brq.redhat.com>
 <20121205191209.GE6629@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205191209.GE6629@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:12:09PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 05, 2012 at 08:06:46PM +0100, Jiri Olsa escreveu:
> > On Wed, Dec 05, 2012 at 03:56:42PM +0900, Namhyung Kim wrote:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > @@ -481,6 +459,11 @@ static void hists__process(struct hists *old, struct hists *new)
> > >  	else
> > >  		hists__link(new, old);
> > >  
> > > +	hists__output_resort(new);
> > > +
> > > +	if (show_displacement)
> > > +		hists__compute_position(new);
> > > +
> > 
> > Computing the position after hists__link screws up the position data,
> > because we likely have new entries in.
> > 
> > However, I wonder if anyone is actualy using displacement info..?
> 
> IIRC that was used long ago in the first version of 'perf diff', that
> is not the default, probably we can just ditch it to simplify things,
> can you check?

you're right, it's there since vert beggining.. and now it's gone ;) attached

jirka


---
Removing displacement output option. It seems not very useful,
because it's possible and event more convenient to lookup related
symbol by name. Also the output value for both 'baseline' and
'new' data is quite apparent from diff output.

And above all it complicates hist code factoring ;)

Ditching out PERF_HPP__DISPL column with related output functions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/Documentation/perf-diff.txt |  4 ----
 tools/perf/builtin-diff.c              | 29 +++++++----------------------
 tools/perf/ui/hist.c                   | 25 -------------------------
 tools/perf/util/hist.h                 |  1 -
 4 files changed, 7 insertions(+), 52 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 194f37d..5b3123d 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -22,10 +22,6 @@ specified perf.data files.
 
 OPTIONS
 -------
--M::
---displacement::
-        Show position displacement relative to baseline.
-
 -D::
 --dump-raw-trace::
         Dump raw trace in ASCII.
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d869029..b2e7d39 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -23,7 +23,6 @@ static char const *input_old = "perf.data.old",
 		  *input_new = "perf.data";
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
-static bool show_displacement;
 static bool show_period;
 static bool show_formula;
 static bool show_baseline_only;
@@ -296,9 +295,8 @@ static void insert_hist_entry_by_name(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-static void hists__name_resort(struct hists *self, bool sort)
+static void hists__name_resort(struct hists *self)
 {
-	unsigned long position = 1;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *next = rb_first(&self->entries);
 
@@ -306,16 +304,12 @@ static void hists__name_resort(struct hists *self, bool sort)
 		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
 
 		next = rb_next(&n->rb_node);
-		n->position = position++;
 
-		if (sort) {
-			rb_erase(&n->rb_node, &self->entries);
-			insert_hist_entry_by_name(&tmp, n);
-		}
+		rb_erase(&n->rb_node, &self->entries);
+		insert_hist_entry_by_name(&tmp, n);
 	}
 
-	if (sort)
-		self->entries = tmp;
+	self->entries = tmp;
 }
 
 static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
@@ -339,12 +333,8 @@ static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
 
 		hists__output_resort(hists);
 
-		/*
-		 * The hists__name_resort only sets possition
-		 * if name is false.
-		 */
-		if (name || ((!name) && show_displacement))
-			hists__name_resort(hists, name);
+		if (name)
+			hists__name_resort(hists);
 	}
 }
 
@@ -549,8 +539,6 @@ static const char * const diff_usage[] = {
 static const struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('M', "displacement", &show_displacement,
-		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
 	OPT_CALLBACK('c', "compute", &compute,
@@ -585,7 +573,7 @@ static const struct option options[] = {
 static void ui_init(void)
 {
 	/*
-	 * Display baseline/delta/ratio/displacement/
+	 * Display baseline/delta/ratio
 	 * formula/periods columns.
 	 */
 	perf_hpp__column_enable(PERF_HPP__BASELINE);
@@ -604,9 +592,6 @@ static void ui_init(void)
 		BUG_ON(1);
 	};
 
-	if (show_displacement)
-		perf_hpp__column_enable(PERF_HPP__DISPL);
-
 	if (show_formula)
 		perf_hpp__column_enable(PERF_HPP__FORMULA);
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 1785bab..1889c12 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -351,30 +351,6 @@ static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_displ(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "Displ.");
-}
-
-static int hpp__width_displ(struct perf_hpp *hpp __maybe_unused)
-{
-	return 6;
-}
-
-static int hpp__entry_displ(struct perf_hpp *hpp,
-			    struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	long displacement = pair ? pair->position - he->position : 0;
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
-	char buf[32] = " ";
-
-	if (displacement)
-		scnprintf(buf, sizeof(buf), "%+4ld", displacement);
-
-	return scnprintf(hpp->buf, hpp->size, fmt, buf);
-}
-
 static int hpp__header_formula(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
@@ -427,7 +403,6 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	HPP__PRINT_FNS(delta),
 	HPP__PRINT_FNS(ratio),
 	HPP__PRINT_FNS(wdiff),
-	HPP__PRINT_FNS(displ),
 	HPP__PRINT_FNS(formula)
 };
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c1b2fad..5b3b007 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -154,7 +154,6 @@ enum {
 	PERF_HPP__DELTA,
 	PERF_HPP__RATIO,
 	PERF_HPP__WEIGHTED_DIFF,
-	PERF_HPP__DISPL,
 	PERF_HPP__FORMULA,
 
 	PERF_HPP__MAX_INDEX
-- 
1.7.11.7

