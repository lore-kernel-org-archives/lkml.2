Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab1CJOlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:41:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab1CJOlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:41:18 -0500
Date: Thu, 10 Mar 2011 09:39:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Takao Indoh <tindoh@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Len Brown <lenb@kernel.org>,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
Message-ID: <20110310143923.GB29464@redhat.com>
References: <1299766243-494-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299766243-494-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:10:43PM +0800, Amerigo Wang wrote:
> From: Takao Indoh <tindoh@redhat.com>
> 
> There is a problem with putting the first kernel in EFI virtual mode,
> it is that when the second kernel comes up it tries to initialize the
> EFI again and once we have put EFI in virtual mode we can not really
> do that.
> 
> Actually, EFI is not necessary for kdump, we can boot the second kernel
> with "noefi" parameter, but the boot will mostly fail because 2nd kernel
> cannot find RSDP.
> 
> In this situation, we introduced "acpi_addr=" kernel parameter,
> so that kexec-tools can pass the "noefi acpi_addr=X" to the second kernel
> to make kdump works.
> 

Little more background on this. So we now seem to have this general
general problem of how to make kexec/kdump work with EFI.

I have very limited knowledge of EFI and based on some information
gleaned, it looks we seem to have two alternatives to make kdump work.

- Don't transition to virtual mode in first kernel and work with
  physical mode of EFI. Maintain a separate set of page tables for
  mapping EFI and use those to make EFI calls.

- Transition EFI in virtual mode in first kernel. Boot second kernel with
  "noefi" and pass in whatever details are required on kernel command line.
  One such details is ACPI pointer.

Matthew Garret mentioned that other OSes tend to transition EFI in
virtual mode (MacOS X seems to be the exception) and if we decide to stick
to physical mode all the time then we can expect a host of BIOS bug report
as vendors are unlikely to test that path.

Keeping in that mind, using noefi for second kernel make sense. But
I think it is not good for pure kexec case. Takao Indoh san mentioned
that he seems to be running into VGA initialization issues and it
seems there is a need to pass SMBIOS address also.

So I think if it work, for kdump case probably using noefi is fine. I
wanted to bring up the case of kexec and wondering how to make it 
work with virtual mode of EFI or what is our strategy to handle it.

Eric and others, any thoughts on this in general?

Thanks
Vivek

> Signed-off-by: Takao Indoh <tindoh@redhat.com>
> [amwang@redhat.com: Add documentation.]
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> 
> ---
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index f4a04c0..0fbbdc6 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -163,6 +163,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  			See also Documentation/power/pm.txt, pci=noacpi
>  
> +	acpi_addr=	[ACPI,EFI]
> +			Pass the RSDP address to the kernel, mostly used
> +			on machines running EFI runtime service to boot the
> +			second kernel for kdump.
> +
>  	acpi_apic_instance=	[ACPI, IOAPIC]
>  			Format: <int>
>  			2: use 2nd APIC table, if available
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index c90c76a..06dfec0 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -238,8 +238,19 @@ void acpi_os_vprintf(const char *fmt, va_list args)
>  #endif
>  }
>  
> +static unsigned long acpi_addr;
> +static int __init setup_acpi_addr(char *arg)
> +{
> +	acpi_addr = simple_strtoul(arg, NULL, 16);
> +	return 0;
> +}
> +early_param("acpi_addr", setup_acpi_addr);
> +
>  acpi_physical_address __init acpi_os_get_root_pointer(void)
>  {
> +	if (acpi_addr)
> +		return acpi_addr;
> +
>  	if (efi_enabled) {
>  		if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
>  			return efi.acpi20;
