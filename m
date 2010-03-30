Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0C3TSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:18:21 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:50381 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0C3TSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FRlhDTMymhAo6aph09Po8H1wo3xxbigENh54wQxbfHuk/z55mjGupYhbdv17MIHfBh
         cumwtV2nWRwWcYvj/A+jK1Olrf+7AjZHjP9YcEM/AfGEbDSrkYmvtOmdqKFlxGSjnA4t
         BPUvL3cqro3Se0L7DicFAnxXGAC+KNeFiLivQ=
Date: Tue, 30 Mar 2010 23:18:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100330191813.GF5211@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com> <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com> <20100330134145.GI11907@erda.amd.com> <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com> <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com> <1269968113.5258.442.camel@laptop> <20100330182906.GD5211@lenovo> <1269975840.5258.609.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269975840.5258.609.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:04:00PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 22:29 +0400, Cyrill Gorcunov wrote:
> > On Tue, Mar 30, 2010 at 06:55:13PM +0200, Peter Zijlstra wrote:
> > [...]
> > > -static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
> > > +static int p4_hw_config(struct perf_event *event)
> > >  {
> > >  	int cpu = raw_smp_processor_id();
> > >  	u32 escr, cccr;
> > > @@ -444,11 +431,29 @@ static int p4_hw_config(struct perf_even
> > >  	 */
> > >  
> > >  	cccr = p4_default_cccr_conf(cpu);
> > > -	escr = p4_default_escr_conf(cpu, attr->exclude_kernel, attr->exclude_user);
> > > -	hwc->config = p4_config_pack_escr(escr) | p4_config_pack_cccr(cccr);
> > > +	escr = p4_default_escr_conf(cpu, event->attr.exclude_kernel,
> > > +					 event->attr.exclude_user);
> > > +	event->hw.config = p4_config_pack_escr(escr) |
> > > +			   p4_config_pack_cccr(cccr);
> > >  
> > >  	if (p4_ht_active() && p4_ht_thread(cpu))
> > > -		hwc->config = p4_set_ht_bit(hwc->config);
> > > +		event->hw.config = p4_set_ht_bit(event->hw.config);
> > > +
> > > +	if (event->attr.type != PERF_TYPE_RAW)
> > > +		return 0;
> > > +
> > > +	/*
> > > +	 * We don't control raw events so it's up to the caller
> > > +	 * to pass sane values (and we don't count the thread number
> > > +	 * on HT machine but allow HT-compatible specifics to be
> > > +	 * passed on)
> > > +	 *
> > > +	 * XXX: HT wide things should check perf_paranoid_cpu() &&
> > > +	 *      CAP_SYS_ADMIN
> > > +	 */
> > > +	event->hw.config |= event->attr.config &
> > > +		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
> > > +		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
> > >  
> > >  	return 0;
> > >  }
> > [...]
> > 
> > P4 events thread specific is a bit more messy in compare with
> > architectural events. There are thread specific (TS) and thread
> > independent (TI) events. The exact effect of mixing flags from
> > what we call "ANY" bit is described in two matrix in SDM.
> > 
> > So to make code simplier I chose to just bind events to a
> > particular logical cpu, when event migrate to say a second cpu
> > the bits just flipped in accordance on which cpu the event is
> > going to run. Pretty simple. Even more -- if there was some
> > RAW event which have set "ANY" bit -- they all will be just stripped
> > and event get bound to a single cpu.
> > 
> > I'll try to find out an easy way to satisfy this "ANY" bit request
> > though it would require some time (perhaps today later or rather
> > tomorrow).
> 
> Right, so don't worry about actively supporting ANY on regular events,
> wider than logical cpu counting is a daft thing.
> 
> What would be nice to detect is if the raw event provided would be a TI
> (ANY) event, in which case we should apply the extra paranoia.
> 

Well, there is a side effect would be anyway, so I think it should be
fixed via the way like: if a caller wanna get ANY event and this caller
has enough rights for that -- go ahead you'll get what you want,
kernel is not going to do a dirty work for you :) so I would need only
fix two procedures -- event assignment (where permission will be checked
as well) and event migration where I will not do any additional work for
the caller.

At least if I not miss anything it should not be quite difficult and
invasive. Will check and send patch... later a bit. At moment we're
on a safe side anyway, ie the former patch is fine for me!

	-- Cyrill
