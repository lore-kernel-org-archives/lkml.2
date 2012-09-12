Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2ILLpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:45:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8573 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2ILLpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:45:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 12 Sep 2012 04:45:31 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Date: Wed, 12 Sep 2012 17:15:27 +0530
Subject: RE: [PATCH] coredump: prevent double-free on an error path in core
 dumper
Thread-Topic: [PATCH] coredump: prevent double-free on an error path in core
 dumper
Thread-Index: Ac2Q2xc4sIgRSWVORnmGfFX4lvLHDwAAMOsQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDEFB8D10@BGMAIL02.nvidia.com>
References: <1347449845-23764-1-git-send-email-vda.linux@googlemail.com>
In-Reply-To: <1347449845-23764-1-git-send-email-vda.linux@googlemail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Denys Vlasenko
> Sent: Wednesday, September 12, 2012 5:07 PM
> To: Oleg Nesterov; linux-kernel@vger.kernel.org; Andrew Morton; Roland
> McGrath
> Cc: Denys Vlasenko
> Subject: [PATCH] coredump: prevent double-free on an error path in core
> dumper
> 
> In !CORE_DUMP_USE_REGSET case, if elf_note_info_init fails to allocate
> memory
> for info->fields, it frees already allocated stuff and returns
> error to its caller, fill_note_info. Which in turn returns
> error to its caller, elf_core_dump. Which jumps to cleanup
> label and calls free_note_info, which will happily try to
> free all info->fields again. BOOM.
> 
> This is the fix.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> ---
>  fs/binfmt_elf.c |   19 ++++---------------
>  1 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 760d7f5..1b4efbc 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1695,30 +1695,19 @@ static int elf_note_info_init(struct elf_note_info
> *info)
>  		return 0;
>  	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);

Why don't you change kmalloc to devm_kzalloc, so that free can be ignored altogether. 

>  	if (!info->psinfo)
> -		goto notes_free;
> +		return 0;
>  	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
>  	if (!info->prstatus)
> -		goto psinfo_free;
> +		return 0;
>  	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
>  	if (!info->fpu)
> -		goto prstatus_free;
> +		return 0;
>  #ifdef ELF_CORE_COPY_XFPREGS
>  	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
>  	if (!info->xfpu)
> -		goto fpu_free;
> +		return 0;
>  #endif
>  	return 1;
> -#ifdef ELF_CORE_COPY_XFPREGS
> - fpu_free:
> -	kfree(info->fpu);
> -#endif
> - prstatus_free:
> -	kfree(info->prstatus);
> - psinfo_free:
> -	kfree(info->psinfo);
> - notes_free:
> -	kfree(info->notes);
> -	return 0;
>  }
> 
>  static int fill_note_info(struct elfhdr *elf, int phdrs,
> --
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
