Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1EDLRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:17:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59193 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab1EDLQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uBtcNdR28LQG3VEEhJn15kYvYZysCfNGStfr6QZOcsu4ao9MbhGQQ6ujjgDXoFqwEN
         tYB0u1mLWcPxHXkOX7d3/eljBPnUOKeFvW9S95DnaoH3qGGVbmhnY+AA5YB7Sc963WGa
         8fIvVJX7EbL/kxRkQ29zVC+tP+dEfZWzt6Aqk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105041233280.3005@ionos>
References: <web-516671337@zbackend1.aha.ru>
	<BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
	<web-516990066@zbackend1.aha.ru>
	<BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
	<20110503190822.GA20520@elte.hu>
	<BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
	<20110504083559.GB25724@elte.hu>
	<alpine.LFD.2.02.1105041124080.3005@ionos>
	<20110504101932.GA3392@elte.hu>
	<alpine.LFD.2.02.1105041233280.3005@ionos>
Date: Wed, 4 May 2011 14:16:57 +0300
X-Google-Sender-Auth: -FAHiGx9I9d20OCHXe1HsE3sIHM
Message-ID: <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
From: Pekka Enberg <penberg@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 2:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 4 May 2011, Ingo Molnar wrote:
>
>>
>> * Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> > But I rather suspect, that CONFIG_SLUB=y is the thing we need to look at. The
>> > lockless fastpath cmpxchg comes to my mind.
>>
>> Hm, and CONFIG_X86_ELAN, as Linus noted, has an impact on the cmpxchg
>> implementation.
>
> Exactly. With ELAN CONFIG_X86_CMPXCHG64 is not set. When I disable
> ELAN it's set.
>
>> > Either we generate broken code with that ELAN caused options or that combo
>> > triggers some hidden problem in SLUB.
>>
>> Note that the crash went away with SLUB_DEBUG=y and PAGEALLOC=y and
>> SLUB_DEBUG=y would certainly narrow any lockless-SLUB race windows.
>
> Well, it's pretty simple:
>
> CONFIG_X86_CMPXCHG64=y compiles this_cpu_generic_cmpxchg_double() into:
>
>    28f7:       89 f9                   mov    %edi,%ecx
>    28f9:       8b 3e                   mov    (%esi),%edi
>    28fb:       89 45 e4                mov    %eax,-0x1c(%ebp)
>    28fe:       89 c3                   mov    %eax,%ebx
>    2900:       8b 45 f0                mov    -0x10(%ebp),%eax
>    2903:       64 0f c7 0f             cmpxchg8b %fs:(%edi)
>    2907:       0f 94 c0                sete   %al
>    290a:       84 c0                   test   %al,%al
>    290c:       88 45 e4                mov    %al,-0x1c(%ebp)
>    290f:       74 a4                   je     28b5 <kmem_cache_alloc+0x29>
>
> while CONFIG_X86_CMPXCHG64=n results in:
>
>    28b0:       8b 03                   mov    (%ebx),%eax
>    28b2:       64 8b 30                mov    %fs:(%eax),%esi
>    28b5:       39 d6                   cmp    %edx,%esi
>    28b7:       75 d2                   jne    288b <kmem_cache_alloc+0x26>
>    28b9:       64 8b 50 04             mov    %fs:0x4(%eax),%edx
>    28bd:       39 ca                   cmp    %ecx,%edx
>    28bf:       75 ca                   jne    288b <kmem_cache_alloc+0x26>
>    28c1:       8b 4b 14                mov    0x14(%ebx),%ecx
>    28c4:       8b 0c 0e                mov    (%esi,%ecx,1),%ecx
>    28c7:       64 89 08                mov    %ecx,%fs:(%eax)
>    28ca:       8b 03                   mov    (%ebx),%eax
>    28cc:       42                      inc    %edx
>    28cd:       64 89 50 04             mov    %edx,%fs:0x4(%eax)
>
> And that code runs with preemption enabled. So when the task gets
> preempted _BEFORE_ it has actuallty written back the data, then the
> race window is wide open.
>
> I'm still trying to understand that macro hell which actually
> generates that code. I always thought that George Anzingers macro maze
> was horrible, but that's even worse.

I'm adding Christoph and Tejun to CC.
