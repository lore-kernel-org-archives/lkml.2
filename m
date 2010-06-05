Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0FEBpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 21:45:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49428 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752731Ab0FEBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 21:45:42 -0400
Date: Fri, 4 Jun 2010 21:45:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: [linux-pm] Invalid opcode on resume from STR on Asus
 P4P800-VM
In-Reply-To: <201006050029.25819.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.1006042144260.6595-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010, Ondrej Zary wrote:

> Here's a patch that fixes the problem. I don't know how many machines will
> it break...
> 
> 
> diff -urp linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_32.h linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_32.h
> --- linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_32.h	2010-05-30 22:21:02.000000000 +0200
> +++ linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_32.h	2010-06-04 23:52:22.000000000 +0200
> @@ -15,6 +15,7 @@ static inline int arch_prepare_suspend(v
>  struct saved_context {
>  	u16 es, fs, gs, ss;
>  	unsigned long cr0, cr2, cr3, cr4;
> +	unsigned long misc_enable;
>  	struct desc_ptr gdt;
>  	struct desc_ptr idt;
>  	u16 ldt;
> diff -urp linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_64.h linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_64.h
> --- linux-2.6.35-rc1-git2-orig/arch/x86/include/asm/suspend_64.h	2010-05-30 22:21:02.000000000 +0200
> +++ linux-2.6.35-rc1-git2/arch/x86/include/asm/suspend_64.h	2010-06-04 23:52:21.000000000 +0200
> @@ -27,6 +27,7 @@ struct saved_context {
>  	u16 ds, es, fs, gs, ss;
>  	unsigned long gs_base, gs_kernel_base, fs_base;
>  	unsigned long cr0, cr2, cr3, cr4, cr8;
> +	unsigned long misc_enable;
>  	unsigned long efer;
>  	u16 gdt_pad;
>  	u16 gdt_limit;
> diff -urp linux-2.6.35-rc1-git2-orig/arch/x86/power/cpu.c linux-2.6.35-rc1-git2/arch/x86/power/cpu.c
> --- linux-2.6.35-rc1-git2-orig/arch/x86/power/cpu.c	2010-05-30 22:21:02.000000000 +0200
> +++ linux-2.6.35-rc1-git2/arch/x86/power/cpu.c	2010-06-04 23:50:52.000000000 +0200
> @@ -105,6 +105,7 @@ static void __save_processor_state(struc
>  	ctxt->cr4 = read_cr4();
>  	ctxt->cr8 = read_cr8();
>  #endif
> +	rdmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
>  }
>  
>  /* Needed by apm.c */
> @@ -152,6 +153,7 @@ static void fix_processor_context(void)
>   */
>  static void __restore_processor_state(struct saved_context *ctxt)
>  {
> +	wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
>  	/*
>  	 * control registers
>  	 */

Great!  I'll try it out early next week.

Alan Stern

