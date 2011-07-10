Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1GJGIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 02:08:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61174 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1GJGIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 02:08:50 -0400
MIME-Version: 1.0
In-Reply-To: <1310253210-1221-1-git-send-email-abogani@kernel.org>
References: <CAPk1OjH4Otd-+q3tD6KYx9ZBT=zenYBvpQMm8LthPd1D1c+AKg@mail.gmail.com>
	<1310253210-1221-1-git-send-email-abogani@kernel.org>
Date: Sun, 10 Jul 2011 02:08:49 -0400
Message-ID: <CACqU3MW=VUn64nsSA2V_eXEfEjv6xmB9yBWL8rYynH1wkHcOgw@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking
From: Arnaud Lacombe <lacombar@gmail.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <JBeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 9, 2011 at 7:13 PM, Alessio Igor Bogani <abogani@kernel.org> wrote:
> The commit f02e8a6 sorts symbols placing each of them in its own elf section.
> The sorting and merging into the canonical sections are done by the linker.
> Unfortunately modpost to generate Module.symvers file parses vmlinux
> (already linked) and all modules object files (which aren't linked yet).
> These aren't sanitized by the linker yet. That breaks modpost that can't
> detect license properly for modules.
>
> This patch makes modpost aware of  the new exported symbols structure.
>
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---
>  scripts/mod/modpost.c |   27 ++++++++++++++++++++++++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 413c536..f41283c 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -254,6 +254,26 @@ static enum export export_no(const char *s)
>        return export_unknown;
>  }
>
> +static const char *sec_name(struct elf_info *elf, int secindex);
> +
> +static enum export export_from_secname(struct elf_info *elf, unsigned int sec)
> +{
> +       const char *secname = sec_name(elf, sec);
> +
> +       if (strncmp(secname, "___ksymtab+", 11) == 0)
I'd suppose 11 here is `sizeof "___ksymtab+" - 1' ? Why not making
that explicit though a macro, ala:

#define SEC_NAME_MATCH(name, str) (strncmp(name, str, strlen(str) - 1) == 0)

This would avoid bug in the future if the string is updated but not
the size, and/or copy paste error where only the string is changed.

 - Arnaud

> +               return export_plain;
> +       else if (strncmp(secname, "___ksymtab_unused+", 18) == 0)
> +               return export_unused;
> +       else if (strncmp(secname, "___ksymtab_gpl+", 15) == 0)
> +               return export_gpl;
> +       else if (strncmp(secname, "___ksymtab_unused_gpl+", 22) == 0)
> +               return export_unused_gpl;
> +       else if (strncmp(secname, "___ksymtab_gpl_future+", 22) == 0)
> +               return export_gpl_future;
> +       else
> +               return export_unknown;
> +}
> +
>  static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
>  {
>        if (sec == elf->export_sec)
> @@ -563,7 +583,12 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
>                               Elf_Sym *sym, const char *symname)
>  {
>        unsigned int crc;
> -       enum export export = export_from_sec(info, get_secindex(info, sym));
> +       enum export export;
> +
> +       if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)
> +               export = export_from_secname(info, get_secindex(info, sym));
> +       else
> +               export = export_from_sec(info, get_secindex(info, sym));
>
>        switch (sym->st_shndx) {
>        case SHN_COMMON:
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
