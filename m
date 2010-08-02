Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0HBUyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:54:03 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:48691 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0HBUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:54:00 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 16:53:59 EDT
Message-ID: <4C572EB0.7060706@mandriva.org>
Date: Mon, 02 Aug 2010 23:46:40 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100724 Mandriva/3.1.1-2mdv2011.0 (2011.0) Thunderbird/3.1.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michal Marek <mmarek@suse.cz>, linuxppc-dev@ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bug-make@gnu.org
Subject: Re: make 3.82 fails on powerpc defconfig update [was: Linux 2.6.35]
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>	<4C5686FF.9010803@mandriva.org> <20100802182848.GA16394@merkur.ravnborg.org>
In-Reply-To: <20100802182848.GA16394@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.08.2010 21:28, Sam Ravnborg skrev:
> On Mon, Aug 02, 2010 at 11:51:11AM +0300, Thomas Backlund wrote:
>> Hi,
>> (please cc me as I'm not subscribed)
>>
>> updating from make 3.81 to 3.82 gets me this:
>>
>> [thomas@tmb linux-2.6.35]$ cp arch/powerpc/configs/ppc64_defconfig .config
>> [thomas@tmb linux-2.6.35]$ LC_ALL=C make oldconfig ARCH=powerpc
>> /mnt/work/2.6.35/linux-2.6.35/arch/powerpc/Makefile:183: *** mixed  
>> implicit and normal rules.  Stop.
>>
>> The lines are:
>>
>> 182:
>> 183: $(BOOT_TARGETS): vmlinux
>> 184:         $(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst  
>> %,$(boot)/%,$@)
>> 185:
>>
>> BOOT_TARGETS are defined on line 166 as:
>> BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage% treeImage.%  
>> cuImage.% simpleImage.%
>>
>>
>> Now it's not a regression in the kernel as the same happends with the  
>> 2.6.34 tree too.
>>
>> (btw, the host I'm syncing the defconfig with is a x86_64 machine)
>>
>>
>> Now, I dont know if this is "intended breakage" by the make update, or  
>> if the Makefile needs to be updated....
>>
>> Any ideas how to fix ?
> 
> This is in the category "intended breakage".
> We had a similar issue in the top-level Makefile which Paul (IIRC)
> helped me to fix long time ago.
> 
> To fix popwerpc I suggest something along these lines.
> [Note: I did not test it - please do so.
> 
> 	Sam
> 
> [PATCH] powerpc: fix build with make 3.82
> 
> Thomas Backlund reported that the powerpc build broke with make 3.82.
> It failed with the following message:
> 
>     arch/powerpc/Makefile:183: *** mixed implicit and normal rules.  Stop.
> 
> The fix is to avoid mixing non-wildcard and wildcard targets.
> 
> Reported-by: Thomas Backlund <tmb@mandriva.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 77cfe7a..ad88b21 100644
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
> @@ -180,7 +182,9 @@ relocs_check: arch/powerpc/relocs_check.pl vmlinux
>  zImage: relocs_check
>  endif
>  
> -$(BOOT_TARGETS): vmlinux
> +$(BOOT_TARGETS1): vmlinux
> +	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
> +$(BOOT_TARGETS2): vmlinux
>  	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
>  
>  bootwrapper_install %.dtb:


Thanks, this seems to fix the first issue, but then I get the same erro on the following line 190:

190: bootwrapper_install %.dtb:
191:        $(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)


--
Thomas
