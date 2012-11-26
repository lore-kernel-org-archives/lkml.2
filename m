Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2KZSnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:43:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:56314 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2KZSnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:43:52 -0500
Date: Mon, 26 Nov 2012 10:43:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: satoru takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Masaki Kimura <masaki.kimura.kz@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [ 11/83] module: fix out-by-one error in kallsyms
Message-ID: <20121126184349.GA21012@kroah.com>
References: <20121122004212.371862690@linuxfoundation.org>
 <20121122004213.695679336@linuxfoundation.org>
 <CAMym5wuprmSoE67wCMJFfODBCU1U29f3qoNYwr4377QrhrOLyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMym5wuprmSoE67wCMJFfODBCU1U29f3qoNYwr4377QrhrOLyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 07:35:36PM +0900, satoru takeuchi wrote:
> Hi,
> 
> 2012/11/22 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Rusty Russell <rusty@rustcorp.com.au>
> >
> > commit 59ef28b1f14899b10d6b2682c7057ca00a9a3f47 upstream.
> >
> > Masaki found and patched a kallsyms issue: the last symbol in a
> > module's symtab wasn't transferred.  This is because we manually copy
> > the zero'th entry (which is always empty) then copy the rest in a loop
> > starting at 1, though from src[0].  His fix was minimal, I prefer to
> > rewrite the loops in more standard form.
> >
> > There are two loops: one to get the size, and one to copy.  Make these
> > identical: always count entry 0 and any defined symbol in an allocated
> > non-init section.
> >
> > This bug exists since the following commit was introduced.
> >    module: reduce symbol table for loaded modules (v2)
> >    commit: 4a4962263f07d14660849ec134ee42b63e95ea9a
> >
> > LKML: http://lkml.org/lkml/2012/10/24/27
> > Reported-by: Masaki Kimura <masaki.kimura.kz@hitachi.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  kernel/module.c |   27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> >
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2273,12 +2273,17 @@ static void layout_symtab(struct module
> >         src = (void *)info->hdr + symsect->sh_offset;
> >         nsrc = symsect->sh_size / sizeof(*src);
> >
> > +       /* strtab always starts with a nul, so offset 0 is the empty string. */
> > +       strtab_size = 1;
> > +
> 
> I suspect above code sniped is not needed since the size of src[0](always 1) is
> counted at the following code("strtab_size += strlen(..) + 1;").
> 
> >         /* Compute total space required for the core symbols' strtab. */
> > -       for (ndst = i = strtab_size = 1; i < nsrc; ++i, ++src)
> > -               if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
> > -                       strtab_size += strlen(&info->strtab[src->st_name]) + 1;
> > +       for (ndst = i = 0; i < nsrc; i++) {
> > +               if (i == 0 ||
> > +                   is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
> 
> src[i] rather than src+1 is better as kallsyms();
> 
> > +                       strtab_size += strlen(&info->strtab[src[i].st_name])+1;
> >                         ndst++;
> >                 }
> > +       }
> >
> >         /* Append room for core symbols at end of core part. */
> >         info->symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
> > @@ -2312,15 +2317,15 @@ static void add_kallsyms(struct module *
> >         mod->core_symtab = dst = mod->module_core + info->symoffs;
> >         mod->core_strtab = s = mod->module_core + info->stroffs;
> >         src = mod->symtab;
> > -       *dst = *src;
> >         *s++ = 0;
> 
> This "*s++"line is also not needed since the content of src[0] is copied in the
> following loop.
> 
> If my understanding is correct, the allsym table becomes as follows by
> applying this patch.
> 
> ==================
> \0\0<first core symbol>\0<second core symbol>\0... # "\0" means null
> character in this case
> ==================
> 
> It should be as follows.
> 
> ====================
> \0<first core symbol>\0<second core symbol>\0...
> ====================
> 
> This patch would work, but need extra one byte per module. Olease let
> us know if I misunderstand something.
> I didn't confirm with real machine.

Please confirm with a real machine, and if the problem is there, please
submit a patch to get it changed in Linus's tree, which is where this
patch came from.

thanks,

greg k-h
