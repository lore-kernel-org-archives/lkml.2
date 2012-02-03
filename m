Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2BCHw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:52:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab2BCHw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:52:56 -0500
Date: Fri, 3 Feb 2012 08:52:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] sched: reduce /proc/schedstat access times
Message-ID: <20120203075250.GD30543@elte.hu>
References: <1328216139.2480.24.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328216139.2480.24.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On a 16 cpus NUMA machine, we can have quite a long /proc/schedstat
> 
> # wc -c /proc/schedstat 
> 8355 /proc/schedstat

Btw., the long-term goal would be to make the schedstats info 
fully available via perf and integrate it into 'perf sched' - or 
'perf stat --sched' or 'perf schedstat' (whichever variant suits 
the person who first implements it).

> @@ -47,9 +43,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  		for_each_domain(cpu, sd) {
>  			enum cpu_idle_type itype;
>  
> -			cpumask_scnprintf(mask_str, mask_len,
> -					  sched_domain_span(sd));
> -			seq_printf(seq, "domain%d %s", dcount++, mask_str);
> +			seq_printf(seq, "domain%d ", dcount++);
> +			seq_bitmap(seq, cpumask_bits(sched_domain_span(sd)),
> +				   nr_cpumask_bits);
>  			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
>  					itype++) {
>  				seq_printf(seq, " %u %u %u %u %u %u %u %u",

that way, via perf, all information gets passed in a binary 
fashion through the perf ring-buffer, so there's no formatting 
overhead (only during post-processing), no restart artifacts due 
to seqfile limitations, etc.

Thanks,

	Ingo
