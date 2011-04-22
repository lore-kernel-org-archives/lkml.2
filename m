Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1DVITj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:19:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37693 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1DVITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:19:33 -0400
Date: Fri, 22 Apr 2011 10:19:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] kbuild: implement several W= levels
Message-ID: <20110422081926.GA26286@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20110421213903.GB9660@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110421213903.GB9660@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 11:39:03PM +0200, Sam Ravnborg wrote:
> Building a kernel with "make W=1" produce far too much noise
> to be usefull.
> 
> Divide the warning options in three groups:
> 
> W=1 - usefull warning options
> W=2 - noisy but semi usefull warnign options
> W=3 - almost pure noise options
> 
> I do not feel strongly about the distinction between
> group 2 and 3. But we should consider what we add in group 1.
> 
> 
> Sample run on my box (x86, 32bit allyesconfig build)
>   CC      kernel/bounds.s
> kernel/bounds.c:14: warning: no previous prototype for ‘foo’
>   GEN     include/generated/bounds.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/linux/sched.h:73,
>                  from arch/x86/kernel/asm-offsets.c:9:
> include/linux/signal.h: In function ‘sigorsets’:
> include/linux/signal.h:121: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
> include/linux/signal.h: In function ‘sigandsets’:
> include/linux/signal.h:124: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
> include/linux/signal.h: In function ‘signandsets’:
> include/linux/signal.h:127: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
> include/linux/signal.h: In function ‘signotset’:
> include/linux/signal.h:151: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
> arch/x86/kernel/asm-offsets.c: At top level:
> arch/x86/kernel/asm-offsets.c:30: warning: no previous prototype for ‘common’
> 
> the patch is only an RFC - and is not made on top
> of an upstream kernel with no additiona stuff applied.

Thanks for doing this, a couple of suggestions below.

> 
> 	Sam
> 
> diff --git a/Makefile b/Makefile
> index b967b96..f0e138b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -103,7 +103,7 @@ ifeq ("$(origin O)", "command line")
>  endif
>  
>  ifeq ("$(origin W)", "command line")
> -  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := 1
> +  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
>  endif
>  
>  # That's our default target when none is given on the command line
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index d5f925a..b65f820 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -56,31 +56,43 @@ endif
>  # $(call cc-option... ) handles gcc -W.. options which
>  # are not supported by all versions of the compiler
>  ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> -KBUILD_EXTRA_WARNINGS := -Wextra
> -KBUILD_EXTRA_WARNINGS += -Wunused -Wno-unused-parameter
> -KBUILD_EXTRA_WARNINGS += -Waggregate-return
> -KBUILD_EXTRA_WARNINGS += -Wbad-function-cast
> -KBUILD_EXTRA_WARNINGS += -Wcast-qual
> -KBUILD_EXTRA_WARNINGS += -Wcast-align
> -KBUILD_EXTRA_WARNINGS += -Wconversion
> -KBUILD_EXTRA_WARNINGS += -Wdisabled-optimization
> -KBUILD_EXTRA_WARNINGS += -Wlogical-op
> -KBUILD_EXTRA_WARNINGS += -Wmissing-declarations
> -KBUILD_EXTRA_WARNINGS += -Wmissing-format-attribute
> -KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wmissing-include-dirs,)
> -KBUILD_EXTRA_WARNINGS += -Wmissing-prototypes
> -KBUILD_EXTRA_WARNINGS += -Wnested-externs
> -KBUILD_EXTRA_WARNINGS += -Wold-style-definition
> -KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
> -KBUILD_EXTRA_WARNINGS += -Wpacked
> -KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
> -KBUILD_EXTRA_WARNINGS += -Wpadded
> -KBUILD_EXTRA_WARNINGS += -Wpointer-arith
> -KBUILD_EXTRA_WARNINGS += -Wredundant-decls
> -KBUILD_EXTRA_WARNINGS += -Wshadow
> -KBUILD_EXTRA_WARNINGS += -Wswitch-default
> -KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
> -KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
> +warning-1 := -Wextra
> +warning-1 += -Wunused -Wno-unused-parameter

Ok, I went and enabled each switch separately to look at output and
recheck whether each one makes sense. The following is all IMHO:

The first two W=1 warnings should be merged into one to denote that
we're actually tweaking -Wextra behavior (otherwise there's too much
output from unused parameters in headers):

warning-1 := -Wextra -Wunused -Wno-unused-parameter

> +warning-2 += -Waggregate-return

  warning-2 := -Waggregate-return

since this is a first-time assignment to warning-2

otherwise I get

$ make W=2 drivers/edac/amd64_edac.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
scripts/Makefile.build:87: *** Recursive variable `KBUILD_CFLAGS' references itself (eventually).  Stop.
make: *** [prepare0] Error 2

> +warning-2 += -Wbad-function-cast

I'd move this one to W=3 since it is almost useless for kernel code. mm
is one good example where we cast unsigned longs to the pagetable types
back and forth.

> +warning-2 += -Wcast-qual

maybe also W=3 due to too noisy with *get_user* calls in headers.

> +warning-2 += -Wcast-align

this one doesn't trigger anything on x86, maybe on other arches?

> +warning-3 += -Wconversion

also first assignment so

warning-3 := -Wconversion

> +warning-2 += -Wdisabled-optimization

this one doesn't trigger anything here either

> +warning-2 += -Wlogical-op
> +warning-1 += -Wmissing-declarations
> +warning-1 += -Wmissing-format-attribute
> +warning-1 += $(call cc-option, -Wmissing-include-dirs,)
> +warning-1 += -Wmissing-prototypes

this one is in the top-level Makefile in HOSTCFLAGS so no need for it
here.

> +warning-1 += -Wnested-externs

I don't think this one makes too much sense since we use the trick it
warns for to artificially cause a build error. Maybe downgrade it to W=2
or W=3.

> +warning-2 += -Wold-style-definition

this one actually finds bugs :), maybe W=1.

> +warning-2 += $(call cc-option, -Woverlength-strings,)

triggers in tracepoints declarations:

include/trace/events/kmem.h:11: warning: string length ‘1643’ is greater than the length ‘509’ ISO C90 compilers are required to support

I'm not sure we want it at all since the warning message is useless.

> +warning-3 += -Wpacked
> +warning-3 += -Wpacked-bitfield-compat

gcc docs says this one is enabled by default:
http://gcc.gnu.org/onlinedocs/gcc-4.6.0/gcc/Warning-Options.html

> +warning-3 += -Wpadded
> +warning-3 += -Wpointer-arith
> +warning-2 += -Wredundant-decls

this might help clean up a bunch of headers

> +warning-2 += -Wshadow
> +warning-3 += -Wswitch-default
> +warning-3 += $(call cc-option, -Wvla,)

oh yeah, maybe sort the warning-{1,2,3} assignments alphanumerically :)

> +ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),1)
> +        KBUILD_CFLAGS += $(warning-1)
> +else
> +        ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),2)
> +                KBUILD_CFLAGS += $(warning-1) $(warning-2)
> +        else
> +                ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),3)
> +                        KBUILD_CFLAGS += $(warning-1) $(warning-2) $(warning-3)
> +                else
> +                        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)

Also, I think it'll make more sense to enable a warning level
exclusively instead of inclusively, so that W=1 gives you only the
most important and sane warnings, W=2 the more noisy ones which are a
disjunct set from the W=1 ones etc.

Thanks.

-- 
Regards/Gruss,
    Boris.
