Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab2CGHCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 02:02:45 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:55173 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2CGHCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 02:02:43 -0500
Message-ID: <1331103163.2048.33.camel@epip-laptop>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 14:52:43 +0800
In-Reply-To: <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
	 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
Organization: MPRC, PKU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 17:30 -0700, Stephen Warren wrote:
> This allows the user to use U-Boot's mkimage's -T kernel_noload option
> if their arch Kconfig allows it, and they desire.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
> that some other architectures will also be able to enable it, but I'm
> not familiar enough with any to know which.
> 
>  init/Kconfig         |   15 +++++++++++++++
>  scripts/Makefile.lib |   15 ++++++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 6cfd71d..2035562 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -203,6 +203,21 @@ config KERNEL_LZO
>  
>  endchoice
>  
> +config ALLOW_UIMAGE_KERNEL_NOLOAD
> +	bool
> +
> +config UIMAGE_KERNEL_NOLOAD
> +	bool "Use mkimage's -T kernel_noload instead of -T kernel"
> +	depends on ALLOW_UIMAGE_KERNEL_NOLOAD
> +	help
> +	  uImage files of type "kernel" embed an absolute load and entry point
> +	  address. If the uImage is loaded to a different address, then the
> +	  image must be copied the uImage file to the specified load address.
> +	  This copy is a waste of time if the uImage is in fact completely
> +	  relocatable. If your kernel and bootloader support it, you can build
> +	  a "kernel_noload" uImage rather than a "kernel" uImage, which
> +	  prevents any such copying. If unsure say N.
> +
>  config DEFAULT_HOSTNAME
>  	string "Default hostname"
>  	default "(none)"
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 7b0be18..d9c1c87 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -314,9 +314,18 @@ MKIMAGE := $(srctree)/scripts/mkuboot.sh
>  UIMAGE_ARCH = $(SRCARCH)
>  UIMAGE_COMPRESSION = $(if $(2),$(2),none)
>  UIMAGE_OPTS-y =
> -UIMAGE_TYPE = kernel
> -UIMAGE_LOADADDR=arch_must_set_this
> -UIMAGE_ENTRYADDR=$(UIMAGE_LOADADDR)
> +ifeq ($(CONFIG_UIMAGE_KERNEL_NOLOAD),y)
> +  UIMAGE_TYPE = kernel_noload
> +  # Unused by bootloader:
> +  UIMAGE_LOADADDR=0
> +  # Entry point relative to actual load address:
> +  UIMAGE_ENTRYADDR=0
> +else
> +  UIMAGE_TYPE = kernel
> +  # Absolute addresses:
> +  UIMAGE_LOADADDR=arch_must_set_this
> +  UIMAGE_ENTRYADDR=$(UIMAGE_LOADADDR)
> +endif
>  UIMAGE_NAME = 'Linux-$(KERNELRELEASE)'
>  UIMAGE_IN = $<
>  UIMAGE_OUT = $@
Hi, Stephen,
It seems that UIMAGE_ARCH and UIMAGE_LOADADDR can't be modified from
arch-Makefiles.

Regards,

Guan Xuetao

