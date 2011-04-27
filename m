Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1D0Lji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:39:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58615 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757465Ab1D0Ljh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:39:37 -0400
Date: Wed, 27 Apr 2011 12:39:35 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Only print warning when desc_size is smaller
 than defined one.
Message-ID: <20110427123935.1aacd8b9@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <4DB74A50.3080804@kernel.org>
References: <4DB74A50.3080804@kernel.org>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 15:42:24 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> One system get warning:
> 	Kernel-defined memdesc doesn't match the one from EFI!
> 
> UEFI spec allows GetMemoryMap() return bigger desc_size and desc_ver for future
> extension.
> And desc_size is already used to get offset of next memory entry.
> 
> Only need to check if desc_size is smaller than defined struct.
> 
> Also print the size in warning if it happens.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/platform/efi/efi.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/platform/efi/efi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> +++ linux-2.6/arch/x86/platform/efi/efi.c
> @@ -448,9 +448,10 @@ void __init efi_init(void)
>  		printk(KERN_ERR "Could not map the EFI memory map!\n");
>  	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
>  
> -	if (memmap.desc_size != sizeof(efi_memory_desc_t))
> +	if (memmap.desc_size < sizeof(efi_memory_desc_t))
>  		printk(KERN_WARNING
> -		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
> +		  "Kernel-defined memdesc size is bigger than the one from EFI! %ld > %ld\n",
> +			 sizeof(efi_memory_desc_t), memmap.desc_size);

Does it make sense for this to just be a warning? If
sizeof(efi_memory_desec_t) > sizeof(memmap.desc_size) aren't we going
to run into some pretty serious problems when we start accessing
memory descriptors?

Would it not make more sense for this to be a BUG_ON()? In the unlikely
event that the kernel's efi_memory_desc_t is too large I really don't
see how we can recover from that.

-- 
Matt Fleming, Intel Open Source Technology Center
