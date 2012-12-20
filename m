Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2LTC7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 21:59:11 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54324 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2LTC7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 21:59:02 -0500
X-AuditID: 9c930197-b7c5bae000000e31-6c-50d27ef581dd
Date: Thu, 20 Dec 2012 11:59:01 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/14] perf ui/hist: Add support for event group view
Message-ID: <20121220025901.GB3679@danjae>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-8-git-send-email-namhyung@kernel.org>
 <20121218154710.GN1283@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121218154710.GN1283@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:47:10PM +0100, Jiri Olsa wrote:
> On Mon, Dec 17, 2012 at 03:38:58PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Show group members' overhead also when showing the leader's if event
> > group is enabled.  Use macro for defining hpp functions which looks
> > almost identical.
> 
> SNIP
> 
> > -
> > -static int hpp__color_overhead_us(struct perf_hpp_fmt *fmt __maybe_unused,
> > -				  struct perf_hpp *hpp, struct hist_entry *he)
> > +static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
> > +			      u64 (*get_field)(struct hist_entry *),
> > +			      const char *fmt, hpp_snprint_fn print_fn)
> 
> it's hard to tell from diff, but the function looks like this (group part):

Exactly.

> 
>         if (symbol_conf.event_group) {
>                 int prev_idx, idx_delta, i;
>                 struct perf_evsel *evsel = hists_to_evsel(hists);
>                 struct hist_entry *pair;
>                 int nr_members = evsel->nr_members;
> 
>                 if (nr_members <= 1)
>                         return ret;
> 
>                 prev_idx = perf_evsel__group_idx(evsel);
> 
>                 list_for_each_entry(pair, &he->pairs.head, pairs.node) {
>                         u64 period = get_field(pair);
>                         u64 total = pair->hists->stats.total_period;
> 
>                         if (!total)
>                                 continue;
> 
>                         evsel = hists_to_evsel(pair->hists);
>                         idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
> 
>                         for (i = 0; i < idx_delta; i++) {
>                                 ret += print_fn(hpp->buf + ret, hpp->size - ret,
>                                                 fmt, 0.0);
>                         }
> 
>                         ret += print_fn(hpp->buf + ret, hpp->size - ret,
>                                         fmt, 100.0 * period / total);
> 
>                         prev_idx += 1 + idx_delta;
>                 }
> 
>                 idx_delta = nr_members - prev_idx - 1;
> 
>                 for (i = 0; i < idx_delta; i++) {
>                         ret += print_fn(hpp->buf + ret, hpp->size - ret,
>                                         fmt, 0.0);
>                 }
>         }
> 
> The temporary array (initial send) was more clear to me.. but if
> this is the preffered way I wont object, since this is another place
> that would benefit from hist_entries array linking.. when (and if)
> there's ever patch for that ;-)
> 
> I think this code now suffers from mischosen data layer

Yes, I admit that using array can make things simple.  But I also don't
like a temporary array due to its runtime cost.  Linking hist entries by
array can be a solution since it can be reused for output resorting and
(multiple) hpp column(s).  In addition, it might have a smaller memory
footprint than the list method for the leader-only sample feature since
it'll make every hist entries to be linked IMHO.

Thanks,
Namhyung
