Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab2CUBad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:30:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:2985 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133Ab2CUBac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79795848"
Subject: Re: [PATCH 3/3] xen/x86: Implement x86_apic_ops
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jwboyer@redhat.com, mingo@elte.hu, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Mar 2012 18:31:37 -0700
In-Reply-To: <1332288764-10351-4-git-send-email-konrad.wilk@oracle.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
	 <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
	 <1332288764-10351-4-git-send-email-konrad.wilk@oracle.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332293497.16101.90.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 20:12 -0400, Konrad Rzeszutek Wilk wrote:
> Or rather just implement one different function as opposed
> to the native one : the read function.
> 
> We synthesize the values.
> 
> Suggested-by:  Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/Makefile    |    2 +-
>  arch/x86/xen/apic.c      |   17 +++++++++++++++++
>  arch/x86/xen/enlighten.c |    2 ++
>  arch/x86/xen/xen-ops.h   |    4 ++++
>  4 files changed, 24 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/xen/apic.c
> 
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index add2c2d..96ab2c0 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -20,5 +20,5 @@ obj-$(CONFIG_EVENT_TRACING) += trace.o
>  obj-$(CONFIG_SMP)		+= smp.o
>  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
>  obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
> -obj-$(CONFIG_XEN_DOM0)		+= vga.o
> +obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
>  obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
> diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> new file mode 100644
> index 0000000..c53b3ef
> --- /dev/null
> +++ b/arch/x86/xen/apic.c
> @@ -0,0 +1,17 @@
> +#include <linux/init.h>
> +#include <asm/x86_init.h>
> +
> +unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> +{
> +	if (reg == 0x1)
> +		return 0x00170020;
> +	else if (reg == 0x0)
> +		return 0x00000000;

For IO-APIC ID register (0), you can probably use the argument 'apic' to
set the ID bits in the returned register.

> +
> +	return 0xfd;

0xff might be better.

If something breaks in future, then we can add that register
implementation here.

thanks,
suresh

> +}
> +
> +void __init xen_init_apic(void)
> +{
> +	x86_apic.read = xen_io_apic_read;
> +}
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 0732326..591ee69 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1381,6 +1381,8 @@ asmlinkage void __init xen_start_kernel(void)
>  		pci_request_acs();
>  
>  		xen_acpi_sleep_register();
> +
> +		xen_init_apic();
>  	}
>  		
>  
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index b095739..45c0c06 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -92,11 +92,15 @@ struct dom0_vga_console_info;
>  
>  #ifdef CONFIG_XEN_DOM0
>  void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
> +void __init xen_init_apic(void);
>  #else
>  static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
>  				       size_t size)
>  {
>  }
> +static inline void __init xen_init_apic(void)
> +{
> +}
>  #endif
>  
>  /* Declare an asm function, along with symbols needed to make it


