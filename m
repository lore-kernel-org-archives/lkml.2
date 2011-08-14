Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HNMkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 08:40:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52227 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1HNMkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 08:40:07 -0400
Date: Sun, 14 Aug 2011 14:40:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
Message-ID: <20110814124002.GA1528@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu>
 <20110814095910.GA18809@liondog.tnic>
 <201108141313.56926.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201108141313.56926.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 01:13:56PM +0200, Denys Vlasenko wrote:
> On Sunday 14 August 2011 11:59, Borislav Petkov wrote:
> > Here's the SSE memcpy version I got so far, I haven't wired in the
> > proper CPU feature detection yet because we want to run more benchmarks
> > like netperf and stuff to see whether we see any positive results there.
> > 
> > The SYSTEM_RUNNING check is to take care of early boot situations where
> > we can't handle FPU exceptions but we use memcpy. There's an aligned and
> > misaligned variant which should handle any buffers and sizes although
> > I've set the SSE memcpy threshold at 512 Bytes buffersize the least to
> > cover context save/restore somewhat.
> > 
> > Comments are much appreciated! :-)
> > 
> > --- a/arch/x86/include/asm/string_64.h
> > +++ b/arch/x86/include/asm/string_64.h
> > @@ -28,10 +28,20 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
> >  
> >  #define __HAVE_ARCH_MEMCPY 1
> >  #ifndef CONFIG_KMEMCHECK
> > +extern void *__memcpy(void *to, const void *from, size_t len);
> > +extern void *__sse_memcpy(void *to, const void *from, size_t len);
> >  #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
> > -extern void *memcpy(void *to, const void *from, size_t len);
> > +#define memcpy(dst, src, len)					\
> > +({								\
> > +	size_t __len = (len);					\
> > +	void *__ret;						\
> > +	if (__len >= 512)					\
> > +		__ret = __sse_memcpy((dst), (src), __len);	\
> > +	else							\
> > +		__ret = __memcpy((dst), (src), __len);		\
> > +	__ret;							\
> > +})
> 
> Please, no. Do not inline every memcpy invocation.
> This is pure bloat (comsidering how many memcpy calls there are)
> and it doesn't even win anything in speed, since there will be
> a fucntion call either way.
> Put the __len >= 512 check inside your memcpy instead.

In the __len < 512 case, this would actually cause two function calls,
actually: once the __sse_memcpy and then the __memcpy one.

> You may do the check if you know that __len is constant:
> if (__builtin_constant_p(__len) && __len >= 512) ...
> because in this case gcc will evaluate it at compile-time.

That could justify the bloat at least partially.

Actually, I had a version which sticks sse_memcpy code into memcpy_64.S
and that would save us both the function call and the bloat. I might
return to that one if it turns out that SSE memcpy makes sense for the
kernel.

Thanks.

-- 
Regards/Gruss,
    Boris.
