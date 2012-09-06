Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab2IFUni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:43:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46292 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2IFUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:43:35 -0400
Date: Thu, 6 Sep 2012 21:43:27 +0100
From: James Hogan <james@albanarts.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
Message-ID: <20120906204327.GA4785@balrog.le.imgtec.org>
References: <20120428205651.GA7426@merkur.ravnborg.org>
 <20120428205919.GC7442@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120428205919.GC7442@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Sat, Apr 28, 2012 at 10:59:19PM +0200, Sam Ravnborg wrote:
> From c92ef0a63bb191fb7642e744e8c5865a983713fa Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 28 Apr 2012 20:03:59 +0200
> Subject: [PATCH 3/4] kbuild: link of vmlinux moved to a script
> 
> Move the final link of vmlinux to a script to improve
> readability and maintainability of the code.
> The Makefil fragments used to link vmlinux has over the
> years seen far too much changes and the logic was very
> hard to follow.

Unfortunately this doesn't appear to take into account that some
architectures add arguments to the KALLSYMS Makefile variable in their
own Makefiles. For example arch/blackfin/Makefile contains the line:
KALLSYMS += --symbol-prefix=_

The script doesn't include this when it calls ./scripts/kallsyms and as
a result kallsyms_addresses won't correctly override the weak symbol
_kallsyms_addresses on such architectures, and it'll hit the BUG_ONs in
kernel/kallsyms.c when kallsyms is used, e.g. to print a backtrace:

BUG_ON(!kallsyms_addresses);

Any thoughts about what the preferred solution would be? There is a
Kconfig variable CONFIG_SYMBOL_PREFIX which it may be more convenient to
use rather than relying on the architecture's Makefile to adjust the
KALLSYMS command.

Cheers
James

> 
> As the process by nature is serialized there was
> nothing gained including this in the Makefile.
> 
> "um" has special link requirments - and the
> only was to handle this was to hard-code the linking
> of "um" in the script.
> This was better than trying to modularize it only for the
> benefit of "um" anyway.
> 
> The shell script has been improved after input from:
> Arnaud Lacombe <lacombar@gmail.com>
> Nick Bowler <nbowler@elliptictech.com>
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Arnaud Lacombe <lacombar@gmail.com>
> Cc: Nick Bowler <nbowler@elliptictech.com>
> Cc: Richard Weinberger <richard@nod.at>
> ---
>  Makefile                |  215 +++--------------------------------------------
>  arch/um/Makefile        |   11 +--
>  scripts/link-vmlinux.sh |  211 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 225 insertions(+), 212 deletions(-)
>  create mode 100644 scripts/link-vmlinux.sh
> 
> diff --git a/Makefile b/Makefile
> index 00bf5b1..e196ec3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -341,7 +341,6 @@ AWK		= awk
>  GENKSYMS	= scripts/genksyms/genksyms
>  INSTALLKERNEL  := installkernel
>  DEPMOD		= /sbin/depmod
> -KALLSYMS	= scripts/kallsyms
>  PERL		= perl
>  CHECK		= sparse
>  
> @@ -727,191 +726,21 @@ libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
>  libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
>  libs-y		:= $(libs-y1) $(libs-y2)
>  
> -# externally visible symbols
> +# Externally visible symbols (used by link-vmlinux.sh)
>  export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
>  export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
>  export KBUILD_LDS          := arch/$(SRCARCH)/kernel/vmlinux.lds
> +export LDFLAGS_vmlinux
>  
> -# Build vmlinux
> -# ---------------------------------------------------------------------------
> -# vmlinux is built from the objects selected by $(vmlinux-init) and
> -# $(vmlinux-main). Most are built-in.o files from top-level directories
> -# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
> -# Ordering when linking is important, and $(vmlinux-init) must be first.
> -#
> -# vmlinux
> -#   ^
> -#   |
> -#   +-< $(vmlinux-init)
> -#   |   +--< init/version.o + more
> -#   |
> -#   +--< $(vmlinux-main)
> -#   |    +--< driver/built-in.o mm/built-in.o + more
> -#   |
> -#   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
> -#
> -# vmlinux version (uname -v) cannot be updated during normal
> -# descending-into-subdirs phase since we do not yet know if we need to
> -# update vmlinux.
> -# Therefore this step is delayed until just before final link of vmlinux -
> -# except in the kallsyms case where it is done just before adding the
> -# symbols to the kernel.
> -#
> -# System.map is generated to document addresses of all kernel symbols
> -
> -vmlinux-init := $(head-y) $(init-y)
> -vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
> -vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
> -vmlinux-lds  := arch/$(SRCARCH)/kernel/vmlinux.lds
> -
> -# Rule to link vmlinux - also used during CONFIG_KALLSYMS
> -# May be overridden by arch/$(ARCH)/Makefile
> -quiet_cmd_vmlinux__ ?= LD      $@
> -      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
> -      -T $(vmlinux-lds) $(vmlinux-init)                          \
> -      --start-group $(vmlinux-main) --end-group                  \
> -      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
> -
> -# Generate new vmlinux version
> -quiet_cmd_vmlinux_version = GEN     .version
> -      cmd_vmlinux_version = set -e;                     \
> -	if [ ! -r .version ]; then			\
> -	  rm -f .version;				\
> -	  echo 1 >.version;				\
> -	else						\
> -	  mv .version .old_version;			\
> -	  expr 0$$(cat .old_version) + 1 >.version;	\
> -	fi;						\
> -	$(MAKE) $(build)=init
> -
> -# Generate System.map
> -quiet_cmd_sysmap = SYSMAP
> -      cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
> -
> -# Link of vmlinux
> -# If CONFIG_KALLSYMS is set .version is already updated
> -# Generate System.map and verify that the content is consistent
> -# Use + in front of the vmlinux_version rule to silent warning with make -j2
> -# First command is ':' to allow us to use + in front of the rule
> -define rule_vmlinux__
> -	:
> -	$(if $(CONFIG_KALLSYMS),,+$(call cmd,vmlinux_version))
> -
> -	$(call cmd,vmlinux__)
> -	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
> -
> -	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
> -	  echo '  $($(quiet)cmd_sysmap)  System.map' &&)                     \
> -	$(cmd_sysmap) $@ System.map;                                         \
> -	if [ $$? -ne 0 ]; then                                               \
> -		rm -f $@;                                                    \
> -		/bin/false;                                                  \
> -	fi;
> -	$(verify_kallsyms)
> -endef
> -
> -
> -ifdef CONFIG_KALLSYMS
> -# Generate section listing all symbols and add it into vmlinux $(kallsyms.o)
> -# It's a three stage process:
> -# o .tmp_vmlinux1 has all symbols and sections, but __kallsyms is
> -#   empty
> -#   Running kallsyms on that gives us .tmp_kallsyms1.o with
> -#   the right size - vmlinux version (uname -v) is updated during this step
> -# o .tmp_vmlinux2 now has a __kallsyms section of the right size,
> -#   but due to the added section, some addresses have shifted.
> -#   From here, we generate a correct .tmp_kallsyms2.o
> -# o The correct .tmp_kallsyms2.o is linked into the final vmlinux.
> -# o Verify that the System.map from vmlinux matches the map from
> -#   .tmp_vmlinux2, just in case we did not generate kallsyms correctly.
> -# o If 'make KALLSYMS_EXTRA_PASS=1" was used, do an extra pass using
> -#   .tmp_vmlinux3 and .tmp_kallsyms3.o.  This is only meant as a
> -#   temporary bypass to allow the kernel to be built while the
> -#   maintainers work out what went wrong with kallsyms.
> -
> -last_kallsyms := 2
> -
> -ifdef KALLSYMS_EXTRA_PASS
> -ifneq ($(KALLSYMS_EXTRA_PASS),0)
> -last_kallsyms := 3
> -endif
> -endif
> -
> -kallsyms.o := .tmp_kallsyms$(last_kallsyms).o
> -
> -define verify_kallsyms
> -	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
> -	  echo '  $($(quiet)cmd_sysmap)  .tmp_System.map' &&)                \
> -	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
> -	$(Q)cmp -s System.map .tmp_System.map ||                             \
> -		(echo Inconsistent kallsyms data;                            \
> -		 echo This is a bug - please report about it;                \
> -		 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround;      \
> -		 rm .tmp_kallsyms* ; /bin/false )
> -endef
> -
> -# Update vmlinux version before link
> -# Use + in front of this rule to silent warning about make -j1
> -# First command is ':' to allow us to use + in front of this rule
> -cmd_ksym_ld = $(cmd_vmlinux__)
> -define rule_ksym_ld
> -	: 
> -	+$(call cmd,vmlinux_version)
> -	$(call cmd,vmlinux__)
> -	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
> -endef
> -
> -# Generate .S file with all kernel symbols
> -quiet_cmd_kallsyms = KSYM    $@
> -      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
> -                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
> -
> -.tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
> -	$(call if_changed_dep,as_o_S)
> +vmlinux-deps := $(KBUILD_LDS) $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN)
>  
> -.tmp_kallsyms%.S: .tmp_vmlinux% $(KALLSYMS)
> -	$(call cmd,kallsyms)
> +# Final link of vmlinux
> +      cmd_link-vmlinux = $(CONFIG_SHELL) $< $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux)
> +quiet_cmd_link-vmlinux = LINK    $@
>  
> -# .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
> -.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
> -	$(call if_changed_rule,ksym_ld)
> -
> -.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
> -	$(call if_changed,vmlinux__)
> -
> -.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
> -	$(call if_changed,vmlinux__)
> -
> -# Needs to visit scripts/ before $(KALLSYMS) can be used.
> -$(KALLSYMS): scripts ;
> -
> -# Generate some data for debugging strange kallsyms problems
> -debug_kallsyms: .tmp_map$(last_kallsyms)
> -
> -.tmp_map%: .tmp_vmlinux% FORCE
> -	($(OBJDUMP) -h $< | $(AWK) '/^ +[0-9]/{print $$4 " 0 " $$2}'; $(NM) $<) | sort > $@
> -
> -.tmp_map3: .tmp_map2
> -
> -.tmp_map2: .tmp_map1
> -
> -endif # ifdef CONFIG_KALLSYMS
> -
> -# Do modpost on a prelinked vmlinux. The finally linked vmlinux has
> -# relevant sections renamed as per the linker script.
> -quiet_cmd_vmlinux-modpost = LD      $@
> -      cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
> -	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
> -	 $(filter-out $(vmlinux-init) $(vmlinux-main) FORCE ,$^)
> -define rule_vmlinux-modpost
> -	:
> -	+$(call cmd,vmlinux-modpost)
> -	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
> -	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
> -endef
> -
> -# vmlinux image - including updated kernel symbols
> -vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
> +# Include targets which we want to
> +# execute if the rest of the kernel build went well.
> +vmlinux: scripts/link-vmlinux.sh $(vmlinux-deps) FORCE
>  ifdef CONFIG_HEADERS_CHECK
>  	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
>  endif
> @@ -921,22 +750,11 @@ endif
>  ifdef CONFIG_BUILD_DOCSRC
>  	$(Q)$(MAKE) $(build)=Documentation
>  endif
> -	$(call vmlinux-modpost)
> -	$(call if_changed_rule,vmlinux__)
> -	$(Q)rm -f .old_version
> -
> -# build vmlinux.o first to catch section mismatch errors early
> -ifdef CONFIG_KALLSYMS
> -.tmp_vmlinux1: vmlinux.o
> -endif
> -
> -modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
> -vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
> -	$(call if_changed_rule,vmlinux-modpost)
> +	+$(call if_changed,link-vmlinux)
>  
>  # The actual objects are generated when descending, 
>  # make sure no implicit rule kicks in
> -$(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
> +$(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
>  
>  # Handle descending into subdirectories listed in $(vmlinux-dirs)
>  # Preset locale variables to speed up the build process. Limit locale
> @@ -1160,8 +978,6 @@ endif # CONFIG_MODULES
>  
>  # Directories & files removed with 'make clean'
>  CLEAN_DIRS  += $(MODVERDIR)
> -CLEAN_FILES +=	vmlinux System.map \
> -                .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
>  
>  # Directories & files removed with 'make mrproper'
>  MRPROPER_DIRS  += include/config usr/include include/generated          \
> @@ -1407,6 +1223,7 @@ scripts: ;
>  endif # KBUILD_EXTMOD
>  
>  clean: $(clean-dirs)
> +	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
>  	$(call cmd,rmdirs)
>  	$(call cmd,rmfiles)
>  	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
> @@ -1540,14 +1357,6 @@ quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
>  cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR) \
>                    $(if $(KBUILD_MODULES),; rm -f $(MODVERDIR)/*)
>  
> -a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
> -	  $(KBUILD_AFLAGS_KERNEL)                              \
> -	  $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(KBUILD_CPPFLAGS) \
> -	  $(modkern_aflags) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
> -
> -quiet_cmd_as_o_S = AS      $@
> -cmd_as_o_S       = $(CC) $(a_flags) -c -o $@ $<
> -
>  # read all saved command lines
>  
>  targets := $(wildcard $(sort $(targets)))
> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index 55c0661..0970910 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -121,15 +121,8 @@ LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
>  
>  LD_FLAGS_CMDLINE = $(foreach opt,$(LDFLAGS),-Wl,$(opt))
>  
> -CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
> -define cmd_vmlinux__
> -	$(CC) $(CFLAGS_vmlinux) -o $@ \
> -	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
> -	-Wl,--start-group $(vmlinux-main) -Wl,--end-group \
> -	-lutil \
> -	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o \
> -	FORCE ,$^) ; rm -f linux
> -endef
> +# Used by link-vmlinux.sh which has special support for um link
> +export CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
>  
>  # When cleaning we don't include .config, so we don't include
>  # TT or skas makefiles and don't clean skas_ptregs.h.
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> new file mode 100644
> index 0000000..fb6d058
> --- /dev/null
> +++ b/scripts/link-vmlinux.sh
> @@ -0,0 +1,211 @@
> +#!/bin/sh
> +#
> +# link vmlinux
> +#
> +# vmlinux is linked from the objects selected by $(KBUILD_VMLINUX_INIT) and
> +# $(KBUILD_VMLINUX_MAIN). Most are built-in.o files from top-level directories
> +# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
> +# Ordering when linking is important, and $(KBUILD_VMLINUX_INIT) must be first.
> +#
> +# vmlinux
> +#   ^
> +#   |
> +#   +-< $(KBUILD_VMLINUX_INIT)
> +#   |   +--< init/version.o + more
> +#   |
> +#   +--< $(KBUILD_VMLINUX_MAIN)
> +#   |    +--< drivers/built-in.o mm/built-in.o + more
> +#   |
> +#   +-< ${kallsymso} (see description in KALLSYMS section)
> +#
> +# vmlinux version (uname -v) cannot be updated during normal
> +# descending-into-subdirs phase since we do not yet know if we need to
> +# update vmlinux.
> +# Therefore this step is delayed until just before final link of vmlinux.
> +#
> +# System.map is generated to document addresses of all kernel symbols
> +
> +# Error out on error
> +set -e
> +
> +# Nice output in kbuild format
> +# Will be supressed by "make -s"
> +info()
> +{
> +	if [ "${quiet}" != "silent_" ]; then
> +		printf "  %-7s %s\n" ${1} ${2}
> +	fi
> +}
> +
> +# Link of vmlinux.o used for section mismatch analysis
> +# ${1} output file
> +modpost_link()
> +{
> +	${LD} ${LDFLAGS} -r -o ${1} ${KBUILD_VMLINUX_INIT}                   \
> +		--start-group ${KBUILD_VMLINUX_MAIN} --end-group
> +}
> +
> +# Link of vmlinux
> +# ${1} - optional extra .o files
> +# ${2} - output file
> +vmlinux_link()
> +{
> +	local lds="${objtree}/${KBUILD_LDS}"
> +
> +	if [ "${SRCARCH}" != "um" ]; then
> +		${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2}                  \
> +			-T ${lds} ${KBUILD_VMLINUX_INIT}                     \
> +			--start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}
> +	else
> +		${CC} ${CFLAGS_vmlinux} -o ${2}                              \
> +			-Wl,-T,${lds} ${KBUILD_VMLINUX_INIT}                 \
> +			-Wl,--start-group                                    \
> +				 ${KBUILD_VMLINUX_MAIN}                      \
> +			-Wl,--end-group                                      \
> +			-lutil ${1}
> +		rm -f linux
> +	fi
> +}
> +
> +
> +# Create ${2} .o file with all symbols from the ${1} object file
> +kallsyms()
> +{
> +	info KSYM ${2}
> +	local kallsymopt;
> +
> +	if [ -n "${CONFIG_KALLSYMS_ALL}" ]; then
> +		kallsymopt=--all-symbols
> +	fi
> +
> +	local aflags="${KBUILD_AFLAGS} ${NOSTDINC_FLAGS}                     \
> +		      ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
> +
> +	${NM} -n ${1} | \
> +		scripts/kallsyms ${kallsymopt} | \
> +		${CC} ${aflags} -c -o ${2} -x assembler-with-cpp -
> +}
> +
> +# Create map file with all symbols from ${1}
> +# See mksymap for additional details
> +mksysmap()
> +{
> +	${CONFIG_SHELL} "${srctree}/scripts/mksysmap" ${1} ${2}
> +}
> +
> +# Delete output files in case of error
> +trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
> +cleanup()
> +{
> +	rm -f .old_version
> +	rm -f .tmp_System.map
> +	rm -f .tmp_kallsyms*
> +	rm -f .tmp_version
> +	rm -f .tmp_vmlinux*
> +	rm -f System.map
> +	rm -f vmlinux
> +	rm -f vmlinux.o
> +}
> +
> +#
> +#
> +# Use "make V=1" to debug this script
> +case "${KBUILD_VERBOSE}" in
> +*1*)
> +	set -x
> +	;;
> +esac
> +
> +if [ "$1" = "clean" ]; then
> +	cleanup
> +	exit 0
> +fi
> +
> +# We need access to CONFIG_ symbols
> +. ./.config
> +
> +#link vmlinux.o
> +info LD vmlinux.o
> +modpost_link vmlinux.o
> +
> +# modpost vmlinux.o to check for section mismatches
> +${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
> +
> +# Update version
> +info GEN .version
> +if [ ! -r .version ]; then
> +	rm -f .version;
> +	echo 1 >.version;
> +else
> +	mv .version .old_version;
> +	expr 0$(cat .old_version) + 1 >.version;
> +fi;
> +
> +# final build of init/
> +${MAKE} -f "${srctree}/scripts/Makefile.build" obj=init
> +
> +kallsymso=""
> +kallsyms_vmlinux=""
> +if [ -n "${CONFIG_KALLSYMS}" ]; then
> +
> +	# kallsyms support
> +	# Generate section listing all symbols and add it into vmlinux
> +	# It's a three step process:
> +	# 1)  Link .tmp_vmlinux1 so it has all symbols and sections,
> +	#     but __kallsyms is empty.
> +	#     Running kallsyms on that gives us .tmp_kallsyms1.o with
> +	#     the right size
> +	# 2)  Link .tmp_vmlinux2 so it now has a __kallsyms section of
> +	#     the right size, but due to the added section, some
> +	#     addresses have shifted.
> +	#     From here, we generate a correct .tmp_kallsyms2.o
> +	# 2a) We may use an extra pass as this has been necessary to
> +	#     woraround some alignment related bugs.
> +	#     KALLSYMS_EXTRA_PASS=1 is used to trigger this.
> +	# 3)  The correct ${kallsymso} is linked into the final vmlinux.
> +	#
> +	# a)  Verify that the System.map from vmlinux matches the map from
> +	#     ${kallsymso}.
> +
> +	kallsymso=.tmp_kallsyms2.o
> +	kallsyms_vmlinux=.tmp_vmlinux2
> +
> +	# step 1
> +	vmlinux_link "" .tmp_vmlinux1
> +	kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
> +
> +	# step 2
> +	vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
> +	kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
> +
> +	# step 2a
> +	if [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
> +		kallsymso=.tmp_kallsyms3.o
> +		kallsyms_vmlinux=.tmp_vmlinux2
> +
> +		vmlinux_link .tmp_kallsyms2.o .tmp_vmlinux3
> +
> +		kallsyms .tmp_vmlinux3 .tmp_kallsyms3.o
> +	fi
> +fi
> +
> +info LD vmlinux
> +vmlinux_link "${kallsymso}" vmlinux
> +
> +info SYSMAP System.map
> +mksysmap vmlinux System.map
> +
> +# step a (see comment above)
> +if [ -n "${CONFIG_KALLSYMS}" ]; then
> +	mksysmap ${kallsyms_vmlinux} .tmp_System.map
> +
> +	if ! cmp -s System.map .tmp_System.map; then
> +		echo Inconsistent kallsyms data
> +		echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
> +		cleanup
> +		exit 1
> +	fi
> +fi
> +
> +# We made a new kernel - delete old version file
> +rm -f .old_version
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
