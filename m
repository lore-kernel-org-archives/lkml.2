Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0C3RLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:11:10 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52599 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0C3RLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZtoOB7KnNQ0Y4lYvI9gRB6q7kfSLkPO5KTNG9/vhgQ1eBACyGJzUyXVr9oF4yVjisa
         ZgR7DfygtL3kBl0uRpSPPpI3PR7JJu58WSgKNDVfuR+AsAm849Lt2l1+iinMw54Llrvd
         g3IcmLW/vazjnQyv1QG+eyXKe+mgXaHGfWexA=
Date: Tue, 30 Mar 2010 21:11:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100330171100.GC5211@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com> <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com> <20100330134145.GI11907@erda.amd.com> <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com> <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com> <1269968113.5258.442.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269968113.5258.442.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 06:55:13PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 17:59 +0200, Robert Richter wrote:
> > > +     if (attr->type == PERF_TYPE_RAW)
> > > +             return x86_pmu.raw_event(event);
> > 
> > We could go on with this and move this into *_hw_config(), but so far
> > this change is fine to me. This would then remove .raw_event() at all.
> > 
> 
> Right, I did have a brief look at that, you mentioned this before to
> Cyrill IIRC, but the issue is that... ~brainwave~ how about the below..
> 

Yeah, Robert sais me about eliminating raw_event, just remember :)

[...]
> -static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
> +static int p4_hw_config(struct perf_event *event)
>  {
>  	int cpu = raw_smp_processor_id();
>  	u32 escr, cccr;
> @@ -444,11 +431,29 @@ static int p4_hw_config(struct perf_even
>  	 */
>  
>  	cccr = p4_default_cccr_conf(cpu);
> -	escr = p4_default_escr_conf(cpu, attr->exclude_kernel, attr->exclude_user);
> -	hwc->config = p4_config_pack_escr(escr) | p4_config_pack_cccr(cccr);
> +	escr = p4_default_escr_conf(cpu, event->attr.exclude_kernel,
> +					 event->attr.exclude_user);
> +	event->hw.config = p4_config_pack_escr(escr) |
> +			   p4_config_pack_cccr(cccr);
>  
>  	if (p4_ht_active() && p4_ht_thread(cpu))
> -		hwc->config = p4_set_ht_bit(hwc->config);
> +		event->hw.config = p4_set_ht_bit(event->hw.config);
> +
> +	if (event->attr.type != PERF_TYPE_RAW)
> +		return 0;
> +
> +	/*
> +	 * We don't control raw events so it's up to the caller
> +	 * to pass sane values (and we don't count the thread number
> +	 * on HT machine but allow HT-compatible specifics to be
> +	 * passed on)
> +	 *
> +	 * XXX: HT wide things should check perf_paranoid_cpu() &&
> +	 *      CAP_SYS_ADMIN
> +	 */
> +	event->hw.config |= event->attr.config &
> +		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
> +		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
>  
>  	return 0;
>  }
[...]

I'll update P4 snippet.

	-- Cyrill
