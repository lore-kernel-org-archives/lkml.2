Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1GAMPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:15:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39258 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab1GAMPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:15:30 -0400
Date: Fri, 1 Jul 2011 14:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 2/2] powerpc/mm: Fix memory_block_size_bytes() for
 non-pseries
Message-ID: <20110701121516.GD28008@elte.hu>
References: <1308013071.2874.785.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308013071.2874.785.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Just compiling pseries in the kernel causes it to override
> memory_block_size_bytes() regardless of what is the runtime
> platform.
> 
> This cleans up the implementation of that function, fixing
> a bug or two while at it, so that it's harmless (and potentially
> useful) for other platforms. Without this, bugs in that code
> would trigger a WARN_ON() in drivers/base/memory.c when
> booting some different platforms. 
> 
> If/when we have another platform supporting memory hotplug we
> might want to either move that out to a generic place or
> make it a ppc_md. callback.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
> index 33867ec..9d6a8ef 100644
> --- a/arch/powerpc/platforms/pseries/hotplug-memory.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
> @@ -12,6 +12,8 @@
>  #include <linux/of.h>
>  #include <linux/memblock.h>
>  #include <linux/vmalloc.h>
> +#include <linux/memory.h>
> +
>  #include <asm/firmware.h>
>  #include <asm/machdep.h>
>  #include <asm/pSeries_reconfig.h>
> @@ -20,24 +22,25 @@
>  static unsigned long get_memblock_size(void)
>  {
>  	struct device_node *np;
> -	unsigned int memblock_size = 0;
> +	unsigned int memblock_size = MIN_MEMORY_BLOCK_SIZE;
> +	struct resource r;
>  
>  	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
>  	if (np) {
> -		const unsigned long *size;
> +		const __be64 *size;
>  
>  		size = of_get_property(np, "ibm,lmb-size", NULL);
> -		memblock_size = size ? *size : 0;
> -
> +		if (size)
> +			memblock_size = be64_to_cpup(size);
>  		of_node_put(np);
> -	} else {
> +	} else  if (machine_is(pseries)) {
> +		/* This fallback really only applies to pseries */
>  		unsigned int memzero_size = 0;
> -		const unsigned int *regs;
>  
>  		np = of_find_node_by_path("/memory@0");
>  		if (np) {
> -			regs = of_get_property(np, "reg", NULL);
> -			memzero_size = regs ? regs[3] : 0;
> +			if (!of_address_to_resource(np, 0, &r))
> +				memzero_size = resource_size(&r);
>  			of_node_put(np);
>  		}
>  
> @@ -50,16 +53,21 @@ static unsigned long get_memblock_size(void)
>  			sprintf(buf, "/memory@%x", memzero_size);
>  			np = of_find_node_by_path(buf);
>  			if (np) {
> -				regs = of_get_property(np, "reg", NULL);
> -				memblock_size = regs ? regs[3] : 0;
> +				if (!of_address_to_resource(np, 0, &r))
> +					memblock_size = resource_size(&r);
>  				of_node_put(np);
>  			}
>  		}
>  	}
> -
>  	return memblock_size;
>  }
>  
> +/* WARNING: This is going to override the generic definition whenever
> + * pseries is built-in regardless of what platform is active at boot
> + * time. This is fine for now as this is the only "option" and it
> + * should work everywhere. If not, we'll have to turn this into a
> + * ppc_md. callback
> + */

Just a small nit, please use the customary (multi-line) comment 
style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo
