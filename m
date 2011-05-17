Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1EQRmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:42:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50939 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1EQRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:42:39 -0400
Date: Tue, 17 May 2011 18:42:33 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 1/5] acpi-cpufreq: Add support for modern AMD CPUs
Message-ID: <20110517174233.GA25111@srcf.ucam.org>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
 <20110517173536.GI30053@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517173536.GI30053@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 07:35:36PM +0200, Borislav Petkov wrote:
> On Tue, May 17, 2011 at 01:03:35PM -0400, Matthew Garrett wrote:
> > The programming model for P-states on modern AMD CPUs is very similar to
> > that of Intel and VIA. It makes sense to consolidate this support into one
> > driver rather than duplicating functionality between two of them. This
> > patch adds support for AMDs with hardware P-state control to acpi-cpufreq.
> 
> Ok, I'm a bit confused here but maybe because I don't know the whole
> cpufreq subsystem that well. Is the purpose here to add hw pstates
> support to acpi-cpufreq so that it is used on AMD but leave the old
> Fid/Vid method to powernow-k8, thus phasing it out...?

Yes. The last patch in the set removes the hw pstate code from 
powernow-k8.

> >  #define MSR_IA32_PERF_STATUS		0x00000198
> >  #define MSR_IA32_PERF_CTL		0x00000199
> > +#define MSR_AMD_PERF_STATUS		0xc0010063
> > +#define MSR_AMD_PERF_CTL		0xc0010062
> 
> Yeah, there are defines for those in
> <arch/x86/kernel/cpu/cpufreq/powernow-k8.h>:
> 
> #define MSR_PSTATE_STATUS       0xc0010063 /* Pstate Status MSR */
> #define MSR_PSTATE_CTRL         0xc0010062 /* Pstate control MSR */
> 
> can you remove them from there for consistency so that we can use only
> the msr-index.h definitions.

That happens in the final patch.

> > +static int check_powernow_cpu(unsigned int cpuid)
> > +{
> > +	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> > +
> > +	return cpu_has(cpu, X86_FEATURE_POWERNOW);
> > +}
> 
> This could be static_cpu_has() since all the CPUs, including the boot
> CPU, will have the HwPstate thing set. Thus, you can ignore the "cpuid"
> parameter.

Ok, this was just for symmetry with the est version.

> > --- a/arch/x86/kernel/cpu/scattered.c
> > +++ b/arch/x86/kernel/cpu/scattered.c
> > @@ -39,6 +39,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
> >  		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
> >  		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
> >  		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
> > +		{ X86_FEATURE_POWERNOW,		CR_EDX, 7, 0x80000007, 0 },
> >  		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
> >  		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
> >  		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
> 
> It might make sense to split out the cpuid changes to a different patch,
> IMHO.

I'd have no problem with that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
