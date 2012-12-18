Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2LRPrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:47:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab2LRPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:47:23 -0500
Date: Tue, 18 Dec 2012 16:47:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/14] perf ui/hist: Add support for event group view
Message-ID: <20121218154710.GN1283@krava.brq.redhat.com>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355726345-29553-8-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 03:38:58PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Show group members' overhead also when showing the leader's if event
> group is enabled.  Use macro for defining hpp functions which looks
> almost identical.

SNIP

> -
> -static int hpp__color_overhead_us(struct perf_hpp_fmt *fmt __maybe_unused,
> -				  struct perf_hpp *hpp, struct hist_entry *he)
> +static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
> +			      u64 (*get_field)(struct hist_entry *),
> +			      const char *fmt, hpp_snprint_fn print_fn)

it's hard to tell from diff, but the function looks like this (group part):

        if (symbol_conf.event_group) {
                int prev_idx, idx_delta, i;
                struct perf_evsel *evsel = hists_to_evsel(hists);
                struct hist_entry *pair;
                int nr_members = evsel->nr_members;

                if (nr_members <= 1)
                        return ret;

                prev_idx = perf_evsel__group_idx(evsel);

                list_for_each_entry(pair, &he->pairs.head, pairs.node) {
                        u64 period = get_field(pair);
                        u64 total = pair->hists->stats.total_period;

                        if (!total)
                                continue;

                        evsel = hists_to_evsel(pair->hists);
                        idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;

                        for (i = 0; i < idx_delta; i++) {
                                ret += print_fn(hpp->buf + ret, hpp->size - ret,
                                                fmt, 0.0);
                        }

                        ret += print_fn(hpp->buf + ret, hpp->size - ret,
                                        fmt, 100.0 * period / total);

                        prev_idx += 1 + idx_delta;
                }

                idx_delta = nr_members - prev_idx - 1;

                for (i = 0; i < idx_delta; i++) {
                        ret += print_fn(hpp->buf + ret, hpp->size - ret,
                                        fmt, 0.0);
                }
        }

The temporary array (initial send) was more clear to me.. but if
this is the preffered way I wont object, since this is another place
that would benefit from hist_entries array linking.. when (and if)
there's ever patch for that ;-)

I think this code now suffers from mischosen data layer

jirka
