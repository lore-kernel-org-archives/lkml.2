Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab2BJPuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:50:04 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:5431 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab2BJPuC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 10 Feb 2012 10:50:02 -0500
Message-Id: <4F354AB6020000780007267B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 10 Feb 2012 15:49:58 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <liang.tang@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <mjg59@srcf.ucam.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/5] EFI: add efi driver for Xen efi
References: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
 <1328758401-24258-1-git-send-email-liang.tang@oracle.com>
In-Reply-To: <1328758401-24258-1-git-send-email-liang.tang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.02.12 at 04:33, Tang Liang <liang.tang@oracle.com> wrote:

As noted in a private mail already, this lack a From:, as large parts of
this are quite obviously derived from what we have in our SLE and
openSUSE trees. Feel free to also stick my Signed-off-by in further
down.

> The efi memory is owned by Xen and efi run-time service can not be called
> directly,so a new efi driver is needed by Xen efi.
> We call efi run-time service through the Xen in Xen efi driver.
> 
> Signed-off-by: Tang Liang <liang.tang@oracle.com>
> 
> --- a/arch/x86/platform/efi/Makefile
> +++ b/arch/x86/platform/efi/Makefile
> @@ -1 +1,4 @@
>  obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
> +ifdef CONFIG_XEN
> +obj-$(CONFIG_EFI)		+= efi-xen.o

Calling this just xen.c would seem more natural to me. The *-xen.c
naming convention really is necessary only in the legacy (and forward
ported) trees.

> +endif
> diff --git a/arch/x86/platform/efi/efi-xen.c b/arch/x86/platform/efi/efi-xen.c
> new file mode 100644
> index 0000000..f4f6235
> --- /dev/null
> +++ b/arch/x86/platform/efi/efi-xen.c
> @@ -0,0 +1,432 @@
> +/*
> + * Common EFI (Extensible Firmware Interface) support functions
> + * Based on Extensible Firmware Interface Specification version 1.0
> + *
> + * Copyright (C) 1999 VA Linux Systems
> + * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
> + * Copyright (C) 1999-2002 Hewlett-Packard Co.
> + *	David Mosberger-Tang <davidm@hpl.hp.com>
> + *	Stephane Eranian <eranian@hpl.hp.com>
> + * Copyright (C) 2005-2008 Intel Co.
> + *	Fenghua Yu <fenghua.yu@intel.com>
> + *	Bibo Mao <bibo.mao@intel.com>
> + *	Chandramouli Narayanan <mouli@linux.intel.com>
> + *	Huang Ying <ying.huang@intel.com>
> + * Copyright (C) 2011-2012 Oracle Co.
> + *	Liang Tang <liang.tang@oracle.com>
> + *

I think everything between here ...

> + * Copied from efi_32.c to eliminate the duplicated code between EFI
> + * 32/64 support code. --ying 2007-10-26
> + *
> + * All EFI Runtime Services are not implemented yet as EFI only
> + * supports physical mode addressing on SoftSDV. This is to be fixed
> + * in a future version.  --drummond 1999-07-20
> + *
> + * Implemented EFI runtime services and virtual mode calls.  --davidm
> + *
> + * Goutham Rao: <goutham.rao@intel.com>
> + *	Skip non-WB memory and ignore empty memory ranges.

... and here is meaningless in this file.

> + */
>...
> +struct efi __read_mostly efi_xen = {

With this just being copied in an __init function below, this can be
both static and __initdata (or even const __initconst).

> +	.mps                      = EFI_INVALID_TABLE_ADDR,
> +	.acpi                     = EFI_INVALID_TABLE_ADDR,
> +	.acpi20                   = EFI_INVALID_TABLE_ADDR,
> +	.smbios                   = EFI_INVALID_TABLE_ADDR,
> +	.sal_systab               = EFI_INVALID_TABLE_ADDR,
> +	.boot_info                = EFI_INVALID_TABLE_ADDR,
> +	.hcdp                     = EFI_INVALID_TABLE_ADDR,
> +	.uga                      = EFI_INVALID_TABLE_ADDR,
> +	.uv_systab                = EFI_INVALID_TABLE_ADDR,
> +	.get_time                 = xen_efi_get_time,
> +	.set_time                 = xen_efi_set_time,
> +	.get_wakeup_time          = xen_efi_get_wakeup_time,
> +	.set_wakeup_time          = xen_efi_set_wakeup_time,
> +	.get_variable             = xen_efi_get_variable,
> +	.get_next_variable        = xen_efi_get_next_variable,
> +	.set_variable             = xen_efi_set_variable,
> +	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
> +	.query_variable_info      = xen_efi_query_variable_info,
> +	.update_capsule           = xen_efi_update_capsule,
> +	.query_capsule_caps       = xen_efi_query_capsule_caps,
> +};
>...
> +static void efi_enter_virtual_mode_xen(void)  { };
> +static void efi_reserve_boot_services_xen(void) { };

With the generic wrapper checking for NULL pointers I don't see why you
need empty placeholders here.

> +
> +struct efi_init_funcs xen_efi_funcs = {

static const.

> +	.__efi_init		     = efi_init_xen,
> +	.__efi_reserve_boot_services = efi_reserve_boot_services_xen,
> +	.__efi_enter_virtual_mode    = efi_enter_virtual_mode_xen,
> +	.__efi_mem_type		     = efi_mem_type_xen,
> +	.__efi_mem_attributes	     = efi_mem_attributes_xen
> +};
> +
> +static void register_xen_efi_function(void)
> +{
> +	efi_init_function_register(&xen_efi_funcs);
> +}
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -476,6 +476,7 @@ extern struct efi_memory_map memmap;
>  extern void efi_init_function_register(struct efi_init_funcs *funcs);
>  extern void get_efi_table_info(efi_config_table_t *config_tables, int 
> nr_tables,
>  			       struct efi *efi_t);
> +extern void __init xen_efi_probe(void);

No __init in declarations.

Jan

>  
>  /**
>   * efi_range_is_wc - check the WC bit on an address range

