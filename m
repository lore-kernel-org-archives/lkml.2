Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2AaPfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:35:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21291 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2AaPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:34:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, lenb@kernel.org, len.brown@intel.com,
        linux-acpi@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/acpi: Provide a ACPI driver that sends "processor" data to the hypervisor.
Date: Tue, 31 Jan 2012 10:32:04 -0500
Message-Id: <1328023924-6858-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1328023924-6858-1-git-send-email-konrad.wilk@oracle.com>
References: <1328023924-6858-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F280A13.0022,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI processor processes the _Pxx and the _Cx state information
which are populated in the 'processor' per-cpu structure. We read
the contents of that structure and pipe it up the Xen hypervisor.

We assume that the ACPI processor is smart and did all the filtering
work so that the contents is correct. After we are done parsing
the information, we unload ourselves and let the hypervisor deal
with cpufreq, cpuidle states and such.

Note: This only works right now under Intel CPUs, b/c the Xen hypervisor
does not properly process the AMD MSR_PSTATE_CUR_LIMIT under AMD.

For Intel the hypervisor needs this patch
http://old-list-archives.xen.org/archives/html/xen-devel/2011-08/msg00511.html

which passes inthe MWAIT CPU attribute.

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

