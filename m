Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657Ab2JLIsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:48:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29782 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab2JLIsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:48:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344211200"; 
   d="scan'208";a="15120690"
Message-ID: <1350031728.14806.45.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 1/7]: PVH: basic and header changes,
	elfnote changes, ...
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 09:48:48 +0100
In-Reply-To: <20121011145317.51655302@mantra.us.oracle.com>
References: <20121011145317.51655302@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 22:53 +0100, Mukesh Rathor wrote:
> PVH: is a PV linux guest that has extended capabilities. This patch allows it to be configured and enabled. Also, basic header file changes to add new subcalls to physmap hypercall. Lastly, mfn_to_local_pfn must return mfn for paging mode translate
> 
> Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>

Since a S-o-b is a quasi-legal statement you probably ought to put your
full name here (I know it's obvious from the email address, but...)

> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index fdce49c..9323b8c 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -50,3 +50,13 @@ config XEN_DEBUG_FS
>  	  Enable statistics output and various tuning options in debugfs.
>  	  Enabling this option may incur a significant performance overhead.
>  
> +config XEN_X86_PVH
> +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> +	depends on X86_64 && XEN && INTEL_IOMMU && EXPERIMENTAL

OOI why does the kernel side require an INTEL_IOMMU? I can see why the
hypervisor would need it but the guests (including dom0) can't actually
see the underlying IOMMU, can they?

> +	default n
> +	help
> +	   This option enables support for running as a PVH guest (PV guest
> +	   using hardware extensions) under a suitably capable hypervisor.
> +	   This option is EXPERIMETNAL because the hypervisor interfaces

You've carried over my original "EXPERIMETNAL" typo.

> +	   which it uses are not yet considered stable therefore backwards and
> +	   forwards compatibility is not yet guaranteed.  If unsure, say N.
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 7faed58..3e65ece 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -13,6 +13,15 @@
>  #include <xen/interface/elfnote.h>
>  #include <asm/xen/interface.h>
>  
> +#ifdef CONFIG_XEN_X86_PVH
> +#define FEATURES_PVH "| writable_descriptor_tables" \
> +		     "| auto_translated_physmap" \
> +		     "| supervisor_mode_kernel" \
> +		     "| hvm_callback_vector"

It's pretty lame but it looks like elf_xen_parse_features doesn't
support stripping whitespace.

Since we need these features to be parsable by older hypervisors and
tools I think we're stuck with that snafu.

> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 9ce788d..3b9d5b6 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -258,6 +258,16 @@ struct physdev_pci_device {
>      uint8_t devfn;
>  };
>  
> +#define PHYSDEVOP_pvh_map_iomem        30
> +struct physdev_map_iomem {
> +    /* IN */
> +    uint64_t first_gfn;
> +    uint64_t first_mfn;
> +    uint32_t nr_mfns;
> +    uint32_t add_mapping;        /* 1 == add mapping;  0 == unmap */
> +
> +};
> +
>  /*
>   * Notify that some PIRQ-bound event channels have been unmasked.
>   * ** This command is obsolete since interface version 0x00030202 and is **


