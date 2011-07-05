Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1GEKUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:20:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab1GEKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:20:32 -0400
Date: Tue, 5 Jul 2011 12:20:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705102017.GA12458@elte.hu>
References: <20110705100320.GK17941@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705100320.GK17941@sun>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.2
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.2 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> +static void p4_hw_watchdog_set_attr(struct perf_event_attr *wd_attr)
> +{
> +	/*
> +	 * Watchdog ticks are special on Netburst, we use
> +	 * that named "non-sleeping" ticks as recommended
> +	 * by Intel SDM Vol3b.
> +	 */
> +	WARN_ON_ONCE(wd_attr->type	!= PERF_TYPE_HARDWARE ||
> +		     wd_attr->config	!= PERF_COUNT_HW_CPU_CYCLES);
> +
> +	wd_attr->type	= PERF_TYPE_RAW;
> +	wd_attr->config	=
> +		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
> +		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
> +			P4_CCCR_COMPARE);
> +}

So why don't we simply set this for all PERF_COUNT_HW_CPU_CYCLES 
events in the P4 PMU driver? That would remove half of the patch 
AFAICS.

Thanks,

	Ingo
