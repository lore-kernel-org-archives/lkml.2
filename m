Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2AWQ45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:56:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30429 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2AWQ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:56:54 -0500
Date: Mon, 23 Jan 2012 11:53:25 -0500
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
Message-ID: <20120123165325.GB5599@phenom.dumpdata.com>
References: <20111220153145.GB13253@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC469@shsmsx502.ccr.corp.intel.com>
 <20111223030103.GA7218@andromeda.dapyr.net>
 <AADFC41AFE54684AB9EE6CBC0274A5D10145B9@SHSMSX102.ccr.corp.intel.com>
 <20120103205925.GI17472@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D102D62B@SHSMSX102.ccr.corp.intel.com>
 <20120113222451.GA6922@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D10FCD37A9@SHSMSX102.ccr.corp.intel.com>
 <20120117171314.GB5494@phenom.dumpdata.com>
 <20120117181922.GA12900@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20120117181922.GA12900@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F1D9114.0047,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2012 at 01:19:22PM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 17, 2012 at 12:13:14PM -0500, Konrad Rzeszutek Wilk wrote:
> > > > I was trying to figure out how difficult it would be to just bring Pxx states to
> > > > the Xen hypervisor using the existing ACPI interfaces. And while it did not pass
> > > > all the _Pxx states (seems that all the _PCT, _PSS, _PSD, _PPC flags need to
> > > > be enabled in the hypercall to make this work), it demonstrates what I had in
> > > > mind. 
> > 
> > .. snip..
> > > > 	/* TODO: Under Xen, the C-states information is not present.
> > > >  	 * Figure out why. */
> > > 
> > > it's possible related to this long thread:
> > > 
> > > http://lists.xen.org/archives/html/xen-devel/2011-08/msg00511.html
> > > 
> > > IOW, Xen doesn't export mwait capability to dom0, which impacts _PDC setting.
> > > Final solution is to have a para-virtualized PDC call for that.
> > 
> > Aaah. Let me play with that a bit. Thanks for the pointer.

Found out the reason. It was that the hypervisor did not expose the MWAIT
bit and that dom0 was setting boot_option_idle...

The #1 patch has the fix for that.

.. snip.
> > > which in current form may add some negative impact, e.g. dom0 will try to control
> > > Px/Cx to conflict with Xen. So some tweaks may be required in that part.
> > 
> > Yup. Hadn't even looked at the cpufreq tries to do yet.
> > > 
> > > given our purpose now, is to come up a cleaner approach which tolerate some
> > > assumptions (e.g. #VCPU of dom0 == #PCPU), there's another option following this
> > > trend (perhaps compensate your idea). We can register a Xen-cpuidle and 
> > > xen-cpufreq driver to current Linux cpuidle and cpufreq framework, which plays 
> > > mainly two roles:
> > > 	- a dummy driver to prevent dom0 touching actual Px/Cx

This is still TODO - I hadn't really looked to see what dom0 does and
if the hypervisor ignores the dom0 (I sure it does so!). 

But interestigly enough, the cpuidle driver is not doing anything
b/c the cpuidle_disable() call which inhibits it from running.
So we might not a dummy driver for cpuidle. Not so sure about cpufreq.

> > > 	- parse ACPI Cx/Px information to Xen, in a similar way you did above

The attached #2 patch does that - and it works at least on Intel machines.
I hadn't done any extensive testing, like doing 'xl vcpu-set 0 X' as that
seems to crash on 3.3 - irregardless of these patches :-)

But 'xenpm' and running some guests seems to work just fine so I am
hopefull.

There are still some TODOs with this:
 - which is how to make the module be autoloaded after the processor.ko
   (or rather acpi_cpufreq_cpu_init) has been loaded. As right now you
   have to manually load the driver.
 - make it work under AMD. I think that requires trapping the MSR call.
 - check the cpufreq notification calls.
 - double check that cpuidle is indeed not called.
 - play with dom0_max_vcpus= or 'xl vcpu-set 0 1'


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xen-setup-pm-acpi-Remove-the-call-to-boot_option_idl.patch"

>From da1c22723b17b4250a81126afa97b5710cede030 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 23 Jan 2012 10:53:57 -0500
Subject: [PATCH 1/2] xen/setup/pm/acpi: Remove the call to
 boot_option_idle_override.

We needed that call in the past to force the kernel to use
default_idle (which called safe_halt, which called xen_safe_halt).

But set_pm_idle_to_default() does now that, so there is no need
to use this boot option operand.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index e03c636..1236623 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -420,7 +420,6 @@ void __init xen_arch_setup(void)
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
 	disable_cpuidle();
-	boot_option_idle_override = IDLE_HALT;
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
 }
-- 
1.7.7.5


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-xen-acpi-Provide-a-ACPI-driver-that-sends-processor-.patch"

>From b3dfedc6a77c324a4fb5a7171903a5d91056282d Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 23 Jan 2012 11:05:02 -0500
Subject: [PATCH 2/2] xen/acpi: Provide a ACPI driver that sends "processor"
 data to the hypervisor.

The ACPI processor processes the _Pxx and the _Cx state information
which are populated in the 'processor' per-cpu structure. We read
the contents of that structure and pipe it up the Xen hypervisor.

We assume that the ACPI processor is smart and did all the filtering
work so that the contents is correct. After we are done parsing
the information, we unload ourselves and let the hypervisor deal
with cpufreq, cpuidle states and such.

Note: This only works right now under Intel CPUs, b/c the Xen hypervisor
does not properly process the AMD MSR_PSTATE_CUR_LIMIT and the hypervisor
should pass in the MWAIT CPU attribute:

http://old-list-archives.xen.org/archives/html/xen-devel/2011-08/msg00511.html

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig         |    5 +
 drivers/xen/Makefile        |    2 +-
 drivers/xen/acpi_xen_sink.c |  265 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 271 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/acpi_xen_sink.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index a1ced52..747ef17 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -178,4 +178,9 @@ config XEN_PRIVCMD
 	depends on XEN
 	default m
 
+config XEN_ACPI_SINK
+	tristate
+	depends on XEN && ACPI_PROCESSOR && CPU_FREQ
+	default m
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index aa31337..1585b35 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+= pci.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
-
+obj-$(CONFIG_XEN_ACPI_SINK)		+= acpi_xen_sink.o
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
 xen-gntalloc-y				:= gntalloc.o
diff --git a/drivers/xen/acpi_xen_sink.c b/drivers/xen/acpi_xen_sink.c
new file mode 100644
index 0000000..78771ca
--- /dev/null
+++ b/drivers/xen/acpi_xen_sink.c
@@ -0,0 +1,265 @@
+
+#define DEBUG 1
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/processor.h>
+#include <linux/cpumask.h>
+
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+
+#define DRV_NAME	"ACPI_Xen_Sink"
+MODULE_AUTHOR("Konrad Rzeszutek Wilk");
+MODULE_DESCRIPTION("ACPI Power Management driver to send data to Xen hypervisor");
+MODULE_LICENSE("GPL");
+
+static int __init push_cxx_to_hypervisor(struct acpi_processor *_pr)
+{
+	struct xen_platform_op op = {
+		.cmd			= XENPF_set_processor_pminfo,
+		.interface_version	= XENPF_INTERFACE_VERSION,
+		.u.set_pminfo.id	= _pr->acpi_id,
+		.u.set_pminfo.type	= XEN_PM_CX,
+	};
+	struct xen_processor_cx *xen_cx, *xen_cx_states = NULL;
+	struct acpi_processor_cx *cx;
+	int i, ok, ret = 0;
+
+	if (!_pr->flags.power_setup_done)
+		return -ENODEV;
+
+	xen_cx_states = kcalloc(_pr->power.count,
+				sizeof(struct xen_processor_cx), GFP_KERNEL);
+	if (!xen_cx_states)
+		return -ENOMEM;
+
+	for (ok = 0, i = 1; i <= _pr->power.count; i++) {
+		cx = &_pr->power.states[i];
+		if (!cx->valid)
+			continue;
+
+		xen_cx = &(xen_cx_states[ok++]);
+
+		xen_cx->reg.space_id = ACPI_ADR_SPACE_SYSTEM_IO;
+		if (cx->entry_method == ACPI_CSTATE_SYSTEMIO) {
+			/* TODO: double check whether anybody cares about it */
+			xen_cx->reg.bit_width = 8;
+			xen_cx->reg.bit_offset = 0;
+		} else {
+			xen_cx->reg.space_id = ACPI_ADR_SPACE_FIXED_HARDWARE;
+			if (cx->entry_method == ACPI_CSTATE_FFH) {
+				/* NATIVE_CSTATE_BEYOND_HALT */
+				xen_cx->reg.bit_offset = 2;
+				xen_cx->reg.bit_width = 1; /* VENDOR_INTEL */
+			}
+		}
+		xen_cx->reg.access_size = 0;
+		xen_cx->reg.address = cx->address;
+
+		xen_cx->type = cx->type;
+		xen_cx->latency = cx->latency;
+		xen_cx->power = cx->power;
+
+		xen_cx->dpcnt = 0;
+		set_xen_guest_handle(xen_cx->dp, NULL);
+
+		pr_debug("\t_CX: ID:%d [C%d:%s]\n", _pr->acpi_id, i, cx->desc);
+	}
+	if (!ok) {
+		pr_err("No available Cx info for cpu %d\n", _pr->acpi_id);
+		kfree(xen_cx_states);
+		return -EINVAL;
+	}
+	op.u.set_pminfo.power.count = ok;
+	op.u.set_pminfo.power.flags.bm_control = _pr->flags.bm_control;
+	op.u.set_pminfo.power.flags.bm_check = _pr->flags.bm_check;
+	op.u.set_pminfo.power.flags.has_cst = _pr->flags.has_cst;
+	op.u.set_pminfo.power.flags.power_setup_done =
+		_pr->flags.power_setup_done;
+
+	set_xen_guest_handle(op.u.set_pminfo.power.states, xen_cx_states);
+
+	if (xen_initial_domain())
+		ret = HYPERVISOR_dom0_op(&op);
+
+	kfree(xen_cx_states);
+
+	return ret;
+}
+
+
+
+static struct xen_processor_px *
+__init xen_copy_pss_data(struct acpi_processor *_pr,
+			 struct xen_processor_performance *xen_perf)
+{
+	struct xen_processor_px *xen_states = NULL;
+	int i;
+
+	xen_states = kcalloc(_pr->performance->state_count,
+			     sizeof(struct xen_processor_px), GFP_KERNEL);
+	if (!xen_states)
+		return ERR_PTR(-ENOMEM);
+
+	xen_perf->state_count = _pr->performance->state_count;
+
+	BUILD_BUG_ON(sizeof(struct xen_processor_px) !=
+		     sizeof(struct acpi_processor_px));
+	for (i = 0; i < _pr->performance->state_count; i++) {
+
+		/* Fortunatly for us, they both have the same size */
+		memcpy(&(xen_states[i]), &(_pr->performance->states[i]),
+		       sizeof(struct acpi_processor_px));
+#ifdef DEBUG
+		{
+			struct xen_processor_px *_px;
+			_px = &(xen_states[i]);
+			pr_debug("\t_PSS: [%2d]: %d, %d, %d, %d, %d, %d\n", i,
+				(u32)_px->core_frequency, (u32)_px->power,
+				(u32)_px->transition_latency,
+				(u32)_px->bus_master_latency, (u32)_px->control,
+				(u32)_px->status);
+		}
+#endif
+	}
+	return xen_states;
+}
+static int __init xen_copy_psd_data(struct acpi_processor *_pr,
+				    struct xen_processor_performance *xen_perf)
+{
+	xen_perf->shared_type = _pr->performance->shared_type;
+
+	BUILD_BUG_ON(sizeof(struct xen_psd_package) !=
+		     sizeof(struct acpi_psd_package));
+	memcpy(&(xen_perf->domain_info), &(_pr->performance->domain_info),
+	       sizeof(struct acpi_psd_package));
+
+#if DEBUG
+	{
+		struct xen_psd_package *_psd;
+		_psd = &(xen_perf->domain_info);
+		pr_debug("\t_PSD: num_entries:%d rev=%d domain=%d coord_type=%d, "
+			 "num_processers=%d\n", (u32)_psd->num_entries,
+			 (u32)_psd->revision, (u32)_psd->domain,
+			 (u32)_psd->coord_type, (u32)_psd->num_processors);
+	}
+#endif
+	return 0;
+}
+static int __init xen_copy_pct_data(struct acpi_pct_register *pct,
+				    struct xen_pct_register *_pct)
+{
+	/* It would be nice if you could just do 'memcpy(pct, _pct') but
+	 * sadly the Xen structure did not have the proper padding
+	 * so the descriptor field takes two (_pct) bytes instead of one (pct).
+	 */
+	_pct->descriptor = pct->descriptor;
+	_pct->length = pct->length;
+	_pct->space_id = pct->space_id;
+	_pct->bit_width = pct->bit_width;
+	_pct->bit_offset = pct->bit_offset;
+	_pct->reserved = pct->reserved;
+	_pct->address = pct->address;
+#ifdef DEBUG
+	pr_debug("\t_PCT: descriptor=%d, length=%d, space_id=%d, "
+		 "bit_width=%d, bit_offset=%d), reserved=%d, address=0x%x\n",
+		 _pct->descriptor, _pct->length, _pct->space_id,
+		 _pct->bit_width, _pct->bit_offset, _pct->reserved,
+		 (u32)_pct->address);
+#endif
+	return 0;
+}
+static int __init push_pxx_to_hypervisor(struct acpi_processor *_pr)
+{
+	int ret = -EINVAL;
+	struct xen_platform_op op = {
+		.cmd			= XENPF_set_processor_pminfo,
+		.interface_version	= XENPF_INTERFACE_VERSION,
+		.u.set_pminfo.id	= _pr->acpi_id,
+		.u.set_pminfo.type	= XEN_PM_PX,
+	};
+	struct xen_processor_performance *xen_perf;
+	struct xen_processor_px *xen_states = NULL;
+
+	if (!_pr->performance)
+		return -ENODEV;
+
+	xen_perf = &op.u.set_pminfo.perf;
+
+	/* PPC */
+	xen_perf->platform_limit = _pr->performance_platform_limit;
+	xen_perf->flags |= XEN_PX_PPC;
+	/* PCT */
+	xen_copy_pct_data(&(_pr->performance->control_register),
+			  &xen_perf->control_register);
+	xen_copy_pct_data(&(_pr->performance->status_register),
+			  &xen_perf->status_register);
+	xen_perf->flags |= XEN_PX_PCT;
+	/* PSS */
+	xen_states = xen_copy_pss_data(_pr, xen_perf);
+	if (!IS_ERR_OR_NULL(xen_states)) {
+		set_xen_guest_handle(xen_perf->states, xen_states);
+		xen_perf->flags |= XEN_PX_PSS;
+	}
+	/* PSD */
+	if (!xen_copy_psd_data(_pr, xen_perf))
+		xen_perf->flags |= XEN_PX_PSD;
+
+	if (xen_initial_domain())
+		ret = HYPERVISOR_dom0_op(&op);
+
+	if (!IS_ERR_OR_NULL(xen_states))
+		kfree(xen_states);
+	return ret;
+}
+
+static int __init acpi_xen_sink_init(void)
+{
+	int cpu;
+	int err = -ENODEV;
+	struct acpi_processor *_pr;
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	/* TODO: Under AMD, the information is populated
+	 * using the powernow-k8 driver which does an MSR_PSTATE_CUR_LIMIT
+	 * MSR which returns the wrong value (under Xen) so the population
+	 * of 'processors' has bogus data. So only run this under
+	 * Intel for right now. */
+	if (!cpu_has(c, X86_FEATURE_EST)) {
+		pr_err("AMD platform is not supported (yet)\n");
+		return -ENODEV;
+	}
+	/*
+	 * It is imperative that we get called _after_ acpi_processor has
+	 * loaded. Otherwise the _pr might be bogus.
+	*/
+	if (request_module("processor")) {
+		pr_err("Unable to load ACPI processor module!\n");
+		return -ENODEV;
+	}
+	for_each_possible_cpu(cpu) {
+		_pr = per_cpu(processors, cpu);
+		if (!_pr)
+			continue;
+
+		if (_pr->flags.power)
+			err = push_cxx_to_hypervisor(_pr);
+
+		if (_pr->performance->states)
+			err |= push_pxx_to_hypervisor(_pr);
+		if (err)
+			break;
+	}
+	return -ENODEV; /* force it to unload */
+}
+static void __exit acpi_xen_sink_exit(void)
+{
+}
+module_init(acpi_xen_sink_init);
+module_exit(acpi_xen_sink_exit);
-- 
1.7.7.5


--cWoXeonUoKmBZSoM--
