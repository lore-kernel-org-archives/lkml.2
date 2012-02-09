Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2BIAYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 19:24:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51098 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab2BIAX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 19:23:58 -0500
Message-ID: <4F33110D.3050904@zytor.com>
Date: Wed, 08 Feb 2012 16:19:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com>    <20120117170512.GB17070@redhat.com>    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>    <20120118015013.GR11715@one.firstfloor.org>    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>    <20120118022217.GS11715@one.firstfloor.org>    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>    <4F3007AD.50307@zytor.com> <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>
In-Reply-To: <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 05:52 PM, Indan Zupancic wrote:
>>
>> - If the CPU is currently in 32- or 64-bit mode.
> 
> What is the best way to find that out at the kernel side? Add a function
> that checks cs and returns the correct answer? But in the kernel path the
> CPU is always in 64-bit mode, so I suppose you want to know what mode the
> tracee was in?
> 

You need to look at the CS descriptor.

>> - If we are currently inside a system call, and if so if it was entered
>>   via:
>> 	- SYSCALL64
>> 	- INT 80
>> 	- SYSCALL32
>> 	- SYSENTER
>>
>>   The reason we need this information is because for the various 32-bit
>>   entry points we do some very ugly swizzling of registers, which
>>   matters to a ptrace client which wants to modify system call
>>   arguments.
> 
> But isn't the swizzling done in such way that all this is hidden from
> ptrace clients (and the rest of the kernel)? Why would a ptrace client
> need to know the details of the 32-bit entry call?
>  
> The ptrace client can always modify the same registers, as system calls
> always use the same registers too. No unexpected behaviour happens as
> far as I can tell from looking at the code, at least not in the syscall
> entry path.

The simple stuff works, but once you want to do things like change the
arguments and/or move the execution point, things get unswizzled in
uncontrolled ways.  There are bug reports related to that (I would have
to dig them up) and they aren't really fixable in any sane way right now.

> A pure 32-bit kernel is compiled with:
> 
> #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))

... which we'd like to get rid of ...

> So all arguments are passed on the stack and those arguments can be
> directly modified by ptrace. For compat kernels the arguments are
> reloaded after ptrace and before the actual system call is done.

>> - If the process was started as a 64-bit process, i386 process or x32
>>   process.
> 
> Can't that be figured out by looking at the AUXV data? Either via /proc
> or PTRACE_GETREGSET + NT_AUXV. And as this can't change, there is no
> need to pass it on all the time.

I'll look at the auxv stuff.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

