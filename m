Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1E3D00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:26:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41465 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1E3D0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nvWeTV/RO7tWi9Nae20X5le75KqSwrTfUZP/5xvNV6DZ6g/KLqM0+ruDExdhI6OpPM
         XkXa3II04t18t4ZN2DiWf0uGHVOpvDrEmb8er6hur+knrVdcV3LsiYboDBc1agN8NNNF
         NcDWGyO+bZu0NwSv78dghRlk4lc9hEXbFktKY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=zxA3xzc0pR14rqwaOUXUAyF__MQ@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com> <20110528153536.GB27104@elte.hu>
 <19938.23219.306163.24059@pilspetsen.it.uu.se> <BANLkTi=y2vGbj_LMqyXzj4JPL+w_KL+=yQ@mail.gmail.com>
 <19938.28108.250080.666938@pilspetsen.it.uu.se> <BANLkTimXoLANJabAK8JfHsGi8OfDgPuhCA@mail.gmail.com>
 <19938.35645.288213.802394@pilspetsen.it.uu.se> <BANLkTi=zxA3xzc0pR14rqwaOUXUAyF__MQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 23:26:03 -0400
X-Google-Sender-Auth: 0Wdf42psjRyWKTpN6qmJdafcTrw
Message-ID: <BANLkTik1c9BvaoTKTdpTi9MRJYBLsNH4vA@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 2:44 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, May 29, 2011 at 2:06 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>> Andrew Lutomirski writes:
>>  > On Sun, May 29, 2011 at 12:01 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>>  > > Andrew Lutomirski writes:
>>  > >  >
>>  > >  > All of the vsyscalls have vDSO versions that work like any other code.
>>  > >
>>  > > Easiest would be if we can simply map int $0xcc with rAX==FOO to syscall or
>>  > > int 0x80 with rAX==BAR.
>>  >
>>  > Yes and no.
>>  >
>>  > With the code I just posted (and am fixing up now) that will work.
>>  > But if we want to replace the entire vsyscall page with three int 0xcc
>>  > and 4090 int3 instructions, then we can't look at eax because it won't
>>  > contain anything meaningful.
>>
>> I can relatively easily also consider the original application rIP
>> when decoding and translating these instructions.
>>
>>  >
>>  > --Andy
>>  >
>>  > >
>>  > > We currently don't even know about the vDSO, it's all just user-space code
>>  > > to us.
>>  > >
>>  > >  > Alternatively, if the dynamic instrumentation code knew about
>>  > >  > vsyscalls, it could just not instrument addresses in the vsyscall
>>  > >  > page.
>>  > >
>>  > > Not instrumenting code is not an option, unless we can prove that the
>>  > > code in question has no relevant side-effects or unexpected control-flow.
>>  > > (Where "side-effects" relate both to the integrity of the instrumentation
>>  > > engine and the application-specific payload it's attaching to the code.)
>>  >
>>  > Calls to 0xffffffffff600000, 0xffffffffff600400, and
>>  > 0xffffffffff600800 are syscalls, as an (unfortunate) part of the ABI.
>>  >
>>  > >
>>  > >  > What existing applications would get broken?
>>  > >
>>  > > My concern is ThreadSpotter, but any user-space dynamic binary instrumentation
>>  > > engine that instruments down to the raw kernel interface (syscall/sysenter/int
>>  > > instructions) would have a problem with syscalls that only work at specific
>>  > > addresses.
>>  >
>>  > I'll look.
>>  >
>>  > >
>>  > > Anyway, if I can map that vsyscall to a plain proper syscall, then I'm OK.
>>  >
>>  > All three vsyscalls can be replaced with real syscalls without side
>>  > effects.  Would it be possible to teach the instrumentation code to
>>  > deal with that?
>>
>> Yes, I just need to know how to identify them and what their equivalents are.
>> E.g., an int3 at <known address> becomes syscall rAX=<some constant>.
>>
>> Sounds like this change will be manageable after all.  Thanks.
>
> I'm not entirely sure I like that -- that way if we ever change it
> again we break your stuff again.
>
> Here are two proposals.
>
> 1. Teach your code that call 0xffffffffff600000 means
> gettimeofday(rdi, rsi).  That's guaranteed to never change and will
> keep working even if we start to emulate vsyscalls by marking the page
> not present and trapping the instruction fetch fault.

valgrind might be doing this.  It does not appear to trace directly
into vsyscalls, or at least it doesn't copy the int 0xcc instruction
out of them.

--Andy
