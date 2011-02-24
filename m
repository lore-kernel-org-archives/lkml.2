Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1BXIFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:05:41 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48290 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1BXIFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:05:40 -0500
Date: Thu, 24 Feb 2011 00:05:35 -0800
From: Andres Salomon <dilinger@queued.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86: OLPC: Cleanup config maze completely
Message-ID: <20110224000535.356cedf7@queued.net>
In-Reply-To: <tip-dc3119e700216a70e82fe07a79f1618852058354@git.kernel.org>
References: <tip-dc3119e700216a70e82fe07a79f1618852058354@git.kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one looks wrong, but I see you fixed it up in a later patch.
Are you going to merge the two?  Also, when will these be showing up
in linux-next?


On Wed, 23 Feb 2011 09:52:50 GMT tip-bot for Thomas Gleixner
<tglx@linutronix.de> wrote:

> Commit-ID:  dc3119e700216a70e82fe07a79f1618852058354
> Gitweb:
> http://git.kernel.org/tip/dc3119e700216a70e82fe07a79f1618852058354
> Author:     Thomas Gleixner <tglx@linutronix.de> AuthorDate: Wed, 23
> Feb 2011 10:08:31 +0100 Committer:  Thomas Gleixner
> <tglx@linutronix.de> CommitDate: Wed, 23 Feb 2011 10:40:45 +0100
> 
> x86: OLPC: Cleanup config maze completely
> 
> Neither CONFIG_OLPC_OPENFIRMWARE nor CONFIG_OLPC_OPENFIRMWARE_DT are
> really necessary.
> 
> OLPC selects OLPC_OPENFIRMWARE unconditionally, so move the "select
> OF" part under OLPC config option and fixup the dependencies in
> Makefiles and code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andres Salomon <dilinger@queued.net>
> ---
>  arch/x86/Kconfig                |   10 +++-------
>  arch/x86/include/asm/olpc_ofw.h |   11 -----------
>  arch/x86/kernel/head_32.S       |    2 +-
>  arch/x86/platform/olpc/Makefile |    2 +-
>  4 files changed, 5 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index dbc10fc..677501d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2066,9 +2066,10 @@ config SCx200HR_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> -	select GPIOLIB
> -	select OLPC_OPENFIRMWARE
>  	depends on !X86_PAE
> +	select GPIOLIB
> +	select OF
> +	select OLPC_OPENFIRMWARE_DT if PROC_DEVICETREE
>  	---help---
>  	  Add support for detecting the unique features of the OLPC
>  	  XO hardware.
> @@ -2079,11 +2080,6 @@ config OLPC_XO1
>  	---help---
>  	  Add support for non-essential features of the OLPC XO-1
> laptop. 
> -config OLPC_OPENFIRMWARE
> -	bool
> -	select OF
> -	select OLPC_OPENFIRMWARE_DT if PROC_DEVICETREE
> -
>  config OLPC_OPENFIRMWARE_DT
>  	bool
>  	select OF_PROMTREE
> diff --git a/arch/x86/include/asm/olpc_ofw.h
> b/arch/x86/include/asm/olpc_ofw.h index 641988e..1fff2de 100644
> --- a/arch/x86/include/asm/olpc_ofw.h
> +++ b/arch/x86/include/asm/olpc_ofw.h
> @@ -6,8 +6,6 @@
>  
>  #define OLPC_OFW_SIG 0x2057464F	/* aka "OFW " */
>  
> -#ifdef CONFIG_OLPC_OPENFIRMWARE
> -
>  extern bool olpc_ofw_is_installed(void);
>  
>  /* run an OFW command by calling into the firmware */
> @@ -26,15 +24,6 @@ extern void setup_olpc_ofw_pgd(void);
>  /* check if OFW was detected during boot */
>  extern bool olpc_ofw_present(void);
>  
> -#else /* !CONFIG_OLPC_OPENFIRMWARE */
> -
> -static inline bool olpc_ofw_is_installed(void) { return false; }
> -static inline void olpc_ofw_detect(void) { }
> -static inline void setup_olpc_ofw_pgd(void) { }
> -static inline bool olpc_ofw_present(void) { return false; }
> -
> -#endif /* !CONFIG_OLPC_OPENFIRMWARE */
> -
>  #ifdef CONFIG_OLPC_OPENFIRMWARE_DT
>  extern void olpc_dt_build_devicetree(void);
>  #else
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 767d6c4..d8cc18a 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -137,7 +137,7 @@ ENTRY(startup_32)
>  	movsl
>  1:
>  
> -#ifdef CONFIG_OLPC_OPENFIRMWARE
> +#ifdef CONFIG_OLPC
>  	/* save OFW's pgdir table for later use when calling into
> OFW */ movl %cr3, %eax
>  	movl %eax, pa(olpc_ofw_pgd)
> diff --git a/arch/x86/platform/olpc/Makefile
> b/arch/x86/platform/olpc/Makefile index e797428..e18e641 100644
> --- a/arch/x86/platform/olpc/Makefile
> +++ b/arch/x86/platform/olpc/Makefile
> @@ -1,4 +1,4 @@
>  obj-$(CONFIG_OLPC)		+= olpc.o
>  obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
> -obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
> +obj-$(CONFIG_OLPC)		+= olpc_ofw.o
>  obj-$(CONFIG_OLPC_OPENFIRMWARE_DT)	+= olpc_dt.o
