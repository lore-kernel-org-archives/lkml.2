Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2EHSxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:53:54 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:53102 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2EHSxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:53:53 -0400
Date: Tue, 8 May 2012 20:53:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: Re: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
Message-ID: <20120508185349.GA12013@merkur.ravnborg.org>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> new file mode 100644
> index 0000000..f22a4f8
> --- /dev/null
> +++ b/arch/x86/realmode/Makefile
> @@ -0,0 +1,20 @@
> +#
> +# arch/x86/realmode/Makefile
Drop filename inside files - they will get wrong.

> +#
> +# This file is subject to the terms and conditions of the GNU General Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
This is useless boilerplate.

> --- /dev/null
> +++ b/arch/x86/realmode/rm/.gitignore
> @@ -0,0 +1,3 @@
> +pasyms.h
> +realmode.lds
> +realmode.relocs
> diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
> new file mode 100644
> index 0000000..7c3f202
> --- /dev/null
> +++ b/arch/x86/realmode/rm/Makefile
> @@ -0,0 +1,63 @@
> +#
> +# arch/x86/realmode/Makefile

And I think you proved my point concerning the filename here :-)

> +#
> +# This file is subject to the terms and conditions of the GNU General Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
> +#
> +#
> +
> +subdir- := wakeup
> +
> +always := realmode.bin
> +
> +realmode-y			+= header.o
I see no reason to use the "-y" variant of the name here.

> +
> +targets	+= $(realmode-y)
> +
> +REALMODE_OBJS = $(addprefix $(obj)/,$(realmode-y))

We try to avoid ALL_CAPS stuff in linux makefiles.
It is unreadable.

> +
> +sed-pasyms := -n -r -e 's/^([0-9a-fA-F]+) [ABCDGRSTVW] (.+)$$/pa_\2 = \2;/p'
> +
> +quiet_cmd_pasyms = PASYMS  $@
> +      cmd_pasyms = $(NM) $(filter-out FORCE,$^) | \
> +		   sed $(sed-pasyms) | sort | uniq > $@
> +
> +$(obj)/pasyms.h: $(REALMODE_OBJS) FORCE
> +	$(call if_changed,pasyms)
> +
> +$(obj)/realmode.lds: $(obj)/pasyms.h
> +
> +LDFLAGS_realmode.elf := --emit-relocs -T
> +CPPFLAGS_realmode.lds += -P -C -I$(obj)
> +
> +$(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
> +	$(call if_changed,ld)
> +
> +OBJCOPYFLAGS_realmode.bin := -O binary
> +
> +$(obj)/realmode.bin: $(obj)/realmode.elf
> +	$(call if_changed,objcopy)
> +
> +quiet_cmd_relocs = RELOCS  $@
> +      cmd_relocs = scripts/x86-relocs --realmode $< > $@
> +$(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
> +	$(call if_changed,relocs)
> +
> +# ---------------------------------------------------------------------------
> +
> +# How to compile the 16-bit code.  Note we always compile for -march=i386,
> +# that way we can complain to the user if the CPU is insufficient.
> +KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
> +		   -DDISABLE_BRANCH_PROFILING \
> +		   -Wall -Wstrict-prototypes \
> +		   -march=i386 -mregparm=3 \
> +		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
> +		   -fno-strict-aliasing -fomit-frame-pointer \
> +		   $(call cc-option, -ffreestanding) \
> +		   $(call cc-option, -fno-toplevel-reorder,\
> +			$(call cc-option, -fno-unit-at-a-time)) \
> +		   $(call cc-option, -fno-stack-protector) \
> +		   $(call cc-option, -mpreferred-stack-boundary=2)
> +KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__

How much is needed to avoid this misuse of kernel-internal build rules?
This was and is an ugly hack.

	Sam
