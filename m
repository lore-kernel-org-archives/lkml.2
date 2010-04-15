Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0DORLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:11:13 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52257 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab0DORLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:11:12 -0400
Date: Thu, 15 Apr 2010 13:11:11 -0400
To: Matteo Croce <technoboy85@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AMD Geode i686
Message-ID: <20100415171111.GA32023@caffeine.csclub.uwaterloo.ca>
References: <40101cc31003011403x4423cb3em1f6fcb04d64dd2bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc31003011403x4423cb3em1f6fcb04d64dd2bb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 11:03:09PM +0100, Matteo Croce wrote:
> Hi,
> I have refreshed my AMD Geode i686 patch with NOPL and I have added a
> new nice feature.
> When a NOPL is found the parser looks for any NOPL after the current
> one, so they are emulated in bulk.
> Tested ok on a Pcengines Alix.
> 
> Signed-off-by: Matteo Croce <technoboy85@gmail.com>
> 
> --- a/arch/x86/kernel/Makefile	2010-03-01 01:18:51.697166322 +0100
> +++ b/arch/x86/kernel/Makefile	2010-03-01 01:19:45.727095700 +0100
> @@ -89,6 +89,8 @@
>  obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
> 
>  obj-$(CONFIG_K8_NB)		+= k8.o
> +obj-$(CONFIG_MGEODEGX1)		+= nopl_emu.o
> +obj-$(CONFIG_MGEODE_LX)		+= nopl_emu.o
>  obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
>  obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
> 
> --- a/arch/x86/kernel/cpu/amd.c	2010-03-01 01:18:51.737097341 +0100
> +++ b/arch/x86/kernel/cpu/amd.c	2010-03-01 01:19:27.867865836 +0100
> @@ -138,8 +138,10 @@
>  	}
> 
>  	if (c->x86_model == 10) {
> -		/Index: linux-2.6.33/arch/x86/kernel/Makefile
> ===================================================================
> * AMD Geode LX is model 10 */
> -		/* placeholder for any needed mods */
> +		/* Geode only lacks the NOPL instruction to be i686,
> +		   but we can emulate it in the exception handler
> +		   and promote it to a class 6 cpu */
> +		boot_cpu_data.x86 = 6;
>  		return;
>  	}
>  }
> --- a/arch/x86/kernel/entry_32.S	2010-03-01 01:18:51.717096708 +0100
> +++ b/arch/x86/kernel/entry_32.S	2010-03-01 01:19:27.867865836 +0100
> @@ -960,7 +960,11 @@
>  	RING0_INT_FRAME
>  	pushl $0
>  	CFI_ADJUST_CFA_OFFSET 4
> +#ifdef CONFIG_MGEODE_LX
> +	pushl $do_nopl_emu
> +#else
>  	pushl $do_invalid_op
> +#endif

How does this work for MGEODEGX1 when it looks for MGEODE_LX?  It seems
you made both link against the code above after all.  Is this wrong or
the above?

Can it not work if you want to run a generic kernel on your Geode rather
than one built explicitly for the LX?  I build one kernel to run on
Geode SC1200 and Geode LX.

-- 
Len Sorensen
