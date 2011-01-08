Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1AHOKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:10:35 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:41600 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1AHOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:10:33 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Sam Ravnborg'" <sam@ravnborg.org>,
        "'lkml'" <linux-kernel@vger.kernel.org>,
        "'linux-kbuild'" <linux-kbuild@vger.kernel.org>,
        "'linux arch'" <linux-arch@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Michal Marek'" <mmarek@suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110108130427.GA25461@merkur.ravnborg.org>
In-Reply-To: <20110108130427.GA25461@merkur.ravnborg.org>
Subject: RE: [PATCH 1/2] kbuild: asm-generic support
Date: Sat, 8 Jan 2011 22:10:13 +0800
Message-ID: <02a001cbaf3d$c4b03820$4e10a860$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIVRfr/5g4pH+HCwkBSapEbzIVlUQH+IsxDkyP8wlA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Sam Ravnborg
> Sent: Saturday, January 08, 2011 9:04 PM
> To: lkml; linux-kbuild; linux arch; Arnd Bergmann; Guan Xuetao; Michal Marek
> Subject: [PATCH 1/2] kbuild: asm-generic support
> 
> >From 47a8c36e0549191ef8b0ba7dea01d7099b772760 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 8 Jan 2011 14:00:50 +0100
> Subject: [PATCH 1/2] kbuild: asm-generic support
> 
> There is an increasing amount of header files
> shared between individual architectures in asm-generic.
> To avoid a lot of dummy wrapper files that just
> include the corresponding file in asm-generic provide
> some basic support in kbuild for this.
> 
> With the followign patch an architecture can maintain
> a list of files in the file arch/$(ARCH)/include/asm-generic
> 
> For each file listed kbuild will generate the necessary wrapper
> in arch/$(ARCH)/include/generated/asm.
> When installing userspace headers a wrapper is likewise created.
> 
> The original inspiration for this came from the unicor32
> patchset - although is used a different method.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  Makefile                       |   12 +++++--
>  include/asm-generic/Kbuild.asm |   66 ++++++++++++++++++++--------------------
>  scripts/Makefile.headersinst   |   19 ++++++++++-
>  scripts/asm-generic.sh         |   23 ++++++++++++++
>  4 files changed, 82 insertions(+), 38 deletions(-)
>  create mode 100644 scripts/asm-generic.sh
> 
> diff --git a/Makefile b/Makefile
> index 74b2555..ee5437c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -344,7 +344,8 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
> 
>  # Use LINUXINCLUDE when you must reference the include/ directory.
>  # Needed to be compatible with the O= option
> -LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
> +LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
> +                   -Iarch/$(hrd-arch)/include/generated -Iinclude \
>                     $(if $(KBUILD_SRC), -I$(srctree)/include) \
>                     -include include/generated/autoconf.h
> 
> @@ -411,6 +412,11 @@ ifneq ($(KBUILD_SRC),)
>  	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
>  endif
> 
> +# Support for using generic headers in asm-generic
> +PHONY += asm-generic
> +asm-generic:
> +	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/asm-generic.sh $(SRCARCH)
> +
>  # To make sure we do not include .config for any of the *config targets
>  # catch them early, and hand them over to scripts/kconfig/Makefile
>  # It is allowed to specify more targets when calling make, including
> @@ -942,7 +948,7 @@ ifneq ($(KBUILD_SRC),)
>  endif
> 
>  # prepare2 creates a makefile if using a separate output directory
> -prepare2: prepare3 outputmakefile
> +prepare2: prepare3 outputmakefile asm-generic
> 
>  prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
>                     include/config/auto.conf
> @@ -1016,7 +1022,7 @@ hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
>  hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
> 
>  PHONY += __headers
> -__headers: include/linux/version.h scripts_basic FORCE
> +__headers: include/linux/version.h scripts_basic asm-generic FORCE
>  	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
> 
>  PHONY += headers_install_all
arch/$(hrd-arch)/include/generated dir need to be cleaned by adding it into MRPROPER_DIRS.

> diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
> index c5d2e5d..f859a88 100644
> --- a/include/asm-generic/Kbuild.asm
> +++ b/include/asm-generic/Kbuild.asm
> @@ -1,45 +1,45 @@
>  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
>  		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
> -header-y  += kvm.h
> +generic-y  += kvm.h
>  endif
> 
>  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
>  		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
> -header-y  += kvm_para.h
> +generic-y  += kvm_para.h
>  endif
> 
>  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
>  		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
> -header-y += a.out.h
> +generic-y += a.out.h
>  endif
> 
> -header-y += auxvec.h
> -header-y += bitsperlong.h
> -header-y += byteorder.h
> -header-y += errno.h
> -header-y += fcntl.h
> -header-y += ioctl.h
> -header-y += ioctls.h
> -header-y += ipcbuf.h
> -header-y += mman.h
> -header-y += msgbuf.h
> -header-y += param.h
> -header-y += poll.h
> -header-y += posix_types.h
> -header-y += ptrace.h
> -header-y += resource.h
> -header-y += sembuf.h
> -header-y += setup.h
> -header-y += shmbuf.h
> -header-y += sigcontext.h
> -header-y += siginfo.h
> -header-y += signal.h
> -header-y += socket.h
> -header-y += sockios.h
> -header-y += stat.h
> -header-y += statfs.h
> -header-y += swab.h
> -header-y += termbits.h
> -header-y += termios.h
> -header-y += types.h
> -header-y += unistd.h
> +generic-y += auxvec.h
> +generic-y += bitsperlong.h
> +generic-y += byteorder.h
> +generic-y += errno.h
> +generic-y += fcntl.h
> +generic-y += ioctl.h
> +generic-y += ioctls.h
> +generic-y += ipcbuf.h
> +generic-y += mman.h
> +generic-y += msgbuf.h
> +generic-y += param.h
> +generic-y += poll.h
> +generic-y += posix_types.h
> +generic-y += ptrace.h
> +generic-y += resource.h
> +generic-y += sembuf.h
> +generic-y += setup.h
> +generic-y += shmbuf.h
> +generic-y += sigcontext.h
> +generic-y += siginfo.h
> +generic-y += signal.h
> +generic-y += socket.h
> +generic-y += sockios.h
> +generic-y += stat.h
> +generic-y += statfs.h
> +generic-y += swab.h
> +generic-y += termbits.h
> +generic-y += termios.h
> +generic-y += types.h
> +generic-y += unistd.h
Kbuild.asm is included in arch/*/include/asm/Kbuild.
When replace all header-y with generic-y, the arch-spec headers will lost.

> diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
> index f89cb87..8cd8bb7 100644
> --- a/scripts/Makefile.headersinst
> +++ b/scripts/Makefile.headersinst
> @@ -28,9 +28,10 @@ install-file  := $(install)/.install
>  check-file    := $(install)/.check
> 
>  # all headers files for this dir
> -all-files     := $(header-y) $(objhdr-y)
> +all-files     := $(header-y) $(objhdr-y) $(generic-y)
>  input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
>                   $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
> +generic-files := $(addprefix $(install)/,$(generic-y))
>  output-files  := $(addprefix $(install)/, $(all-files))
> 
>  # Work out what needs to be removed
> @@ -68,8 +69,22 @@ ifndef HDRCHECK
>  __headersinst: $(subdirs) $(install-file)
>  	@:
> 
> +# List of generic files may have two sources.
> +# If a file exits in $(srctree)/$(obj) use it
> +# otherwise create a dummy that arch/$(ARCH)/include/
> +$(generic-files): scripts/headers_install.pl
> +	$(Q)set -e;                                                       \
> +	if [ -f $@ ]; then                                                \
> +		$(PERL) $< $(dir $@) $(install) $(SRCARCH) $(notdir $@);  \
> +	else                                                              \
> +	        mkdir -p $(install);                                      \
> +		echo "#include <asm-generic/$(notdir $@)>"                \
> +	             > $(install)/$(notdir $@);                           \
> +	fi
> +
>  targets += $(install-file)
> -$(install-file): scripts/headers_install.pl $(input-files) FORCE
> +$(install-file): scripts/headers_install.pl \
> +                 $(input-files) $(generic-files) FORCE
>  	$(if $(unwanted),$(call cmd,remove),)
>  	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
>  	$(call if_changed,install)
> diff --git a/scripts/asm-generic.sh b/scripts/asm-generic.sh
> new file mode 100644
> index 0000000..ec53b37
> --- /dev/null
> +++ b/scripts/asm-generic.sh
> @@ -0,0 +1,23 @@
> +#!/bin/sh
> +#
> +# include/asm-generic contains a lot of files that are used
> +# verbatim by several architectures.
> +# This scripts read the file arch/$(ARCH)/include/asm-generic
> +# and for each file listed in this file create a small include
> +# file in arch/$(ARCH)/include/generated/
> +
> +# If this arch does not have an asm-generic file exit
> +if [ ! -e ${srctree}/arch/$1/include/asm-generic ]; then
> +	exit 0
> +fi
> +
> +# read list of header files form asm-generic
> +files=$(grep -v ^# ${srctree}/arch/$1/include/asm-generic)
> +
> +gendir=arch/$1/include/generated/asm
> +mkdir -p ${gendir}
> +
> +# create include files for each file used form asm-generic
> +for F in ${files}; do
> +	echo "#include <asm-generic/$F>" > ${gendir}/$F
> +done
> --
> 1.6.0.6
> 
> --

Guan Xuetao

