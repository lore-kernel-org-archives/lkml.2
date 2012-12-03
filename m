Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2LCK0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:26:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab2LCK0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:26:23 -0500
Date: Mon, 3 Dec 2012 11:19:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/18] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121203101952.GA1131@krava.redhat.com>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-9-git-send-email-namhyung@kernel.org>
 <20121129185257.GC1957@ghostprotocols.net>
 <87pq2ryksr.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq2ryksr.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:41:08AM +0900, Namhyung Kim wrote:
> On Thu, 29 Nov 2012 15:52:57 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Nov 29, 2012 at 03:38:35PM +0900, Namhyung Kim escreveu:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >> 
> >> When comparing entries for collapsing put the given entry first, and
> >> then the iterated entry.  This is for the sake of consistency and will
> >
> > consistency with what? and, see below:
> >
> >> be required by the event group report.
> >> 
> >> Cc: Jiri Olsa <jolsa@redhat.com>
> >> Cc: Stephane Eranian <eranian@google.com>
> >> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >> ---
> >>  tools/perf/util/hist.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> >> index 82df1b26f0d4..161c35e7ed0e 100644
> >> --- a/tools/perf/util/hist.c
> >> +++ b/tools/perf/util/hist.c
> >> @@ -433,7 +433,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
> >>  		parent = *p;
> >>  		iter = rb_entry(parent, struct hist_entry, rb_node_in);
> >>  
> >> -		cmp = hist_entry__collapse(iter, he);
> >> +		cmp = hist_entry__collapse(he, iter);
> >>  
> >>  		if (!cmp) {
> >>  			he_stat__add_stat(&iter->stat, &he->stat);
> >
> > doesn't this now gets inconsistent with the hist_entry__collapse() call?
> > I.e. iter first, he after, also there is the case for callchains, below,
> > care to elaborate here?
> 
> I meant it by consistent with hist_entry__cmp() and didn't consider
> he_stat__add_stat and callchain_merge things - thought that they're
> other kind of operation.
> 
> I needed this change because I introduced hists__{match,link}_collapsed
> function in the patch 8 and I found that hist_entry__cmp and
> hist_entry__collapse received same kind of arguments in different
> order.  Sorry about missing this in the changelog.
> 
> However on the second thought, I feel like I don't need those _collapsed
> functions at all and perf diff can be converted to use collapsed rb tree
> directly instead.  IIUC perf diff use those functions to match entries
> by sort keys and do additional resort output rb tree by sort keys (IMHO
> the function names - _name_resort and _insert_by_name - are misnomers)
> to do the match.
> 
> Since output resorting (by period) is only needed for the baseline,
> other data files doesn't need to do this additional step.  So I can get
> rid of those hists__{match,link}_collapsed functions and change plain
> hists__{match,link} functions to use collapsed (or input) rb tree
> directly.
>
> Jiri, what do you think?  What am I missing? :)

feels like I'm missing something now :))

right now I don't see a point in having sort__need_collapse enabled
for group report.. there seems to be no special processing as it was
in the initial patchset..?

It seems like you could do only stadard period resort (collapsed if
needed) and afterwards run current hists__match and hists_link function
they are now.

All you need at the output callback is paired leader hist entry.. where
you do the temp array magic to get the data.

/me going to dishonour some whiteboard.. ;)

jirka
