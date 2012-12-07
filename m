Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2LGKTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:19:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab2LGKTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:19:05 -0500
Date: Fri, 7 Dec 2012 11:18:53 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/5] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121207101853.GA1015@krava.brq.redhat.com>
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
 <1354806581-5316-3-git-send-email-namhyung@kernel.org>
 <20121206165325.GE1080@krava.brq.redhat.com>
 <20121206190920.GA1899@ghostprotocols.net>
 <874njydzpd.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874njydzpd.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:38:22PM +0900, Namhyung Kim wrote:
> Hi Arnaldo,
> 

SNIP

> @@ -739,6 +739,10 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
>  
>                 cmp = hist_entry__collapse(he, pair);
>  
> +               if (sort__need_collapse)
> +                       cmp = hist_entry__collapse(he, pair);
> +               else
> +                       cmp = hist_entry__cmp(pair, he);
>                 if (!cmp)
>                         goto out;
>  
> @@ -772,7 +776,12 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
>  
>         while (n) {
>                 struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node_in);
> -               int64_t cmp = hist_entry__collapse(iter, he);
> +               int64_t cmp;
> +
> +               if (sort__need_collapse)
> +                       cmp = hist_entry__collapse(iter, he);
> +               else
> +                       cmp = hist_entry__cmp(he, iter);
>  
>                 if (cmp < 0)
>                         n = n->rb_left;
> 
> It doesn't look good, especially hist_entry__collapse will be same as
> hist_entry__cmp if 'sort__need_collapse' is false.  If we can make the
> order consistent, it'd be converted to a sigle _collapse() call
> without the conditional.
> 
> Thanks,
> Namhyung

I've got non matching entries in diff after applying just patch 2/5,
and it's caused by missing he/iter swap in initial name resort in
insert_hist_entry_by_name function.

I understand that function goes away in your next patch while
add_hist_entry (swap ok) being the one doing initial name resort,
but still.. took me some time to figure this out ;)

jirka

---
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b2e7d39..4dda6f4 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -285,7 +285,7 @@ static void insert_hist_entry_by_name(struct rb_root *root,
 	while (*p != NULL) {
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp(he, iter) < 0)
+		if (hist_entry__cmp(iter, he) < 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
