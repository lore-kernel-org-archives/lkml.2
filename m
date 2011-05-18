Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1ERDS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 23:18:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62091 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab1ERDS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 23:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=N3G5HOiou9hnZGYNWzpufZCzUpl/9zVPVLLY22MYebCLbydd1Gfb80cRDuY8FzXHnl
         7aOOcWXDfeecVw9k+rZ8fyqF7Pf618/tqe07MeLXi9RwaJTryMHy1fWkDZUlpIuJ0Ikk
         eFYPLCPWEBBl19JNi4PmVSEkNK6f0W8fJ5+M8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105172354040.3078@ionos>
References: <20110516160943.GC25898@one.firstfloor.org> <alpine.LFD.2.02.1105161817120.3078@ionos>
 <20110516164939.GD25898@one.firstfloor.org> <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
 <m2fwoeo0pf.fsf@firstfloor.org> <alpine.LFD.2.02.1105162345110.3078@ionos>
 <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com> <alpine.LFD.2.02.1105170022430.3078@ionos>
 <20110517080029.GB22093@elte.hu> <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
 <20110517113634.GC13475@elte.hu> <4DD2BEFB.6070609@mit.edu>
 <m2hb8typxt.fsf@firstfloor.org> <alpine.LFD.2.02.1105172354040.3078@ionos>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 17 May 2011 23:18:08 -0400
X-Google-Sender-Auth: Cyha37q-66inQWqJiycJhnghW00
Message-ID: <BANLkTik9+UGLvPCLYO246N4fMxJ5F=vHwA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
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

On Tue, May 17, 2011 at 6:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 17 May 2011, Andi Kleen wrote:
>> Andy Lutomirski <luto@MIT.EDU> writes:
>> >
>> > On KVM on Sandy Bridge, I can emulate a vsyscall that does nothing in 400ns or so.  I'll try to make this code emulate real vsyscalls over the weekend.  This was much easier than I expected.
>>
>> How about the performance of all the statically linked programs? I guess
>
> _ALL_ the statically linked programs? Point out a single one which
> matters and _IS_ performance critical.
>
>> you just declared they don't matter? gettimeofday is quite critical
>> and adding a exception into it is just a performance desaster.
>>
>> Also it's always a dangerous assumption to think that all
>> programs on Linux use glibc ("all world is a Vax")
>>
>> In fact more and more of Linux users are using different libcs these
>> days (like Android or embedded systems or languages with special runtime
>> systems) Who knows if all those other libraries use vDSO?
>
> Which is completely irrelevant to x86_64. Point to a single relevant
> x86_64 embedded system to which one of the above handwaving applies.
>
>> And then there are of course the old glibcs. A lot of people
>> (including me) use new kernels with old userland.
>
> And how is your use case performance critical ?
>
> Furthermore any halfways up to date deployemnt is using VDSO for
> obvious reasons and the archaic stuff which might be affected is not
> using a recent kernel at all (except for akpm on his retro laptop, but
> that "performance penalty" is probably the least of his worries).

Sadly that's not quite true.  glibc git right now contains this:

ENTRY (__gettimeofday)
        /* Align stack.  */
        sub     $0x8, %rsp
        cfi_adjust_cfa_offset(8)
#ifdef SHARED
        movq    __vdso_gettimeofday(%rip), %rax
        PTR_DEMANGLE (%rax)
#else
        movq    $VSYSCALL_ADDR_vgettimeofday, %rax
#endif
        callq   *%rax

And time() and sched_getcpu() call the vsyscall page unconditionally.
We should either declare CLOCK_REALTIME_COARSE to be acceptable for
time() or add a new vDSO call.

IMO we should put a note in feature-removal-schedule.txt, add vsyscall
emulation as a config option for 2.6.41 but leave it turned off by
default, and turn it on by default (or just remove the old code) in
2.6.43 or so.  That'll give glibc a chance to stop generating *new*
static binaries that call it.

I'm not volunteering to dig around the libdl stuff to fix it myself.

klibc doesn't seem to use vsyscalls or the vDSO.  I haven't looked at
uclibc, and I don't think that Bionic has any released version on
x86_64.

--Andy
