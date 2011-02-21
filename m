Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1BUD0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:26:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36288 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1BUD0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:26:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SfqpOR9uGl7Z2l+29a8hN0xKuMeniPy2XlC2ah5u8PHoGrDwRDOhZ3CcnIeWUP+/tL
         MzJt9BmWVnmhnK9DsfLWqn8bn7dvvpLvpFjCBJHi528cISFCM7tJt3nFqMJhFyRLOiAC
         jPR1tpF42CXx8SmFUbgDQjXaMGunqh5IiKz8A=
MIME-Version: 1.0
In-Reply-To: <20110221022316.GA18332@liondog.tnic>
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
	<20110220175709.GA5178@merkur.ravnborg.org>
	<20110220193906.GC6713@liondog.tnic>
	<20110220195222.GA12915@merkur.ravnborg.org>
	<20110221022316.GA18332@liondog.tnic>
Date: Sun, 20 Feb 2011 22:26:13 -0500
Message-ID: <AANLkTimZhB8Ong=nJ_mjit+VRtb7g+TQhT9_wvojQ0-e@mail.gmail.com>
Subject: Re: [PATCH -v3] kbuild: Add extra gcc checks
From: Arnaud Lacombe <lacombar@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 20, 2011 at 9:23 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Feb 20, 2011 at 08:52:22PM +0100, Sam Ravnborg wrote:
>
> ..
>
>> Use of EXTRA_CFLAGS is deprecated - so that is not the right choice.
>> I suggest to use KBUILD_CFLAGS that is an KBUILD internal variable.
>
> Hey Sam,
>
> thanks for the suggestions/review, here's hopefully a better version:
>
> --
> From: Borislav Petkov <bp@alien8.de>
> Date: Sun, 20 Feb 2011 17:18:40 +0100
> Subject: [PATCH -v3] kbuild: Add extra gcc checks
>
> Add a 'W=1' Makefile switch which adds additional checking per build
> object.
>
> The idea behind this option is targeted at developers who, in the
> process of writing their code, want to do the occasional
>
> make W=1 [target.o]
>
> and let gcc do more extensive code checking for them. Then, they
> could eyeball the output for valid gcc warnings about various
> bugs/discrepancies which are not reported during the normal build
> process.
>
> For more background information and a use case, read through this
> thread: http://marc.info/?l=kernel-janitors&m=129802065918147&w=2
>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: linux-kbuild@vger.kernel.org
> Acked-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  Makefile               |    6 ++++++
>  scripts/Makefile.build |   29 ++++++++++++++++++++++++++++-
>  2 files changed, 34 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index c9c8c8f..c3bca9c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -102,6 +102,11 @@ ifeq ("$(origin O)", "command line")
>   KBUILD_OUTPUT := $(O)
>  endif
>
> +ifeq ("$(origin W)", "command line")
> +  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
> +  export KBUILD_ENABLE_EXTRA_GCC_CHECKS
> +endif
> +
You never check CC is gcc. How can you assert this ? Moreover, can you
certify that all the compiler supported to build Linux do support the
set of new warnings ? What about icc ? old gcc ? LLVM/clang ?

>  # That's our default target when none is given on the command line
>  PHONY := _all
>  _all:
> @@ -1262,6 +1267,7 @@ help:
>        @echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
>        @echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
>        @echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
> +       @echo  '  make W=1   [targets] Enable extra gcc checks'
same as above.

>        @echo  ''
>        @echo  'Execute "make" or "make all" to build all targets marked with [*] '
>        @echo  'For further info see the ./README file'
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 4eb99ab..b4d7661 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -49,6 +49,34 @@ ifeq ($(KBUILD_NOPEDANTIC),)
>                 $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use EXTRA_CFLAGS)
>         endif
>  endif
> +
> +# make W=1 settings
> +ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> +KBUILD_CFLAGS += -Wextra -Wno-unused
> +KBUILD_CFLAGS += -Waggregate-return
> +KBUILD_CFLAGS += -Wbad-function-cast
> +KBUILD_CFLAGS += -Wcast-qual
> +KBUILD_CFLAGS += -Wcast-align
> +KBUILD_CFLAGS += -Wconversion
> +KBUILD_CFLAGS += -Wdisabled-optimization
> +KBUILD_CFLAGS += -Wlogical-op
> +KBUILD_CFLAGS += -Wmissing-declarations
> +KBUILD_CFLAGS += -Wmissing-format-attribute
> +KBUILD_CFLAGS += -Wmissing-include-dirs
> +KBUILD_CFLAGS += -Wmissing-prototypes
> +KBUILD_CFLAGS += -Wnested-externs
> +KBUILD_CFLAGS += -Wold-style-definition
> +KBUILD_CFLAGS += -Woverlength-strings
> +KBUILD_CFLAGS += -Wpacked
> +KBUILD_CFLAGS += -Wpacked-bitfield-compat
> +KBUILD_CFLAGS += -Wpadded
> +KBUILD_CFLAGS += -Wpointer-arith
> +KBUILD_CFLAGS += -Wredundant-decls
> +KBUILD_CFLAGS += -Wshadow
> +KBUILD_CFLAGS += -Wswitch-default
> +KBUILD_CFLAGS += -Wvla
> +endif
> +
Why not making it simple at the beginning by:
 1) s/GCC/CC/
 2) using `cc-option' provided by Kbuild for each new option. As an
example, for `-Wvla':

KBUILD_CFLAGS += $(call cc-option, -Wvla)

so so on.

 - Arnaud

>  include scripts/Makefile.lib
>
>  ifdef host-progs
> @@ -403,7 +431,6 @@ ifneq ($(cmd_files),)
>   include $(cmd_files)
>  endif
>
> -
>  # Declare the contents of the .PHONY variable as phony.  We keep that
>  # information in a variable se we can use it in if_changed and friends.
>
> --
> 1.7.4.1.48.g5673d
>
>
>
> --
> Regards/Gruss,
>    Boris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
