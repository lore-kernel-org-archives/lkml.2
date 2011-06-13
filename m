Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1FMRws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:52:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63651 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1FMRwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bmcZBh/DFYxf/NZrFyzKO3ZjdHXeiGKGLgsR5CIKzMJrr5+/BkClZxO/l4CezJk7Uq
         vwsEjI4CKuTMecE3d0k/gdS6A2IGjE3du+UHOgaDhz8OwhBU5h6yIGhtYyQy38xfgBsH
         7Mon0h2o6i1VCr4TnqIRkeIkO0OAc/8l0oDQY=
Message-ID: <4DF64E6A.70700@gmail.com>
Date: Mon, 13 Jun 2011 19:52:42 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <20110613164712.GA23343@srcf.ucam.org>
In-Reply-To: <20110613164712.GA23343@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 13-06-11 18:47, Matthew Garrett schreef:
> Ok, let's just try this in a somewhat more brute force way. Can you try 
> this patch on top of current git, and give me the full dmesg and 
> /proc/iomem ?
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 0d3a4fa..ffbe47c 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -312,11 +312,35 @@ void __init efi_reserve_boot_services(void)
>  		efi_memory_desc_t *md = p;
>  		unsigned long long start = md->phys_addr;
>  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> +		unsigned long long end = start + size;
>  
> -		if (md->type != EFI_BOOT_SERVICES_CODE &&
> -		    md->type != EFI_BOOT_SERVICES_DATA)
> +		if (md->type != EFI_BOOT_SERVICES_CODE)
>  			continue;
>  
> +		/*
> +		 * Trying to map EFI code over the zero page is just asking
> +		 * for trouble. The good news is that it's almost certainly
> +		 * only there for graphics card bringup at POST time, so
> +		 * we should be able to get away with not having it there
> +		 */
> +
> +		if (start == 0) {
> +			md->num_pages = 0;
> +			continue;
> +		}
> +
> +		/*
> +		 * We probably also want to avoid mapping code over the
> +		 * kernel...
> +		 */
> +
> +		if ((start <= virt_to_phys(_etext)-1 && end >= virt_to_phys(_text)) ||
> +		    (start <= virt_to_phys(_edata)-1 && end >= virt_to_phys(_etext)) ||
_etext -> _sdata perhaps?
> +		    (start <= virt_to_phys(&__bss_stop)-1 && end >= virt_to_phys(&__bss_start))) {
> +			md->num_pages = 0;
> +			continue;
> +		}
> +
>  		memblock_x86_reserve_range(start, start + size, "EFI Boot");
>  	}
>  }
Will test though. It might also be appropriate to put a WARN when that condition happens.

~Maarten
