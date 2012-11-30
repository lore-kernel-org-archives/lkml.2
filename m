Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab2K3QB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:01:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59903 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2K3QBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:01:53 -0500
Message-ID: <50B8D86E.1080109@gmail.com>
Date: Fri, 30 Nov 2012 10:01:50 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Mark Salter <msalter@redhat.com>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au, Chris Zankel <chris@zankel.net>,
        linux-xtensa@linux-xtensa.org, Max Filippov <jcmvbkbc@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH V7 1/7] kbuild: centralize .dts->.dtb rule
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 05:29 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> All architectures that use cmd_dtc do so in almost the same way. Create
> a central build rule to avoid duplication. The one difference is that
> most current uses of dtc build $(obj)/%.dtb from $(src)/dts/%.dts rather
> than building the .dtb in the same directory as the .dts file. This
> difference will be eliminated arch-by-arch in future patches.
> 
> MIPS is the exception here; it already uses the exact same rule as the
> new common rule, so the duplicate is removed in this patch to avoid any
> conflict. arch/mips changes courtesy of Ralf Baechle.
> 
> Update Documentation/kbuild to remove the explicit call to cmd_dtc from
> the example, now that the rule exists in a centralized location.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: Chris Zankel <chris@zankel.net>
> Cc: linux-xtensa@linux-xtensa.org
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This is based on next-20121126.
> 

I'll apply the series but I need a stable base. Looks like xtensa has
the dependency. Or I can just drop xtensa.

Rob

> I've split out this dtc rule cleanup as a separate patch series.
> Hopefully it can be applied without too much controversy, then I'll move
> back to discussing running cpp over *.dts.
> 
> v7:
> * Build *.dtb from *.dts not src/*.dts.
> * Removed all arch/ updates except MIPS.
> v6: Added arch/{arm64,microblaze,mips} updates.
> v5: Updated Documentation/kbuild.
> v4: No change.
> v3: No change.
> v2: New patch.
> ---
>  Documentation/kbuild/makefiles.txt |   15 ++++++++-------
>  arch/mips/cavium-octeon/Makefile   |    3 ---
>  arch/mips/lantiq/dts/Makefile      |    3 ---
>  arch/mips/netlogic/dts/Makefile    |    3 ---
>  scripts/Makefile.lib               |    3 +++
>  5 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index ec9ae67..14c3f4f 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -1175,15 +1175,16 @@ When kbuild executes, the following steps are followed (roughly):
>  	in an init section in the image. Platform code *must* copy the
>  	blob to non-init memory prior to calling unflatten_device_tree().
>  
> -	Example:
> -		#arch/x86/platform/ce4100/Makefile
> -		clean-files := *dtb.S
> +	To use this command, simply add *.dtb into obj-y or targets, or make
> +	some other target depend on %.dtb
>  
> -		DTC_FLAGS := -p 1024
> -		obj-y += foo.dtb.o
> +	A central rule exists to create $(obj)/%.dtb from $(src)/%.dts;
> +	architecture Makefiles do no need to explicitly write out that rule.
>  
> -		$(obj)/%.dtb: $(src)/%.dts
> -			$(call cmd,dtc)
> +	Example:
> +		targets += $(dtb-y)
> +		clean-files += *.dtb
> +		DTC_FLAGS ?= -p 1024
>  
>  --- 6.8 Custom kbuild commands
>  
> diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
> index bc96e29..6e927cf 100644
> --- a/arch/mips/cavium-octeon/Makefile
> +++ b/arch/mips/cavium-octeon/Makefile
> @@ -24,9 +24,6 @@ DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
>  
>  obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
>  
> -$(obj)/%.dtb: $(src)/%.dts FORCE
> -	$(call if_changed_dep,dtc)
> -
>  # Let's keep the .dtb files around in case we want to look at them.
>  .SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
>  
> diff --git a/arch/mips/lantiq/dts/Makefile b/arch/mips/lantiq/dts/Makefile
> index 674fca4..6fa72dd 100644
> --- a/arch/mips/lantiq/dts/Makefile
> +++ b/arch/mips/lantiq/dts/Makefile
> @@ -1,4 +1 @@
>  obj-$(CONFIG_DT_EASY50712) := easy50712.dtb.o
> -
> -$(obj)/%.dtb: $(obj)/%.dts
> -	$(call if_changed,dtc)
> diff --git a/arch/mips/netlogic/dts/Makefile b/arch/mips/netlogic/dts/Makefile
> index 67ae3fe2..d117d46 100644
> --- a/arch/mips/netlogic/dts/Makefile
> +++ b/arch/mips/netlogic/dts/Makefile
> @@ -1,4 +1 @@
>  obj-$(CONFIG_DT_XLP_EVP) := xlp_evp.dtb.o
> -
> -$(obj)/%.dtb: $(obj)/%.dts
> -	$(call if_changed,dtc)
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 0be6f11..bdf42fd 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -266,6 +266,9 @@ $(obj)/%.dtb.S: $(obj)/%.dtb
>  quiet_cmd_dtc = DTC     $@
>  cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile) $<
>  
> +$(obj)/%.dtb: $(src)/%.dts FORCE
> +	$(call if_changed_dep,dtc)
> +
>  # Bzip2
>  # ---------------------------------------------------------------------------
>  
> 
