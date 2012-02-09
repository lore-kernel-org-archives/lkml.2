Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2BIEUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 23:20:55 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:41399 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2BIEUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 23:20:51 -0500
Message-ID: <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
In-Reply-To: <4F33110D.3050904@zytor.com>
References: <20120116183730.GB21112@redhat.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
    <4F3007AD.50307@zytor.com>
    <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>
    <4F33110D.3050904@zytor.com>
Date: Thu, 9 Feb 2012 05:20:17 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        "Roland McGrath" <mcgrathr@chromium.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: d3d6c6694e059b137bd8e4e2c0542d46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 9, 2012 01:19, H. Peter Anvin wrote:
> On 02/06/2012 05:52 PM, Indan Zupancic wrote:
>>>
>>> - If the CPU is currently in 32- or 64-bit mode.
>>
>> What is the best way to find that out at the kernel side? Add a function
>> that checks cs and returns the correct answer? But in the kernel path the
>> CPU is always in 64-bit mode, so I suppose you want to know what mode the
>> tracee was in?
>>
>
> You need to look at the CS descriptor.

CS is already available to user space, but any other value than 0x23 or 0x33
will confuse user space, as that is all they know about. Apparently Xen uses
different values, but if those are static then user space can check for them
separately. But if the values change dynamically then some other way may be
needed.

But does it make much sense to pass the CPU mode of user space if that mode
can be changed at any moment? I don't think it really does. Can you give an
example of how that info can be used by a ptracer?

>
>>> - If we are currently inside a system call, and if so if it was entered
>>>   via:
>>> 	- SYSCALL64
>>> 	- INT 80
>>> 	- SYSCALL32
>>> 	- SYSENTER
>>>
>>>   The reason we need this information is because for the various 32-bit
>>>   entry points we do some very ugly swizzling of registers, which
>>>   matters to a ptrace client which wants to modify system call
>>>   arguments.
>>
>> But isn't the swizzling done in such way that all this is hidden from
>> ptrace clients (and the rest of the kernel)? Why would a ptrace client
>> need to know the details of the 32-bit entry call?
>>
>> The ptrace client can always modify the same registers, as system calls
>> always use the same registers too. No unexpected behaviour happens as
>> far as I can tell from looking at the code, at least not in the syscall
>> entry path.
>
> The simple stuff works, but once you want to do things like change the
> arguments and/or move the execution point, things get unswizzled in
> uncontrolled ways.

I do both and haven't encountered any problems.

I can't find any unswizzling happening in the return path though. So
from a ptracer's point of view it all looks the same after a system
call, no matter how it was entered. Except for IP perhaps, but that's
handled in the vDSO.

> There are bug reports related to that (I would have
> to dig them up) and they aren't really fixable in any sane way right now.

I don't see any problems in the code.

Only confusion I can think of is someone following the register values
across a systemcall instruction. Then the swizzling may be unexpected.
But if they do that they could check how the sycall was entered and
compensate for that. (I can't think of any requirement why this would
need to be race-free.)

>> A pure 32-bit kernel is compiled with:
>>
>> #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
>
> ... which we'd like to get rid of ...

If you do get rid of it, then you have to reload the registers after
ptrace, just like currently happens on x86_64 kernels. So regparm(0)
isn't a requirement, I only explained why reloading the registers
isn't needed for pure 32-bit.

Greetings,

Indan


