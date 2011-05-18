Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1ERLav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:30:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32808 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab1ERLau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=KwryfQluaB++PsNf21/Y8Mh7eWskLRSmoIXmxyGwGqjOK51iNlSvQZYnzcZEx2hqk6
         jtyS0rcDVP1fBr72JrFhAZ3nQMhN/VWLkH3x4Zf+2DGrQzgEV0AIpe3KX3iYy+vPvci2
         GIkclCd99SKfSIbUc+m5Uwm4YPXYVjyuhc0F0=
MIME-Version: 1.0
In-Reply-To: <20110518083147.GD14805@elte.hu>
References: <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
 <alpine.LFD.2.02.1105170022430.3078@ionos> <20110517080029.GB22093@elte.hu>
 <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com> <20110517113634.GC13475@elte.hu>
 <4DD2BEFB.6070609@mit.edu> <m2hb8typxt.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105172354040.3078@ionos> <BANLkTik9+UGLvPCLYO246N4fMxJ5F=vHwA@mail.gmail.com>
 <alpine.LFD.2.02.1105180839370.3078@ionos> <20110518083147.GD14805@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 18 May 2011 07:30:30 -0400
X-Google-Sender-Auth: 8bEi7-21WufTSYiak0W4yrTT12Q
Message-ID: <BANLkTi=cqjGDD7X8u_7LDGZh7KqFZo6h+w@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
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

On Wed, May 18, 2011 at 4:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> > And time() and sched_getcpu() call the vsyscall page unconditionally.
>>
>> Dammit, time() is a real problem. I missed that and thought that it's
>> gettimeofday() alone for the static case. sched_getcpu() is nothing to worry
>> about.

I made exactly the same assumption.

>
> There's a relatively simple solution for all this:
>
>  - We can make the old vsyscall page contain an int $0x81 (it is a free vector)
>
>  - We can use vector 0x81 as a wrapper around the int80 entry: it would check
>   the syscall nrs and return if it's outside the small number of permitted
>   syscalls
>
>  - We can put this behind a straightforward CONFIG_COMPAT_VSYSCALL=y option,
>   enabled by default for compatibility.
>
>  - Distros that fix glibc can turn it off
>
> Costs:
>
>  - the performance cost of this solution is minimal: weirdly built binaries on
>   unfixed glibc will have a handful of syscalls execute via int $0x81 not the
>   syscall instruction. The cost of that is +50 nsecs at most - not 500.
>
>  - almost zero maintenance cost: it just wraps existing int80 logic. It does not
>   even have to use any kernel stack, it only checks register arguments so the
>   code is truly small and trivial to keep secure.
>
> Advantages:
>
>  - we defang the constant-address syscall instruction this way - it cannot be
>   used for anything even remotely useful to an exploit.
>
>  - it's very simple
>
>  - there's a future path out of it and a future path to deprecate this
>
> What do you think?

I was thinking of something similar but using ud2 instead of a new
interrupt vector.  I like the interrupt approach better.  We could
fill the rest of the page with 0xCC to make certain that jumping
anywhere else in there isn't useful.

As an interim measure, we could keep vtime and check it for anything
that could be used as a syscall if called with the wrong instruction
alignment.

Should we add a vDSO vtime for 2.6.40 so that people can start using it?

--Andy
