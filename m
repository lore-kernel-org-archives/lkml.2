Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2AMW17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:27:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43757 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2AMW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:27:56 -0500
Date: Fri, 13 Jan 2012 17:24:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, liang tang <liang.tang@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "mike.mcclurg@citrix.com" <mike.mcclurg@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "liang.tang@oracle.com" <liang.tang@oracle.com>,
        "Yu, Ke" <ke.yu@intel.com>, "konrad@kernel.org" <konrad@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Message-ID: <20120113222451.GA6922@phenom.dumpdata.com>
References: <20111216220342.GC9832@phenom.dumpdata.com>
 <625BA99ED14B2D499DC4E29D8138F1506E01AABC7A@shsmsx502.ccr.corp.intel.com>
 <20111219142626.GB27772@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
 <20111220153145.GB13253@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC469@shsmsx502.ccr.corp.intel.com>
 <20111223030103.GA7218@andromeda.dapyr.net>
 <AADFC41AFE54684AB9EE6CBC0274A5D10145B9@SHSMSX102.ccr.corp.intel.com>
 <20120103205925.GI17472@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D102D62B@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D102D62B@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F10AFAE.00CC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > sure. VCPU!=PCPU requirement is orthogonal to the basic part for gearing
> > > ACPI information to Xen.

.. snip..
> > >
> > > >  1). For new distros (Ubuntu, Fedora), the default is all VCPUs.
> > >
> > > good to know that.
> > >
> > > >      Enterprising users might use dom0_max_vcpus to limit the VCPU
> > count,
> > > >      but most won't.
> > > >      Which mean we can concentrate on bringing the _Pxx/_Cxx parsing
> > > >      up to the hypervisor. Which is really neccessary on any chipset
> > > >      which has the notion of TurboBoost (otherwise the Xen scheduler
> > > >      won't pick this up and won't engage this mode in certain
> > > >      workloads).

.. snip..

> yes, this is a big question. First, I'd like to give my sincere thanks to you and
> Liang for help push this part to Linux upstream. You've done a great job. :-)

Thanks!
> Unfortunately I can't afford the time in the short term, due to extremely busy
> tasks in other projects, at least in the whole Q1. Really sorry about that. :/

Bummer.
> 
> I would very appreciate your help if you could continue lending some time here,
> since you've done plenty of works on the cleanup. The majority of the tricky 
> part is related to VCPU/PCPU handling. If putting that part aside, the remaining 
> logic should be much simpler.

I was trying to figure out how difficult it would be to just bring Pxx states to
the Xen hypervisor using the existing ACPI interfaces. And while it did not pass
all the _Pxx states (seems that all the _PCT, _PSS, _PSD, _PPC flags need to
be enabled in the hypercall to make this work), it demonstrates what I had in mind.


#include <linux/device.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/types.h>
#include <acpi/acpi_bus.h>
#include <acpi/acpi_drivers.h>
#include <acpi/processor.h>
#include <linux/cpumask.h>

#include <xen/interface/platform.h>
#include <asm/xen/hypercall.h>

#define DRV_NAME	"ACPI_PXX"
#define DRV_CLASS	"ACPI_PXX_CLASS"
MODULE_AUTHOR("Konrad Rzeszutek Wilk");
MODULE_DESCRIPTION("ACPI Processor Driver to send data to Xen hypervisor");
MODULE_LICENSE("GPL");

static int parse_acpi_cxx(struct acpi_processor *_pr)
{
	struct acpi_processor_cx *cx;
	int i;

	for (i = 1; i <= _pr->power.count; i++) {
		cx = &_pr->power.states[i];
		if (!cx->valid)
			continue;
		pr_info("%s: %d %d %d 0x%x\n", __func__,
			cx->type, cx->latency, cx->power, (u32)cx->address);
	}
	/* TODO: Under Xen, the C-states information is not present.
 	 * Figure out why. */
	return 0;
}
static int push_pxx_to_hypervisor(struct acpi_processor *_pr)
{
	int ret = -EINVAL;
	struct xen_platform_op op = {
		.cmd			= XENPF_set_processor_pminfo,
		.interface_version	= XENPF_INTERFACE_VERSION,
		.u.set_pminfo.id	= _pr->acpi_id,
		.u.set_pminfo.type	= XEN_PM_PX,
	};
	struct xen_processor_performance *xen_perf;
	struct xen_processor_px *xen_states, *xen_px = NULL;
	struct acpi_processor_px *px;
	unsigned i;

	xen_perf = &op.u.set_pminfo.perf;
	xen_perf->flags = XEN_PX_PSS;

	xen_perf->state_count = _pr->performance->state_count;
	xen_states = kzalloc(xen_perf->state_count *
			     sizeof(struct xen_processor_px), GFP_KERNEL);
	if (!xen_states)
		return -ENOMEM;

	for (i = 0; i < _pr->performance->state_count; i++) {
		xen_px = &(xen_states[i]);
		px = &(_pr->performance->states[i]);

		xen_px->core_frequency = px->core_frequency;
		xen_px->power = px->power;
		xen_px->transition_latency = px->transition_latency;
		xen_px->bus_master_latency = px->bus_master_latency;
		xen_px->control = px->control;
		xen_px->status = px->status;
	}
	set_xen_guest_handle(xen_perf->states, xen_states);
	ret = HYPERVISOR_dom0_op(&op);
	kfree(xen_states);
	return ret;
}
static int parse_acpi_pxx(struct acpi_processor *_pr)
{
	struct acpi_processor_px *px;
	int i;

	for (i = 0; i < _pr->performance->state_count;i++) {
		px = &(_pr->performance->states[i]);
		pr_info("%s: [%d]: %d, %d, %d, %d, %d, %d\n", __func__,
			i, (u32)px->core_frequency, (u32)px->power,
			(u32)px->transition_latency,
			(u32)px->bus_master_latency,
			(u32)px->control, (u32)px->status);
	}
	if (xen_initial_domain())
		return push_pxx_to_hypervisor(_pr);
	return 0;
}
static int parse_acpi_data(void)
{
	int cpu;
	int err = -ENODEV;
	struct acpi_processor *_pr;
	struct cpuinfo_x86 *c = &cpu_data(0);

	/* TODO: Under AMD, the information is populated
	 * using the powernow-k8 driver which does an MSR_PSTATE_CUR_LIMIT
	 * MSR which returns the wrong value so the population of 'processors'
	 * has bogus data. So only run this under Intel for right now. */
	if (!cpu_has(c, X86_FEATURE_EST))
		return -ENODEV;
	for_each_possible_cpu(cpu) {
		_pr = per_cpu(processors, cpu);
		if (!_pr)
			continue;

		if (_pr->flags.power)
			(void)parse_acpi_cxx(_pr);

		if (_pr->performance->states)
			err = parse_acpi_pxx(_pr);
		if (err)
			break;
	}
	return -ENODEV; /* force it to unload */
}
static int __init acpi_pxx_init(void)
{
	return parse_acpi_data();
}
static void __exit acpi_pxx_exit(void)
{
}
module_init(acpi_pxx_init);
module_exit(acpi_pxx_exit);
