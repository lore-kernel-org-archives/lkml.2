Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab2KVVyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:54:37 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:53856 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab2KVVya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:54:30 -0500
Date: Thu, 22 Nov 2012 12:10:41 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tell the world we gave up on pushing
 CC_OPTIMIZE_FOR_SIZE
Message-ID: <20121122081041.GA380@tugrik.mns.mnsspb.ru>
References: <1351856461-3662-1-git-send-email-kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351856461-3662-1-git-send-email-kirr@mns.spb.ru>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:41:01PM +0400, Kirill Smelkov wrote:
>  [continuing 281dc5c5 "Give up on pushing CC_OPTIMIZE_FOR_SIZE"]
> 
> Recently I've been beaten hard by CC_OPTIMIZE_FOR_SIZE=y on X86
> performance-wise. The problem turned out to be for -Os gcc wants to
> inline __builtin_memcpy, to which x86 memcpy directly refers,
> 
>     ---- 8< ---- arch/x86/include/asm/string_32.h
>     #if (__GNUC__ >= 4)
>     #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
> 
> to "rep; movsb" which is several times slower compared to "rep; movsl".
> 
> For me this turned out in vivi driver, where memcpy is used to copy
> lines with colorbars, and this is one of the most significant parts of
> the workload:
> 
>     ---- 8< ---- drivers/media/platform/vivi.c
>     static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
>     {
>             ...
> 
>             for (h = 0; h < hmax; h++)
>                     memcpy(vbuf + h * wmax * dev->pixelsize,
>                            dev->line + (dev->mv_count % wmax) * dev->pixelsize,
>                            wmax * dev->pixelsize);
> 
> Gcc insists on using movb, even if it knows dest and src alignment. For
> example with gcc-4.4, -4.7 and yesterday's gcc trunk, for following function
> 
>     ---- 8< ----
>     void doit(unsigned long *dst, unsigned long *src, unsigned n)
>     {
>         void *__d = __builtin_assume_aligned(dst, 4);
>         void *__s = __builtin_assume_aligned(src, 4);
> 
>         __builtin_memcpy(__d, __s, n);
>     }
> 
> it still wants to use movsb with -Os:
> 
>     00000000 <doit>:
>        0:   55                      push   %ebp
>        1:   89 e5                   mov    %esp,%ebp
>        3:   57                      push   %edi
>        4:   8b 4d 10                mov    0x10(%ebp),%ecx
>        7:   56                      push   %esi
>        8:   8b 7d 08                mov    0x8(%ebp),%edi
>        b:   8b 75 0c                mov    0xc(%ebp),%esi
>        e:   f3 a4                   rep movsb %ds:(%esi),%es:(%edi)
>       10:   5e                      pop    %esi
>       11:   5f                      pop    %edi
>       12:   5d                      pop    %ebp
>       13:   c3                      ret
> 
> and even if I change "n" to "4*n"...
> 
> On the other hand, with -O2, it generates call to memcpy, which at least
> has rep; movsl inside it, and things works several times faster.
> 
> So tell people to not enable CC_OPTIMIZE_FOR_SIZE by default.
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 6fdd6e3..6a448d5 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1119,7 +1119,7 @@ config CC_OPTIMIZE_FOR_SIZE
>  	  Enabling this option will pass "-Os" instead of "-O2" to gcc
>  	  resulting in a smaller kernel.
>  
> -	  If unsure, say Y.
> +	  If unsure, say N.
>  
>  config SYSCTL
>  	bool

Linus, maybe you missed this. What is the reason telling people
CC_OPTIMIZE_FOR_SIZE should be Y if we actually do otherwise?


commit 281dc5c5ec0fb299514567cbc358562649c1af95
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 22 14:30:36 2011 -0700

    Give up on pushing CC_OPTIMIZE_FOR_SIZE
    
    I still happen to believe that I$ miss costs are a major thing, but
    sadly, -Os doesn't seem to be the solution.  With or without it, gcc
    will miss some obvious code size improvements, and with it enabled gcc
    will sometimes make choices that aren't good even with high I$ miss
    ratios.
    
    For example, with -Os, gcc on x86 will turn a 20-byte constant memcpy
    into a "rep movsl".  While I sincerely hope that x86 CPU's will some day
    do a good job at that, they certainly don't do it yet, and the cost is
    higher than a L1 I$ miss would be.
    
    Some day I hope we can re-enable this.
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/init/Kconfig b/init/Kconfig
index 4986ecc..ffcdad7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -908,7 +908,6 @@ endif
 
 config CC_OPTIMIZE_FOR_SIZE
        bool "Optimize for size"
-       default y
        help
          Enabling this option will pass "-Os" instead of "-O2" to gcc
          resulting in a smaller kernel.

