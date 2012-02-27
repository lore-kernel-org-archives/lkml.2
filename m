Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2B0QGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:06:47 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:42225 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753222Ab2B0QGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:06:46 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz936eK1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPV:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 27 Feb 2012 11:06:32 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [PATCH] perf_event use rdpmc rather than rdmsr when possible in
 kernel
In-Reply-To: <1330342762.11248.69.camel@twins>
Message-ID: <alpine.DEB.2.00.1202271051330.1902@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1202201722120.2753@cl320.eecs.utk.edu> <1330342762.11248.69.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, Peter Zijlstra wrote:

> On Mon, 2012-02-20 at 17:38 -0500, Vince Weaver wrote:
> 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 5adce10..5550047 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -85,7 +85,7 @@ u64 x86_perf_event_update(struct perf_event *event)
> >  	 */
> >  again:
> >  	prev_raw_count = local64_read(&hwc->prev_count);
> > -	rdmsrl(hwc->event_base, new_raw_count);
> > +	new_raw_count=native_read_pmc(hwc->event_base_rdpmc);
> 
> That really wants to be rdpmc(), bypassing paravirt like that isn't
> nice.

I couldn't find another usable rdpmc() call in the kernel.  Should I add 
one?  I admit I hadn't thought that this might break VMs not expecting
rdpmc calls from the kernel.

> > index abb2776..432ac69 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -562,6 +562,7 @@ struct hw_perf_event {
> >  			u64		last_tag;
> >  			unsigned long	config_base;
> >  			unsigned long	event_base;
> > +			unsigned long	event_base_rdpmc;
> 
> We could make that unsigned int, the SDM explicitly states
> rdmsr/wrmsr/rdpmc take ECX (and ignore the upper 32bits RCX).

OK.
 
> >  			int		idx;
> >  			int		last_cpu;
> >  			struct hw_perf_event_extra extra_reg;
> 
> But yeah, avoiding the extra variable will add a conditional and extra
> instructions to the rdpmc path.

yes, I couldn't think of a good way to get rid of the extra field
without adding extra conditional branches in key code paths.

Mostly that's the fault of the Intel fixed counters, otherwise you could 
possibly fix things by cleverly adding or subtracting off the msr_base
to get the counter number.

Vince

