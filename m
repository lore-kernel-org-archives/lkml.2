Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1HDP4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:56:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:54982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1HDP4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:56:12 -0400
Subject: Re: [perf] enable raw OFFCORE_EVENTS for non-perf userspace
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Aug 2011 17:55:30 +0200
Message-ID: <1312473330.16729.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 12:05 -0400, Vince Weaver wrote:
> Hello
> 
> I propose we just enable raw OFFCORE_EVENT support and get it over with.
> 
> There is a lot of demand for this from PAPI users, and so we encourage 
> them to apply the below patch.  PAPI supports this out of the box.
> 
> The current "block" against using this feature *DOES NOT WORK*.
> It silently fails if you try to use the config1 field to set it.
> 
> Even worse, if some previous user has set the OFFCORE_RSP_0 msr
> (say by running "perf stat -e LLC-load-misses") then
> the msr *stays set* and if you try to set the config1 field on your own
> it looks like it worked, but instead it is using whatever value the
> kernel last used.
> 
> So there's a lot of userspace confusion about this, and you can't even 
> reliably tell if the feature is turned off or not because it fails 
> silently in unpredictable ways.


> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 4ee3abf..28f9ca9 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -604,12 +604,8 @@ static int x86_setup_perfctr(struct perf_event *event)
>  			return -EOPNOTSUPP;
>  	}
>  
> -	/*
> -	 * Do not allow config1 (extended registers) to propagate,
> -	 * there's no sane user-space generalization yet:
> -	 */
>  	if (attr->type == PERF_TYPE_RAW)
> -		return 0;
> +		return x86_pmu_extra_regs(event->attr.config, event);
>  
>  	if (attr->type == PERF_TYPE_HW_CACHE)
>  		return set_ext_hw_attr(hwc, event);


I'm inclined to merge this, aside from snb, the offcore stuff is
actually quite usable now. Ingo can we somehow persuade you?

Anybody who knows how to program the snb offcore please tell. I mean we
have all the code to poke at the right registers, and the SDM lists all
the various bits that go where and a few constraints on how to combine
said bits, but I've really no idea what any of it means.


