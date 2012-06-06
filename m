Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2FFUPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:15:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42432 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2FFUPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:15:01 -0400
Date: Wed, 6 Jun 2012 16:07:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        stable@vger.kernel.org.#.3.4+,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/4] x86, AMD: Fix crash as Xen Dom0 on AMD Trinity
 systems
Message-ID: <20120606200734.GD9602@phenom.dumpdata.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-4-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338562358-28182-4-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 04:52:37PM +0200, Borislav Petkov wrote:
> From: Andre Przywara <andre.przywara@amd.com>
> 
> f7f286a910221 ("x86/amd: Re-enable CPU topology extensions in case BIOS
> has disabled it") wrongfully added code which used the AMD-specific
> {rd,wr}msr variants for no real reason.
> 
> This caused boot panics on xen which wasn't initializing the
> {rd,wr}msr_safe_regs pv_ops members properly.
> 
> This, in turn, caused a heated discussion leading to us reviewing all
> uses of the AMD-specific variants and removing them where unneeded
> (almost everywhere except an obscure K8 BIOS fix, see 6b0f43ddfa358).
> 
> Finally, this patch switches to the standard {rd,wr}msr*_safe* variants
> which should've been used in the first place anyway and avoided unneeded
> excitation with xen.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> Cc: stable@vger.kernel.org # 3.4+
> Link: <http://lkml.kernel.org/r/1338383402-3838-1-git-send-email-andre.przywara@amd.com>
> [Boris: correct and expand commit message]
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 146bb6218eec..80ccd99542e6 100644
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
> 1.7.9.3.362.g71319
