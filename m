Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2K3QKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:10:00 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47390 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2K3QJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:09:57 -0500
Date: Fri, 30 Nov 2012 10:52:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/18] perf ui/hist: Add support for event group view
Message-ID: <20121130135215.GG1957@ghostprotocols.net>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-14-git-send-email-namhyung@kernel.org>
 <20121130132943.GC1080@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130132943.GC1080@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 30, 2012 at 02:29:43PM +0100, Jiri Olsa escreveu:
> On Thu, Nov 29, 2012 at 03:38:40PM +0900, Namhyung Kim wrote:
> > +#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
> > +static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
> > +{										\
> > +	int ret;								\
> > +	double percent = 0.0;							\
> > +	struct hists *hists = he->hists;					\
> > +										\
> > +	if (hists->stats.total_period)						\
> > +		percent = 100.0 * he->stat._field / hists->stats.total_period; 	\
> > +										\
> > +	ret = percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);	\
> > +										\
> > +	if (symbol_conf.event_group) {						\
> > +		int i;								\
> > +		struct perf_evsel *evsel = hists_to_evsel(hists);		\
> > +		struct hist_entry *pair;					\
> > +		int nr_members = evsel->nr_members;				\
> > +		double *percents;						\
> > +										\
> > +		if (nr_members <= 1)						\
> > +			return ret;						\
> > +										\
> > +		percents = zalloc(sizeof(*percents) * nr_members);		\
> > +		if (percents == NULL) {						\
> > +			pr_warning("Not enough memory!\n");			\
> > +			return ret;						\
> > +		}								\

Why do we need to zalloc this percents array?

> > +		list_for_each_entry(pair, &he->pairs.head, pairs.node) { 	\
> > +			u64 period = pair->stat._field;				\
> > +			u64 total = pair->hists->stats.total_period;		\
> > +										\
> > +			if (!total)						\
> > +				continue;					\
> > +										\
> > +			evsel = hists_to_evsel(pair->hists);			\
> > +			i = perf_evsel__group_idx(evsel);			\
> > +			percents[i] = 100.0 * period / total;			\

Why not use percent_color_snprintf here, using some "%*s" thing that
uses i to position the output in the right column? This way the
following loop can be ditched as well. No?

> > +		}								\
> > +										\
> > +		for (i = 1; i < nr_members; i++) {				\
> > +			ret += percent_color_snprintf(hpp->buf + ret,		\
> > +						      hpp->size - ret,		\
> > +						      " %6.2f%%", percents[i]);	\
> > +		}								\
> > +		free(percents);							\
> > +	}									\
> > +	return ret;								\

- Arnaldo
