Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1GTNQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:16:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38527 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1GTNQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:16:39 -0400
Date: Wed, 20 Jul 2011 16:16:25 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: cl@linux.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next-20110718] Fix build error at mm/slab.c .
In-Reply-To: <201107200319.p6K3JWN5001223@www262.sakura.ne.jp>
Message-ID: <alpine.DEB.2.00.1107201616120.3528@tiger>
References: <201107200319.p6K3JWN5001223@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Tetsuo Handa wrote:

> ARCH_SLAB_MINALIGN might be defined as
>
>  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>
> but gcc 3.3 cannot understand
>
>  #if __alignof__(unsigned long long)
>
> line.
>
>  CC      mm/slab.o
> mm/slab.c:3156:5: warning: "__alignof__" is not defined
> mm/slab.c:3156:5: missing binary operator before token "("
> make[1]: *** [mm/slab.o] Error 1
> make: *** [mm] Error 2
>
> Use "if (ARCH_SLAB_MINALIGN)" rather than "#if ARCH_SLAB_MINALIGN".
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> mm/slab.c |    5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
> --- linux-3.0-next.orig/mm/slab.c
> +++ linux-3.0-next/mm/slab.c
> @@ -3153,12 +3153,9 @@ static void *cache_alloc_debugcheck_afte
> 	objp += obj_offset(cachep);
> 	if (cachep->ctor && cachep->flags & SLAB_POISON)
> 		cachep->ctor(objp);
> -#if ARCH_SLAB_MINALIGN
> -	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
> +	if (ARCH_SLAB_MINALIGN && ((u32)objp & (ARCH_SLAB_MINALIGN-1)))
> 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
> 		       objp, ARCH_SLAB_MINALIGN);
> -	}
> -#endif
> 	return objp;

Looks good to me. Christoph?
