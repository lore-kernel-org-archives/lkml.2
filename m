Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1IAPP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:15:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62485 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab1IAPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:15:27 -0400
Message-ID: <4E5FA18A.7010205@gmail.com>
Date: Thu, 01 Sep 2011 17:15:22 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com> <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic> <6296.1313462075@turing-police.cc.vt.edu> <20110816121604.GA29251@aftab>
In-Reply-To: <20110816121604.GA29251@aftab>
Content-Type: multipart/mixed;
 boundary="------------020205020404090801050908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020205020404090801050908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hey,

2011/8/16 Borislav Petkov <bp@amd64.org>:
> On Mon, Aug 15, 2011 at 10:34:35PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Sun, 14 Aug 2011 11:59:10 +0200, Borislav Petkov said:
>>
>> > Benchmarking with 10000 iterations, average results:
>> > size    XM              MM              speedup
>> > 119     540.58          449.491         0.8314969419
>>
>> > 12273   2307.86         4042.88         1.751787902
>> > 13924   2431.8          4224.48         1.737184756
>> > 14335   2469.4          4218.82         1.708440514
>> > 15018 2675.67         1904.07         0.711622886
>> > 16374   2989.75         5296.26         1.771470902
>> > 24564   4262.15         7696.86         1.805863077
>> > 27852   4362.53         3347.72         0.7673805572
>> > 28672   5122.8          7113.14         1.388524413
>> > 30033   4874.62         8740.04         1.792967931
>>
>> The numbers for 15018 and 27852 are *way* odd for the MM case. I don't feel
>> really good about this till we understand what happened for those two cases.
>
> Yep.
>
>> Also, anytime I see "10000 iterations", I ask myself if the benchmark
>> rigging took proper note of hot/cold cache issues. That *may* explain
>> the two oddball results we see above - but not knowing more about how
>> it was benched, it's hard to say.
>
> Yeah, the more scrutiny this gets the better. So I've cleaned up my
> setup and have attached it.
>
> xm_mem.c does the benchmarking and in bench_memcpy() there's the
> sse_memcpy call which is the SSE memcpy implementation using inline asm.
> It looks like gcc produces pretty crappy code here because if I replace
> the sse_memcpy call with xm_memcpy() from xm_memcpy.S - this is the
> same function but in pure asm - I get much better numbers, sometimes
> even over 2x. It all depends on the alignment of the buffers though.
> Also, those numbers don't include the context saving/restoring which the
> kernel does for us.
>
> 7491    1509.89         2346.94         1.554378381
> 8170    2166.81         2857.78         1.318890326
> 12277   2659.03         4179.31         1.571744176
> 13907   2571.24         4125.7          1.604558427
> 14319   2638.74         5799.67         2.19789466      <----
> 14993   2752.42         4413.85         1.603625603
> 16371   3479.11         5562.65         1.59887055

This work intrigued me, in some cases kernel memcpy was a lot faster than sse memcpy,
and I finally figured out why. I also extended the test to an optimized avx memcpy,
but I think the kernel memcpy will always win in the aligned case.

Those numbers you posted aren't right it seems. It depends a lot on the alignment,
for example if both are aligned to 64 relative to each other,
kernel memcpy will win from avx memcpy on my machine.

I replaced the malloc calls with memalign(65536, size + 256) so I could toy
around with the alignments a little. This explains why for some sizes, kernel
memcpy was faster than sse memcpy in the test results you had.
When (src & 63 == dst & 63), it seems that kernel memcpy always wins, otherwise
avx memcpy might.

If you want to speed up memcpy, I think your best bet is to find out why it's
so much slower when src and dst aren't 64-byte aligned compared to each other.

Cheers,
Maarten

---
Attached: my modified version of the sse memcpy you posted.

I changed it a bit, and used avx, but some of the other changes might
be better for your sse memcpy too.

--------------020205020404090801050908
Content-Type: text/plain;
 name="ym_memcpy.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ym_memcpy.txt"

LyoKICogeW1fbWVtY3B5IC0gQVZYIHZlcnNpb24gb2YgbWVtY3B5CiAqCiAqIElucHV0Ogog
KiAgcmRpIGRlc3RpbmF0aW9uCiAqICByc2kgc291cmNlCiAqICByZHggY291bnQKICoKICog
T3V0cHV0OgogKiByYXggb3JpZ2luYWwgZGVzdGluYXRpb24KICovCi5nbG9ibCB5bV9tZW1j
cHkKLnR5cGUgeW1fbWVtY3B5LCBAZnVuY3Rpb24KCnltX21lbWNweToKCW1vdiAlcmRpLCAl
cmF4CgoJLyogVGFyZ2V0IGFsaWduICovCgltb3Z6YnEgJWRpbCwgJXJjeAoJbmVnYiAlY2wK
CWFuZGIgJDB4MWYsICVjbAoJc3VicSAlcmN4LCAlcmR4CglyZXAgbW92c2IKCgltb3ZxICVy
ZHgsICVyY3gKCWFuZHEgJDB4MWZmLCAlcmR4CglzaHJxICQ5LCAlcmN4CglqeiAudHJhaWxl
cgoKCW1vdmIgJXNpbCwgJXI4YgoJYW5kYiAkMHgxZiwgJXI4YgoJdGVzdCAlcjhiLCAlcjhi
CglqeiAucmVwZWF0X2EKCgkuYWxpZ24gMzIKLnJlcGVhdF91YToKCXZtb3Z1cHMgMHgwKCVy
c2kpLCAleW1tMAoJdm1vdnVwcyAweDIwKCVyc2kpLCAleW1tMQoJdm1vdnVwcyAweDQwKCVy
c2kpLCAleW1tMgoJdm1vdnVwcyAweDYwKCVyc2kpLCAleW1tMwoJdm1vdnVwcyAweDgwKCVy
c2kpLCAleW1tNAoJdm1vdnVwcyAweGEwKCVyc2kpLCAleW1tNQoJdm1vdnVwcyAweGMwKCVy
c2kpLCAleW1tNgoJdm1vdnVwcyAweGUwKCVyc2kpLCAleW1tNwoJdm1vdnVwcyAweDEwMCgl
cnNpKSwgJXltbTgKCXZtb3Z1cHMgMHgxMjAoJXJzaSksICV5bW05Cgl2bW92dXBzIDB4MTQw
KCVyc2kpLCAleW1tMTAKCXZtb3Z1cHMgMHgxNjAoJXJzaSksICV5bW0xMQoJdm1vdnVwcyAw
eDE4MCglcnNpKSwgJXltbTEyCgl2bW92dXBzIDB4MWEwKCVyc2kpLCAleW1tMTMKCXZtb3Z1
cHMgMHgxYzAoJXJzaSksICV5bW0xNAoJdm1vdnVwcyAweDFlMCglcnNpKSwgJXltbTE1CgoJ
dm1vdmFwcyAleW1tMCwgMHgwKCVyZGkpCgl2bW92YXBzICV5bW0xLCAweDIwKCVyZGkpCgl2
bW92YXBzICV5bW0yLCAweDQwKCVyZGkpCgl2bW92YXBzICV5bW0zLCAweDYwKCVyZGkpCgl2
bW92YXBzICV5bW00LCAweDgwKCVyZGkpCgl2bW92YXBzICV5bW01LCAweGEwKCVyZGkpCgl2
bW92YXBzICV5bW02LCAweGMwKCVyZGkpCgl2bW92YXBzICV5bW03LCAweGUwKCVyZGkpCgl2
bW92YXBzICV5bW04LCAweDEwMCglcmRpKQoJdm1vdmFwcyAleW1tOSwgMHgxMjAoJXJkaSkK
CXZtb3ZhcHMgJXltbTEwLCAweDE0MCglcmRpKQoJdm1vdmFwcyAleW1tMTEsIDB4MTYwKCVy
ZGkpCgl2bW92YXBzICV5bW0xMiwgMHgxODAoJXJkaSkKCXZtb3ZhcHMgJXltbTEzLCAweDFh
MCglcmRpKQoJdm1vdmFwcyAleW1tMTQsIDB4MWMwKCVyZGkpCgl2bW92YXBzICV5bW0xNSwg
MHgxZTAoJXJkaSkKCgkvKiBhZHZhbmNlIHBvaW50ZXJzICovCglhZGRxICQweDIwMCwgJXJz
aQoJYWRkcSAkMHgyMDAsICVyZGkKCXN1YnEgJDEsICVyY3gKCWpueiAucmVwZWF0X3VhCglq
eiAudHJhaWxlcgoKCS5hbGlnbiAzMgoucmVwZWF0X2E6CglwcmVmZXRjaG50YSAweDgwKCVy
c2kpCglwcmVmZXRjaG50YSAweDEwMCglcnNpKQoJcHJlZmV0Y2hudGEgMHgxODAoJXJzaSkK
CXZtb3ZhcHMgMHgwKCVyc2kpLCAleW1tMAoJdm1vdmFwcyAweDIwKCVyc2kpLCAleW1tMQoJ
dm1vdmFwcyAweDQwKCVyc2kpLCAleW1tMgoJdm1vdmFwcyAweDYwKCVyc2kpLCAleW1tMwoJ
dm1vdmFwcyAweDgwKCVyc2kpLCAleW1tNAoJdm1vdmFwcyAweGEwKCVyc2kpLCAleW1tNQoJ
dm1vdmFwcyAweGMwKCVyc2kpLCAleW1tNgoJdm1vdmFwcyAweGUwKCVyc2kpLCAleW1tNwoJ
dm1vdmFwcyAweDEwMCglcnNpKSwgJXltbTgKCXZtb3ZhcHMgMHgxMjAoJXJzaSksICV5bW05
Cgl2bW92YXBzIDB4MTQwKCVyc2kpLCAleW1tMTAKCXZtb3ZhcHMgMHgxNjAoJXJzaSksICV5
bW0xMQoJdm1vdmFwcyAweDE4MCglcnNpKSwgJXltbTEyCgl2bW92YXBzIDB4MWEwKCVyc2kp
LCAleW1tMTMKCXZtb3ZhcHMgMHgxYzAoJXJzaSksICV5bW0xNAoJdm1vdmFwcyAweDFlMCgl
cnNpKSwgJXltbTE1CgoJdm1vdmFwcyAleW1tMCwgMHgwKCVyZGkpCgl2bW92YXBzICV5bW0x
LCAweDIwKCVyZGkpCgl2bW92YXBzICV5bW0yLCAweDQwKCVyZGkpCgl2bW92YXBzICV5bW0z
LCAweDYwKCVyZGkpCgl2bW92YXBzICV5bW00LCAweDgwKCVyZGkpCgl2bW92YXBzICV5bW01
LCAweGEwKCVyZGkpCgl2bW92YXBzICV5bW02LCAweGMwKCVyZGkpCgl2bW92YXBzICV5bW03
LCAweGUwKCVyZGkpCgl2bW92YXBzICV5bW04LCAweDEwMCglcmRpKQoJdm1vdmFwcyAleW1t
OSwgMHgxMjAoJXJkaSkKCXZtb3ZhcHMgJXltbTEwLCAweDE0MCglcmRpKQoJdm1vdmFwcyAl
eW1tMTEsIDB4MTYwKCVyZGkpCgl2bW92YXBzICV5bW0xMiwgMHgxODAoJXJkaSkKCXZtb3Zh
cHMgJXltbTEzLCAweDFhMCglcmRpKQoJdm1vdmFwcyAleW1tMTQsIDB4MWMwKCVyZGkpCgl2
bW92YXBzICV5bW0xNSwgMHgxZTAoJXJkaSkKCgkvKiBhZHZhbmNlIHBvaW50ZXJzICovCglh
ZGRxICQweDIwMCwgJXJzaQoJYWRkcSAkMHgyMDAsICVyZGkKCXN1YnEgJDEsICVyY3gKCWpu
eiAucmVwZWF0X2EKCgkuYWxpZ24gMzIKLnRyYWlsZXI6Cgltb3ZxICVyZHgsICVyY3gKCXNo
cnEgJDMsICVyY3gKCXJlcDsgbW92c3EKCW1vdnEgJXJkeCwgJXJjeAoJYW5kcSAkMHg3LCAl
cmN4CglyZXA7IG1vdnNiCglyZXRxCg==
--------------020205020404090801050908--
