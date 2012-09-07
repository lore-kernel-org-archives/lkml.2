Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2IGJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:16:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44585 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab2IGJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:16:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120906211125.GB4785@balrog.le.imgtec.org>
References: <20120906211125.GB4785@balrog.le.imgtec.org>
Date: Fri, 7 Sep 2012 17:16:53 +0800
Message-ID: <CAA_GA1enseskbRhgCGtZBcouuqUpJfcebUNtviUGw2HC8VBq4Q@mail.gmail.com>
Subject: Re: [PATCH] kbuild: add symbol prefix arg to kallsyms
From: Bob Liu <lliubbo@gmail.com>
To: James Hogan <james@albanarts.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Fri, Sep 7, 2012 at 5:11 AM, James Hogan <james@albanarts.com> wrote:
> Commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 ("kbuild: link of
> vmlinux moved to a script") introduced in v3.5-rc1 broke kallsyms on
> architectures which have symbol prefixes.
>
> The --symbol-prefix argument used to be added to the KALLSYMS command
> line from the architecture Makefile, however this isn't picked up by the
> new scripts/link-vmlinux.sh. This resulted in symbols like
> kallsyms_addresses being added which weren't correctly overriding the
> weak symbols such as _kallsyms_addresses. These could then trigger
> BUG_ONs in kallsyms code.
>
> This is fixed by removing the KALLSYMS addition from the architecture
> Makefile, and using CONFIG_SYMBOL_PREFIX in the link-vmlinux.sh script
> to determine whether to add the --symbol-prefix argument.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Yes, we also found this issue. Thank you for your fix.
I'll apply it soon.

> ---
>  arch/blackfin/Makefile  |    1 -
>  scripts/link-vmlinux.sh |    7 ++++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
> index d3d7e64..66cf000 100644
> --- a/arch/blackfin/Makefile
> +++ b/arch/blackfin/Makefile
> @@ -20,7 +20,6 @@ endif
>  KBUILD_AFLAGS           += $(call cc-option,-mno-fdpic)
>  KBUILD_CFLAGS_MODULE    += -mlong-calls
>  LDFLAGS                 += -m elf32bfin
> -KALLSYMS         += --symbol-prefix=_
>
>  KBUILD_DEFCONFIG := BF537-STAMP_defconfig
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 4629038..df48dda 100644
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -74,8 +74,13 @@ kallsyms()
>         info KSYM ${2}
>         local kallsymopt;
>
> +       if [ -n "${CONFIG_SYMBOL_PREFIX}" ]; then
> +               kallsymopt="${kallsymopt} \
> +                           --symbol-prefix=${CONFIG_SYMBOL_PREFIX}"
> +       fi
> +
>         if [ -n "${CONFIG_KALLSYMS_ALL}" ]; then
> -               kallsymopt=--all-symbols
> +               kallsymopt="${kallsymopt} --all-symbols"
>         fi
>
>         local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
> --
> 1.7.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards,
--Bob
