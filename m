Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2E3Oqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:46:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35990 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2E3Oqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:46:54 -0400
Date: Wed, 30 May 2012 10:39:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andre Przywara <andre.przywara@amd.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, jeremy@goop.org,
        xen-devel@lists.xensource.com, stable@vger.kernel.org#3.4+,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530143937.GF3207@phenom.dumpdata.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:10:02PM +0200, Andre Przywara wrote:
> Because we are behind a family check before tweaking the topology
> bit, we can use the standard rd/wrmsr variants for the CPUID feature
> register.
> This fixes a crash when using the kernel as a Xen Dom0 on affected
> Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
> yet (this will be fixed in another patch).

So with a rdmsrl_amd_safe and wrmsrl_amd_safe being implemented in
the pv_cpu_ops - would this patch even be neccessary?

> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> Cc: stable@vger.kernel.org # 3.4+
> ---
>  arch/x86/kernel/cpu/amd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 146bb62..80ccd99 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -586,9 +586,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
>  		u64 val;
>  
> -		if (!rdmsrl_amd_safe(0xc0011005, &val)) {
> +		if (!rdmsrl_safe(0xc0011005, &val)) {
>  			val |= 1ULL << 54;
> -			wrmsrl_amd_safe(0xc0011005, val);
> +			checking_wrmsrl(0xc0011005, val);
>  			rdmsrl(0xc0011005, val);
>  			if (val & (1ULL << 54)) {
>  				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
> -- 
> 1.7.4.4
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
