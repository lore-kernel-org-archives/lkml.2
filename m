Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2HGSUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:20:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32605 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2HGSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:20:10 -0400
Date: Tue, 7 Aug 2012 14:10:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 01/23] arm: initial Xen support
Message-ID: <20120807181017.GF15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:04PM +0100, Stefano Stabellini wrote:
> - Basic hypervisor.h and interface.h definitions.
> - Skeleton enlighten.c, set xen_start_info to an empty struct.
> - Make xen_initial_domain dependent on the SIF_PRIVILIGED_BIT.
> 
> The new code only compiles when CONFIG_XEN is set, that is going to be
> added to arch/arm/Kconfig in patch #11 "xen/arm: introduce CONFIG_XEN on
> ARM".

You can add my Ack, but do one change pls:

> +/* XXX: Move pvclock definitions some place arch independent */

Just use 'TODO'

> +struct pvclock_vcpu_time_info {
> +	u32   version;
> +	u32   pad0;
> +	u64   tsc_timestamp;
> +	u64   system_time;
> +	u32   tsc_to_system_mul;
> +	s8    tsc_shift;
> +	u8    flags;
> +	u8    pad[2];
> +} __attribute__((__packed__)); /* 32 bytes */
> +
> +struct pvclock_wall_clock {
> +	u32   version;
> +	u32   sec;
> +	u32   nsec;
> +} __attribute__((__packed__));

Mention the size and why it is OK to have it be a weird
size while the one above is nicely padded.

> +#endif
> +
> +#endif /* _ASM_ARM_XEN_INTERFACE_H */
> diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> new file mode 100644
> index 0000000..0bad594
> --- /dev/null
> +++ b/arch/arm/xen/Makefile
> @@ -0,0 +1 @@
> +obj-y		:= enlighten.o
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> new file mode 100644
> index 0000000..d27c2a6
> --- /dev/null
> +++ b/arch/arm/xen/enlighten.c
> @@ -0,0 +1,35 @@
> +#include <xen/xen.h>
> +#include <xen/interface/xen.h>
> +#include <xen/interface/memory.h>
> +#include <xen/platform_pci.h>
> +#include <asm/xen/hypervisor.h>
> +#include <asm/xen/hypercall.h>
> +#include <linux/module.h>
> +
> +struct start_info _xen_start_info;
> +struct start_info *xen_start_info = &_xen_start_info;
> +EXPORT_SYMBOL_GPL(xen_start_info);
> +
> +enum xen_domain_type xen_domain_type = XEN_NATIVE;
> +EXPORT_SYMBOL_GPL(xen_domain_type);
> +
> +struct shared_info xen_dummy_shared_info;
> +struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
> +
> +DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
> +
> +/* XXX: to be removed */

s/XXX/TODO/ here, and mention pls why it needs to be removed.

> +__read_mostly int xen_have_vector_callback;
> +EXPORT_SYMBOL_GPL(xen_have_vector_callback);
> +
> +int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
> +EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
