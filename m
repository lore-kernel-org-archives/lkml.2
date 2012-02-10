Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab2BJRVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:21:55 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39606 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2BJRVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:21:53 -0500
Date: Fri, 10 Feb 2012 12:18:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com
Subject: Re: [PATCH 5/8] ACPI: add processor driver for Xen virtual CPUs.
Message-ID: <20120210171838.GB25046@phenom.dumpdata.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F355228.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (pr->id == -1) {
> +		int device_declaration;
> +		int apic_id = -1;
> +
> +		if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_OBJECT_HID))
> +			device_declaration = 0;
> +		else
> +			device_declaration = 1;
> +
> +		apic_id = acpi_get_cpuid(pr->handle,
> +			device_declaration, pr->acpi_id);
> +		if (apic_id == -1) {
> +			/* Processor is not present in MADT table */

So I was struggling to find an easy way to make the cases below (where
VCPU != physical CPU) work with using the driver that iterates over the
'processor' and was mystified to why it would not work, even with this
patchset. Found out that the acpi_get_cpuid does this:


201 #ifdef CONFIG_SMP
202         for_each_possible_cpu(i) {
203                 if (cpu_physical_id(i) == apic_id)
204                         return i;
205         }

and since not-online vCPUs (so dom0_max_vcpus) are not in the "possible"
bitmask, we never get to check line 203 and end up returning -1 for
offline/not-present/not-possible vCPUs.

Which means that we end up here:
> +			return 0;
> +		}
> +

instead of going through the pr->id = 0.

By the end of this, the information that the hypervisor gets is
actually limited to the amount of CPUs that we specified in dom0_max_vcpus=

> +		/*
> +		 * It's possible to have pr->id as '-1' even when it's actually
> +		 * present in MADT table, e.g. due to limiting dom0 max vcpus
> +		 * less than physical present number. In such case we still want
> +		 * to parse ACPI processor object information, so mimic the
> +		 * pr->id to CPU-0. This should be safe because we only care
> +		 * about raw ACPI information, which only relies on pr->acpi_id.
> +		 * For other information relying on pr->id and gathered through
> +		 * SMP function call, it's safe to let them run on CPU-0 since
> +		 * underlying Xen will collect them. Only a valid pr->id can
> +		 * make later invocations forward progress.
> +		 */
> +		pr->id = 0;
> +	}
