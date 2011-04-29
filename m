Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823Ab1D2SNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:13:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47437 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735Ab1D2SNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rc1evRBwcyeGuGfVnd00tNjYPGkg5CrP0PmsjLZ0Zz3c1MwUKzvBLZLbAMmNYYwugz
         5Z/HnTIF1I9z/EzEH6NCp7ZzOnR5OWEJ07FPbExdXao8D/D4iKAQ3CCHgXS5PS29NgCv
         YvG773tSvCwmZqoMztIJ2vlng8iDDRaAwE7dk=
MIME-Version: 1.0
In-Reply-To: <1304083893-18849-1-git-send-email-mmarek@suse.cz>
References: <71633.1304013549@localhost>
	<1304083893-18849-1-git-send-email-mmarek@suse.cz>
Date: Fri, 29 Apr 2011 14:13:11 -0400
Message-ID: <BANLkTimsNF=OeaLSnSt2gFdDaAbJ6tMFng@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Valdis.Kletnieks@vt.edu, bp@alien8.de, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 29, 2011 at 9:31 AM, Michal Marek <mmarek@suse.cz> wrote:
> Add support for make W=12, make W=123 and so on, to enable warnings from
> multiple W= levels. Normally, make W=<level> does not include warnings
> from the previous level.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/Makefile.build |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 9c0c481..28cef2a 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -60,6 +60,8 @@ endif
>  # $(call cc-option, -W...) handles gcc -W.. options which
>  # are not supported by all versions of the compiler
>  ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> +warning-  := $(empty)
> +
>  warning-1 := -Wextra -Wunused -Wno-unused-parameter
>  warning-1 += -Wmissing-declarations
>  warning-1 += -Wmissing-format-attribute
> @@ -85,9 +87,11 @@ warning-3 += -Wswitch-default
>  warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
>  warning-3 += $(call cc-option, -Wvla)
>
> -warning := $(warning-$(KBUILD_ENABLE_EXTRA_GCC_CHECKS))
> +warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
> +warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
> +warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>
I do not really like that, it would mean that W=123, W=321, W=231 and
W=132 would lead to the same result. What about a comma separated
string, ala:

LEVELS=1,2,3,4

comma:= ,
empty:=
space:= $(empty) $(empty)

warning-1:= a
warning-2:= b
warning-3:= c
warning-4:= d

all:
        echo $(foreach level, $(subst ${comma},${space},${LEVELS},
${warning}), ${warning-${level}})

It has the advantage to scale up without adding new code.

 - Arnaud

> -ifeq ("$(warning)","")
> +ifeq ("$(strip $(warning))","")
>         $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
>  endif
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
