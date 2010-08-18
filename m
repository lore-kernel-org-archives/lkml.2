Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab0HRGKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:10:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46354 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0HRGKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZTxeKrqRukkHJZHcld1Nk8zLMAlNt6k8sXUf21HZZhjxCLr8ap0aj8xfbjGy3l+7B+
         LabF0UXxH017ZKmoFSOowsiGdKM6Hvse7kyS3fnt86wvYn7tKoLd+jkbF7J2IIEvfgas
         UvtZUw+ZGvcTGUqONfzw2bIB0KRuqH9FFHaDk=
MIME-Version: 1.0
In-Reply-To: <AANLkTimoD+-KzXVJhaKNZRvb=MkRgRUEQWnGNEwjvoRL@mail.gmail.com>
References: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com>
	<AANLkTimoD+-KzXVJhaKNZRvb=MkRgRUEQWnGNEwjvoRL@mail.gmail.com>
Date: Wed, 18 Aug 2010 11:40:28 +0530
X-Google-Sender-Auth: JPlB9RbuD3t8Zbp5Eas3MH9REuM
Message-ID: <AANLkTi=wy07mZE=h1JSq9GN8_d0taikw5zMfMh+iqFWL@mail.gmail.com>
Subject: Re: [PATCH] mm: code improvement of check_stack_guard_page
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 10:45 AM, jovi zhang <bookjovi@gmail.com> wrote:
> little code improvement of check_stack_guard_page function.
> this commit is on top of commit "mm: keep a guard page below a
> grow-down stack segment" of linus.
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9b3b73f..643b112 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2768,13 +2768,15 @@ out_release:
>   */
>  static inline int check_stack_guard_page(struct vm_area_struct *vma,
> unsigned long address)
>  {
> -       address &= PAGE_MASK;
> -       if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
> -               address -= PAGE_SIZE;
> -               if (find_vma(vma->vm_mm, address) != vma)
> -                       return -ENOMEM;
> -
> -               expand_stack(vma, address);
> +       if (vma->vm_flags & VM_GROWSDOWN) {
> +               address &= PAGE_MASK;
> +               if(address == vma->vm_start) {
                    ^^^ coding style is broken, did u run it through
scripts/checkpatch.pl?

> +                       address -= PAGE_SIZE;
> +                       if (unlikely(find_vma(vma->vm_mm, address) != vma))
> +                               return -ENOMEM;
> +
> +                       expand_stack(vma, address);
> +               }
>         }
>         return 0;
>  }
>

The main benefit I see is the new branch hint being passed to
find_vma, is my understanding correct?

Balbir
