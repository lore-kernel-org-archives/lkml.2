Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748Ab2BNUUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:20:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51307 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab2BNUUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:20:42 -0500
Message-ID: <1329250830.2293.24.camel@twins>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Date: Tue, 14 Feb 2012 21:20:30 +0100
In-Reply-To: <1329237838.2293.20.camel@twins>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1329236924.2293.13.camel@twins> <1329237838.2293.20.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 17:43 +0100, Peter Zijlstra wrote:
> > I added the below but all I managed was to crash my kernel, its probably
> > a simple thing, but sysfs didn't give a hint. 

OK, this one works. the attributes thing wants NULL termination. Thanks
for mentioning that Jiri.

---
Subject: perf, x86: Add simple format descriptions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Feb 14 16:37:27 CET 2012


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |    7 ++++++
 arch/x86/kernel/cpu/perf_event.h       |    1 
 arch/x86/kernel/cpu/perf_event_amd.c   |   19 +++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |   36 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c    |   19 +++++++++++++++++
 include/linux/perf_event.h             |    6 -----
 kernel/events/core.c                   |   22 --------------------
 7 files changed, 82 insertions(+), 28 deletions(-)
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1250,6 +1250,11 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
+static struct attribute_group x86_pmu_format_group = {
+	.name = "format",
+	.attrs = NULL,
+};
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1324,6 +1329,7 @@ static int __init init_hw_perf_events(vo
 	}
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
@@ -1604,6 +1610,7 @@ static struct attribute_group x86_pmu_at
 
 static const struct attribute_group *x86_pmu_attr_groups[] = {
 	&x86_pmu_attr_group,
+	&x86_pmu_format_group,
 	NULL,
 };
 
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -311,6 +311,7 @@ struct x86_pmu {
 	 * sysfs attrs
 	 */
 	int		attr_rdpmc;
+	struct attribute **format_attrs;
 
 	/*
 	 * CPU Hotplug hooks
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -398,6 +398,21 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *amd_format_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -420,6 +435,8 @@ static __initconst const struct x86_pmu 
 	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
+	.format_attrs		= amd_format_attr,
+
 	.cpu_prepare		= amd_pmu_cpu_prepare,
 	.cpu_starting		= amd_pmu_cpu_starting,
 	.cpu_dead		= amd_pmu_cpu_dead,
@@ -590,6 +607,8 @@ static __initconst const struct x86_pmu 
 	.cpu_starting		= amd_pmu_cpu_starting,
 	.cpu_dead		= amd_pmu_cpu_dead,
 #endif
+
+	.format_attrs		= amd_format_attr,
 };
 
 __init int amd_pmu_init(void)
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1382,6 +1382,24 @@ static void core_pmu_enable_all(int adde
 	}
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(pc,	"config:19"	);
+PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_arch_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -1406,6 +1424,7 @@ static __initconst const struct x86_pmu 
 	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 	.guest_get_msrs		= core_guest_get_msrs,
+	.format_attrs		= intel_arch_formats_attr,
 };
 
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1486,6 +1505,21 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
+PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
+
+static struct attribute *intel_arch3_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_any.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+
+	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	NULL,
+};
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -1509,6 +1543,8 @@ static __initconst const struct x86_pmu 
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
 
+	.format_attrs		= intel_arch3_formats_attr,
+
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -87,6 +87,23 @@ static void p6_pmu_enable_event(struct p
 	(void)checking_wrmsrl(hwc->config_base, val);
 }
 
+PMU_FORMAT_ATTR(event,	"config:0-7"	);
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
+PMU_FORMAT_ATTR(edge,	"config:18"	);
+PMU_FORMAT_ATTR(pc,	"config:19"	);
+PMU_FORMAT_ATTR(inv,	"config:23"	);
+PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+
+static struct attribute *intel_p6_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -115,6 +132,8 @@ static __initconst const struct x86_pmu 
 	.cntval_mask		= (1ULL << 32) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= p6_event_constraints,
+
+	.format_attrs		= intel_p6_formats_attr,
 };
 
 __init int p6_pmu_init(void)
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -628,12 +628,6 @@ struct pmu {
 	int				task_ctx_nr;
 
 	/*
-	 * True if the pmu defines its own set of format attributes within
-	 * attr_groups. If false, default format attributes are used.
-	 */
-	bool				format_defined;
-
-	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
 	 * as well as for lazy/batch writing of the MSRs.
 	 */
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5540,22 +5540,6 @@ static struct bus_type pmu_bus = {
 	.dev_attrs	= pmu_dev_attrs,
 };
 
-/* Default format attributes. */
-PMU_FORMAT_ATTR(config,  "config:0-63");
-PMU_FORMAT_ATTR(config1, "config1:0-63");
-PMU_FORMAT_ATTR(config2, "config2:0-63");
-
-static struct attribute *format_attrs[] = {
-	&format_attr_config.attr,
-	&format_attr_config1.attr,
-	&format_attr_config2.attr,
-};
-
-static struct attribute_group format_attr_group = {
-	.name   = "format",
-	.attrs  = format_attrs,
-};
-
 static void pmu_dev_release(struct device *dev)
 {
 	kfree(dev);
@@ -5582,12 +5566,6 @@ static int pmu_dev_alloc(struct pmu *pmu
 	if (ret)
 		goto free_dev;
 
-	if (!pmu->format_defined) {
-		ret = sysfs_create_group(&pmu->dev->kobj, &format_attr_group);
-		if (ret)
-			goto free_dev;
-	}
-
 out:
 	return ret;
 

