Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1GALQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:16:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1GALQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:16:53 -0400
Date: Fri, 1 Jul 2011 13:16:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf report/annotate: Add option to specify a CPU range
Message-ID: <20110701111641.GE20990@elte.hu>
References: <20110629150739.49b25604@kryten>
 <4E0B69EC.70009@gmail.com>
 <20110630131639.253c6529@kryten>
 <4E0BF3D0.4010405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0BF3D0.4010405@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> > @@ -262,6 +271,41 @@ static int __cmd_report(void)
> >  	if (session == NULL)
> >  		return -ENOMEM;
> >  
> > +	if (cpu_list) {
> > +		int i;
> > +		struct cpu_map *map;
> > +
> > +		for (i = 0; i < PERF_TYPE_MAX; ++i) {
> > +			struct perf_evsel *evsel;
> > +
> > +			evsel = perf_session__find_first_evtype(session, i);
> > +			if (!evsel)
> > +				continue;
> > +
> > +			if (!(evsel->attr.sample_type & PERF_SAMPLE_CPU)) {
> > +				pr_err("File does not contain CPU events. "
> > +				       "Remove -c option to proceed.\n");
> > +				ret = -1;
> > +				goto out_delete;
> > +			}
> > +		}
> > +
> > +		map = cpu_map__new(cpu_list);
> > +
> > +		for (i = 0; i < map->nr; i++) {
> > +			int cpu = map->map[i];
> > +
> > +			if (cpu >= MAX_NR_CPUS) {
> > +				pr_err("Requested CPU %d too large. "
> > +				       "Consider raising MAX_NR_CPUS\n", cpu);
> > +				ret = -1;
> > +				goto out_delete;
> > +			}
> > +
> > +			set_bit(cpu, cpu_bitmap);
> > +		}
> > +	}
> > +
> 
> It would be better to make this a function that all 3 commands 
> reference -- something like perf_session__cpu_bitmap(session, 
> cpu_list, cpu_bitmap) in util/session.c

Agreed. I can see how it ended up looking like this (fixing only perf 
report, then adding it to top, then to script), but at this stage it 
really calls for one helper that all three commands can utilize.

Very nice enhancement otherwise - might i suggest a 'perf top' hotkey 
as well to limit the output to certain CPUs only? :-)

Thanks,

	Ingo
