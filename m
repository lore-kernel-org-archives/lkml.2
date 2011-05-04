Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1EDLLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:11:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:53146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1EDLLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:11:45 -0400
Date: Wed, 4 May 2011 13:11:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504101932.GA3392@elte.hu>
Message-ID: <alpine.LFD.2.02.1105041233280.3005@ionos>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Ingo Molnar wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > But I rather suspect, that CONFIG_SLUB=y is the thing we need to look at. The 
> > lockless fastpath cmpxchg comes to my mind.
> 
> Hm, and CONFIG_X86_ELAN, as Linus noted, has an impact on the cmpxchg 
> implementation.

Exactly. With ELAN CONFIG_X86_CMPXCHG64 is not set. When I disable
ELAN it's set.

> > Either we generate broken code with that ELAN caused options or that combo 
> > triggers some hidden problem in SLUB.
> 
> Note that the crash went away with SLUB_DEBUG=y and PAGEALLOC=y and 
> SLUB_DEBUG=y would certainly narrow any lockless-SLUB race windows.

Well, it's pretty simple:

CONFIG_X86_CMPXCHG64=y compiles this_cpu_generic_cmpxchg_double() into:

    28f7:       89 f9                   mov    %edi,%ecx
    28f9:       8b 3e                   mov    (%esi),%edi
    28fb:       89 45 e4                mov    %eax,-0x1c(%ebp)
    28fe:       89 c3                   mov    %eax,%ebx
    2900:       8b 45 f0                mov    -0x10(%ebp),%eax
    2903:       64 0f c7 0f             cmpxchg8b %fs:(%edi)
    2907:       0f 94 c0                sete   %al
    290a:       84 c0                   test   %al,%al
    290c:       88 45 e4                mov    %al,-0x1c(%ebp)
    290f:       74 a4                   je     28b5 <kmem_cache_alloc+0x29>

while CONFIG_X86_CMPXCHG64=n results in:

    28b0:       8b 03                   mov    (%ebx),%eax
    28b2:       64 8b 30                mov    %fs:(%eax),%esi
    28b5:       39 d6                   cmp    %edx,%esi
    28b7:       75 d2                   jne    288b <kmem_cache_alloc+0x26>
    28b9:       64 8b 50 04             mov    %fs:0x4(%eax),%edx
    28bd:       39 ca                   cmp    %ecx,%edx
    28bf:       75 ca                   jne    288b <kmem_cache_alloc+0x26>
    28c1:       8b 4b 14                mov    0x14(%ebx),%ecx
    28c4:       8b 0c 0e                mov    (%esi,%ecx,1),%ecx
    28c7:       64 89 08                mov    %ecx,%fs:(%eax)
    28ca:       8b 03                   mov    (%ebx),%eax
    28cc:       42                      inc    %edx
    28cd:       64 89 50 04             mov    %edx,%fs:0x4(%eax)

And that code runs with preemption enabled. So when the task gets
preempted _BEFORE_ it has actuallty written back the data, then the
race window is wide open.

I'm still trying to understand that macro hell which actually
generates that code. I always thought that George Anzingers macro maze
was horrible, but that's even worse.

Thanks,

	tglx
