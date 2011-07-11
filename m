Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1GKKly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:41:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59740 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1GKKlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <e9c49596e493c1ebb80b52d2dff7bd50191ebc0e.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
	<e9c49596e493c1ebb80b52d2dff7bd50191ebc0e.1310267866.git.luto@mit.edu>
Date: Mon, 11 Jul 2011 16:41:51 +0600
Message-ID: <CADZ9YHiSmjtXx1Ue4tfUzN9zpj2qjABY_fhMP+SOm2_vYrrFfw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] x86-64: Allow alternative patching in the vDSO
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 9:22 AM, Andy Lutomirski <luto@mit.edu> wrote:
> This code is short enough and different enough from the module
> loader that it's not worth trying to share anything.
>
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/vdso/vma.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 7abd2be..ba92244 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -23,11 +23,41 @@ extern unsigned short vdso_sync_cpuid;
>  static struct page **vdso_pages;
>  static unsigned vdso_size;
>
> +static void patch_vdso(void *vdso, size_t len)

I think, patch_vdso should mark with __init. Since it's been only
called from an __init function. We might hit a section mismatch, even
if we don't hit section mismatch, the will function get removed after
system boot - saves some .text size.

> +{
> +       Elf64_Ehdr *hdr = vdso;
> +       Elf64_Shdr *sechdrs, *alt_sec = 0;
> +       char *secstrings;
> +       void *alt_data;
> +       int i;
> +
> +       BUG_ON(len < sizeof(Elf64_Ehdr));
> +       BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
> +
> +       sechdrs = (void *)hdr + hdr->e_shoff;
> +       secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
> +
> +       for (i = 1; i < hdr->e_shnum; i++) {
> +               Elf64_Shdr *shdr = &sechdrs[i];
> +               if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
> +                       alt_sec = shdr;
> +                       goto found;
> +               }
> +       }
> +       return;  /* nothing to patch */

If there's nothing to patch, I think (perhaps) - it would be nice to
let user know through printk.

Thanks,
Rakib.
