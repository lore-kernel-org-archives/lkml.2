Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2AQSWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:22:31 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:63981 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2AQSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:22:29 -0500
Date: Tue, 17 Jan 2012 13:19:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: liang tang <liang.tang@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "mike.mcclurg@citrix.com" <mike.mcclurg@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Yu, Ke" <ke.yu@intel.com>, "konrad@kernel.org" <konrad@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Message-ID: <20120117181922.GA12900@phenom.dumpdata.com>
References: <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
 <20111220153145.GB13253@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC469@shsmsx502.ccr.corp.intel.com>
 <20111223030103.GA7218@andromeda.dapyr.net>
 <AADFC41AFE54684AB9EE6CBC0274A5D10145B9@SHSMSX102.ccr.corp.intel.com>
 <20120103205925.GI17472@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D102D62B@SHSMSX102.ccr.corp.intel.com>
 <20120113222451.GA6922@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D10FCD37A9@SHSMSX102.ccr.corp.intel.com>
 <20120117171314.GB5494@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117171314.GB5494@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F15BC2C.0074,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:13:14PM -0500, Konrad Rzeszutek Wilk wrote:
> > > I was trying to figure out how difficult it would be to just bring Pxx states to
> > > the Xen hypervisor using the existing ACPI interfaces. And while it did not pass
> > > all the _Pxx states (seems that all the _PCT, _PSS, _PSD, _PPC flags need to
> > > be enabled in the hypercall to make this work), it demonstrates what I had in
> > > mind. 
> 
> .. snip..
> > > 	/* TODO: Under Xen, the C-states information is not present.
> > >  	 * Figure out why. */
> > 
> > it's possible related to this long thread:
> > 
> > http://lists.xen.org/archives/html/xen-devel/2011-08/msg00511.html
> > 
> > IOW, Xen doesn't export mwait capability to dom0, which impacts _PDC setting.
> > Final solution is to have a para-virtualized PDC call for that.
> 
> Aaah. Let me play with that a bit. Thanks for the pointer.
> 
> .. snip..
> > the prerequisites for this module to work correctly, is that dom0 has the right
> > configurations to have all necessary Cx/Px information ready before this 
> > module is loaded. That may mean enabling full CONFIG_CPU_IDLE and CONFIG_CPUFREQ,
> 
> Right.
> > which in current form may add some negative impact, e.g. dom0 will try to control
> > Px/Cx to conflict with Xen. So some tweaks may be required in that part.
> 
> Yup. Hadn't even looked at the cpufreq tries to do yet.
> > 
> > given our purpose now, is to come up a cleaner approach which tolerate some
> > assumptions (e.g. #VCPU of dom0 == #PCPU), there's another option following this
> > trend (perhaps compensate your idea). We can register a Xen-cpuidle and 
> > xen-cpufreq driver to current Linux cpuidle and cpufreq framework, which plays 
> > mainly two roles:
> > 	- a dummy driver to prevent dom0 touching actual Px/Cx
> > 	- parse ACPI Cx/Px information to Xen, in a similar way you did above
> 
> Yeah, I like where you are heading.
> > 
> > there may have some other trickiness, but the majority code will be self-contained.
> 
> <nods>

For reference, the attached module does end up programming the Pxx states in the
hypervisor. The issues that I hit on a Core i3 box (some MSI motherboard) it would fail
on the PCT, but I hadn't really dug into this. And did not look any further in the
Cxx states issue either. On a old Core 2 Duo it looked to have programmed the hypervisor
fine, but the machine afterwards started to act very weird so I am sure there is
something extra that needs to be done (like maybe not using memcpy in this module).

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
 	 * Figure out why.
 	 * Kevin thinks it might be: http://lists.xen.org/archives/html/xen-devel/2011-08/msg00511.html
 	 * But perhaps it is http://lists.xen.org/archives/html/xen-devel/2011-08/msg00521.html?
 	 */
	return 0;
}
static struct xen_processor_px *xen_copy_pss_data(struct acpi_processor *_pr,
		  				  struct xen_processor_performance *xen_perf)
{
	struct xen_processor_px *xen_states = NULL;
	int i;

	xen_states = kzalloc(_pr->performance->state_count *
			     sizeof(struct xen_processor_px), GFP_KERNEL);
	if (!xen_states)
		return ERR_PTR(-ENOMEM);

	xen_perf->state_count = _pr->performance->state_count;
	for (i = 0; i < _pr->performance->state_count; i++) {
		/* Figure out if the lack of __packed is bad */
		memcpy(&(xen_states[i]), &(_pr->performance->states[i]),
		       sizeof(struct acpi_processor_px));
	}
	return xen_states;
}
static int
xen_copy_psd_data(struct acpi_processor *_pr,
		  struct xen_processor_performance *xen_perf)
{
	/* Figure out if the lack of __packed is bad */
	printk(KERN_INFO "psd: %ld\n",
		offsetof(struct xen_processor_performance, domain_info.num_entries));

	xen_perf->shared_type = _pr->performance->shared_type;
	memcpy(&(xen_perf->domain_info), &(_pr->performance->domain_info),
	       sizeof(struct acpi_psd_package));

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
	struct xen_processor_px *xen_states = NULL;

	if (!_pr->performance)
		return -ENODEV;

	xen_perf = &op.u.set_pminfo.perf;

	/* PPC */
	xen_perf->platform_limit = _pr->performance_platform_limit;
	xen_perf->flags |= XEN_PX_PPC;
	/* PCT */
	/* Mmight need to copy them individually as there are no __packed
	 * so the offset might be wrong on a 32-bit host with 64-bit hypervisor. */
	printk(KERN_INFO "address: %ld\n", offsetof(struct xen_processor_performance, control_register.address));
	printk(KERN_INFO "address: %ld\n", offsetof(struct xen_processor_performance, status_register.address));
	printk(KERN_INFO "state_count: %ld\n", offsetof(struct xen_processor_performance, state_count));
	memcpy(&xen_perf->control_register, &(_pr->performance->control_register),
	       sizeof(struct acpi_pct_register));
	memcpy(&xen_perf->status_register, &(_pr->performance->status_register),
	       sizeof(struct acpi_pct_register));
	xen_perf->flags |= XEN_PX_PCT;
	/* PSS */
	xen_states = xen_copy_pss_data(_pr, xen_perf);
	if (!IS_ERR_OR_NULL(xen_states)) {
		set_xen_guest_handle(xen_perf->states, xen_states);
		xen_perf->flags |= XEN_PX_PSS;
	}
	/* PSD */
	if (!xen_copy_psd_data(_pr, xen_perf)) {
		xen_perf->flags |= XEN_PX_PSD;
	}
	printk(KERN_INFO "Sending %x\n", xen_perf->flags);

	ret = HYPERVISOR_dom0_op(&op);
	if (!IS_ERR_OR_NULL(xen_states))
		kfree(xen_states);
	return ret;
}
static int parse_acpi_pxx(struct acpi_processor *_pr)
{
/*
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
*/
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
