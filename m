Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2DWCXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:23:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64352 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DWCXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120422212220.GA6537@merkur.ravnborg.org>
References: <20120422212220.GA6537@merkur.ravnborg.org>
Date: Sun, 22 Apr 2012 22:23:28 -0400
Message-ID: <CACqU3MU7MS7MjpyiSx-tUJ6c3rSexUB5=vTGy6gPv_OJevuOqw@mail.gmail.com>
Subject: Re: [RFC] move link of vmlinux to a script
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[some quick nits...]

On Sun, Apr 22, 2012 at 5:22 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> [...]
> index 0000000..c5a46ae
> --- /dev/null
> +++ b/scripts/link-vmlinux.sh
> @@ -0,0 +1,238 @@
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
> +#   ^
> +#   |
> +#   +-< $(KBUILD_VMLINUX_INIT)
> +#   |   +--< init/version.o + more
> +#   |
> +#   +--< $(KBUILD_VMLINUX_MAIN)
> +#   |    +--< driver/built-in.o mm/built-in.o + more
> +#   |
> +#   +-< ${kallsymso} (see description in KALLSYMS section)
> +#
> +# vmlinux version (uname -v) cannot be updated during normal
> +# descending-into-subdirs phase since we do not yet know if we need to
> +# update vmlinux.
> +# Therefore this step is delayed until just before final link of vmlinux.
> +#
> +# System.map is generated to document addresses of all kernel symbols
> +
> +# We need access to CONFIG_ symbols
> +source ./.config
> +
> +# Error out on error
> +set -e
> +
> +# Link of vmlinux
> +# $1 output file
> +modpost_link()
> +{
> +       ${LD} ${LDFLAGS} -r -o $1 ${KBUILD_VMLINUX_INIT}                     \
> +               --start-group ${KBUILD_VMLINUX_MAIN} --end-group
> +}
> +
> +# Link of vmlinux
> +# $1 - optional extra .o files
> +# $2 output file
> +vmlinux_link()
> +{
> +       local lds=${srctree}/arch/${SRCARCH}/kernel/vmlinux.lds
> +echo srcarch=${SRCARCH} CF=${CFLAGS_vmlinux}
debugging leftover ?

> +       if [ "${SRCARCH}" != "um" ]; then
> +               ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o $2                    \
> +                       -T ${lds} ${KBUILD_VMLINUX_INIT}                     \
> +                       --start-group ${KBUILD_VMLINUX_MAIN} --end-group $1
> +       else
> +               ${CC} ${CFLAGS_vmlinux} -o $2                                \
> +                       -Wl,-T,${lds} ${KBUILD_VMLINUX_INIT}                 \
> +                       -Wl,--start-group                                    \
> +                                ${KBUILD_VMLINUX_MAIN}                      \
> +                       -Wl,--end-group                                      \
> +                       -lutil $1
> +               rm -f linux
> +       fi
> +}
> +
> +
> +# Create $2 .o file with all symbols from $1 .o file
> +kallsyms()
> +{
> +       info KSYM $2
> +       local kallsymopt;
> +
> +       if [ "${CONFIG_KALLSYMS_ALL}" != "" ]; then
> +               kallsymopt=--all-symbols
> +       fi
> +
> +       local aflags="${KBUILD_AFLAGS} ${AFLAGS_KERNEL} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} ${modkern_aflags}"
might be worse splitting that line.

> +       ${NM} -n $1 | \
> +               scripts/kallsyms ${kallsymopt} | \
> +               ${CC} ${aflags} -c -o $2 -x assembler-with-cpp -
> +}
> +
> +# Based on the vmlinux file create the System.map file
> +# System.map is used by module-init tools and some debugging
> +# tools to retrieve the actual addresses of symbols in the kernel.
> +# Generate System.map (actual filename passed as second argument)
> +
> +# $NM produces the following output:
> +# f0081e80 T alloc_vfsmnt
> +
> +#   The second row specify the type of the symbol:
> +#   A = Absolute
> +#   B = Uninitialised data (.bss)
> +#   C = Comon symbol
> +#   D = Initialised data
> +#   G = Initialised data for small objects
> +#   I = Indirect reference to another symbol
> +#   N = Debugging symbol
> +#   R = Read only
> +#   S = Uninitialised data for small objects
> +#   T = Text code symbol
> +#   U = Undefined symbol
> +#   V = Weak symbol
> +#   W = Weak symbol
> +#   Corresponding small letters are local symbols
> +
> +# For System.map filter away:
> +#   a - local absolute symbols
> +#   U - undefined global symbols
> +#   N - debugging symbols
> +#   w - local weak symbols
> +
> +# readprofile starts reading symbols when _stext is found, and
> +# continue until it finds a symbol which is not either of 'T', 't',
> +# 'W' or 'w'. __crc_ are 'A' and placed in the middle
> +# so we just ignore them to let readprofile continue to work.
> +# (At least sparc64 has __crc_ in the middle).
> +mksysmap()
> +{
> +       $NM -n $1 | \
> +               grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
> +}
> +
you don't seem to consistently use #{FOO} vs. $FOO.

> +
> +# Delete output files in case of error
> +trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
> +cleanup()
> +{
> +       rm -f vmlinux.o
> +       rm -f .old_version
> +       rm -f .tmp_vmlinux*
> +       rm -f .tmp_kallsyms*
> +       rm -f vmlinux
> +       rm -f .tmp_System.map
> +       rm -f System.map
> +}
> +
> +# non-verbose output
> +info()
> +{
> +       printf "  %-7s %s\n" $1 $2
> +}
> +
> +# Use "make V=L" to debug this script
> +case "${KBUILD_VERBOSE}" in
> +*L*)
> +       set -x
> +       ;;
> +esac
> +
> +# Override MAKEFLAGS to avoid parrallel builds
> +MAKEFLAGS='--no-print-directory -Rr'
> +
> +#link vmlinux.o
> +info LD vmlinux.o
> +modpost_link vmlinux.o
> +
> +# modpost vmlinux.o to check for section mismatches
> +${MAKE} -f ${srctree}/scripts/Makefile.modpost vmlinux.o
> +
> +# Update version
> +info GEN .version
> +if [ ! -r .version ]; then
why '-r' specifically ? '-e' might be just enough.

> +       rm -f .version;
> +       echo 1 >.version;
> +else
> +       mv .version .old_version;
> +       expr 0$(cat .old_version) + 1 >.version;
> +fi;
> +
> +# final build of init/
> +${MAKE} -f ${srctree}/scripts/Makefile.build obj=init
> +
are spaces allowed in `srctree' ? if so, this will break here.

> +
> +kallsymso=""
> +kallsyms_vmlinux=""
> +
> +if [ "${CONFIG_KALLSYMS}" != "" ]; then
> +
[ -n "${CONFIG_KALLSYMS}" ] would work too, as well as the other
places where you use the [ "${FOO}" != "" ] syntax.

 - Arnaud

> +       # kallsyms support
> +       # Generate section listing all symbols and add it into vmlinux
> +       # It's a three step process:
> +       # 1)  Link .tmp_vmlinux1 so it has all symbols and sections,
> +       #     but __kallsyms is empty.
> +       #     Running kallsyms on that gives us .tmp_kallsyms1.o with
> +       #     the right size
> +       # 2)  Link .tmp_vmlinux2 so it now has a __kallsyms section of
> +       #     the right size, but due to the added section, some
> +       #     addresses have shifted.
> +       #     From here, we generate a correct .tmp_kallsyms2.o
> +       # 2a) We may use an extra pass as this has been necessary to
> +       #     woraround some alignment related bugs.
> +       #     KALLSYMS_EXTRA_PASS=1 is used to trigger this.
> +       # 3)  The correct ${kallsymso} is linked into the final vmlinux.
> +       #
> +       # a)  Verify that the System.map from vmlinux matches the map from
> +       #     ${kallsymso}.
> +
> +       kallsymso=.tmp_kallsyms2.o
> +       kallsyms_vmlinux=.tmp_vmlinux2
> +
> +       # step 1
> +       vmlinux_link "" .tmp_vmlinux1
> +       kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
> +
> +       # step 2
> +       vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
> +       kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
> +
> +       # step 2a
> +       if [ "${KALLSYMS_EXTRA_PASS}" != "" ]; then
> +               kallsymso=.tmp_kallsyms3.o
> +               kallsyms_vmlinux=.tmp_vmlinux2
> +
> +               vmlinux_link .tmp_kallsyms2.o .tmp_vmlinux3
> +
> +               kallsyms .tmp_vmlinux3 .tmp_kallsyms3.o
> +       fi
> +fi
> +
> +vmlinux_link "${kallsymso}" vmlinux
> +
> +info SYSMAP System.map
> +mksysmap vmlinux System.map
> +
> +# step a (see comment above)
> +if [ "${CONFIG_KALLSYMS}" != "" ]; then
> +       mksysmap ${kallsyms_vmlinux} .tmp_System.map
> +
> +       if [ $(cmp -s System.map .tmp_System.map) ]; then
> +               echo Inconsistent kallsyms data
> +               echo This is a bug - please report about it
> +               echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
> +               cleanup
> +               exit 1
> +       fi
> +fi
> +
> +# We made a new kernel - delete old version file
> +rm -f .old_version
