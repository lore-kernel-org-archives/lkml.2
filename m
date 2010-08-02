Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0HBVDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:03:39 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:59149 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab0HBVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:03:38 -0400
Message-ID: <4C5732A7.2050003@mandriva.org>
Date: Tue, 03 Aug 2010 00:03:35 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100724 Mandriva/3.1.1-2mdv2011.0 (2011.0) Thunderbird/3.1.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Backlund <tmb@mandriva.org>, Michal Marek <mmarek@suse.cz>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "bug-make@gnu.org" <bug-make@gnu.org>
Subject: Re: make 3.82 fails on powerpc defconfig update [was: Linux 2.6.35]
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com> <4C5686FF.9010803@mandriva.org> <20100802182848.GA16394@merkur.ravnborg.org> <4C572EB0.7060706@mandriva.org> <20100802205121.GA16520@merkur.ravnborg.org>
In-Reply-To: <20100802205121.GA16520@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.08.2010 23:51, Sam Ravnborg skrev:
>>
>> Thanks, this seems to fix the first issue, but then I get the same erro on the following line 190:
>>
>> 190: bootwrapper_install %.dtb:
>> 191:        $(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
>>
> 
> Obviously - dunno how I missed that.
> Updated patch below.
> 
> I will do a proper submission after you
> confirm that powerpc build is working with make 3.82.
> 

Yeah, that was an obvious fix, thanks!

One small typo fix below...
(a missing ':')

Otherwise it works here, so:

Tested-by: Thomas Backlund <tmb@mandriva.org>

> 	Sam
> 
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 77cfe7a..ace7a3e 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -163,9 +163,11 @@ drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
>  # Default to zImage, override when needed
>  all: zImage
>  
> -BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
> +# With make 3.82 we cannot mix normal and wildcard targets
> +BOOT_TARGETS1 := zImage zImage.initrd uImaged
> +BOOT_TARGETS2 := zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
>  
> -PHONY += $(BOOT_TARGETS)
> +PHONY += $(BOOT_TARGETS1) $(BOOT_TARGETS2)
>  
>  boot := arch/$(ARCH)/boot
>  
> @@ -180,10 +182,16 @@ relocs_check: arch/powerpc/relocs_check.pl vmlinux
>  zImage: relocs_check
>  endif
>  
> -$(BOOT_TARGETS): vmlinux
> +$(BOOT_TARGETS1): vmlinux
> +	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
> +$(BOOT_TARGETS2): vmlinux
> +	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
> +
> +
> +bootwrapper_install

bootwrapper_install:

>  	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
>  
> -bootwrapper_install %.dtb:
> +%.dtb:
>  	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
>  
>  define archhelp
> .
> 

--
Thomas
