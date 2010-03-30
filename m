Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0C3TEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:04:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:45951 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0C3TEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:04:05 -0400
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <20100330182906.GD5211@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
	 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
	 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
	 <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com>
	 <1269968113.5258.442.camel@laptop>  <20100330182906.GD5211@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 21:04:00 +0200
Message-ID: <1269975840.5258.609.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 22:29 +0400, Cyrill Gorcunov wrote:
> On Tue, Mar 30, 2010 at 06:55:13PM +0200, Peter Zijlstra wrote:
> [...]
> > -static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
> > +static int p4_hw_config(struct perf_event *event)
> >  {
> >  	int cpu = raw_smp_processor_id();
> >  	u32 escr, cccr;
> > @@ -444,11 +431,29 @@ static int p4_hw_config(struct perf_even
> >  	 */
> >  
> >  	cccr = p4_default_cccr_conf(cpu);
> > -	escr = p4_default_escr_conf(cpu, attr->exclude_kernel, attr->exclude_user);
> > -	hwc->config = p4_config_pack_escr(escr) | p4_config_pack_cccr(cccr);
> > +	escr = p4_default_escr_conf(cpu, event->attr.exclude_kernel,
> > +					 event->attr.exclude_user);
> > +	event->hw.config = p4_config_pack_escr(escr) |
> > +			   p4_config_pack_cccr(cccr);
> >  
> >  	if (p4_ht_active() && p4_ht_thread(cpu))
> > -		hwc->config = p4_set_ht_bit(hwc->config);
> > +		event->hw.config = p4_set_ht_bit(event->hw.config);
> > +
> > +	if (event->attr.type != PERF_TYPE_RAW)
> > +		return 0;
> > +
> > +	/*
> > +	 * We don't control raw events so it's up to the caller
> > +	 * to pass sane values (and we don't count the thread number
> > +	 * on HT machine but allow HT-compatible specifics to be
> > +	 * passed on)
> > +	 *
> > +	 * XXX: HT wide things should check perf_paranoid_cpu() &&
> > +	 *      CAP_SYS_ADMIN
> > +	 */
> > +	event->hw.config |= event->attr.config &
> > +		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
> > +		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
> >  
> >  	return 0;
> >  }
> [...]
> 
> P4 events thread specific is a bit more messy in compare with
> architectural events. There are thread specific (TS) and thread
> independent (TI) events. The exact effect of mixing flags from
> what we call "ANY" bit is described in two matrix in SDM.
> 
> So to make code simplier I chose to just bind events to a
> particular logical cpu, when event migrate to say a second cpu
> the bits just flipped in accordance on which cpu the event is
> going to run. Pretty simple. Even more -- if there was some
> RAW event which have set "ANY" bit -- they all will be just stripped
> and event get bound to a single cpu.
> 
> I'll try to find out an easy way to satisfy this "ANY" bit request
> though it would require some time (perhaps today later or rather
> tomorrow).

Right, so don't worry about actively supporting ANY on regular events,
wider than logical cpu counting is a daft thing.

What would be nice to detect is if the raw event provided would be a TI
(ANY) event, in which case we should apply the extra paranoia.

