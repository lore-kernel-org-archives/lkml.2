Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387Ab1KJNg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:36:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:43991 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1KJNgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:36:55 -0500
Subject: Re: [RFC PATCH 02/17] powerpc: Split up PHYS_64BIT config option to fix "select" issues
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 10 Nov 2011 07:36:06 -0600
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5AD601D7-7E16-42B0-BC5F-6D4333EC100E@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2011, at 6:07 PM, Kyle Moffett wrote:

> The "CONFIG_PHYS_64BIT" option violates the Kconfig best-practices in
> various colorful ways.  It has explicit dependencies, but it is also
> "select"ed by various CPUs and platforms.  It is not set on 64-bit
> systems, but it is used by a number of pieces of powerpc code to enable
> or disable 64-bit physical address support.
> 
> To resolve these issues, the option has now been split into 3:
> 
>  CONFIG_PHYS_64BIT_SUPPORTED:
>    This hidden option should be selected by any CPU type which supports
>    64-bit physical addresses.  This will enable the PHYS_64BIT option
>    to be selected.  It is (obviously) always set on PPC64.
> 
>  CONFIG_PHYS_64BIT_DT_REQUIRED:
>    This hidden option should be selected by any board or platform which
>    has >32-bit physical devices present in hardware.  If this is set
>    then the CONFIG_PHYS_64BIT option will be forcibly enabled and
>    hidden from the user.  It is (obviously) always set on PPC64.
> 
>  CONFIG_PHYS_64BIT:
>    This option is user-controllable, where allowed by CPU and platform
>    settings, and should never be pointed at with a "select" statement.
>    Due to the values of the above two options, this is never visible on
>    PPC64.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
> arch/powerpc/Kconfig                   |    4 ++--
> arch/powerpc/platforms/82xx/Kconfig    |    2 +-
> arch/powerpc/platforms/83xx/Kconfig    |    2 +-
> arch/powerpc/platforms/85xx/Kconfig    |   12 ++++++------
> arch/powerpc/platforms/86xx/Kconfig    |    1 +
> arch/powerpc/platforms/Kconfig.cputype |   25 ++++++++++++++++++-------
> 6 files changed, 29 insertions(+), 17 deletions(-)

I don't really see what this gets us and don't think we should make this change.

- k

> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index b177caa..27e31c5 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -18,10 +18,10 @@ config WORD_SIZE
> 	default 32 if !PPC64
> 
> config ARCH_PHYS_ADDR_T_64BIT
> -       def_bool PPC64 || PHYS_64BIT
> +	def_bool PHYS_64BIT
> 
> config ARCH_DMA_ADDR_T_64BIT
> -	def_bool ARCH_PHYS_ADDR_T_64BIT
> +	def_bool PHYS_64BIT
> 
> config MMU
> 	bool
> diff --git a/arch/powerpc/platforms/82xx/Kconfig b/arch/powerpc/platforms/82xx/Kconfig
> index 7c7df40..849d403 100644
> --- a/arch/powerpc/platforms/82xx/Kconfig
> +++ b/arch/powerpc/platforms/82xx/Kconfig
> @@ -1,6 +1,6 @@
> menuconfig PPC_82xx
> 	bool "82xx-based boards (PQ II)"
> -	depends on 6xx
> +	depends on 6xx && !PHYS_64BIT
> 
> if PPC_82xx
> 
> diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
> index 670a033..1ed8877 100644
> --- a/arch/powerpc/platforms/83xx/Kconfig
> +++ b/arch/powerpc/platforms/83xx/Kconfig
> @@ -1,6 +1,6 @@
> menuconfig PPC_83xx
> 	bool "83xx-based boards"
> -	depends on 6xx
> +	depends on 6xx && !PHYS_64BIT
> 	select PPC_UDBG_16550
> 	select PPC_PCI_CHOICE
> 	select FSL_PCI if PCI
> diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
> index 9088381..37f9de7 100644
> --- a/arch/powerpc/platforms/85xx/Kconfig
> +++ b/arch/powerpc/platforms/85xx/Kconfig
> @@ -80,7 +80,7 @@ config P1010_RDB
> config P1022_DS
> 	bool "Freescale P1022 DS"
> 	select DEFAULT_UIMAGE
> -	select PHYS_64BIT	# The DTS has 36-bit addresses
> +	select PHYS_64BIT_DT_REQUIRED # The DTS has 36-bit addresses
> 	select SWIOTLB
> 	help
> 	  This option enables support for the Freescale P1022DS reference board.
> @@ -175,7 +175,7 @@ config P2041_RDB
> 	bool "Freescale P2041 RDB"
> 	select DEFAULT_UIMAGE
> 	select PPC_E500MC
> -	select PHYS_64BIT
> +	select PHYS_64BIT_DT_REQUIRED
> 	select SWIOTLB
> 	select ARCH_REQUIRE_GPIOLIB
> 	select GPIO_MPC8XXX
> @@ -189,7 +189,7 @@ config P3041_DS
> 	bool "Freescale P3041 DS"
> 	select DEFAULT_UIMAGE
> 	select PPC_E500MC
> -	select PHYS_64BIT
> +	select PHYS_64BIT_DT_REQUIRED
> 	select SWIOTLB
> 	select ARCH_REQUIRE_GPIOLIB
> 	select GPIO_MPC8XXX
> @@ -203,7 +203,7 @@ config P3060_QDS
> 	bool "Freescale P3060 QDS"
> 	select DEFAULT_UIMAGE
> 	select PPC_E500MC
> -	select PHYS_64BIT
> +	select PHYS_64BIT_DT_REQUIRED
> 	select SWIOTLB
> 	select MPC8xxx_GPIO
> 	select HAS_RAPIDIO
> @@ -216,7 +216,7 @@ config P4080_DS
> 	bool "Freescale P4080 DS"
> 	select DEFAULT_UIMAGE
> 	select PPC_E500MC
> -	select PHYS_64BIT
> +	select PHYS_64BIT_DT_REQUIRED
> 	select SWIOTLB
> 	select ARCH_REQUIRE_GPIOLIB
> 	select GPIO_MPC8XXX
> @@ -233,7 +233,7 @@ config P5020_DS
> 	select DEFAULT_UIMAGE
> 	select E500
> 	select PPC_E500MC
> -	select PHYS_64BIT
> +	select PHYS_64BIT_DT_REQUIRED
> 	select SWIOTLB
> 	select ARCH_REQUIRE_GPIOLIB
> 	select GPIO_MPC8XXX
> diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
> index 8d6599d..576eb43 100644
> --- a/arch/powerpc/platforms/86xx/Kconfig
> +++ b/arch/powerpc/platforms/86xx/Kconfig
> @@ -5,6 +5,7 @@ menuconfig PPC_86xx
> 	select FSL_SOC
> 	select ALTIVEC
> 	select ARCH_WANT_OPTIONAL_GPIOLIB
> +	select PHYS_64BIT_SUPPORTED
> 	help
> 	  The Freescale E600 SoCs have 74xx cores.
> 
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 9210e94..0ab01b0 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -26,6 +26,7 @@ config PPC_BOOK3S_32
> 
> config PPC_85xx
> 	bool "Freescale 85xx"
> +	select PHYS_64BIT_SUPPORTED
> 	select E500
> 
> config PPC_8xx
> @@ -47,7 +48,8 @@ config 44x
> 	select PPC_UDBG_16550
> 	select 4xx_SOC
> 	select PPC_PCI_CHOICE
> -	select PHYS_64BIT
> +	select PHYS_64BIT_SUPPORTED
> +	select PHYS_64BIT_DT_REQUIRED
> 
> config E200
> 	bool "Freescale e200"
> @@ -187,14 +189,20 @@ config PPC_FSL_BOOK3E
> 	select PPC_SMP_MUXED_IPI
> 	default y if FSL_BOOKE
> 
> -config PTE_64BIT
> -	bool
> -	depends on 44x || E500 || PPC_86xx
> -	default y if PHYS_64BIT
> +## Only some 32-bit CPUs support 64-bit physical addresses
> +config PHYS_64BIT_SUPPORTED
> +	def_bool PPC64
> +
> +## Some 32-bit system device trees have >32-bit physical addresses, and so
> +## the kernel won't boot unless those are supported.
> +config PHYS_64BIT_DT_REQUIRED
> +	def_bool PPC64
> 
> +## DO NOT "select" this user-visible symbol, select the two above instead!
> config PHYS_64BIT
> -	bool 'Large physical address support' if E500 || PPC_86xx
> -	depends on (44x || E500 || PPC_86xx) && !PPC_83xx && !PPC_82xx
> +	def_bool PHYS_64BIT_DT_REQUIRED
> +	prompt 'Large physical address support' if !PHYS_64BIT_DT_REQUIRED
> +	depends on PHYS_64BIT_SUPPORTED
> 	---help---
> 	  This option enables kernel support for larger than 32-bit physical
> 	  addresses.  This feature may not be available on all cores.
> @@ -205,6 +213,9 @@ config PHYS_64BIT
> 
> 	  If in doubt, say N here.
> 
> +config PTE_64BIT
> +	def_bool PHYS_64BIT
> +
> config ALTIVEC
> 	bool "AltiVec Support"
> 	depends on 6xx || POWER4
> -- 
> 1.7.2.5

