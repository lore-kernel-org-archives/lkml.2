Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2I1DVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:21:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2I1DVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:21:07 -0400
Date: Thu, 27 Sep 2012 22:21:01 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH V2 08/10] efi: Enable secure boot lockdown automatically
 when enabled in firmware
Message-ID: <20120928032101.GC5478@sergelap>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <1348152065-31353-9-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348152065-31353-9-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matthew Garrett (mjg@redhat.com):
> The firmware has a set of flags that indicate whether secure boot is enabled
> and enforcing. Use them to indicate whether the kernel should lock itself
> down.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

(purely for the non-firmware bits) seems good, thanks.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  Documentation/x86/zero-page.txt  |  2 ++
>  arch/x86/boot/compressed/eboot.c | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c          |  3 +++
>  include/linux/cred.h             |  2 ++
>  5 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
> index cf5437d..7f9ed48 100644
> --- a/Documentation/x86/zero-page.txt
> +++ b/Documentation/x86/zero-page.txt
> @@ -27,6 +27,8 @@ Offset	Proto	Name		Meaning
>  1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
>  1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
>  				(below)
> +1EB/001	ALL	kbd_status	Numlock is enabled
> +1EC/001	ALL	secure_boot	Kernel should enable secure boot lockdowns
>  290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
>  2D0/A00	ALL	e820_map	E820 memory map table
>  				(array of struct e820entry)
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index b3e0227..3789356 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -724,6 +724,36 @@ fail:
>  	return status;
>  }
>  
> +static int get_secure_boot(efi_system_table_t *_table)
> +{
> +	u8 sb, setup;
> +	unsigned long datasize = sizeof(sb);
> +	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
> +	efi_status_t status;
> +
> +	status = efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> +
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (sb == 0)
> +		return 0;
> +
> +
> +	status = efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SetupMode", &var_guid, NULL, &datasize,
> +				&setup);
> +
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (setup == 1)
> +		return 0;
> +
> +	return 1;
> +}
> +
>  /*
>   * Because the x86 boot code expects to be passed a boot_params we
>   * need to create one ourselves (usually the bootloader would create
> @@ -1018,6 +1048,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
>  	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>  		goto fail;
>  
> +	boot_params->secure_boot = get_secure_boot(sys_table);
> +
>  	setup_graphics(boot_params);
>  
>  	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
> index 2ad874c..c7338e0 100644
> --- a/arch/x86/include/asm/bootparam.h
> +++ b/arch/x86/include/asm/bootparam.h
> @@ -114,7 +114,8 @@ struct boot_params {
>  	__u8  eddbuf_entries;				/* 0x1e9 */
>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
>  	__u8  kbd_status;				/* 0x1eb */
> -	__u8  _pad6[5];					/* 0x1ec */
> +	__u8  secure_boot;				/* 0x1ec */
> +	__u8  _pad6[4];					/* 0x1ed */
>  	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
>  	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
>  	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f4b9b80..239bf2a 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -947,6 +947,9 @@ void __init setup_arch(char **cmdline_p)
>  
>  	io_delay_init();
>  
> +	if (boot_params.secure_boot)
> +		secureboot_enable();
> +
>  	/*
>  	 * Parse the ACPI tables for possible boot-time SMP configuration.
>  	 */
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index ebbed2c..a24faf1 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -170,6 +170,8 @@ extern int set_security_override_from_ctx(struct cred *, const char *);
>  extern int set_create_files_as(struct cred *, struct inode *);
>  extern void __init cred_init(void);
>  
> +extern void secureboot_enable(void);
> +
>  /*
>   * check for validity of credentials
>   */
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
