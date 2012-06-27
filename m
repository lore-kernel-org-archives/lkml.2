Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2F0FUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:20:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37821 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2F0FUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:20:08 -0400
Date: Wed, 27 Jun 2012 07:20:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Message-ID: <20120627052002.GA32654@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
 <1340280437-7718-2-git-send-email-bp@amd64.org>
 <1340380019.18025.82.camel@twins>
 <20120626194043.GB28495@aftab.osrc.amd.com>
 <1340747178.21991.105.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340747178.21991.105.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:46:18PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-26 at 21:40 +0200, Borislav Petkov wrote:
> >  
> > > +void perf_check_microcode(void)
> > > +{
> > > +	if (x86_pmu.check_microcode)
> > > +		x86_pmu.check_microcode();
> > > +}
> > > +EXPORT_SYMBOL_GPL(perf_check_microcode);
> > 
> > Maybe we should call the after-ucode-has-been-updated callback something
> > like arch_verify_microcode_revision or something similar and move it to
> > generic x86 code so that other stuff can use it too, in the future...
> > 
> > Although I'm not aware of any other users right about now.
> 
> Like that notifier list I had earlier? Yeah we can do that if more users
> show up.

Yeah, ok.

> > > @@ -373,7 +375,7 @@ struct x86_pmu {
> > >  	 * Intel DebugStore bits
> > >  	 */
> > >  	int		bts, pebs;
> > > -	int		bts_active, pebs_active;
> > > +	int		bts_active, pebs_active, pebs_broken;
> > 
> > I know you don't like bool's here but maybe make it a bitfield like the
> > one in perf_event_attr?
> 
> I added another patch doing just that:
> 
> ---
> Subject: perf, x86: Save a few bytes in struct x86_pmu
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jun 26 23:38:39 CEST 2012
> 
> All these are basically boolean flags, use a bitfield to save a few
> bytes.
> 
> Suggested-by: Borislav Petkov <bp@amd64.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event.h |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -374,8 +374,11 @@ struct x86_pmu {
>  	/*
>  	 * Intel DebugStore bits
>  	 */
> -	int		bts, pebs;
> -	int		bts_active, pebs_active, pebs_broken;
> +	int		bts		:1,
> +			bts_active	:1,
> +			pebs		:1,
> +			pebs_active	:1,
> +			pebs_broken	:1;
>  	int		pebs_record_size;
>  	void		(*drain_pebs)(struct pt_regs *regs);
>  	struct event_constraint *pebs_constraints;
> ---

Yep.

> 
> 
> > >  	int		pebs_record_size;
> > >  	void		(*drain_pebs)(struct pt_regs *regs);
> > >  	struct event_constraint *pebs_constraints;
> > > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > > @@ -1714,11 +1714,54 @@ static __init void intel_clovertown_quir
> > >  	x86_pmu.pebs_constraints = NULL;
> > >  }
> > >  
> > > +static int intel_snb_pebs_broken(int cpu)
> > > +{
> > > +	u32 rev = UINT_MAX; /* default to broken for unknown models */
> > > +
> > > +	switch (cpu_data(cpu).x86_model) {
> > 
> > cpu_data(cpu) does a per_cpu access three times in this function, maybe
> > declare a local ptr which saves us the next two derefs... (if the
> > compiler is not optimizing those, anyway, that is).
> 
> I was hoping for CSE optimization to do that for me.. its not really a
> performance critical path anyway. I could change it if people think it
> reads better with regular: struct cpuinfo_x86 *c = &cpu_data(cpu);

Right, we maybe will do this a couple of times tops during system
lifetime, ok.

> > > +	get_online_cpus();
> > > +	for_each_online_cpu(cpu)
> > > +		pebs_broken |= intel_snb_pebs_broken(cpu);
> > 
> > if pebs_broken gets set here not on the last cpu, you could break out of
> > the loop early instead of iterating to the last cpu.
> 
> Right you are.. 
> 
> 
> ---
> Subject: perf, x86: Add a microcode revision check for SNB-PEBS
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Jun 08 14:50:50 CEST 2012
> 
> Recent Intel microcode resolved the SNB-PEBS issues, so conditionally
> enable PEBS on SNB hardware depending on the microcode revision.
> 
> Thanks to Stephane for figuring out the various microcode revisions.
> 
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Right, looks ok to me.

If it is of any use:

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
