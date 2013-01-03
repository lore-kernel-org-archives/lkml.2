Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3ACXPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:15:21 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45096 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3ACXPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:15:17 -0500
Message-ID: <50E610FD.8010307@zankel.net>
Date: Fri, 04 Jan 2013 00:15:09 +0100
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST] xtensa: use new common dtc rule
References: <1357151234-5681-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1357151234-5681-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for the patch. I have added it to the 'for_next' tree. Max, since 
you added that feature for Xtensa, any comments before I ask to pull?

-Chris


On 1/2/13 7:27 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> The current rules have the .dtb files build in a different directory
> from the .dts files. This patch changes xtensa to use the generic dtb
> rule which builds .dtb files in the same directory as the source .dts.
>
> This requires moving parts of arch/xtensa/boot/Makefile into newly
> created arch/xtensa/boot/dts/Makefile, and updating arch/xtensa/Makefile
> to call the new Makefile.
>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-xtensa@linux-xtensa.org
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This patch applies recent dtc-rule-related changes to the xtensa arch.
> They couldn't be applied along with the similar changes for other archs
> due to dependencies on other xtensa changes. This should apply OK now to
> Linus's tree, or for 3.9.
>
> Note: I have not tested this recently.
>
>   arch/xtensa/Makefile          |    4 ++--
>   arch/xtensa/boot/Makefile     |   12 ------------
>   arch/xtensa/boot/dts/Makefile |   15 +++++++++++++++
>   3 files changed, 17 insertions(+), 14 deletions(-)
>   create mode 100644 arch/xtensa/boot/dts/Makefile
>
> diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
> index 0aa7270..48c1a5b 100644
> --- a/arch/xtensa/Makefile
> +++ b/arch/xtensa/Makefile
> @@ -88,7 +88,7 @@ core-y		+= $(buildvar) $(buildplf)
>   libs-y		+= arch/xtensa/lib/ $(LIBGCC)
>   
>   ifneq ($(CONFIG_BUILTIN_DTB),"")
> -core-$(CONFIG_OF) += arch/xtensa/boot/
> +core-$(CONFIG_OF) += arch/xtensa/boot/dts/
>   endif
>   
>   boot		:= arch/xtensa/boot
> @@ -101,7 +101,7 @@ zImage: vmlinux
>   	$(Q)$(MAKE) $(build)=$(boot) $@
>   
>   %.dtb:
> -	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> +	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
>   
>   define archhelp
>     @echo '* zImage      - Compressed kernel image (arch/xtensa/boot/images/zImage.*)'
> diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
> index 818647e..64ffc4b 100644
> --- a/arch/xtensa/boot/Makefile
> +++ b/arch/xtensa/boot/Makefile
> @@ -25,18 +25,6 @@ bootdir-$(CONFIG_XTENSA_PLATFORM_ISS)	 += boot-elf
>   bootdir-$(CONFIG_XTENSA_PLATFORM_XT2000) += boot-redboot boot-elf boot-uboot
>   bootdir-$(CONFIG_XTENSA_PLATFORM_XTFPGA) += boot-redboot boot-elf boot-uboot
>   
> -
> -BUILTIN_DTB := $(patsubst "%",%,$(CONFIG_BUILTIN_DTB)).dtb.o
> -ifneq ($(CONFIG_BUILTIN_DTB),"")
> -obj-$(CONFIG_OF) += $(BUILTIN_DTB)
> -endif
> -
> -# Rule to build device tree blobs
> -$(obj)/%.dtb: $(src)/dts/%.dts FORCE
> -	$(call if_changed_dep,dtc)
> -
> -clean-files := *.dtb.S
> -
>   zImage Image: $(bootdir-y)
>   
>   $(bootdir-y): $(addprefix $(obj)/,$(subdir-y)) \
> diff --git a/arch/xtensa/boot/dts/Makefile b/arch/xtensa/boot/dts/Makefile
> new file mode 100644
> index 0000000..5f711bb
> --- /dev/null
> +++ b/arch/xtensa/boot/dts/Makefile
> @@ -0,0 +1,15 @@
> +#
> +# arch/xtensa/boot/dts/Makefile
> +#
> +# This file is subject to the terms and conditions of the GNU General Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
> +#
> +#
> +
> +BUILTIN_DTB := $(patsubst "%",%,$(CONFIG_BUILTIN_DTB)).dtb.o
> +ifneq ($(CONFIG_BUILTIN_DTB),"")
> +obj-$(CONFIG_OF) += $(BUILTIN_DTB)
> +endif
> +
> +clean-files := *.dtb.S

