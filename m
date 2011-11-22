Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab1KVQ1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:27:12 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:17175
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757910Ab1KVQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:27:10 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV2LP1-02-4T6-02
X-M-MSG: 
Date: Tue, 22 Nov 2011 17:27:00 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] perf, x86: handle overlapping counters
Message-ID: <20111122162700.GH15738@erda.amd.com>
References: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
 <1321975567.14799.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321975567.14799.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.11.11 16:26:07, Peter Zijlstra wrote:
> @@ -574,16 +574,25 @@ static bool __perf_sched_find_counter(st
>  
>  	c = sched->constraints[sched->state.event];
>  
> +	/* Prefer fixed purpose counters */
> +	if (x86_pmu.num_counters_fixed) {
> +		idx = X86_PMC_IDX_FIXED;
> +		for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
> +			if (!__test_and_set_bit(idx, sched->state.used))
> +				goto done;
> +		}
> +	}
>  	/* Grab the first unused counter starting with idx */
>  	idx = sched->state.counter;
> -	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
> +	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
>  		if (!__test_and_set_bit(idx, sched->state.used))
> -			break;
> +			goto done;
>  	}
> -	sched->state.counter = idx;
>  
> -	if (idx >= X86_PMC_IDX_MAX)
> -		return false;
> +	return false;
> +
> +done:
> +	sched->state.counter = idx;

Yes, we don't need to save this on failure. Looks ok.

-Robert

>  
>  	if (c->overlap)
>  		perf_sched_save_state(sched);
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

