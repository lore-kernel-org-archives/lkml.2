Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0CWL7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:59:34 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55260 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0CWL7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:59:33 -0400
Date: Tue, 23 Mar 2010 12:59:57 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
Message-ID: <20100323115957.GD16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <1269283121-11894-4-git-send-email-bp@amd64.org>
 <201003231226.22756.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003231226.22756.trenn@suse.de>
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
Date: Tue, Mar 23, 2010 at 12:26:22PM +0100

> On Monday 22 March 2010 19:38:39 Borislav Petkov wrote:
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
> This is nearly identical to (beside c->cpuid_level > 6),
> in arch/x86/kernel/cpu/intel.c:
> if (c->cpuid_level > 6) {
>                 unsigned ecx = cpuid_ecx(6);
>                 if (ecx & 0x01)
>                         set_cpu_cap(c, X86_FEATURE_APERFMPERF);
> }
> I expect you are correct... or could it get moved to general x86 init code?

Sounds good...

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
