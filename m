Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2CMIVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:21:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58722 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2CMIVl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Tue, 13 Mar 2012 04:21:41 -0400
Message-Id: <4F5F11A00200007800077DD4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 13 Mar 2012 08:21:36 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <mike.mcclurg@citrix.com>, <ke.yu@intel.com>, <kevin.tian@intel.com>,
        <xen-devel@lists.xensource.com>, <davej@redhat.com>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/acpi-processor: C and P-state driver that
 uploads said data to hypervisor.
References: <1331395500-28033-1-git-send-email-konrad.wilk@oracle.com>
 <1331395500-28033-2-git-send-email-konrad.wilk@oracle.com>
 <4F5DE5AD02000078000779CC@nat28.tlf.novell.com>
 <20120312150729.GB4236@phenom.dumpdata.com>
 <4F5E23CA0200007800077B90@nat28.tlf.novell.com>
 <20120313033541.GB17536@phenom.dumpdata.com>
In-Reply-To: <20120313033541.GB17536@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.03.12 at 04:35, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> +static unsigned int __init get_max_acpi_id(void)
> +{
> +	struct xenpf_pcpuinfo *info;
> +	struct xen_platform_op op = {
> +		.cmd = XENPF_get_cpuinfo,
> +		.interface_version = XENPF_INTERFACE_VERSION,
> +	};
> +	int ret = 0;
> +	unsigned int i, max_apic_id, max_acpi_id = 0;
> +
> +	info = &op.u.pcpu_info;
> +	info->xen_cpuid = 0;
> +
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return max_acpi_id;
> +
> +	/* The max_present is the same irregardless of the xen_cpuid */
> +	max_apic_id = op.u.pcpu_info.max_present;

The 'apic' in the name here is confusing, as this isn't an APIC ID, but
(Xen) ID of the last present CPU (i.e. one less than the maximum
count).

> +	for (i = 0; i <= max_apic_id; i++) {
> +		info->xen_cpuid = i;
> +		ret = HYPERVISOR_dom0_op(&op);
> +		if (ret)
> +			continue;
> +		max_acpi_id = max(info->acpi_id, max_acpi_id);
> +	}
> +	pr_debug(DRV_NAME "Max ACPI ID: %u\n", max_acpi_id);
> +	return max_acpi_id;

Iirc hotplug CPUs may not be represented in MADT, and hence I'd
suggest adding some slack here (e.g. doubling the value).

> +}

Now, if the whole thing could become a true extension to processor.ko,
the fishy (and too weak in the 'm' case, as you noted yourself) Kconfig
dependency on the cpufreq drivers could go away, since both
acpi-cpufreq and powernow-k8 depend on ACPI_PROCESSOR. Which
would at once put it on par with the XenoLinux placement (in terms of
the point in time when it gets executed) of the code.

Jan

