Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2LZO2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 09:28:53 -0500
Received: from [65.55.88.13] ([65.55.88.13]:44810 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab2LZO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 09:28:50 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z37d4lz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dh8275ch17326ahz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 26 Dec 2012 22:27:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Sam Ravnborg <sam@ravnborg.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V7 2/7] ARM: dt: change .dtb build rules to build in dts
 directory
Message-ID: <20121226142739.GA28980@S2101-09.ap.freescale.net>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
 <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:29:11PM -0700, Stephen Warren wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> The current rules have the .dtb files build in a different directory
> from the .dts files. The only reason for this is that it was what
> PowerPC has done historically. This patch changes ARM to use the generic
> dtb rule which builds .dtb files in the same directory as the source .dts.
> 
It's a pity that after merging the patch, all the enabled dts files
will be rebuilt anyway no matter whether they are actually changed
or not.

Shawn

> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> [swarren: added rm command for old stale .dtb files]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v7: New patch.
> ---
>  arch/arm/Makefile          |    4 ++--
>  arch/arm/boot/Makefile     |   12 ------------
>  arch/arm/boot/dts/Makefile |    8 ++++++++
>  3 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 1ec5f67..5f92252 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -291,10 +291,10 @@ zinstall uinstall install: vmlinux
>  	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
>  
>  %.dtb: scripts
> -	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
> +	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
>  
>  dtbs: scripts
> -	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
> +	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) dtbs
>  
>  # We use MRPROPER_FILES and CLEAN_FILES now
>  archclean:
> diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
> index 9137df5..abfce28 100644
> --- a/arch/arm/boot/Makefile
> +++ b/arch/arm/boot/Makefile
> @@ -15,8 +15,6 @@ ifneq ($(MACHINE),)
>  include $(srctree)/$(MACHINE)/Makefile.boot
>  endif
>  
> -include $(srctree)/arch/arm/boot/dts/Makefile
> -
>  # Note: the following conditions must always be true:
>  #   ZRELADDR == virt_to_phys(PAGE_OFFSET + TEXT_OFFSET)
>  #   PARAMS_PHYS must be within 4MB of ZRELADDR
> @@ -59,16 +57,6 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
>  
>  endif
>  
> -targets += $(dtb-y)
> -
> -# Rule to build device tree blobs
> -$(obj)/%.dtb: $(src)/dts/%.dts FORCE
> -	$(call if_changed_dep,dtc)
> -
> -$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
> -
> -clean-files := *.dtb
> -
>  ifneq ($(LOADADDR),)
>    UIMAGE_LOADADDR=$(LOADADDR)
>  else
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index a17d5ab..cb217f8 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -136,4 +136,12 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>  	wm8650-mid.dtb
>  dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
>  
> +targets += dtbs
>  endif
> +
> +dtbs: $(addprefix $(obj)/, $(dtb-y))
> +	# *.dtb used to be generated in the directory above. Clean out the
> +	# old build results so people don't accidentally use them.
> +	rm -f $(obj)/../*.dtb
> +
> +clean-files := *.dtb
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

