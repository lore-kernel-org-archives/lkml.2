Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1G3PG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:06:58 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:35655 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1G3PGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:06:52 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jul 2011 11:06:51 EDT
X-ME-engine: default
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
Organization: BZH lan
To: =?utf-8?q?Rados=C5=82aw_Smogura?= <mail@smogura.eu>
Subject: Re: [PATCH] Allows Kernel developer to change optimization options making code more debug friendly.
Date: Sat, 30 Jul 2011 16:58:48 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org
References: <1312027749-10520-1-git-send-email-mail@smogura.eu> <1312029234-14997-1-git-send-email-mail@smogura.eu>
In-Reply-To: <1312029234-14997-1-git-send-email-mail@smogura.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107301658.48336.yann.morin.1998@anciens.enib.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radosław, all,

On Saturday 30 July 2011 14:33:54 Radosław Smogura wrote:
> New menu under kernel hacking allows to force "-01" optimization
> and gives ability to discard additional optimizations (passed
> with -O1). Options are added as "-f-no-..." to GCC invoke line.
> This make cause to produce additional warnings, but makes compiled
> code more debug friendly.
> 
> Included new Makefile and new KConfig has been automaticly generated
> by simple bash script scripts/debug/make_config_optim.sh, which
> is included to simple add or remove new options.

For what they are worth, see my comments below.
Note: I'm not commenting the usefulness or not of such a change,
just suggesting readability changes.

[--SNIP--]
> diff --git a/Makefile b/Makefile
> index f676d15..1de2a79 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -558,12 +558,23 @@ endif # $(dot-config)
> 
>  # Defaults to vmlinux, but the arch makefile usually adds further targets
>  all: vmlinux
> 
> +ifdef CONFIG_HACK_OPTIM_FORCE_O1_LEVEL
> +KBUILD_CFLAGS += -O1
> +else
> +
> 
>  ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
>  KBUILD_CFLAGS  += -Os
>  else
>  KBUILD_CFLAGS  += -O2
>  endif
> 
> +endif

endif # ! CONFIG_HACK_OPTIM_FORCE_O1_LEVEL
Thus, it's easier to spot the corresponding if/else.

> +# Include makefile for optimization override
> +ifdef CONFIG_HACK_OPTIM
> +include $(srctree)/scripts/Makefile.optim.inc
> +endif
> +
> 
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
>  ifneq ($(CONFIG_FRAME_WARN),0)

[--SNIP--]

> diff --git a/scripts/debug/make_config_optim.sh b/scripts/debug/make_config_optim.sh
> new file mode 100644
> index 0000000..44736d7
> --- /dev/null
> +++ b/scripts/debug/make_config_optim.sh
> @@ -0,0 +1,92 @@
> +#!/bin/sh
> +
> +## Utility script for generating optimization override options
> +## for kernel compilation.
> +##
> +## Distributed under GPL v2 license
> +## (c) Radosław Smogura, 2011
> +
> +# Prefix added for variable
> +CFG_PREFIX="HACK_OPTIM"
> +
> +KCFG="Kconfig.debug.optim"
> +MKFI="Makefile.optim.inc"



> +OPTIMIZATIONS_PARAMS="-fno-inline-functions-called-once \
> + -fno-combine-stack-adjustments \
> + -fno-tree-dce \
> + -fno-tree-dominator-opts \
> + -fno-dse \
> + -fno-dce \
> + -fno-auto-inc-dec \
> + -fno-inline-small-functions \
> + -fno-if-conversion \
> + -fno-if-conversion2 \
> + -fno-tree-fre \
> + -fno-tree-dse \
> + -fno-tree-sra
> +"
> +
> +function printStandardHelp() {
> +    echo -e "\t  This changes how GCC optimizes code. Code"           >> $KCFG
> +    echo -e "\t  may be slower and larger but will be more debug"     >> $KCFG
> +    echo -e "\t  \"friendly\"."                                       >> $KCFG
> +    echo                                                              >> $KCFG
> +    echo -e "\t  In some cases there is a low chance that the kernel" >> $KCFG
> +    echo -e "\t  will run differently than normal, reporting or not"  >> $KCFG
> +    echo -e "\t  reporting some bugs or errors."                      >> $KCFG
> +    echo -e "\t  Refer to GCC manual for more details."               >> $KCFG
> +    echo                                                              >> $KCFG
> +    echo -e "\t  You SHOULD say N here."                              >> $KCFG
> +}

To redirect output iun the function, but only when you call it:
  printStandardHelp >>$KCFG

Don't use 'echo -e', its not protable. Prefer using printf:
  printf "\t  blabla\n"

In this case, you may even prefer using here-document:
    cat <<_EOF_ >>"${KCFG}"
[TAB]  blabla
[TAB]  blabla
_EOF_

Also, enclose file names with double-quotes, it guards against future
changes where a file name would gain a space in it:
  blabla >"$KCFG"

> +echo "# This file was auto generated. It's utility configuration" > $KCFG
> +echo "# Distributed under GPL v2 License" >> $KCFG
> +echo >> $KCFG
> +echo "menuconfig ${CFG_PREFIX}"                                >> $KCFG

With variables, use smthg like:
  printf "menuconfig %s\n" "${CFG_PREFIX}"

Variables are expanded in here-documents:
    cat <<_EOF_ >>"${KCFG}"
menuconfig ${CFG_PREFIX}
_EOF_

Also, be consistent in the way you /dereference/ variables. Either use one
the ${foo} or $foo, not both. Eg, you use $KCFG, but you use ${CFG_PREFIX}
I personnaly prefer ${foo} because it makes it explicit what the variable
name is.

> +echo -e "\tbool \"Allows overriding GCC optimizations\""       >> $KCFG
> +echo -e "\tdepends on DEBUG_KERNEL && EXPERIMENTAL"            >> $KCFG
> +echo -e "\thelp"                                               >> $KCFG
> +echo -e "\t  If you say Y here you will be able to override"   >> $KCFG
> +echo -e "\t  how GCC optimizes kernel code. This creates"      >> $KCFG
> +echo -e "\t  more debug-friendly code, but does not guarantee" >> $KCFG
> +echo -e "\t  the same running code like a production kernel."  >> $KCFG
> +echo                                                           >> $KCFG
> +echo -e "\t  If you say Y here probably you will want to say"  >> $KCFG
> +echo -e "\t  Y for all suboptions"                             >> $KCFG
> +echo >> $KCFG
> +echo "if ${CFG_PREFIX}" >> $KCFG
> +echo >> $KCFG

Make this a function that just sends to stdout, and call it with stdout
redirected to $KCFG :
  printDotInHeader() {
    cat <<_EOF_ 
[TAB]blabla
[TAB]help
[TAB]  blabla
_EOF_
  }
  printDotInHeader >$KCFG

> +echo "# This file was auto generated. It's utility configuration" > $MKFI
> +echo "# Distributed under GPL v2 License" >> $MKFI
> +echo >> $MKFI

Ditto.

> +# Insert standard override optimization level
> +# This is exception, and this value will not be included
> +# in auto generated makefile. Support for this value
> +# is hard coded in main Makefile.
> +echo -e "config ${CFG_PREFIX}_FORCE_O1_LEVEL" >> $KCFG
> +echo -e "\tbool \"Forces -O1 optimization level\"" >> $KCFG
> +echo -e "\t---help---" >> $KCFG
> +printStandardHelp;
> +echo >> $KCFG

Ditto.

Also, it should be better to change the way 'CONFIG_CC_OPTIMIZE_FOR_SIZE'
works. For example:

  choice
    bool "Optimise level"
    default CC_OPTIMIZE_O2

  config CC_OPTIMIZE_O2
    bool "O2, for speed"

  config CC_OPTIMIZE_OS
    bool "Os, for size"

  config CC_OPTIMIZE_O1
    bool "O1 (for debug only)"

  endchoice

  config CC_O_LEVEL
    string
    default "-O2" if CC_OPTIMIZE_O2
    default "-Os" if CC_OPTIMIZE_Os
    default "-O1" if CC_OPTIMIZE_O1

Then:

KBUILD_CFLAGS += "${CONFIG_CC_O_LEVEL}"

> +for o in $OPTIMIZATIONS_PARAMS ; do
> +	cfg_o="${CFG_PREFIX}_${o//-/_}";

This is a bashism, and is not portable. If /bin/sh is not bash, this does
not work. Use sed:
  cfg_o="$( printf "${o}" |sed -r -e 's/-/_/g;' )"

No need for a trailing ';'.

> +	echo "Processing param ${o} config variable will be $cfg_o";
> +
> +	# Generate kconfig entry
> +	echo -e "config ${cfg_o}" >> $KCFG
> +	echo -e "\tbool \"Adds $o parameter to gcc invoke line.\"" >> $KCFG
> +	echo -e "\t---help---" >> $KCFG

'---help---' should be written as simply 'help'.

> +	printStandardHelp;
> +	echo >> $KCFG

Move this to a function (eg. printOption), with $1 being the name of the
option. Eg.:
  printOption() {
    cfg_o="$( printf "${o}" |sed -r -e 's/-/_/g;' )"
    printf 'config %s%s\n' "${CFG_PREFIX" "${cfg_o}"
    printf '\tbool "Adds %s prm to gcc\n' "${1}"
    printf '\thelp\n'
    printfStandardHelp
    printf '\n'
  }
  for o in $OPTIMIZATIONS_PARAMS ; do
    printOption "${o}" >>"${KCFG}"
    printMakeVar "${o}" >> "${MKFI}"
  done

> +	#Generate Make for include
> +	echo "ifdef CONFIG_${cfg_o}" >> $MKFI
> +	echo -e "\tKBUILD_CFLAGS += $o" >> $MKFI
> +	echo "endif" >> $MKFI
> +	echo  >> $MKFI
> +done;
> +echo "endif #${CFG_PREFIX}" >> $KCFG
> 

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
