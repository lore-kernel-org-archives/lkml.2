Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1E2QfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:35:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33916 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1E2QfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=n2MqKqsiC/2zHYcMDSLleKQgc9F6WsPvaBIVZY9EjqaHJkEN9F5pZh0AKbqnLh6AtS
         1QvLGFbgGZhtbw/NjUwYDTh41ch3+DVxdqfDOOCUmAuCS7HjjqRfB5/SQf9Li2GXMpUQ
         2O78KVnPArYuY6ZHUruGm9ShWqVTt51438yHc=
MIME-Version: 1.0
In-Reply-To: <19938.28108.250080.666938@pilspetsen.it.uu.se>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com> <20110528153536.GB27104@elte.hu>
 <19938.23219.306163.24059@pilspetsen.it.uu.se> <BANLkTi=y2vGbj_LMqyXzj4JPL+w_KL+=yQ@mail.gmail.com>
 <19938.28108.250080.666938@pilspetsen.it.uu.se>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 12:35:04 -0400
X-Google-Sender-Auth: Dt2dAgYMDZLjpC3Ej_3vzuArj9Q
Message-ID: <BANLkTimXoLANJabAK8JfHsGi8OfDgPuhCA@mail.gmail.com>
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

On Sun, May 29, 2011 at 12:01 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Andrew Lutomirski writes:
>  > On Sun, May 29, 2011 at 10:39 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>  > > Ingo Molnar writes:
>  > >  >
>  > >  > * Andrew Lutomirski <luto@mit.edu> wrote:
>  > >  >
>  > >  > > On Fri, May 27, 2011 at 7:36 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>  > >  > > > 3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
>  > >  > > > called from a user address (so it has no risk of ever becoming ABI)
>  > >  > > > and it will do gettimeofday if called from the right address.  (I like
>  > > ...
>  > >  > > Make it a real syscall but with extra constraints.  It would have the
>  > >  > > same calling convention as the syscall instruction, but it would turn
>  > >  > > into SIGKILL if the calling address isn't in the VSYSCALL page
>  > >
>  > > This will make things difficult for user-space dynamic binary instrumentation
>  > > applications, since these normally execute generated code at different
>  > > addresses than the original code.
>  > >
>  > > Is there a safe fallback for this particular vsyscall?
>  >
>  > All of the vsyscalls have vDSO versions that work like any other code.
>
> Easiest would be if we can simply map int $0xcc with rAX==FOO to syscall or
> int 0x80 with rAX==BAR.

Yes and no.

With the code I just posted (and am fixing up now) that will work.
But if we want to replace the entire vsyscall page with three int 0xcc
and 4090 int3 instructions, then we can't look at eax because it won't
contain anything meaningful.

--Andy

>
> We currently don't even know about the vDSO, it's all just user-space code
> to us.
>
>  > Alternatively, if the dynamic instrumentation code knew about
>  > vsyscalls, it could just not instrument addresses in the vsyscall
>  > page.
>
> Not instrumenting code is not an option, unless we can prove that the
> code in question has no relevant side-effects or unexpected control-flow.
> (Where "side-effects" relate both to the integrity of the instrumentation
> engine and the application-specific payload it's attaching to the code.)

Calls to 0xffffffffff600000, 0xffffffffff600400, and
0xffffffffff600800 are syscalls, as an (unfortunate) part of the ABI.

>
>  > What existing applications would get broken?
>
> My concern is ThreadSpotter, but any user-space dynamic binary instrumentation
> engine that instruments down to the raw kernel interface (syscall/sysenter/int
> instructions) would have a problem with syscalls that only work at specific
> addresses.

I'll look.

>
> Anyway, if I can map that vsyscall to a plain proper syscall, then I'm OK.

All three vsyscalls can be replaced with real syscalls without side
effects.  Would it be possible to teach the instrumentation code to
deal with that?

--Andy
