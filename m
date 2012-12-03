Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2LCCoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:44:44 -0500
Received: from ozlabs.org ([203.10.76.45]:42894 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab2LCCoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:44:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: satoru takeuchi <satoru.takeuchi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Masaki Kimura <masaki.kimura.kz@hitachi.com>
Subject: Re: [ 11/83] module: fix out-by-one error in kallsyms
In-Reply-To: <CAMym5wuprmSoE67wCMJFfODBCU1U29f3qoNYwr4377QrhrOLyg@mail.gmail.com>
References: <20121122004212.371862690@linuxfoundation.org> <20121122004213.695679336@linuxfoundation.org> <CAMym5wuprmSoE67wCMJFfODBCU1U29f3qoNYwr4377QrhrOLyg@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Dec 2012 10:34:06 +1030
Message-ID: <87hao4j91l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

satoru takeuchi <satoru.takeuchi@gmail.com> writes:
> Hi,

Hi!

>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2273,12 +2273,17 @@ static void layout_symtab(struct module
>>         src = (void *)info->hdr + symsect->sh_offset;
>>         nsrc = symsect->sh_size / sizeof(*src);
>>
>> +       /* strtab always starts with a nul, so offset 0 is the empty string. */
>> +       strtab_size = 1;
>> +
>
> I suspect above code sniped is not needed since the size of src[0](always 1) is
> counted at the following code("strtab_size += strlen(..) + 1;").

You are correct, on both counts.  This was a remnant of the previous
1-based looping.

Here's the fix I have pending.

Thanks!
Rusty.

module: fix one byte kallsyms overallocation.

Since we fixed our kallsyms strtab expansion code in
59ef28b1f14899b10d6b2682c7057ca00a9a3f47 (module: fix out-by-one error
in kallsyms) we now loop from zero, so we don't need to add an extra
byte for the first empty string.

Reported-by: satoru takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index a1d2ed8..79a526d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2285,7 +2285,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
 	Elf_Shdr *strsect = info->sechdrs + info->index.str;
 	const Elf_Sym *src;
-	unsigned int i, nsrc, ndst, strtab_size;
+	unsigned int i, nsrc, ndst, strtab_size = 0;
 
 	/* Put symbol section at end of init part of module. */
 	symsect->sh_flags |= SHF_ALLOC;
@@ -2296,9 +2296,6 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
 
-	/* strtab always starts with a nul, so offset 0 is the empty string. */
-	strtab_size = 1;
-
 	/* Compute total space required for the core symbols' strtab. */
 	for (ndst = i = 0; i < nsrc; i++) {
 		if (i == 0 ||
@@ -2340,7 +2337,6 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
 	mod->core_strtab = s = mod->module_core + info->stroffs;
 	src = mod->symtab;
-	*s++ = 0;
 	for (ndst = i = 0; i < mod->num_symtab; i++) {
 		if (i == 0 ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
