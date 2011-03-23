Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1CWTVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:21:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61267 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1CWTVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=h39f4SfeeP9tK5A4I1+FIoBw6xW87ZFxqk5COMWn/oGkocSTTOrFZVXOgQOq6RP57Q
         sviqTvT34fAwr4vw4UgIfkCEB2AqTlHsV3d4nMl2JfqLwGrH8NsrYoW6OggF0ZpsH6Eo
         f3t1PWq2eznXeBcU7t9gUu83ws44U0wKWEOsg=
MIME-Version: 1.0
In-Reply-To: <1300907573.15255.224.camel@deneb.localdomain>
References: <1300907573.15255.224.camel@deneb.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 23 Mar 2011 15:19:52 -0400
Message-ID: <AANLkTiks3dUzD5+Ud73CgguYsOUdyBeSNeGH9C0MueUT@mail.gmail.com>
Subject: Re: generic page.h problem
To: Mark Salter <msalter@redhat.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 15:12, Mark Salter wrote:
> I'm working with a new architecture port (nommu) and was wanting to use
> the generic page.h but there is a problem. I'm using CONFIG_FLATMEM with
> a non-zero CONFIG_KERNEL_RAM_BASE_ADDRESS. The hardware uses this same
> address to access RAM from code and for DMA purposes. The generic page.h
> has:
>
> #ifdef CONFIG_KERNEL_RAM_BASE_ADDRESS
> #define PAGE_OFFSET             (CONFIG_KERNEL_RAM_BASE_ADDRESS)
> #else
> #define PAGE_OFFSET             (0)
> #endif
>
> #ifndef __ASSEMBLY__
>
> #define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
> #define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
>
> The problem I have is that __va(x) and __pa(x) should do nothing on
> this architecture. If I use the following, then everything seems to
> work as it should.
>
>
> diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
> index 75fec18..4dc4a81 100644
> --- a/include/asm-generic/page.h
> +++ b/include/asm-generic/page.h
> @@ -73,8 +73,8 @@ extern unsigned long memory_end;
>
>  #ifndef __ASSEMBLY__
>
> -#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
> -#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
> +#define __va(x) ((void *)((unsigned long) (x)))
> +#define __pa(x) ((unsigned long) (x))
>
>  #define virt_to_pfn(kaddr)     (__pa(kaddr) >> PAGE_SHIFT)
>  #define pfn_to_virt(pfn)       __va((pfn) << PAGE_SHIFT)
>
>
> Am I missing something here? The only other arch using the generic
> page.h is blackfin, but it uses a zero PAGE_OFFSET, so my patch
> would have no effect there.

the only arch that defines CONFIG_KERNEL_RAM_BASE_ADDRESS is mn10300,
and it seems that this generic page.h was designed with it in mind.
fwiw, the va/pa defs for mn10300 also ignore PAGE_OFFSET.
-mike
