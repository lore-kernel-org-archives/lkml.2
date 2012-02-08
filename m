Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2BHScI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:32:08 -0500
Received: from mga06.intel.com ([134.134.136.21]:48112 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754336Ab2BHScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:32:06 -0500
Subject: Re: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit
 efi/kernel
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mjg@redhat.com
In-Reply-To: <1328660732-27263-6-git-send-email-olof@lixom.net>
References: <1328660732-27263-1-git-send-email-olof@lixom.net>
	 <1328660732-27263-6-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Wed, 08 Feb 2012 18:31:54 +0000
Message-ID: <1328725914.3675.15.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 16:25 -0800, Olof Johansson wrote: 
> Traditionally the kernel has refused to setup EFI at all if there's been
> a mismatch in 32/64-bit mode between EFI and the kernel.
> 
> On some platforms that boot natively through EFI (Chrome OS being one),
> we still need to get at least some of the static data such as memory
> configuration out of EFI. Runtime services aren't as critical, and
> it's a significant amount of work to implement switching between the
> operating modes to call between kernel and firmware for thise cases. So
> I'm ignoring it for now.

Presumably with these patches in mainline you can get rid of the hacks
that ChromeOS currently uses?

> v4:
> * Some of the earlier cleanup was accidentally reverted by this patch, fixed.
> * Reworded some messages to not have to line wrap printk strings
> 
> v3:
> * Reorganized to a series of patches to make it easier to review, and
>   do some of the cleanups I had left out before.
> 
> v2:
> * Added graceful error handling for 32-bit kernel that gets passed
>   EFI data above 4GB.
> * Removed some warnings that were missed in first version.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  arch/x86/include/asm/efi.h  |    2 +-
>  arch/x86/kernel/setup.c     |   10 ++-
>  arch/x86/platform/efi/efi.c |  164 +++++++++++++++++++++++++++++++++++++------
>  include/linux/efi.h         |   45 ++++++++++++
>  4 files changed, 195 insertions(+), 26 deletions(-)
> 

[...]

> +
> +		early_iounmap(systab64, sizeof(*systab64));
> +#ifdef CONFIG_X86_32
> +		if (tmp >> 32) {
> +			pr_err("EFI data located above 4GB, disabling.\n");
> +			return -EINVAL;
> +		}
> +#endif

You should really say "disabling EFI" here.

[...]

> +#ifdef CONFIG_X86_32
> +			if (table64 >> 32) {
> +				pr_cont("\n");
> +				pr_err("Table located above 4GB, disabling.\n");
> +				early_iounmap(config_tables,
> +					      efi.systab->nr_tables * sz);
> +				return -EINVAL;
> +			}
> +#endif

Likewise here, mention that you're disabling EFI.

[...]

> @@ -576,11 +670,19 @@ void __init efi_init(void)
>  	void *tmp;
>  
>  #ifdef CONFIG_X86_32
> +	if (boot_params.efi_info.efi_systab_hi ||
> +	    boot_params.efi_info.efi_memmap_hi) {
> +		pr_info("Table located above 4GB, disabling.\n");
> +		efi_enabled = 0;
> +		return;
> +	}
>  	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
> +	efi_native = !efi_64bit;
>  #else

... and here

> 	efi_phys.systab = (efi_system_table_t *)
> -		(boot_params.efi_info.efi_systab |
> -		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
> +			  (boot_params.efi_info.efi_systab |
> +			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
> +	efi_native = efi_64bit;
>  #endif
>  
>  	if (efi_systab_init(efi_phys.systab)) {
> @@ -609,19 +711,26 @@ void __init efi_init(void)
>  		return;
>  	}
>  
> -	if (efi_runtime_init()) {
> +	/*
> +	 * Note: We currently don't support runtime services on an EFI
> +	 * that doesn't match the kernel 32/64-bit mode.
> +	 */
> +
> +	if (efi_native && efi_runtime_init()) {
>  		efi_enabled = 0;
>  		return;
> -	}
> +	} else
> +		pr_info("No EFI runtime due to 32/64b mismatch with kernel\n");

Hmm... this isn't right. efi_runtime_init() returns 0 on success, so
you're printing this warning in the native EFI success path. Also,
please spell out "32/64-bit". 

> @@ -679,6 +788,13 @@ void __init efi_enter_virtual_mode(void)
>  
>  	efi.systab = NULL;
>  
> +	/* We don't do virtual mode, since we don't do runtime services, on
> +	 * non-native EFI
> +	 */
> +
> +	if (!efi_native)
> +		goto out;
> +

	/*
	 * Multi-line comments should look like this.
	 */

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 37c3007..17385ba 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -315,6 +315,16 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
>  
>  typedef struct {
>  	efi_guid_t guid;
> +	u64 table;
> +} _efi_config_table_64_t;
> +
> +typedef struct {
> +	efi_guid_t guid;
> +	u32 table;
> +} _efi_config_table_32_t;
> +
> +typedef struct {
> +	efi_guid_t guid;
>  	unsigned long table;
>  } efi_config_table_t;

There's no need for the underscore prefix on these names.
efi_config_table_64_t, etc, is fine. Normally you should try to avoid
adding new typedefs, but I think these make sense because they're an
extension of existing typedefs.

Actually, thinking about it some more, it would make more sense to just
delete efi_config_table_t and efi_system_table_t and make everyone
explicitly pick a size, not least because it will make people adding new
code think long and hard about the mixed mode case.

> @@ -329,6 +339,40 @@ typedef struct {
>  
>  typedef struct {
>  	efi_table_hdr_t hdr;
> +	u64 fw_vendor;	/* physical addr of CHAR16 vendor string */
> +	u32 fw_revision;
> +	u32 __pad1;
> +	u64 con_in_handle;
> +	u64 con_in;
> +	u64 con_out_handle;
> +	u64 con_out;
> +	u64 stderr_handle;
> +	u64 stderr;
> +	u64 runtime;
> +	u64 boottime;
> +	u32 nr_tables;
> +	u32 __pad2;
> +	u64 tables;
> +} _efi_system_table_64_t;

No underscore please.

> +typedef struct {
> +	efi_table_hdr_t hdr;
> +	u32 fw_vendor;	/* physical addr of CHAR16 vendor string */
> +	u32 fw_revision;
> +	u32 con_in_handle;
> +	u32 con_in;
> +	u32 con_out_handle;
> +	u32 con_out;
> +	u32 stderr_handle;
> +	u32 stderr;
> +	u32 runtime;
> +	u32 boottime;
> +	u32 nr_tables;
> +	u32 tables;
> +} _efi_system_table_32_t;

Same here.


