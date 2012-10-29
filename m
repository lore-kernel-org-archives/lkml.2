Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab2J2Piv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:38:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:42695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2J2Piu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:38:50 -0400
Message-ID: <1351525112.24721.36.camel@twins>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Date: Mon, 29 Oct 2012 16:38:32 +0100
In-Reply-To: <1351523752-4215-5-git-send-email-eranian@google.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	 <1351523752-4215-5-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
> +       fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
> +
>         perf_sample_data_init(&data, 0, event->hw.last_period);
>  
> +       data.period = event->hw.last_period;
> +       sample_type = event->attr.sample_type;
> +
> +       /*
> +        * if PEBS-LL or PreciseStore
> +        */
> +       if (fll) {
> +               if (sample_type & PERF_SAMPLE_ADDR)
> +                       data.addr = pebs->dla;
> +
> +               /*
> +                * Use latency for cost (only avail with PEBS-LL)
> +                */
> +               if (fll && (sample_type & PERF_SAMPLE_COST))
> +                       data.cost = pebs->lat;
> +
> +               /*
> +                * data.dsrc encodes the data source
> +                */
> +               if (sample_type & PERF_SAMPLE_DSRC) {
> +                       if (fll)
> +                               data.dsrc.val = load_latency_data(pebs->dse);
> +               }
> +       } 


Why does fl1 exist? the above looks really convoluted, all fl1 checks
inside are pointless. Also 'fl1' is a bizarre name, 'pebs_ll' would be a
better name I guess.

What's wrong with:

	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT) {
		if (sample_type & PERF_SAMPLE_ADDR)
			data.addr = pebs->dla;

		if (sample_type & PERF_SAMPLE_COST)
			data.cost = perf->lat;

		if (sample_type & PERF_SAMPLE_DSRC)
			data.dsrc.val = load_latency_data(pebs->dse);
	}


