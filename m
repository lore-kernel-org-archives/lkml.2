Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0CYLGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:06:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45525 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab0CYLGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:06:22 -0400
Date: Thu, 25 Mar 2010 12:06:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, linux@dominikbrodowski.net,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       cpufreq@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
Message-ID: <20100325110648.GA6060@aftab>
References: <1269452783-966-1-git-send-email-bp@amd64.org>
 <1269452783-966-4-git-send-email-bp@amd64.org>
 <201003251043.04867.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003251043.04867.trenn@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>
Date: Thu, Mar 25, 2010 at 10:43:04AM +0100

Hi Thomas,

> On Wednesday 24 March 2010 18:46:21 Borislav Petkov wrote:
> > From: Mark Langsdorf <mark.langsdorf@amd.com>
> > 
> > Starting with model 10 of Family 0x10, AMD processors may have
> > support for APERF/MPERF.  Add support for identifying it and using
> > it within cpufreq.  Move the APERF/MPERF functions out of the
> > acpi-cpufreq code and into their own file so they can easily be
> > shared.
> > 
> > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  arch/x86/kernel/cpu/amd.c                  |    6 +++
> >  arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
> >  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44 +-----------------------
> >  arch/x86/kernel/cpu/cpufreq/mperf.c        |   50 ++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/cpufreq/mperf.h        |    9 +++++
> >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    8 ++++
> >  6 files changed, 77 insertions(+), 44 deletions(-)
> >  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
> >  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.h
> > 
> > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > index e485825..796f662 100644
> > --- a/arch/x86/kernel/cpu/amd.c
> > +++ b/arch/x86/kernel/cpu/amd.c
> > @@ -537,6 +537,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> >  		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
> >  	}
> >  
> > +	if (c->cpuid_level >= 6) {
> > +		unsigned ecx = cpuid_ecx(6);
> > +		if (ecx & 0x01)
> > +			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
> > +	}
> > +
> Can you put this into:
> arch/x86/kernel/cpu/common.c (or wherever it fits in general x86 cpu init code)
> and remove this (arch/x86/kernel/cpu/intel.c):
>         if (c->cpuid_level > 6) {
>                 unsigned ecx = cpuid_ecx(6);
>                 if (ecx & 0x01)
>                         set_cpu_cap(c, X86_FEATURE_APERFMPERF);
>         }
> 
> an x86 maintainer might want to double check, but I expect this should work
> for all x86 machines?

Yes, it should. However, there's the remote, far-fetched possibility
that other x86 vendors besides AMD and Intel, might have/plan to have
CPUID, base function 6, ECX[1] defined as a completely different feature
flag. And then it becomes ugly.

Besides, this is, strictly speaking, not x86 generic code but AMD- and
Intel-generic (huh, is there something like that? :)) code.

So, IMO, this is a judgement call based on the current settings of the
duplication and bloating levels of the x86 maintainers' filters :)

Let's have some more opinions, please...

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
