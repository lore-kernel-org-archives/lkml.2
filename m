Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1JJPbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:31:36 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45551 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1JJPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <20111010114840.GC17079@elte.hu>
References: <CAFLxGvzpvJ1mgdcbrq+3h5EA+VOhZDR9BY27uWGgsmV4TWYb4A@mail.gmail.com>
 <20111005223055.GG14406@localhost.pp.htv.fi> <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
 <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
 <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com> <20111010114840.GC17079@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 10 Oct 2011 08:31:13 -0700
X-Google-Sender-Auth: hZbPPV2r1FEMy1dqbSp2jG_0R3M
Message-ID: <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
To: Ingo Molnar <mingo@elte.hu>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 4:48 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
>
>> From UML's point of view the current situation is odd. UML will no
>> longer run on top of a default 3.1 kernel.
>
> This needs to be fixed (perhaps worked around in UML if that's
> possible and if you agree with that) - or barring a real obvious fix
> needs to be reverted to the last-known-working state. We are in -rc9
> so nothing but really, really obvious patches can be applied.
>
>> Why is this odd? One of the major reasons why people are still
>> using UML is because you can run it as non-privileged user on any
>> x86 Linux host. An user which has root privileges can setup and use
>> KVM which is much nicer than UML...
>
> No, your complaint is entirely justified.
>
> Andrew?

I think I know what the root cause is and I have most of a patch to
fix it.  It doesn't compile (yet), it's a little less trivial than I'd
like for something this late in the -rc cycle, and it adds 16 bytes to
thread_struct (ugh!).

I think I can make a follow-up patch that removes 32 bytes of
per-thread state to restore my karma, though, but that will definitely
not be 3.1 material.

The issue is that the existing trap_no, error_code, and cr2 fields are
used in ways that appear rather broken and extremely fragile to report
detailed exception info to user space when SIGSEGV, SIGBUS, and
SIGTRAP happen.  Touching them from the failed uaccess paths might
have unfortunate side effects like breaking vm86.  I suspect that
nothing other than UML and vm86 users care because they're only used
for the old sigcontext data and not for modern siginfo.  The tricky
case for vsyscall emulation is if gettimeofday is called with a buffer
that crosses a page boundary and the second page causes the fault.

I'll email something out in a day or two (maybe today).

--Andy
