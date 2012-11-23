Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab2KWKfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:35:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38536 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2KWKfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:35:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121122004213.695679336@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
	<20121122004213.695679336@linuxfoundation.org>
Date: Fri, 23 Nov 2012 19:35:36 +0900
Message-ID: <CAMym5wuprmSoE67wCMJFfODBCU1U29f3qoNYwr4377QrhrOLyg@mail.gmail.com>
Subject: Re: [ 11/83] module: fix out-by-one error in kallsyms
From: satoru takeuchi <satoru.takeuchi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Masaki Kimura <masaki.kimura.kz@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/11/22 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> 3.6-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> commit 59ef28b1f14899b10d6b2682c7057ca00a9a3f47 upstream.
>
> Masaki found and patched a kallsyms issue: the last symbol in a
> module's symtab wasn't transferred.  This is because we manually copy
> the zero'th entry (which is always empty) then copy the rest in a loop
> starting at 1, though from src[0].  His fix was minimal, I prefer to
> rewrite the loops in more standard form.
>
> There are two loops: one to get the size, and one to copy.  Make these
> identical: always count entry 0 and any defined symbol in an allocated
> non-init section.
>
> This bug exists since the following commit was introduced.
>    module: reduce symbol table for loaded modules (v2)
>    commit: 4a4962263f07d14660849ec134ee42b63e95ea9a
>
> LKML: http://lkml.org/lkml/2012/10/24/27
> Reported-by: Masaki Kimura <masaki.kimura.kz@hitachi.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  kernel/module.c |   27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2273,12 +2273,17 @@ static void layout_symtab(struct module
>         src = (void *)info->hdr + symsect->sh_offset;
>         nsrc = symsect->sh_size / sizeof(*src);
>
> +       /* strtab always starts with a nul, so offset 0 is the empty string. */
> +       strtab_size = 1;
> +

I suspect above code sniped is not needed since the size of src[0](always 1) is
counted at the following code("strtab_size += strlen(..) + 1;").

>         /* Compute total space required for the core symbols' strtab. */
> -       for (ndst = i = strtab_size = 1; i < nsrc; ++i, ++src)
> -               if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
> -                       strtab_size += strlen(&info->strtab[src->st_name]) + 1;
> +       for (ndst = i = 0; i < nsrc; i++) {
> +               if (i == 0 ||
> +                   is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {

src[i] rather than src+1 is better as kallsyms();

> +                       strtab_size += strlen(&info->strtab[src[i].st_name])+1;
>                         ndst++;
>                 }
> +       }
>
>         /* Append room for core symbols at end of core part. */
>         info->symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
> @@ -2312,15 +2317,15 @@ static void add_kallsyms(struct module *
>         mod->core_symtab = dst = mod->module_core + info->symoffs;
>         mod->core_strtab = s = mod->module_core + info->stroffs;
>         src = mod->symtab;
> -       *dst = *src;
>         *s++ = 0;

This "*s++"line is also not needed since the content of src[0] is copied in the
following loop.

If my understanding is correct, the allsym table becomes as follows by
applying this patch.

==================
\0\0<first core symbol>\0<second core symbol>\0... # "\0" means null
character in this case
==================

It should be as follows.

====================
\0<first core symbol>\0<second core symbol>\0...
====================

This patch would work, but need extra one byte per module. Olease let
us know if I misunderstand something.
I didn't confirm with real machine.

Thanks,
Satoru

> -       for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
> -               if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
> -                       continue;
> -
> -               dst[ndst] = *src;
> -               dst[ndst++].st_name = s - mod->core_strtab;
> -               s += strlcpy(s, &mod->strtab[src->st_name], KSYM_NAME_LEN) + 1;
> +       for (ndst = i = 0; i < mod->num_symtab; i++) {
> +               if (i == 0 ||
> +                   is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
> +                       dst[ndst] = src[i];
> +                       dst[ndst++].st_name = s - mod->core_strtab;
> +                       s += strlcpy(s, &mod->strtab[src[i].st_name],
> +                                    KSYM_NAME_LEN) + 1;
> +               }
>         }
>         mod->core_num_syms = ndst;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
