Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2EATr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:47:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41903 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2EATrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:47:55 -0400
Date: Tue, 1 May 2012 15:41:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2] xen/apic: implement io apic read with
 hypercall
Message-ID: <20120501194158.GA15164@phenom.dumpdata.com>
References: <1335802587.4746.2.camel@chief-river-32>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335802587.4746.2.camel@chief-river-32>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 12:16:27AM +0800, Lin Ming wrote:
> Implements xen_io_apic_read with hypercall, so it returns proper
> IO-APIC information instead of fabricated one.

Looks good. I queued it up and sending the git pull to Ingo shortly.
> 
> Fallback to return an emulated IO_APIC values if hypercall fails.
> 
> Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> ---
> 
> v2: fallback to return an emulated IO_APIC values if hypercall fails
> 
>  arch/x86/xen/apic.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> index aee16ab..1913bf2 100644
> --- a/arch/x86/xen/apic.c
> +++ b/arch/x86/xen/apic.c
> @@ -1,14 +1,27 @@
>  #include <linux/init.h>
>  #include <asm/x86_init.h>
> +#include <asm/apic.h>
> +#include <xen/interface/physdev.h>
> +#include <asm/xen/hypercall.h>
>  
>  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
>  {
> +	struct physdev_apic apic_op;
> +	int ret;
> +
> +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
> +	apic_op.reg = reg;
> +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
> +	if (!ret)
> +		return apic_op.value;
> +
> +	/* fallback to return an emulated IO_APIC values */
>  	if (reg == 0x1)
>  		return 0x00170020;
>  	else if (reg == 0x0)
>  		return apic << 24;
>  
> -	return 0xff;
> +	return 0xfd;
>  }
>  
>  void __init xen_init_apic(void)
> -- 
> 1.7.9
> 
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
