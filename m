Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3ACPJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:09:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:34279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab3ACPJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:09:30 -0500
Message-ID: <1354725859.7184.194.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [Patch v4] x86: make 'mem=' option to work for efi platform
From: Matt Fleming <matt.fleming@intel.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bhelgaas@google.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <50A227C4.6050403@cn.fujitsu.com>
References: <50A227C4.6050403@cn.fujitsu.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Dec 2012 16:44:19 +0000
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 18:58 +0800, Wen Congyang wrote:
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index ad44391..7592163 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -314,10 +314,17 @@ static void __init do_add_efi_memmap(void)
>  		int e820_type;
>  
>  		switch (md->type) {
> -		case EFI_LOADER_CODE:
> -		case EFI_LOADER_DATA:
>  		case EFI_BOOT_SERVICES_CODE:
>  		case EFI_BOOT_SERVICES_DATA:
> +			/* EFI_BOOT_SERVICES_{CODE,DATA} needs to be mapped */
> +			if (md->attribute & EFI_MEMORY_WB)
> +				e820_type = E820_RAM;
> +			else
> +				e820_type = E820_RESERVED;
> +			e820_add_region(start, size, e820_type);
> +			continue;
> +		case EFI_LOADER_CODE:
> +		case EFI_LOADER_DATA:
>  		case EFI_CONVENTIONAL_MEMORY:
>  			if (md->attribute & EFI_MEMORY_WB)
>  				e820_type = E820_RAM;

This chunk seems to cause one of my EFI machines to crash. If I include
EFI_LOADER_{CODE,DATA} in the same clause as EFI_BOOT_SERVICES* things
work. I'm not sure why that is since the e820_type is E820_RAM.

Maybe I need to use memmap= too when booting?

