Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0IJRZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:25:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50574 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0IJRZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:25:42 -0400
Date: Fri, 10 Sep 2010 11:25:38 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, Mitch Bradley <wmb@laptop.org>,
        linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 2/2] x86: of: define irq functions to allow
 drivers/of/* to build on x86
Message-ID: <20100910172538.GC11284@angua.secretlab.ca>
References: <20100910060151.6613e9c3@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910060151.6613e9c3@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 06:01:51AM -0700, Andres Salomon wrote:
> 
>  - Define a stub irq_create_of_mapping for x86 as a stop-gap solution until
>    drivers/of/irq is further along.
>  - Define irq_dispose_mapping for x86 to appease of_i2c.c
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied to my test-devicetree branch.  I'll need an ack from the x86
maintainers before I put it into my -next branch.

g.

> ---
>  arch/x86/include/asm/irq.h |    3 +++
>  arch/x86/kernel/irq.c      |    8 ++++++++
>  include/linux/of_irq.h     |    1 +
>  3 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index 5458380..8ffa06f 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -10,6 +10,9 @@
>  #include <asm/apicdef.h>
>  #include <asm/irq_vectors.h>
>  
> +/* Even though we don't support this, supply it to appease OF */
> +static inline void irq_dispose_mapping(unsigned int virq) { }
> +
>  static inline int irq_canonicalize(int irq)
>  {
>  	return ((irq == 2) ? 9 : irq);
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 91fd0c7..b78bb6f 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -4,6 +4,7 @@
>  #include <linux/cpu.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> +#include <linux/of.h>
>  #include <linux/seq_file.h>
>  #include <linux/smp.h>
>  #include <linux/ftrace.h>
> @@ -275,6 +276,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
>  
>  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
>  
> +unsigned int irq_create_of_mapping(struct device_node *controller,
> +		const u32 *intspec, unsigned int intsize)
> +{
> +	return intspec[0] + 1;
> +}
> +EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
>  void fixup_irqs(void)
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index 090cbaa..109e013 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -5,6 +5,7 @@
>  struct of_irq;
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/irq.h>
>  #include <linux/ioport.h>
>  #include <linux/of.h>
>  
> -- 
> 1.5.6.5
> 
