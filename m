Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1E3NxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:53:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37593 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755598Ab1E3NxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:53:05 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+k0gkQtbCknnF3RWmBjjNdARhuTwqQilD/ArNT+v
	c8+nS/hxEWdFcl
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: Patch "x86, efi: Retain boot service code until after switching to" has been added to the 2.6.39-stable tree
Date: Mon, 30 May 2011 15:52:55 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-0.slh.7-aptosid-686; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@linux.intel.com,
        tony.luck@intel.com, stable@kernel.org
References: <13067284712957@kroah.org>
In-Reply-To: <13067284712957@kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301552.57712.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Monday 30 May 2011, gregkh@suse.de wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     x86, efi: Retain boot service code until after switching to
> 
> to the 2.6.39-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      x86-efi-retain-boot-service-code-until-after-switching-to.patch
> and it can be found in the queue-2.6.39 subdirectory.

The -stable backport of this upstream commit introduces a syntax error,
see below.

> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@kernel.org> know about it.
> 
> 
> From 916f676f8dc016103f983c7ec54c18ecdbb6e349 Mon Sep 17 00:00:00 2001
> From: Matthew Garrett <mjg@redhat.com>
> Date: Wed, 25 May 2011 09:53:13 -0400
> Subject: x86, efi: Retain boot service code until after switching to
>  virtual mode
> 
> From: Matthew Garrett <mjg@redhat.com>
> 
> commit 916f676f8dc016103f983c7ec54c18ecdbb6e349 upstream.
[...]
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -64,10 +64,11 @@ static void __init early_runtime_code_ma
>  	if (!(__supported_pte_mask & _PAGE_NX))
>  		return;
>  
> -	/* Make EFI runtime service code area executable */
> +	/* Make EFI service code area executable */
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
> -		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
> +		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
> +		    md->type == EFI_BOOT_SERVICES_CODE)
                                                  ^ missing '{'
>  			unsigned long end;
>  			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
>  			early_mapping_set_exec(md->phys_addr, end, executable);
[...]

This leads to:

arch/x86/platform/efi/efi_64.c: In function 'early_runtime_code_mapping_set_exec':
arch/x86/platform/efi/efi_64.c:72:4: error: expected expression before 'unsigned'
arch/x86/platform/efi/efi_64.c:73:4: error: 'end' undeclared (first use in this function)
arch/x86/platform/efi/efi_64.c:73:4: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/platform/efi/efi_64.c: At top level:
arch/x86/platform/efi/efi_64.c:77:1: error: expected identifier or '(' before '}' token
make[5]: *** [arch/x86/platform/efi/efi_64.o] Error 1

Regards
	Stefan Lippers-Hollmann
