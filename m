Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1EPV2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:28:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57923 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab1EPV2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qj/eSmK/+T2twlGo4zleoO0KbjtsvUKFlGJa/dg5pkyMKn1kB5DJUVbCiTTw6zSqVo
         2sFfdFvnJCoxSeU0oOVfihZYdaSTENw9eAftMdZR1Z+Gp7VKCh93OJ2uQXeugKTkVC+v
         wp/YwWqAzSZ3m2OQXW0YrW5jOqqWW54dhmCKw=
MIME-Version: 1.0
In-Reply-To: <m2fwoeo0pf.fsf@firstfloor.org>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org>
 <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> <m2fwoeo0pf.fsf@firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 16 May 2011 17:28:24 -0400
X-Google-Sender-Auth: DyW953HuIzlpHxizQLBW8_s3wh8
Message-ID: <BANLkTi=oMB+92dOAtJtiAXJH9g1=VmnSgQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 4:22 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Andrew Lutomirski <luto@mit.edu> writes:
>
>> On Mon, May 16, 2011 at 12:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>>> And unless you or someone else changes the primitive state of the
>>>> kernel, framepointers are going to stay simply because removing them
>>>> breaks profiling backtraces when the hit is inside vread().
>>>
>>> This doesn't work anyways because the glibc stub code calling vgettimeofday
>>> normally doesn't set up a frame pointer frame.
>>>
>>> The only way to unwind there is dwarf2.
>>
>> For code in the vsyscall page, I think using CFI data is a lost cause.
>>  How is any user code supposed to find the CFI data?
>
> It only works for the vDSO. vsyscall is legacy.

Except that vread_tsc (i.e. the code in question) is in the vsyscall
page.  (That's on my list of less low-hanging fruit to attack if I
decide to go for another 3 ns or so for 2.6.41.)

>
>> For the vDSO, we could be nice to userspace and install the debugging
>> symbols somewhere sensible.  Currently we generate a buildid but we
>> don't install the symbols anywhere by default.
>
> Actually we include the dwarf2 tables and signal unwinding works
> (for the vDSO)

That particular comment was more about debugging than stack traces.
Things like perf annotate would like the full symbols.

>
>> Longer term, it would be nice to mark the vsyscall page NX.  That
>> involves a few things:
>
> Why NX? What would make sense is to call the VDSO from it.
> The problem is that the vDSO is randomized and there's no good memory
> location to store the pointer to it.
>
> The real reason for all this dance is to have some less non randomized
> code around. What I implemented back then was instead code to patch out
> the SYSCALL in there if not needed to lower the attack surface (not sure
> if that still works though, but that was the idea). For most cases
> (TSC/HPET read) it's not needed.

Nothing sensible calls the vsyscall page.  (I'm defining code that
statically links against current glibc as insensible.  But that could
be fixed.  I think it's mainly an artifact of some odd glibc
internals.)  So if we make the vsyscall page NX then we have no
non-randomized code at all.

How do we tell that a program really wants to call the vsyscall page
and isn't being exploited to call the vsyscall page?

There are excactly four entry-points into the vsyscall page that are
part of the ABI.  One of them is venosys (maybe it used to do
something) and the other three are archaic duplicates of vDSO
functions.  It seems less complicated to emulate them than to patch
them in.

--Andy
