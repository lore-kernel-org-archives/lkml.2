Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab2BJQ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:58:33 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:40548 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2BJQ6b convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 10 Feb 2012 11:58:31 -0500
Message-Id: <4F355AC50200007800072701@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 10 Feb 2012 16:58:29 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <liang.tang@oracle.com>, <mjg59@srcf.ucam.org>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/5] EFI: Provide registration for
 efi_init.. etc efi public function
References: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
 <1328758328-24156-1-git-send-email-liang.tang@oracle.com>
In-Reply-To: <1328758328-24156-1-git-send-email-liang.tang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.02.12 at 04:32, Tang Liang <liang.tang@oracle.com> wrote:
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -50,6 +50,23 @@
>  #define PFX 		"EFI: "
>  
>  int efi_enabled;
> +
> +static void efi_init_generic(void);
> +
> +static void efi_enter_virtual_mode_generic(void);
> +static u32 efi_mem_type_generic(unsigned long phys_addr);
> +static u64 efi_mem_attributes_generic(unsigned long phys_addr);
> +
> +struct efi_init_funcs efi_generic_funcs = {

static const.

> +	.__efi_init		     = efi_init_generic,
> +	.__efi_reserve_boot_services = efi_reserve_boot_services_generic,
> +	.__efi_enter_virtual_mode    = efi_enter_virtual_mode_generic,
> +	.__efi_mem_type		     = efi_mem_type_generic,
> +	.__efi_mem_attributes	     = efi_mem_attributes_generic
> +};
> +
> +struct efi_init_funcs *efi_override_funcs =  &efi_generic_funcs;

const struct ...

> +
>  EXPORT_SYMBOL(efi_enabled);
>  
>  struct efi __read_mostly efi = {
> @@ -781,3 +798,41 @@ u64 efi_mem_attributes(unsigned long phys_addr)
>  	}
>  	return 0;
>  }
> +
> +void efi_init_function_register(struct efi_init_funcs *funcs)

... (const struct ...

> +{
> +	efi_override_funcs = funcs;
> +}
> +
> +void __init efi_init(void)
> +{
> +	if (efi_override_funcs->__efi_init)
> +		efi_override_funcs->__efi_init();
> +}
> +
> +void __init efi_reserve_boot_services(void)
> +{
> +	if (efi_override_funcs->__efi_reserve_boot_services)
> +		efi_override_funcs->__efi_reserve_boot_services();
> +}
> +
> +void __init efi_enter_virtual_mode(void)
> +{
> +	if (efi_override_funcs->__efi_enter_virtual_mode)
> +		efi_override_funcs->__efi_enter_virtual_mode();
> +}
> +
> +
> +u32 efi_mem_type(unsigned long phys_addr)
> +{
> +	if (efi_override_funcs->__efi_mem_type)
> +		return efi_override_funcs->__efi_mem_type(phys_addr);
> +	return EFI_INVALID_TYPE;
> +}
> +
> +u64 efi_mem_attributes(unsigned long phys_addr)
> +{
> +	if (efi_override_funcs->__efi_mem_attributes)
> +		return efi_override_funcs->__efi_mem_attributes(phys_addr);
> +	return EFI_INVALID_ATTRIBUTE;
> +}
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -79,8 +79,9 @@ typedef	struct {
>  #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
>  #define EFI_PAL_CODE			13
>  #define EFI_MAX_MEMORY_TYPE		14
> -

I would suggest to retain the newline.

> +#define EFI_INVALID_TYPE		0xffffffff
>  /* Attribute values: */
> +#define EFI_INVALID_ATTRIBUTE	((u64)0x0000000000000000ULL)	/* invalid attribute*/
>  #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
>  #define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
>  #define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
> @@ -434,6 +435,14 @@ extern struct efi {
>  	efi_set_virtual_address_map_t *set_virtual_address_map;
>  } efi;
>  
> +struct efi_init_funcs {
> +	void (*__efi_init)(void);
> +	void (*__efi_reserve_boot_services)(void);
> +	void (*__efi_enter_virtual_mode)(void);
> +	u32 (*__efi_mem_type)(unsigned long phys_addr);
> +	u64 (*__efi_mem_attributes)(unsigned long phys_addr);

What is the reason for having the __ (or even the whole __efi_) at
their beginning?

Jan

> +};
> +
>  static inline int
>  efi_guidcmp (efi_guid_t left, efi_guid_t right)
>  {


