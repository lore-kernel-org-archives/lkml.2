Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2LBPeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:34:05 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:38642 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2LBPeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:34:03 -0500
Message-ID: <50BB74E7.9060306@bfs.de>
Date: Sun, 02 Dec 2012 16:33:59 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] x86, UV: integer wrap bug in uv_hub_ipi_value()
References: <20121202104438.GD16078@elgon.mountain>
In-Reply-To: <20121202104438.GD16078@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 02.12.2012 11:44, schrieb Dan Carpenter:
> This is a static checker fix.  The problem is that we store the bits
> from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> them.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Style fix.  Don't use ulong.
> 
> I don't have this hardware so I can't test it.  There may also be other
> bugs which this patch does not addressed.  These files are only compiled
> on x86_64 and "unsigned long" is used throughout to mean 64 bits.
> 
> diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
> index 21f7385..e7a83d5 100644
> --- a/arch/x86/include/asm/uv/uv_hub.h
> +++ b/arch/x86/include/asm/uv/uv_hub.h
> @@ -577,7 +577,7 @@ static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
>  {
>  	apicid |= uv_apicid_hibits;
>  	return (1UL << UVH_IPI_INT_SEND_SHFT) |
> -			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
> +			((unsigned long)apicid << UVH_IPI_INT_APIC_ID_SHFT) |
>  			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
>  			(vector << UVH_IPI_INT_VECTOR_SHFT);
>  }
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

making this more readable is hard but what is about:

val=(1UL << UVH_IPI_INT_SEND_SHFT) |
     ((unsigned long)phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
      ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12);

 uv_write_global_mmr64(pnode, UVH_IPI_INT, val|APIC_DM_INIT);

 uv_write_global_mmr64(pnode, UVH_IPI_INT, val|APIC_DM_STARTUP);


just my 2 cents,
 re
  wh

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
