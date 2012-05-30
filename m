Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2E3RZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:25:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30946 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2E3RZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:25:07 -0400
Date: Wed, 30 May 2012 13:17:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530171754.GA5115@phenom.dumpdata.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530150334.GA13349@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, the following patch also fixed the crash for us:
> 
> Implement rdmsr_regs and wrmsr_regs for Xen pvops.

That needs more data. Such as the reason for it, the crash
tombstone, and an analysis of the bug.

But at this point I am not sure what we are going to do.

I think Peter leans towards ripping the .rdmsr_regs/wdmsr_regs
function out altogether (so altering the amd_rdmsr... to use the
.rdmsr/.wrdmsr). At which point I think this would all work
just fine?

I am tempted to write a patch that checks all the pv-cpu-ops
to see if there are any that are NULL and throw a warning so
that this does not hit us in the future - to be at least more
proactive about this sort of thing.


> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> Cc: stable@vger.kernel.org # 3.4+
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 75f33b2..f3ae5ec 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -945,9 +945,12 @@ static void xen_write_cr4(unsigned long cr4)
>  	native_write_cr4(cr4);
>  }
>  
> -static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
> +static int xen_wrmsr_safe_regs(u32 regs[8])
>  {
>  	int ret;
> +	unsigned int msr = regs[1];
> +	unsigned low = regs[0];
> +	unsigned high = regs[2];
>  
>  	ret = 0;
>  
> @@ -985,12 +988,23 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
>  		break;
>  
>  	default:
> -		ret = native_write_msr_safe(msr, low, high);
> +		ret = native_wrmsr_safe_regs(regs);
>  	}
>  
>  	return ret;
>  }
>  
> +static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
> +{
> +	u32 regs[8] = { 0 };
> +
> +	regs[0] = low;
> +	regs[1] = msr;
> +	regs[2] = high;
> +
> +	return xen_wrmsr_safe_regs(regs);
> +}
> +
>  void xen_setup_shared_info(void)
>  {
>  	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> @@ -1116,7 +1130,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
>  	.wbinvd = native_wbinvd,
>  
>  	.read_msr = native_read_msr_safe,
> +	.rdmsr_regs = native_rdmsr_safe_regs,
>  	.write_msr = xen_write_msr_safe,
> +	.wrmsr_regs = xen_wrmsr_safe_regs,
>  	.read_tsc = native_read_tsc,
>  	.read_pmc = native_read_pmc,
>  
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
