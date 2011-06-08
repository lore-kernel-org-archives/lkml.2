Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1FHMdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:33:32 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37998 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1FHMdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:33:31 -0400
Date: Wed, 8 Jun 2011 14:33:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] x86-64: Allow alternative patching in the vDSO
Message-ID: <20110608123335.GA21548@gere.osrc.amd.com>
References: <cover.1307474707.git.luto@mit.edu>
 <9f34abb8ee488207e6b1cc2972eee81a4e612a0d.1307474707.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f34abb8ee488207e6b1cc2972eee81a4e612a0d.1307474707.git.luto@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 03:32:39PM -0400, Andy Lutomirski wrote:
> This code is short enough and different enough from the module
> loader that it's not worth trying to share anything.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/vdso/vma.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 7abd2be..b8b074c1 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -23,11 +23,43 @@ extern unsigned short vdso_sync_cpuid;
>  static struct page **vdso_pages;
>  static unsigned vdso_size;
>  
> +static void patch_vdso(void *vdso, size_t len)
> +{
> +	Elf64_Ehdr *hdr = vdso;
> +	Elf64_Shdr *sechdrs, *alt_sec = 0;
> +	char *secstrings;
> +	void *alt_data;
> +	int i;
> +
> +	BUG_ON(len < sizeof(Elf64_Ehdr));
> +	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
> +
> +	sechdrs = (void *)hdr + hdr->e_shoff;
> +	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
> +
> +	for (i = 1; i < hdr->e_shnum; i++) {
> +		Elf64_Shdr *shdr = &sechdrs[i];
> +		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
> +			alt_sec = shdr;
> +			break;
> +		}
> +	}
> +
> +	if (!alt_sec)
> +		return;  /* nothing to patch */

Just a minor nitpick:

Maybe do

	for (.. ) {

		if (!strcmp(...)) {
			alt_sec = shdr;
			goto apply;
		}
	}
	return;

apply:

to save yourself the if (!alt_sec) test and the alt_sec = 0 aka NULL
assignment above.

> +
> +	alt_data = (void *)hdr + alt_sec->sh_offset;
> +
> +	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
> +}
> +
>  static int __init init_vdso_vars(void)
>  {
>  	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
>  	int i;
>  
> +	patch_vdso(vdso_start, vdso_end - vdso_start);
> +
>  	vdso_size = npages << PAGE_SHIFT;
>  	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
>  	if (!vdso_pages)
> -- 
> 1.7.5.2

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
