Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2CLPLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:11:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37005 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab2CLPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:11:39 -0400
Date: Mon, 12 Mar 2012 11:07:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mike.mcclurg@citrix.com, ke.yu@intel.com, kevin.tian@intel.com,
        xen-devel@lists.xensource.com, davej@redhat.com,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/acpi-processor: C and P-state driver that uploads
 said data to hypervisor.
Message-ID: <20120312150729.GB4236@phenom.dumpdata.com>
References: <1331395500-28033-1-git-send-email-konrad.wilk@oracle.com>
 <1331395500-28033-2-git-send-email-konrad.wilk@oracle.com>
 <4F5DE5AD02000078000779CC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DE5AD02000078000779CC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F5E1223.0058,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:01:49AM +0000, Jan Beulich wrote:
> >>> On 10.03.12 at 17:05, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > [v7: Made it a semi-cpufreq scaling type driver suggested by Jan Beulich 
> 
> I don't see any registration or other hooking up that would match this
> piece of the description.

Oh, a little stale. Should have said : "suggestion by Jan Beulich made me
think about not depending on CPU freq scaling drivers at all."
> 
> > --- a/drivers/xen/Kconfig
> > +++ b/drivers/xen/Kconfig
> > @@ -178,4 +178,21 @@ config XEN_PRIVCMD
> >  	depends on XEN
> >  	default m
> >  
> > +config XEN_ACPI_PROCESSOR
> > +	tristate "Xen ACPI processor"
> > +	depends on XEN && X86 && ACPI_PROCESSOR
> > +	default y if (X86_ACPI_CPUFREQ = y || X86_POWERNOW_K8 = y)
> > +	default m if (X86_ACPI_CPUFREQ = m || X86_POWERNOW_K8 = m)
> 
> I don't think the code itself has any dependencies on this, and as long
> as you interface directly with the "normal" ACPI processor driver there
> also shouldn't be any implicit dependency. Is this hence may just a
> leftover?

It is needed so that the CPU freq scaling drivers don't get called
before this driver is loaded.

Being that if the kernel was compiled with powernow-k8/acpi-cpufreq as
built in, we really want to be loaded before them - to thwart them
from loading. The one way this is done is by calling
 acpi_processor_notify_smm

which on subsequent calls will return -EBUSY for the cpufreq scaling drivers
and inhibit them from being called. Naturally it does not fix the case
if the drivers are built as modules - then the change to load xen-acpi-processor
should be done in the same init script as the one loading powernow-k8/acpi-cpufreq.,

It would be much easier if there was a cpuidle_disable variant in the cpufreq
scaling department - let me see if Dave Jones is open for this, as I can't
see an easy /clean way to make the cpuid checks in the acpi-cpufreq and powernow-k8
changed so that said drivers won't load.


> 
> > +	help
> > +          This ACPI processor uploads Power Management information to the Xen hypervisor.
> > +
> > +	  To do that the driver parses the Power Management data and uploads said
> > +	  information to the Xen hypervisor. Then the Xen hypervisor can select the
> > +          proper Cx and Pxx states. It also registers itslef as the SMM so that
> > +          other drivers (such as ACPI cpufreq scaling driver) will not load.
> > +
> > +          To compile this driver as a module, choose M here: the
> > +          module will be called xen_acpi_processor  If you do not know what to choose,
> > +          select M here. If the CPUFREQ drivers are built in, select Y here.
> > +
> >  endmenu
> > --- /dev/null
> > +++ b/drivers/xen/xen-acpi-processor.c
> > +#define NR_ACPI_CPUS	NR_CPUS
> > +#define MAX_ACPI_BITS	(BITS_TO_LONGS(NR_ACPI_CPUS))
> 
> Rather than arbitrarily limiting this, you could call into Xen at startup
> and scan over all CPUs' ACPI IDs to find the maximum. I think that
> would even cover statically declared hotplug ones, but adding some
> slack may still be necessary to cover dynamic hotplug ones (implying
> that pCPU hotplug patches will make it in at some point).

This would be the XENPF_get_cpuinfo call right? I do plan on looking at the
pCPU hotplug, but I think I need some fancy hardware to test it correctly?

> 
> >...
> > +static int __init check_acpi_ids(struct acpi_processor *pr_backup)
> > +{
> > +	if (!pr_backup)
> > +		return -ENODEV;
> > +
> > +	/* All online CPUs have been processed at this stage. Now verify
> > +	 * whether in fact "online CPUs" == physical CPUs.
> > +	 */
> > +	acpi_id_present = kcalloc(MAX_ACPI_BITS, sizeof(unsigned long), GFP_KERNEL);
> > +	if (!acpi_id_present)
> > +		return -ENOMEM;
> > +
> > +	memset(acpi_id_present, 0, MAX_ACPI_BITS * sizeof(unsigned long));
> 
> kcalloc() already clears the allocated memory.
> 
> > +
> > +	acpi_id_cst_present = kcalloc(MAX_ACPI_BITS, sizeof(unsigned long), GFP_KERNEL);
> > +	if (!acpi_id_cst_present) {
> > +		kfree(acpi_id_present);
> > +		return -ENOMEM;
> > +	}
> > +	memset(acpi_id_cst_present, 0, MAX_ACPI_BITS * sizeof(unsigned long));
> 
> Same here.

Ah yes, one of those paste-n-copy errors.
> 
> > +
> > +	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
> > +			    ACPI_UINT32_MAX,
> > +			    read_acpi_id, NULL, NULL, NULL);
> > +	acpi_get_devices("ACPI0007", read_acpi_id, NULL, NULL);
> > +
> > +	if (!bitmap_equal(acpi_id_present, acpi_ids_done, MAX_ACPI_BITS)) {
> > +		unsigned int i;
> > +
> > +		for_each_set_bit(i, acpi_id_present, MAX_ACPI_BITS) {
> > +			pr_backup->acpi_id = i;
> > +			/* Mask out C-states if there are no _CST */
> > +			pr_backup->flags.power = test_bit(i, acpi_id_cst_present);
> > +			(void)upload_pm_data(pr_backup);
> > +		}
> > +	}
> > +	kfree(acpi_id_present);
> > +	acpi_id_present = NULL;
> > +	kfree(acpi_id_cst_present);
> > +	acpi_id_cst_present = NULL;
> > +	return 0;
> > +}
> > +static int __init check_prereq(void)
> > +{
> > +	struct cpuinfo_x86 *c = &cpu_data(0);
> > +
> > +	if (!xen_initial_domain())
> > +		return -ENODEV;
> > +
> > +	if (!acpi_gbl_FADT.smi_command)
> > +		return -ENODEV;
> > +
> > +	if (c->x86_vendor == X86_VENDOR_INTEL) {
> > +		if (!cpu_has(c, X86_FEATURE_EST))
> > +			return -ENODEV;
> > +
> > +		return 0;
> > +	}
> > +	if (c->x86_vendor == X86_VENDOR_AMD) {
> > +		/* Copied from powernow-k8.h, can't include ../xen-acpi-processor/powernow
> > +		 * as we get compile warnings for the static functions.
> > +		 */
> 
> If drivers/cpufreq/powernow-k[78].h are supposed to be useful at all
> (which they currently aren't as both get included in just a single place),
> those static function declarations should be removed from the latter.

<nods> Will post a seperate patch for that.
> 
> > +#define CPUID_FREQ_VOLT_CAPABILITIES    0x80000007
> > +#define USE_HW_PSTATE                   0x00000080
> > +		u32 eax, ebx, ecx, edx;
> > +		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
> > +		if ((edx & USE_HW_PSTATE) != USE_HW_PSTATE)
> > +			return -ENODEV;
> > +		return 0;
> > +	}
> > +	return -ENODEV;
> > +}
> >...
> > +static int __init xen_acpi_processor_init(void)
> > +{
> > +	struct acpi_processor *pr_backup = NULL;
> > +	unsigned int i;
> > +	int rc = check_prereq();
> > +
> > +	if (rc)
> > +		return rc;
> > +
> > +	acpi_ids_done = kcalloc(MAX_ACPI_BITS, sizeof(unsigned long), GFP_KERNEL);
> > +	if (!acpi_ids_done)
> > +		return -ENOMEM;
> > +
> > +	memset(acpi_ids_done, 0, MAX_ACPI_BITS * sizeof(unsigned long));
> 
> Pointless kcalloc() + memset() again.
> 
> > +
> > +	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
> > +	if (!acpi_perf_data) {
> > +		pr_debug(DRV_NAME "Memory allocation error for acpi_perf_data.\n");
> > +		kfree(acpi_ids_done);
> > +		return -ENOMEM;
> > +	}
> > +	for_each_possible_cpu(i) {
> > +		if (!zalloc_cpumask_var_node(
> > +			&per_cpu_ptr(acpi_perf_data, i)->shared_cpu_map,
> > +			GFP_KERNEL, cpu_to_node(i))) {
> > +			rc = -ENOMEM;
> > +			goto err_out;
> > +		}
> > +	}
> > +
> > +	/* Do initialization in ACPI core */
> > +	rc = acpi_processor_preregister_performance(acpi_perf_data);
> > +	if (WARN_ON(rc))
> > +		goto err_out;
> > +
> > +	for_each_possible_cpu(i) {
> > +		struct acpi_processor_performance *perf;
> > +
> > +		perf = per_cpu_ptr(acpi_perf_data, i);
> > +		rc = acpi_processor_register_performance(perf, i);
> > +		if (WARN_ON(rc))
> > +			goto err_out;
> > +	}
> > +	rc = acpi_processor_notify_smm(THIS_MODULE);
> > +	if (WARN_ON(rc))
> > +		goto err_unregister;
> > +
> > +	for_each_possible_cpu(i) {
> > +		struct acpi_processor *_pr;
> > +		_pr = per_cpu(processors, i /* APIC ID */);
> > +		if (!_pr)
> > +			continue;
> > +
> > +		if (!pr_backup) {
> > +			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
> > +			memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
> > +		}
> > +		(void)upload_pm_data(_pr);
> > +	}
> > +	rc = check_acpi_ids(pr_backup);
> > +	if (rc)
> > +		goto err_unregister;
> > +
> > +	kfree(pr_backup);
> > +	register_hotcpu_notifier(&xen_cpu_notifier);
> 
> This is pointless - you'd get notified of vCPU-s arrival/departure only.
> Without pCPU hotplug code in place, there's just nothing you can (and
> need to) do here.

I hadn't actually looked in details on the pCPU hotplug code to see how it works.

I presume I need special hardware for this to work as well as the ACPI
is involved in triggering the hotplug CPU up calls?

> 
> > +
> > +	return 0;
> > +err_unregister:
> > +	for_each_possible_cpu(i) {
> > +		struct acpi_processor_performance *perf;
> > +		perf = per_cpu_ptr(acpi_perf_data, i);
> > +		acpi_processor_unregister_performance(perf, i);
> > +	}
> > +err_out:
> > +	/* Freeing a NULL pointer is OK: alloc_percpu zeroes. */
> > +	free_acpi_perf_data();
> > +	kfree(acpi_ids_done);
> > +	return rc;
> > +}
> 
> Overall this version looks a lot better to me than the previous ones.

Yeah, and it drops the dependency on those Xen patches I had sent earlier.
Thanks for taking a look!

> 
> Jan
