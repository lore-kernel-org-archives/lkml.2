Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab0JZQYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:24:31 -0400
Received: from www.tglx.de ([62.245.132.106]:45872 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662Ab0JZQYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:24:30 -0400
Date: Tue, 26 Oct 2010 18:24:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Tim Bird <tim.bird@am.sony.com>, andi@firstfloor.org
Subject: Re: [PATCH] archs: add ioremap_change_write_prot
In-Reply-To: <4CC3F13B.4030107@gmail.com>
Message-ID: <alpine.LFD.2.00.1010261818300.3115@localhost6.localdomain6>
References: <4CC3F13B.4030107@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010, Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> This patch adds a new function called ioremap_change_write_prot.
> Goal of this patch is to create a general function for all archs to be
> able to change a write protection of a memory mapped area. x86
> has already got a similar framework, so this function is only
> a wrapper. Next target will be arm and powerpc. This function
> will be used by Pramfs (see its latest review).

Sorry for the delay. I'm traveling.
 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> diff -Nurp linux-2.6.36-orig/arch/x86/mm/ioremap.c linux-2.6.36/arch/x86/mm/ioremap.c
> --- linux-2.6.36-orig/arch/x86/mm/ioremap.c	2010-09-13 01:07:37.000000000 +0200
> +++ linux-2.6.36/arch/x86/mm/ioremap.c	2010-10-24 10:03:36.000000000 +0200
> @@ -50,6 +50,27 @@ int ioremap_change_attr(unsigned long va
>  	return err;
>  }
  
> +int ioremap_change_write_prot(unsigned long vaddr, unsigned long size,
> +			       unsigned int rw)
> +{
> +	unsigned long nrpages = size >> PAGE_SHIFT;
> +	int ret;
> +
> +	/* Page aligned */
> +	vaddr &= PAGE_MASK;
> +
> +	if (size & (PAGE_SIZE - 1))
> +		nrpages++;
> +
> +	if (rw)
> +		ret = set_memory_rw(vaddr, nrpages);
> +	else
> +		ret = set_memory_ro(vaddr, nrpages);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ioremap_change_write_prot);

Why inventing a new interface if we have one already ?

    set_memory_* which has a few more variants than ro/rw

Also this is not related to ioremap, these are functions which works on
almost anything when there are other restrictions in place.

So implementing set_memory_ro(), set_memory_rw() for those archs which
you need it for makes more sense than creating a misnomed and
misplaced wrapper.

Thanks,

	tglx
