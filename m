Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1HON1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:27:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38930 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1HON1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:27:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110814124002.GA1528@liondog.tnic>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
	<20110812195220.GA29051@elte.hu>
	<20110814095910.GA18809@liondog.tnic>
	<201108141313.56926.vda.linux@googlemail.com>
	<20110814124002.GA1528@liondog.tnic>
Date: Mon, 15 Aug 2011 18:57:38 +0530
Message-ID: <CAHSGOuvW1nN3cjEBpcPYjCxtNGgUODwdFXNUzXR+D5raUq5dOA@mail.gmail.com>
Subject: Re: x86 memcpy performance
From: melwyn lobo <linux.melwyn@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Denys Vlasenko <vda.linux@googlemail.com>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Was on a vacation for last two days. Thanks for the good insights into
the issue.
Ingo, unfortunately the data we have is on a soon to be released
platform and strictly confidential at this stage.

Boris, thanks for the patch. On seeing your patch:
+void *__sse_memcpy(void *to, const void *from, size_t len)
+{
+       unsigned long src = (unsigned long)from;
+       unsigned long dst = (unsigned long)to;
+       void *p = to;
+       int i;
+
+       if (in_interrupt())
+               return __memcpy(to, from, len)
So what is the reason we cannot use sse_memcpy in interrupt context.
(fpu registers not saved ? )
My question is still not answered. There are 3 versions of memcpy in kernel:

***********************************arch/x86/include/asm/string_32.h******************************
179 #ifndef CONFIG_KMEMCHECK
180
181 #if (__GNUC__ >= 4)
182 #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
183 #else
184 #define memcpy(t, f, n)                         \
185         (__builtin_constant_p((n))              \
186          ? __constant_memcpy((t), (f), (n))     \
187          : __memcpy((t), (f), (n)))
188 #endif
189 #else
190 /*
191  * kmemcheck becomes very happy if we use the REP instructions
unconditionally,
192  * because it means that we know both memory operands in advance.
193  */
194 #define memcpy(t, f, n) __memcpy((t), (f), (n))
195 #endif
196
197
****************************************************************************************.
I will ignore CONFIG_X86_USE_3DNOW (including mmx_memcpy() ) as this
is valid only for AMD and not for Atom Z5xx series.
This means __memcpy, __constant_memcpy, __builtin_memcpy .
I have a hunch by default we were using  __builtin_memcpy. This  is
because I see my GCC version >=4 and CONFIG_KMEMCHECK not defined.
Can someone confirm of these 3 which is used, with i386_defconfig.
Again with i386_defconfig which workloads provide the best results
with the default implementation.

thanks,
M.
