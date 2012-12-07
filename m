Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2LGIi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:38:26 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51793 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2LGIiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:38:25 -0500
X-AuditID: 9c930179-b7b25ae0000031c2-8d-50c1aafeb625
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/5] perf hists: Exchange order of comparing items when collapsing hists
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
	<1354806581-5316-3-git-send-email-namhyung@kernel.org>
	<20121206165325.GE1080@krava.brq.redhat.com>
	<20121206190920.GA1899@ghostprotocols.net>
Date: Fri, 07 Dec 2012 17:38:22 +0900
In-Reply-To: <20121206190920.GA1899@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 6 Dec 2012 16:09:20 -0300")
Message-ID: <874njydzpd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 6 Dec 2012 16:09:20 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 06, 2012 at 05:53:25PM +0100, Jiri Olsa escreveu:
>> On Fri, Dec 07, 2012 at 12:09:38AM +0900, Namhyung Kim wrote:
>> > From: Namhyung Kim <namhyung.kim@lge.com>
>> > 
>> > When comparing entries for collapsing put the given entry first, and
>> > then the iterated entry.  This is not the case of hist_entry__cmp()
>> > when called if given sort keys don't require collapsing.  So change
>> > the order for the sake of consistency.  It will be required for
>> > matching and/or linking multiple hist entries.
>> 
>> As discussed with Arnadlo, this change seems like changing the
>> sort order... could you ellaborate how it is usefull in future?
>
> In several places the order is (he, iter) then it became (iter, he),
> something like that, so he inverted it for consistency, but then he
> needs to invert in the cmp function too, unsure if this is worth the
> trouble now, perhaps some comment placed in the right spot clarifies
> things,

The point is that it needs to have a same order when comparing two
entries for both of inserting (add_hist_entry) and linking (hists__add_
dummy_entry and hists__find_entry).  This was simple when we used output
tree, because it's a single tree so that we can make sure that it use
the same order as of insertion.  But by using internal trees we should
select one between inserting (entries_in) and collapsing
(entries_collapsed) based on the sort keys given.

Unfortunately, inserting and collapsing used different order - (he, iter)
vs. (iter, he) - so we need to use corresponding (different) order for
match/link also.  That means that without this patch, we have to call
corresponding function with different order like following:


@@ -739,6 +739,10 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 
                cmp = hist_entry__collapse(he, pair);
 
+               if (sort__need_collapse)
+                       cmp = hist_entry__collapse(he, pair);
+               else
+                       cmp = hist_entry__cmp(pair, he);
                if (!cmp)
                        goto out;
 
@@ -772,7 +776,12 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 
        while (n) {
                struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node_in);
-               int64_t cmp = hist_entry__collapse(iter, he);
+               int64_t cmp;
+
+               if (sort__need_collapse)
+                       cmp = hist_entry__collapse(iter, he);
+               else
+                       cmp = hist_entry__cmp(he, iter);
 
                if (cmp < 0)
                        n = n->rb_left;

It doesn't look good, especially hist_entry__collapse will be same as
hist_entry__cmp if 'sort__need_collapse' is false.  If we can make the
order consistent, it'd be converted to a sigle _collapse() call
without the conditional.

Thanks,
Namhyung
