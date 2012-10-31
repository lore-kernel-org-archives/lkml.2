Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2JaFVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:21:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63255 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2JaFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:21:23 -0400
X-AuditID: 9c930179-b7c8bae000003559-d6-5090b551b7c6
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        ming.m.lin@intel.com
Subject: Re: [Patch v1 06/10] perf/x86: add support for PEBS Precise Store
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-7-git-send-email-eranian@google.com>
Date: Wed, 31 Oct 2012 14:21:21 +0900
In-Reply-To: <1351523752-4215-7-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Mon, 29 Oct 2012 16:15:48 +0100")
Message-ID: <87pq3z5i9a.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 16:15:48 +0100, Stephane Eranian wrote:
> This patch adds support for PEBS Precise Store
> which is available on Intel Sandy Bridge and
> Ivy Bridge processors.
>
> To use Precise store, the proper PEBS event
> must be used: mem_trans_retired:precise_stores.
> For the perf tool, the generic mem-stores event
> exported via sysfs can be used directly.

Just trivial nitpicks..

>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
[snip]
> @@ -486,6 +524,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
>  	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
>  	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
>  	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> +	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
>  	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
>  	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
>  	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> @@ -500,6 +539,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
>          INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
>          INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
>          INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> +	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */

White-space damaged?  Oh, it seems already broken with spaces.


>          INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
>          INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
>          INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
[snip]
> @@ -672,7 +715,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	/*
>  	 * if PEBS-LL or PreciseStore
>  	 */
> -	if (fll) {
> +	if (fll || fst) {
>  		if (sample_type & PERF_SAMPLE_ADDR)
>  			data.addr = pebs->dla;
>  
> @@ -688,6 +731,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  		if (sample_type & PERF_SAMPLE_DSRC) {
>  			if (fll)
>  				data.dsrc.val = load_latency_data(pebs->dse);
> +			else if (fst)

Looks like it can be converted to a plain 'else'.

Thanks,
Namhyung
