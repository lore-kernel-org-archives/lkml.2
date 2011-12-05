Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1LEMyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:54:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56036 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab1LEMya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:54:30 -0500
MIME-Version: 1.0
In-Reply-To: <4E5FA18A.7010205@gmail.com>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
	<20110812195220.GA29051@elte.hu>
	<20110814095910.GA18809@liondog.tnic>
	<6296.1313462075@turing-police.cc.vt.edu>
	<20110816121604.GA29251@aftab>
	<4E5FA18A.7010205@gmail.com>
Date: Mon, 5 Dec 2011 18:24:29 +0530
Message-ID: <CAHSGOuvJsJr3r+RwM0+733BQJO6hsK0iP0ZNzRoycWX3YHwE0A@mail.gmail.com>
Subject: Re: x86 memcpy performance
From: melwyn lobo <linux.melwyn@gmail.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will AVX work on Intel ATOM. I guess not. Then is this now not the
time for having architecture dependant definitions for basic cpu
intensive tasks


On Thu, Sep 1, 2011 at 8:45 PM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> Hey,
>
> 2011/8/16 Borislav Petkov <bp@amd64.org>:
>> On Mon, Aug 15, 2011 at 10:34:35PM -0400, Valdis.Kletnieks@vt.edu wrote:
>>> On Sun, 14 Aug 2011 11:59:10 +0200, Borislav Petkov said:
>>>
>>> > Benchmarking with 10000 iterations, average results:
>>> > size    XM              MM              speedup
>>> > 119     540.58          449.491         0.8314969419
>>>
>>> > 12273   2307.86         4042.88         1.751787902
>>> > 13924   2431.8          4224.48         1.737184756
>>> > 14335   2469.4          4218.82         1.708440514
>>> > 15018 2675.67         1904.07         0.711622886
>>> > 16374   2989.75         5296.26         1.771470902
>>> > 24564   4262.15         7696.86         1.805863077
>>> > 27852   4362.53         3347.72         0.7673805572
>>> > 28672   5122.8          7113.14         1.388524413
>>> > 30033   4874.62         8740.04         1.792967931
>>>
>>> The numbers for 15018 and 27852 are *way* odd for the MM case. I don't feel
>>> really good about this till we understand what happened for those two cases.
>>
>> Yep.
>>
>>> Also, anytime I see "10000 iterations", I ask myself if the benchmark
>>> rigging took proper note of hot/cold cache issues. That *may* explain
>>> the two oddball results we see above - but not knowing more about how
>>> it was benched, it's hard to say.
>>
>> Yeah, the more scrutiny this gets the better. So I've cleaned up my
>> setup and have attached it.
>>
>> xm_mem.c does the benchmarking and in bench_memcpy() there's the
>> sse_memcpy call which is the SSE memcpy implementation using inline asm.
>> It looks like gcc produces pretty crappy code here because if I replace
>> the sse_memcpy call with xm_memcpy() from xm_memcpy.S - this is the
>> same function but in pure asm - I get much better numbers, sometimes
>> even over 2x. It all depends on the alignment of the buffers though.
>> Also, those numbers don't include the context saving/restoring which the
>> kernel does for us.
>>
>> 7491    1509.89         2346.94         1.554378381
>> 8170    2166.81         2857.78         1.318890326
>> 12277   2659.03         4179.31         1.571744176
>> 13907   2571.24         4125.7          1.604558427
>> 14319   2638.74         5799.67         2.19789466      <----
>> 14993   2752.42         4413.85         1.603625603
>> 16371   3479.11         5562.65         1.59887055
>
> This work intrigued me, in some cases kernel memcpy was a lot faster than sse memcpy,
> and I finally figured out why. I also extended the test to an optimized avx memcpy,
> but I think the kernel memcpy will always win in the aligned case.
>
> Those numbers you posted aren't right it seems. It depends a lot on the alignment,
> for example if both are aligned to 64 relative to each other,
> kernel memcpy will win from avx memcpy on my machine.
>
> I replaced the malloc calls with memalign(65536, size + 256) so I could toy
> around with the alignments a little. This explains why for some sizes, kernel
> memcpy was faster than sse memcpy in the test results you had.
> When (src & 63 == dst & 63), it seems that kernel memcpy always wins, otherwise
> avx memcpy might.
>
> If you want to speed up memcpy, I think your best bet is to find out why it's
> so much slower when src and dst aren't 64-byte aligned compared to each other.
>
> Cheers,
> Maarten
>
> ---
> Attached: my modified version of the sse memcpy you posted.
>
> I changed it a bit, and used avx, but some of the other changes might
> be better for your sse memcpy too.
