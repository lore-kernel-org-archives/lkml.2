Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0CWL02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:26:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:59861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0CWL0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:26:25 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
Date: Tue, 23 Mar 2010 12:26:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-4-git-send-email-bp@amd64.org>
In-Reply-To: <1269283121-11894-4-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231226.22756.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 19:38:39 Borislav Petkov wrote:
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> Starting with model 10 of Family 0x10, AMD processors may have
> support for APERF/MPERF.  Add support for identifying it and using
> it within cpufreq.  Move the APERF/MPERF functions out of the
> acpi-cpufreq code and into their own file so they can easily be
> shared.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c                  |    6 +++
>  arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44 +-----------------------
>  arch/x86/kernel/cpu/cpufreq/mperf.c        |   50 ++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/cpufreq/mperf.h        |    9 +++++
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    8 ++++
>  6 files changed, 77 insertions(+), 44 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
>  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.h
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index e485825..796f662 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -537,6 +537,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
>  	}
>  
> +	if (c->cpuid_level >= 6) {
> +		unsigned ecx = cpuid_ecx(6);
> +		if (ecx & 0x01)
> +			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
> +	}
This is nearly identical to (beside c->cpuid_level > 6),
in arch/x86/kernel/cpu/intel.c:
if (c->cpuid_level > 6) {
                unsigned ecx = cpuid_ecx(6);
                if (ecx & 0x01)
                        set_cpu_cap(c, X86_FEATURE_APERFMPERF);
}
I expect you are correct... or could it get moved to general x86 init code?

     Thomas
