Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab1AMQFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:05:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37762 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1AMQFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <20110113130037.GB5241@davesworkthinkpad>
References: <20110113130037.GB5241@davesworkthinkpad>
Date: Thu, 13 Jan 2011 10:05:40 -0600
Message-ID: <AANLkTimbxAofdrovOvKn0kjtrRAszG3eojasL1BhmNyR@mail.gmail.com>
Subject: Re: Possible patch; fix perf Annotation of Thumb code
From: Dave Martin <dave.martin@linaro.org>
To: "Dr. David Alan Gilbert" <david.gilbert@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        acme@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 7:00 AM, Dr. David Alan Gilbert
<david.gilbert@linaro.org> wrote:
> Hi,
>  I'm finding that if I annotate an ARM Thumb function with perf that it's
> mis-disassembling it; below is a patch that fixes it, but I'm not sure if
> it's the best place for the fix.
>
>  The problem is that on Thumb, the bottom bit of the symbol address is
> set for thumb functions, and thus perf starts disassembling at address+1,
> and since all thumb instructions are 2 bytes aligned to 2 bytes you end
> up disassembling across the middle of pairs of instructions.
>
>
>  The patch removes that bottom bit during symbol loading.
>
>  Questions:
>    1) Is this the right place to do it - does some other bit of Perf need the
> raw symbol value?  My alternative is to mask it just before the objdump,
> but then my worry is if it also needs masking somewhere else.
>
>    2) Should the check be more selective - i.e. only some symbol types?

We should definitely only do this if for function symbols, since data
symbols have no "thumb bit" and can be arbitrarily aligned.

I think this can be achieved by checking map->type :

if ((ehdr.e_machine == EM_ARM) && map->type == MAP__FUNCTION &&
(sym.st_value & 1)) {
 ...

Cheers
---Dave

>
> This is against the Linaro 2.6.37 tree; I'm happy to rebase it against
> the clean 2.6.37 if people agree the patch is doing the right thing.
>
> Dave
> (For reference this corresponds to this bug
> https://bugs.launchpad.net/linux-linaro/+bug/677547 )
>
>        Signed-off-by: Dr. David Alan Gilbert <david.gilbert@linaro.org>
> ---
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 439ab94..3d77b5e 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1129,6 +1129,11 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>
>                section_name = elf_sec__name(&shdr, secstrs);
>
> +               /* On ARM, symbols for thumb functions have 1 added to
> +               the symbol address as a flag - remove it */
> +               if ((ehdr.e_machine == EM_ARM) && (sym.st_value & 1))
> +                       sym.st_value-=1;
> +
>                if (self->kernel != DSO_TYPE_USER || kmodule) {
>                        char dso_name[PATH_MAX];
>
>
