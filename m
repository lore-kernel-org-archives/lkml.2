Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1CJQ0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:26:07 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38883 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752770Ab1CJQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:26:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L4Cdv4vNki4XK/i6EH/0FA4rBikJmEaQhK3KPUxm/NBhUxjjUfOmA+EgxrYTP50NElImVuI2YZi4kQSl3gTeaWAhQEl1jG9aSIh6oytw5Nq690CN6YnAgljeraOZ5hPA;
Date: Thu, 10 Mar 2011 08:26:00 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Takao Indoh <tindoh@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Len Brown <lenb@kernel.org>,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
Message-Id: <20110310082600.b52de7fb.rdunlap@xenotime.net>
In-Reply-To: <1299766243-494-1-git-send-email-amwang@redhat.com>
References: <1299766243-494-1-git-send-email-amwang@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 22:10:43 +0800 Amerigo Wang wrote:

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

I think that "acpi_addr" is a bit too generic.  How about
acpi_rsdp or acpi_root instead?


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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
