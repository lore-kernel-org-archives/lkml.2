Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab2HHQbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:31:40 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:50320 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab2HHQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:31:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,733,1336348800"; 
   d="scan'208";a="13914211"
Date: Wed, 8 Aug 2012 17:31:13 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH v2 01/23] arm: initial Xen support
In-Reply-To: <20120807181017.GF15053@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208081730560.21096@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com> <1344263246-28036-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120807181017.GF15053@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Aug 06, 2012 at 03:27:04PM +0100, Stefano Stabellini wrote:
> > - Basic hypervisor.h and interface.h definitions.
> > - Skeleton enlighten.c, set xen_start_info to an empty struct.
> > - Make xen_initial_domain dependent on the SIF_PRIVILIGED_BIT.
> > 
> > The new code only compiles when CONFIG_XEN is set, that is going to be
> > added to arch/arm/Kconfig in patch #11 "xen/arm: introduce CONFIG_XEN on
> > ARM".
> 
> You can add my Ack, but do one change pls:

Thanks! I'll make the changes.


> > +/* XXX: Move pvclock definitions some place arch independent */
> 
> Just use 'TODO'
> 
> > +struct pvclock_vcpu_time_info {
> > +	u32   version;
> > +	u32   pad0;
> > +	u64   tsc_timestamp;
> > +	u64   system_time;
> > +	u32   tsc_to_system_mul;
> > +	s8    tsc_shift;
> > +	u8    flags;
> > +	u8    pad[2];
> > +} __attribute__((__packed__)); /* 32 bytes */
> > +
> > +struct pvclock_wall_clock {
> > +	u32   version;
> > +	u32   sec;
> > +	u32   nsec;
> > +} __attribute__((__packed__));
> 
> Mention the size and why it is OK to have it be a weird
> size while the one above is nicely padded.
> 
> > +#endif
> > +
> > +#endif /* _ASM_ARM_XEN_INTERFACE_H */
> > diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> > new file mode 100644
> > index 0000000..0bad594
> > --- /dev/null
> > +++ b/arch/arm/xen/Makefile
> > @@ -0,0 +1 @@
> > +obj-y		:= enlighten.o
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > new file mode 100644
> > index 0000000..d27c2a6
> > --- /dev/null
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -0,0 +1,35 @@
> > +#include <xen/xen.h>
> > +#include <xen/interface/xen.h>
> > +#include <xen/interface/memory.h>
> > +#include <xen/platform_pci.h>
> > +#include <asm/xen/hypervisor.h>
> > +#include <asm/xen/hypercall.h>
> > +#include <linux/module.h>
> > +
> > +struct start_info _xen_start_info;
> > +struct start_info *xen_start_info = &_xen_start_info;
> > +EXPORT_SYMBOL_GPL(xen_start_info);
> > +
> > +enum xen_domain_type xen_domain_type = XEN_NATIVE;
> > +EXPORT_SYMBOL_GPL(xen_domain_type);
> > +
> > +struct shared_info xen_dummy_shared_info;
> > +struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
> > +
> > +DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
> > +
> > +/* XXX: to be removed */
> 
> s/XXX/TODO/ here, and mention pls why it needs to be removed.
> 
> > +__read_mostly int xen_have_vector_callback;
> > +EXPORT_SYMBOL_GPL(xen_have_vector_callback);
> > +
> > +int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
> > +EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
> 
