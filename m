Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab0D3Rhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:37:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:58396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686Ab0D3RhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:37:23 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86 cpufreq: Make trace_power_frequency cpufreq driver independent
Date: Fri, 30 Apr 2010 12:00:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: x86@kernel.org, linux-trace-users@vger.kernel.org,
       linux-perf-users@vger.kernel.org, robert.schoene@tu-dresden.de,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
       arjan@infradead.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <1272380262-23671-1-git-send-email-trenn@suse.de> <1272380262-23671-3-git-send-email-trenn@suse.de> <20100430090814.GF11032@elte.hu>
In-Reply-To: <20100430090814.GF11032@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004301200.39076.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 April 2010 11:08:14 Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > +		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> > +	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
> > +		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> > +	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
> > +                trace_power_frequency(POWER_PSTATE, freqs->new, freqs->cpu);
> > +	trace_power_end(smp_processor_id());
> 
> Extending power tracing to all cpufreq modules is obviously a good thing.
> 
> But why is trace_power_start() adding a CPU ID argument? CPU ids are already 
> available and can be sampled via PERF_SAMPLE_CPU if needed. AFAICS only 
> power_frequency needs a new 'target_cpu_id' field.
Currently the C-states get triggered on the machine you are running on.
But you can have C-state dependencies (ACPI spec at least defines this 
the same way as done for P-states, not sure whether this exists in
reality already, Linux does not evaluate them yet).
The same way we run into trouble with P-states (SW_ALL, SW_ANY, HW).
Not sure how this will/could show up in reality in HW or implementation, but
as these dependencies are already defined in spec, it sounds like a good idea
to pass the CPU through the POWER_CSTATE events as well.

Compare with chapter 8.4.2.2 _CSD (C-State Dependency)
of an ACPI spec 3.0 or newer.

There are also other architectures starting to use processor sleep states.

So this is not actually used (smp_processor_id() is the same as already
tracked by trace event internally), but to make the interface more robust
for the future. Changes in the trace_power layout later may hurt.
 
> > diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> > index 0d4d8ff..7809bef 100644
> > --- a/tools/perf/builtin-timechart.c
> > +++ b/tools/perf/builtin-timechart.c
> 
> Timechart is maintained by Arjan so we need an ack from him as well. I've seen 
> some back and forth in the discussions - what's the technical resolution of 
> that?
> 
> (Also, there's some whitespace noise in the patch.)
Oops. Tell me if you like to push it and I send a checkpatch cleaned up version.
Sorry about that.

     Thomas
