Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0FJBaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:30:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43562 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab0FJBaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pWA0x/XvNbQ9WfDtvJ8Wb2ouoaAI8ezgnCZJvL6pptTxuXoPZA7xsp8QgYhd77NhNE
         5n3L1MM23bxQL8zPNHLWwfhBDzg/GQKU+Tix2h5ay6KvmW2ELqBgkD4AIG0+lWmyGCEZ
         HiJm4yq2UDCeNnU0xdtjdxddEpn8jHDYEy/Vg=
MIME-Version: 1.0
In-Reply-To: <20100609211617.3e7e41bd@annuminas.surriel.com>
References: <AANLkTin1OS3LohKBvWyS81BoAk15Y-riCiEdcevSA7ye@mail.gmail.com>
	<1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
	<AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
	<AANLkTik-cwrabXH_bQRPFtTo3C9r30B83jMf4IwJKCms@mail.gmail.com>
	<20100609211617.3e7e41bd@annuminas.surriel.com>
Date: Thu, 10 Jun 2010 09:30:12 +0800
Message-ID: <AANLkTin9UTy3qSWJ8u3b1hwhnsX5NHCZNzkFbH9_-vIZ@mail.gmail.com>
Subject: Re: [PATCH -mm] only drop root anon_vma if not self
From: Dave Young <hidave.darkstar@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 9:16 AM, Rik van Riel <riel@redhat.com> wrote:
> On Wed, 9 Jun 2010 17:19:02 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> > Manually bisected mm patches, the memleak caused by following patch:
>> >
>> > mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
>>
>>
>> So I guess the refcount break, either drop-without-get or over-drop
>
> I'm guessing I did not run the kernel with enough debug options enabled
> when I tested my patches...
>
> Dave & Catalin, thank you for tracking this down.
>
> Dave, does the below patch fix your issue?

Yes, it fixed the issue. Thanks.

Tested-by: Dave Young <hidave.darkstar@gmail.com>

>
> Andrew, if the patch below works, you'll probably want to merge it as
> mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch :)
>
> ----------------
>
> With the new anon_vma code we take a refcount on the root anon_vma.
> However, the root anon_vma does not have a refcount on itself, so
> we should not try to do a drop on itself when it is being unlinked.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
>
> --- linux-2.6-rtavma/mm/rmap.c.orig     2010-06-09 21:10:07.349376896 -0400
> +++ linux-2.6-rtavma/mm/rmap.c  2010-06-09 21:10:24.180406299 -0400
> @@ -275,7 +275,8 @@ static void anon_vma_unlink(struct anon_
>
>        if (empty) {
>                /* We no longer need the root anon_vma */
> -               drop_anon_vma(anon_vma->root);
> +               if (anon_vma->root != anon_vma)
> +                       drop_anon_vma(anon_vma->root);
>                anon_vma_free(anon_vma);
>        }
>  }
>



-- 
Regards
dave
