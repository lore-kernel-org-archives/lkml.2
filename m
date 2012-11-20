Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2KTAsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:48:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52441 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753304Ab2KTAsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:48:38 -0500
Date: Mon, 19 Nov 2012 18:48:34 -0600
From: Russ Anderson <rja@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        rja@americas.sgi.com
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121120004834.GE5060@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20121117151611.GB16900@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121117151611.GB16900@elgon.mountain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 06:16:11PM +0300, Dan Carpenter wrote:
> This is a static checker fix.  The problem is that we store the bits
> from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> them.

Is this the complete patch?  phys_apicid is an int, but gets
cast as unsigned long.  Doesn't phys_apicid also have to be
changed to unsigned long?  And why ulong instead of uint (on x86_64)?

I agree with changing signed to unsigned where appropriate, but
this looks like a partial fix.  Am I missing something?

Thanks.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is for an SGI product, and I can't test it.
> 
> diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
> index 21f7385..f3a0f91 100644
> --- a/arch/x86/include/asm/uv/uv_hub.h
> +++ b/arch/x86/include/asm/uv/uv_hub.h
> @@ -573,7 +573,7 @@ static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
>  }
>  
>  extern unsigned int uv_apicid_hibits;
> -static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
> +static unsigned long uv_hub_ipi_value(ulong apicid, ulong vector, ulong mode)
>  {
>  	apicid |= uv_apicid_hibits;
>  	return (1UL << UVH_IPI_INT_SEND_SHFT) |
> diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> index 8cfade9..6d93b2f 100644
> --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -194,13 +194,13 @@ static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_ri
>  	pnode = uv_apicid_to_pnode(phys_apicid);
>  	phys_apicid |= uv_apicid_hibits;
>  	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
> -	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
> +	    ((unsigned long)phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
>  	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
>  	    APIC_DM_INIT;
>  	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
>  
>  	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
> -	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
> +	    ((unsigned long)phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
>  	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
>  	    APIC_DM_STARTUP;
>  	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
