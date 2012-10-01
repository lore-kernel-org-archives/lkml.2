Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2JANWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:22:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48606 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2JANWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:22:08 -0400
Date: Mon, 1 Oct 2012 15:21:49 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: andrew.cooper3@citrix.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 05/11] x86/xen: Register resources required by kexec-tools
Message-ID: <20121001132149.GE2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <20120928162132.GC16262@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928162132.GC16262@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:21:35PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Sep 27, 2012 at 08:06:32PM +0200, Daniel Kiper wrote:
> > Register resources required by kexec-tools.
> >
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  arch/x86/xen/kexec.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 150 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/x86/xen/kexec.c
> >
> > diff --git a/arch/x86/xen/kexec.c b/arch/x86/xen/kexec.c
> > new file mode 100644
> > index 0000000..eb0108b
> > --- /dev/null
> > +++ b/arch/x86/xen/kexec.c
> > @@ -0,0 +1,150 @@
> > +/*
> > + * Copyright (c) 2011 Daniel Kiper
> > + * Copyright (c) 2012 Daniel Kiper, Oracle Corporation
> > + *
> > + * kexec/kdump implementation for Xen was written by Daniel Kiper.
> > + * Initial work on it was sponsored by Google under Google Summer
> > + * of Code 2011 program and Citrix. Konrad Rzeszutek Wilk from Oracle
> > + * was the mentor for this project.
> > + *
> > + * Some ideas are taken from:
> > + *   - native kexec/kdump implementation,
> > + *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
> > + *   - PV-GRUB.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/ioport.h>
> > +#include <linux/kernel.h>
> > +#include <linux/kexec.h>
> > +#include <linux/slab.h>
> > +#include <linux/string.h>
> > +
> > +#include <xen/interface/platform.h>
> > +#include <xen/interface/xen.h>
> > +#include <xen/xen.h>
> > +
> > +#include <asm/xen/hypercall.h>
> > +
> > +unsigned long xen_vmcoreinfo_maddr = 0;
> > +unsigned long xen_vmcoreinfo_max_size = 0;
> > +
> > +static int __init xen_init_kexec_resources(void)
> > +{
> > +	int rc;
> > +	static struct resource xen_hypervisor_res = {
> > +		.name = "Hypervisor code and data",
> > +		.flags = IORESOURCE_BUSY | IORESOURCE_MEM
> > +	};
> > +	struct resource *cpu_res;
> > +	struct xen_kexec_range xkr;
> > +	struct xen_platform_op cpuinfo_op;
> > +	uint32_t cpus, i;
> > +
> > +	if (!xen_initial_domain())
> > +		return 0;
> > +
> > +	if (strstr(boot_command_line, "crashkernel="))
> > +		pr_info("kexec: Ignoring crashkernel option. "
>
> pr_warn?

OK.

> > +			"It should be passed to Xen hypervisor.\n");
> > +
> > +	/* Register Crash kernel resource. */
> > +	xkr.range = KEXEC_RANGE_MA_CRASH;
> > +	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &xkr);
> > +
> > +	if (rc) {
> > +		pr_info("kexec: %s: HYPERVISOR_kexec_op(KEXEC_RANGE_MA_CRASH)"
> > +			": %i\n", __func__, rc);
>
> Perhaps pr_warn?

Ditto.

> > +		return rc;
> > +	}
> > +
> > +	if (!xkr.size)
> > +		return 0;
> > +
> > +	crashk_res.start = xkr.start;
> > +	crashk_res.end = xkr.start + xkr.size - 1;
> > +	insert_resource(&iomem_resource, &crashk_res);
> > +
> > +	/* Register Hypervisor code and data resource. */
> > +	xkr.range = KEXEC_RANGE_MA_XEN;
> > +	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &xkr);
> > +
> > +	if (rc) {
> > +		pr_info("kexec: %s: HYPERVISOR_kexec_op(KEXEC_RANGE_MA_XEN)"
>
> pr_warn

Ditto.

> > +			": %i\n", __func__, rc);
> > +		return rc;
> > +	}
> > +
> > +	xen_hypervisor_res.start = xkr.start;
> > +	xen_hypervisor_res.end = xkr.start + xkr.size - 1;
> > +	insert_resource(&iomem_resource, &xen_hypervisor_res);
> > +
> > +	/* Determine maximum number of physical CPUs. */
> > +	cpuinfo_op.cmd = XENPF_get_cpuinfo;
> > +	cpuinfo_op.u.pcpu_info.xen_cpuid = 0;
> > +	rc = HYPERVISOR_dom0_op(&cpuinfo_op);
> > +
> > +	if (rc) {
> > +		pr_info("kexec: %s: HYPERVISOR_dom0_op(): %i\n", __func__, rc);
>
> pr_warn.

Ditto.

> > +		return rc;
> > +	}
> > +
> > +	cpus = cpuinfo_op.u.pcpu_info.max_present + 1;
>
> Do we care about the hotplug CPUs?

Good point. I have not considered it yet.

> > +
> > +	/* Register CPUs Crash note resources. */
> > +	cpu_res = kcalloc(cpus, sizeof(struct resource), GFP_KERNEL);
> > +
> > +	if (!cpu_res) {
> > +		pr_info("kexec: %s: kcalloc(): %i\n", __func__, -ENOMEM);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	for (i = 0; i < cpus; ++i) {
>
> Any specific reason for using '++i' instead of 'i++' ?

It does not matter here but I prefer '++i' form.
That is it.

Daniel
