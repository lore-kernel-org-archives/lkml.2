Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0IVSmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:42:49 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56306 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab0IVSms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:42:48 -0400
Date: Wed, 22 Sep 2010 12:02:19 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PCI: OLPC configuration cleanup
Message-ID: <20100922120219.407ec023@debxo>
In-Reply-To: <20100922164402.A72D49D401B@zog.reactivated.net>
References: <20100922164402.A72D49D401B@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 17:44:02 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> An OLPC system isn't usable without PCI, so we can simplify the
> configuration here.

Hm, I think I'm opposed to tying it into CONFIG_OLPC like that.  Future
plans call for an ARM-based OLPC which will presumably not have a PCI
bus.

..However, I'm also failing to come up w/ a good alternative right
now.  

> 
> Also updated the code to be clearer that this is only for XO-1, and
> fixed an issue where the XO-1 PCI configuration override was being
> applied for XO-1.5 laptops.
> 
> Based on earlier work by Deepak Saxena.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/Kconfig       |   12 +++---------
>  arch/x86/kernel/olpc.c |    4 +---
>  arch/x86/pci/Makefile  |    2 +-
>  arch/x86/pci/olpc.c    |    4 ++--
>  4 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cea0cd9..708ee0d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1899,10 +1899,6 @@ config PCI_GOMMCONFIG
>  config PCI_GODIRECT
>  	bool "Direct"
>  
> -config PCI_GOOLPC
> -	bool "OLPC"
> -	depends on OLPC
> -
>  config PCI_GOANY
>  	bool "Any"
>  
> @@ -1915,16 +1911,12 @@ config PCI_BIOS
>  # x86-64 doesn't support PCI BIOS access from long mode so always go
> direct. config PCI_DIRECT
>  	def_bool y
> -	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY ||
> PCI_GOOLPC))
> +	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY))
>  
>  config PCI_MMCONFIG
>  	def_bool y
>  	depends on X86_32 && PCI && (ACPI || SFI) && (PCI_GOMMCONFIG
> || PCI_GOANY) 
> -config PCI_OLPC
> -	def_bool y
> -	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
> -
>  config PCI_DOMAINS
>  	def_bool y
>  	depends on PCI
> @@ -2060,6 +2052,8 @@ config SCx200HR_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> +	select PCI
> +	select PCI_GOANY
>  	select GPIOLIB
>  	---help---
>  	  Add support for detecting the unique features of the OLPC
> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 0e0cdde..10b4dce 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -241,11 +241,9 @@ static int __init olpc_init(void)
>  	olpc_ec_cmd(EC_FIRMWARE_REV, NULL, 0,
>  			(unsigned char *) &olpc_platform_info.ecver,
> 1); 
> -#ifdef CONFIG_PCI_OLPC
>  	/* If the VSA exists let it emulate PCI, if not emulate in
> kernel */
> -	if (!cs5535_has_vsa2())
> +	if (machine_is_olpc_xo_1() && !cs5535_has_vsa2())
>  		x86_init.pci.arch_init = pci_olpc_init;
> -#endif
>  
>  	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
>  			((olpc_platform_info.boardrev & 0xf) < 8) ?
> "pre" : "", diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> index a0207a7..b0f2712 100644
> --- a/arch/x86/pci/Makefile
> +++ b/arch/x86/pci/Makefile
> @@ -3,7 +3,7 @@ obj-y				:= i386.o init.o
>  obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
>  obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o
> mmconfig-shared.o obj-$(CONFIG_PCI_DIRECT)	+= direct.o
> -obj-$(CONFIG_PCI_OLPC)		+= olpc.o
> +obj-$(CONFIG_OLPC)		+= olpc.o
>  
>  obj-y				+= fixup.o
>  obj-$(CONFIG_ACPI)		+= acpi.o
> diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
> index b348154..fa5ba7b 100644
> --- a/arch/x86/pci/olpc.c
> +++ b/arch/x86/pci/olpc.c
> @@ -1,5 +1,5 @@
>  /*
> - * Low-level PCI config space access for OLPC systems who lack the
> VSA
> + * Low-level PCI config space access for OLPC XO-1 systems who lack
> the VSA
>   * PCI virtualization software.
>   *
>   * Copyright © 2006  Advanced Micro Devices, Inc.
> @@ -304,7 +304,7 @@ static struct pci_raw_ops pci_olpc_conf = {
>  
>  int __init pci_olpc_init(void)
>  {
> -	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
> +	printk(KERN_INFO "PCI: Using configuration type OLPC
> XO-1\n"); raw_pci_ops = &pci_olpc_conf;
>  	is_lx = is_geode_lx();
>  	return 0;

