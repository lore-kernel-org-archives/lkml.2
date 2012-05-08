Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2EHTge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:36:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60907 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2EHTgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120412203517.GA30769@merkur.ravnborg.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
	<1332960678-11879-2-git-send-email-andi@firstfloor.org>
	<CAMuHMdVX28zeebzN6277B5p2b=9s-Q06i01o5AHPyXAuKMigGQ@mail.gmail.com>
	<20120412194016.GA30558@merkur.ravnborg.org>
	<CAMuHMdXfpvprGD18_YYyctfrAk6iRJonWFGFRf9oSaH0u0zfhw@mail.gmail.com>
	<4F8733C5.5080609@linux.intel.com>
	<20120412200752.GA30685@merkur.ravnborg.org>
	<CAMuHMdXN0PcxZQb6=ReFrpG6U49tP8ujA+OKkeVGd_yeftaydw@mail.gmail.com>
	<20120412203517.GA30769@merkur.ravnborg.org>
Date: Tue, 8 May 2012 21:36:12 +0200
X-Google-Sender-Auth: 7Vt72O3JlDNGdSrJK9L5xqqdP_U
Message-ID: <CAMuHMdViZUB1812w3RnVysX6ESZuKAVtP8yyqPv25FJyzHbzCQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add CONFIG_READABLE_ASM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:35 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Apr 12, 2012 at 10:17:07PM +0200, Geert Uytterhoeven wrote:
>> On Thu, Apr 12, 2012 at 22:07, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > Could you try this:
>> >
>> > cc-disable-opt = $(call try-run,\
>> >        $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -f$(strip $(1)) -c -xc /dev/null -o "$TMP",-fno-$(strip $(1)))
>> >
>> > KBUILD_CFLAGS += $(call cc-disable-opt, ipa-cp-clone)
>> >
>> >
>> > It will try if "gcc -fipa-cp-clone" is supported,
>> > and add -fno-ipa-cp-clone in that case.
>>
>> Unfortunately not:
>>
>> m68k-linux-gnu-gcc -Wp,-MD,kernel/.bounds.s.d  -nostdinc -isystem
>> /usr/lib/gcc/m68k-linux-gnu/4.1.2/include
>> -I/scratch/geert/linux/linux-next/arch/m68k/include
>> Iarch/m68k/include/generated -Iinclude  -include
>> /scratch/geert/linux/linux-next/include/linux/kconfig.h -D__KERNEL__
>> -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
>> -fno-common -Werror-implicit-function-declaration -Wno-format-security
>> -fno-delete-null-pointer-checks -Os -fno-reorder-blocks
>> -fno-ipa-cp-clone -pipe -fno-strength-reduce -ffixed-a2
>> -fno-omit-frame-pointer -fno-optimize-sibling-calls -g
>> -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(bounds)"
>> -D"KBUILD_MODNAME=KBUILD_STR(bounds)" -fverbose-asm -S -o
>> kernel/bounds.s kernel/bounds.c
>> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
>> make[1]: *** [kernel/bounds.s] Error 1
>> make: *** [prepare0] Error 2
>
> So with the above command-line gcc fails with an exit code for -fno-ipa-cp-clone.
> But with cc-option it does not.
>
> Can you dig out the command-line used for cc-option?
> We may be able to analyze why it fails in the above case, but
> not with cc-option.

gcc -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
-Wno-format-security -fno-delete-null-pointer-checks -Os
-fno-ipa-cp-clone -c -xc /dev/null -o .6376.tmp

So it's running "gcc" instead of "m68k-linux-gnu-gcc".

I used the gmail-damaged patch below to get the command in /tmp/x.

diff --git a/Makefile b/Makefile
index d17a616..0e0cbb9 100644
--- a/Makefile
+++ b/Makefile
@@ -567,7 +567,7 @@ ifdef CONFIG_READABLE_ASM
 # ipa clone creates specialized cloned functions
 # partial inlining inlines only parts of functions
 KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
-                 $(call cc-option,-fno-ipa-cp-clone,) \
+                 $(call cc-option2,-fno-ipa-cp-clone,) \
                  $(call cc-option,-fno-partial-inlining)
 endif

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 6a3ee98..41c80bf 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -94,6 +94,16 @@ try-run = $(shell set -e;            \
        fi;                             \
        rm -f "$$TMP" "$$TMPO")

+try-run2 = $(shell set -e;             \
+       TMP="$(TMPOUT).$$$$.tmp";       \
+       TMPO="$(TMPOUT).$$$$.o";        \
+       echo "$(1)" > /tmp/x;           \
+       if ($(1)) >/dev/null 2>&1;      \
+       then echo "$(2)";               \
+       else echo "$(3)";               \
+       fi;                             \
+       rm -f "$$TMP" "$$TMPO")
+
 # as-option
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)

@@ -112,6 +122,9 @@ as-instr = $(call try-run,\
 cc-option = $(call try-run,\
        $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc
/dev/null -o "$$TMP",$(1),$(2))

+cc-option2 = $(call try-run2,\
+       $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc
/dev/null -o "$$TMP",$(1),$(2))
+
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
