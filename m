Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2EaQYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:24:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34287 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2EaQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:24:31 -0400
Date: Thu, 31 May 2012 12:17:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andre Przywara <andre.przywara@amd.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org.#.v3.0+
Subject: Re: [PATCH] xen: filter APERFMPERF feature for kernel usage
Message-ID: <20120531161732.GA14197@phenom.dumpdata.com>
References: <1338289651-15843-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338289651-15843-1-git-send-email-andre.przywara@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 01:07:31PM +0200, Andre Przywara wrote:
> Xen PV kernels allow access to the APERF/MPERF registers to read the
> effective frequency. Access to the MSRs is however redirected to the
> currently scheduled physical CPU, making consecutive read and
> compares unreliable. In addition each rdmsr traps into the hypervisor.
> So to avoid bogus readouts and expensive traps, disable the kernel
> internal feature flag for APERF/MPERF if running under Xen.
> This will
> a) remove the aperfmperf flag from /proc/cpuinfo
> b) not mislead the power scheduler (arch/x86/kernel/cpu/sched.c) to
>    use the feature to improve scheduling (by default disabled)
> c) not mislead the cpufreq driver to use the MSRs
> 
> This does not cover userland programs which access the MSRs via the
> device file interface, but this will be addressed separately.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> Cc: stable@vger.kernel.org # v3.0+

applied.
> ---
>  arch/x86/xen/enlighten.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 95dccce..dfbe1af 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -207,6 +207,9 @@ static void __init xen_banner(void)
>  	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
>  }
>  
> +#define CPUID_THERM_POWER_LEAF 6
> +#define APERFMPERF_PRESENT 0
> +
>  static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
>  static __read_mostly unsigned int cpuid_leaf1_ecx_mask = ~0;
>  
> @@ -240,6 +243,11 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  		*dx = cpuid_leaf5_edx_val;
>  		return;
>  
> +	case CPUID_THERM_POWER_LEAF:
> +		/* Disabling APERFMPERF for kernel usage */
> +		maskecx = ~(1 << APERFMPERF_PRESENT);
> +		break;
> +
>  	case 0xb:
>  		/* Suppress extended topology stuff */
>  		maskebx = 0;
> -- 
> 1.7.4.4
> 
