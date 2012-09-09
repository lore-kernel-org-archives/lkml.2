Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2IIIdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:33:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43882 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2IIIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <1345140905-10209-1-git-send-email-geert@linux-m68k.org>
References: <1345140905-10209-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 9 Sep 2012 10:33:01 +0200
X-Google-Sender-Auth: kYgUN71PidFWjZEfIIB6O-WWJpY
Message-ID: <CAMuHMdVyWRGyTPbA9pL267XWnvBnbN77353WjF8Ovmd062NSwg@mail.gmail.com>
Subject: Re: [PATCH/RFC] um: Preinclude include/linux/kern_levels.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>, Joe Perches <joe@perches.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Thu, Aug 16, 2012 at 8:15 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> The userspace part of UML uses the asm-offsets.h generator mechanism to
> create definitions for UM_KERN_<LEVEL> that match the in-kernel
> KERN_<LEVEL> constant definitions.
>
> As of commit 04d2c8c83d0e3ac5f78aeede51babb3236200112 ("printk: convert
> the format for KERN_<LEVEL> to a 2 byte pattern"), KERN_<LEVEL> is no
> longer expanded to the literal '"<LEVEL>"', but to '"\001" "LEVEL"', i.e.
> it contains two parts.
>
> However, the combo of DEFINE_STR() in
> arch/x86/um/shared/sysdep/kernel-offsets.h and sed-y in Kbuild doesn't
> support string literals consisting of multiple parts. Hence for all
> UM_KERN_<LEVEL> definitions, only the SOH character is retained in the actual
> definition, while the remainder ends up in the comment. E.g. in
> include/generated/asm-offsets.h we get
>
>     #define UM_KERN_INFO "\001" /* "6" KERN_INFO */
>
> instead of
>
>     #define UM_KERN_INFO "\001" "6" /* KERN_INFO */
>
> This causes spurious '^A' output in some kernel messages:
>
>     Calibrating delay loop... 4640.76 BogoMIPS (lpj=23203840)
>     pid_max: default: 32768 minimum: 301
>     Mount-cache hash table entries: 256
>     ^AChecking that host ptys support output SIGIO...Yes
>     ^AChecking that host ptys support SIGIO on close...No, enabling workaround
>     ^AUsing 2.6 host AIO
>     NET: Registered protocol family 16
>     bio: create slab <bio-0> at 0
>     Switching to clocksource itimer
>
> To fix this:
>   - Move the mapping from UM_KERN_<LEVEL> to KERN_<LEVEL> from
>     arch/um/include/shared/common-offsets.h to
>     arch/um/include/shared/user.h, which is preincluded for all userspace
>     parts,
>   - Preinclude include/linux/kern_levels.h for all userspace parts, to
>     obtain the in-kernel KERN_<LEVEL> constant definitions. This doesn't
>     violate the kernel/userspace separation, as include/linux/kern_levels.h
>     is self-contained and doesn't expose any other kernel internals.
>   - Remove the now unused STR() and DEFINE_STR() macros.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> We may convert all UM_KERN_* users to KERN_* and drop the extra defines?
> ---
>  arch/um/include/shared/common-offsets.h    |   10 ----------
>  arch/um/include/shared/user.h              |   11 +++++++++++
>  arch/um/scripts/Makefile.rules             |    2 +-
>  arch/x86/um/shared/sysdep/kernel-offsets.h |    3 ---
>  4 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
> index 40db8f7..2df313b 100644
> --- a/arch/um/include/shared/common-offsets.h
> +++ b/arch/um/include/shared/common-offsets.h
> @@ -7,16 +7,6 @@ DEFINE(UM_KERN_PAGE_MASK, PAGE_MASK);
>  DEFINE(UM_KERN_PAGE_SHIFT, PAGE_SHIFT);
>  DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
>
> -DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
> -DEFINE_STR(UM_KERN_ALERT, KERN_ALERT);
> -DEFINE_STR(UM_KERN_CRIT, KERN_CRIT);
> -DEFINE_STR(UM_KERN_ERR, KERN_ERR);
> -DEFINE_STR(UM_KERN_WARNING, KERN_WARNING);
> -DEFINE_STR(UM_KERN_NOTICE, KERN_NOTICE);
> -DEFINE_STR(UM_KERN_INFO, KERN_INFO);
> -DEFINE_STR(UM_KERN_DEBUG, KERN_DEBUG);
> -DEFINE_STR(UM_KERN_CONT, KERN_CONT);
> -
>  DEFINE(UM_ELF_CLASS, ELF_CLASS);
>  DEFINE(UM_ELFCLASS32, ELFCLASS32);
>  DEFINE(UM_ELFCLASS64, ELFCLASS64);
> diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
> index 4fa82c0..cef0685 100644
> --- a/arch/um/include/shared/user.h
> +++ b/arch/um/include/shared/user.h
> @@ -26,6 +26,17 @@
>  extern void panic(const char *fmt, ...)
>         __attribute__ ((format (printf, 1, 2)));
>
> +/* Requires preincluding include/linux/kern_levels.h */
> +#define UM_KERN_EMERG  KERN_EMERG
> +#define UM_KERN_ALERT  KERN_ALERT
> +#define UM_KERN_CRIT   KERN_CRIT
> +#define UM_KERN_ERR    KERN_ERR
> +#define UM_KERN_WARNING        KERN_WARNING
> +#define UM_KERN_NOTICE KERN_NOTICE
> +#define UM_KERN_INFO   KERN_INFO
> +#define UM_KERN_DEBUG  KERN_DEBUG
> +#define UM_KERN_CONT   KERN_CONT
> +
>  #ifdef UML_CONFIG_PRINTK
>  extern int printk(const char *fmt, ...)
>         __attribute__ ((format (printf, 1, 2)));
> diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
> index d50270d..15889df 100644
> --- a/arch/um/scripts/Makefile.rules
> +++ b/arch/um/scripts/Makefile.rules
> @@ -8,7 +8,7 @@ USER_OBJS += $(filter %_user.o,$(obj-y) $(obj-m)  $(USER_SINGLE_OBJS))
>  USER_OBJS := $(foreach file,$(USER_OBJS),$(obj)/$(file))
>
>  $(USER_OBJS:.o=.%): \
> -       c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) -include user.h $(CFLAGS_$(basetarget).o)
> +       c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) -include $(srctree)/include/linux/kern_levels.h -include user.h $(CFLAGS_$(basetarget).o)
>
>  # These are like USER_OBJS but filter USER_CFLAGS through unprofile instead of
>  # using it directly.
> diff --git a/arch/x86/um/shared/sysdep/kernel-offsets.h b/arch/x86/um/shared/sysdep/kernel-offsets.h
> index 5868526..46a9df9 100644
> --- a/arch/x86/um/shared/sysdep/kernel-offsets.h
> +++ b/arch/x86/um/shared/sysdep/kernel-offsets.h
> @@ -7,9 +7,6 @@
>  #define DEFINE(sym, val) \
>         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
>
> -#define STR(x) #x
> -#define DEFINE_STR(sym, val) asm volatile("\n->" #sym " " STR(val) " " #val: : )
> -
>  #define BLANK() asm volatile("\n->" : : )
>
>  #define OFFSET(sym, str, mem) \

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
