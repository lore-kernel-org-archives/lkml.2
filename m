Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1HNLOC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 07:14:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1HNLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 07:14:00 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: x86 memcpy performance
Date: Sun, 14 Aug 2011 13:13:56 +0200
User-Agent: KMail/1.8.2
Cc: Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com> <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic>
In-Reply-To: <20110814095910.GA18809@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201108141313.56926.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 August 2011 11:59, Borislav Petkov wrote:
> Here's the SSE memcpy version I got so far, I haven't wired in the
> proper CPU feature detection yet because we want to run more benchmarks
> like netperf and stuff to see whether we see any positive results there.
> 
> The SYSTEM_RUNNING check is to take care of early boot situations where
> we can't handle FPU exceptions but we use memcpy. There's an aligned and
> misaligned variant which should handle any buffers and sizes although
> I've set the SSE memcpy threshold at 512 Bytes buffersize the least to
> cover context save/restore somewhat.
> 
> Comments are much appreciated! :-)
> 
> --- a/arch/x86/include/asm/string_64.h
> +++ b/arch/x86/include/asm/string_64.h
> @@ -28,10 +28,20 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
>  
>  #define __HAVE_ARCH_MEMCPY 1
>  #ifndef CONFIG_KMEMCHECK
> +extern void *__memcpy(void *to, const void *from, size_t len);
> +extern void *__sse_memcpy(void *to, const void *from, size_t len);
>  #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
> -extern void *memcpy(void *to, const void *from, size_t len);
> +#define memcpy(dst, src, len)					\
> +({								\
> +	size_t __len = (len);					\
> +	void *__ret;						\
> +	if (__len >= 512)					\
> +		__ret = __sse_memcpy((dst), (src), __len);	\
> +	else							\
> +		__ret = __memcpy((dst), (src), __len);		\
> +	__ret;							\
> +})

Please, no. Do not inline every memcpy invocation.
This is pure bloat (comsidering how many memcpy calls there are)
and it doesn't even win anything in speed, since there will be
a fucntion call either way.
Put the __len >= 512 check inside your memcpy instead.

You may do the check if you know that __len is constant:
if (__builtin_constant_p(__len) && __len >= 512) ...
because in this case gcc will evaluate it at compile-time.

-- 
vda
