Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2E3OPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:15:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59036 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2E3OPa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 30 May 2012 10:15:30 -0400
Message-Id: <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 30 May 2012 14:33:03 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andre Przywara" <andre.przywara@amd.com>
Cc: <mingo@elte.hu>, <jeremy@goop.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org#3.4+>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
In-Reply-To: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 15:10, Andre Przywara <andre.przywara@amd.com> wrote:
> Because we are behind a family check before tweaking the topology
> bit, we can use the standard rd/wrmsr variants for the CPUID feature
> register.
> This fixes a crash when using the kernel as a Xen Dom0 on affected
> Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
> yet (this will be fixed in another patch).

I'm not following: If the AMD variants (putting a special value into
%edi) can be freely replaced by the non-AMD variants, why did
the AMD special ones get used in the first place?

Further, I can't see how checking_wrmsrl() is being paravirtualized
any better than wrmsrl_amd_safe() - both have nothing but an
exception handling fixup attached to the wrmsr invocation. Care
to point out what actual crash it is that was seen?

Finally, I would question whether re-enabling the topology
extensions under Xen shouldn't be skipped altogether, perhaps
even on Dom0 (as the hypervisor is controlling this MSR, but in
any case on DomU - the hypervisor won't allow (read: ignore,
not fault on) the write anyway (and will log a message for each
(v)CPU that attempts this).

Jan

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


