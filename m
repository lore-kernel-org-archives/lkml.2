Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2BIGDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:03:47 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44957 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2BIGDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:03:33 -0500
Message-ID: <5f13059f9b57d2a0fe2be094702b8177.squirrel@webmail.greenhost.nl>
In-Reply-To: <4F334B8C.2050005@zytor.com>
References: <20120116183730.GB21112@redhat.com>
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
    <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>
    <4F334B8C.2050005@zytor.com>
Date: Thu, 9 Feb 2012 07:03:08 +0100
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
        ak@linux.intel.com, eric.dumazet@gmail.com, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 388a8ff653e0601f0215f26536afca72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 9, 2012 05:29, H. Peter Anvin wrote:
> On 02/08/2012 08:20 PM, Indan Zupancic wrote:
>>
>> CS is already available to user space, but any other value than 0x23 or 0x33
>> will confuse user space, as that is all they know about. Apparently Xen uses
>> different values, but if those are static then user space can check for them
>> separately. But if the values change dynamically then some other way may be
>> needed.
>>
>> But does it make much sense to pass the CPU mode of user space if that mode
>> can be changed at any moment? I don't think it really does. Can you give an
>> example of how that info can be used by a ptracer?
>>
>
> Uh... you could make THAT argument about ANY register state!

Well, when the tracee is in a system call, it can't change registers,
and their values determine the system call number and arguments. That
information is stable for the current system call. And as a ptracer
can't determine if the 32 or 64-bit syscall entry path was taken in
a race-free way, it makes sense to provide that extra info.

But the same is not true for the user space CPU mode, that can change
at any time without the tracer getting a notification, except if it is
single stepping (which I forgot about).

Would it be useful to know the CPU mode when single stepping or otherwise?

I'm asking because I don't see a need for it, but if someone else does
it's better to add it now together with the syscall mode bit. Unlike the
system call mode, the CPU mode can be checked via CS. The question is
if that works well enough or if the values are dynamic enough that it's
better to pass the info explicitly instead.

Unlike the syscall mode info, figuring out the mode from CS isn't trivial
when it can change dynamically. Then all places that use non-standard CS
values need to be changed to provide the mode somehow.

> I believe H.J. can fill you in about the usage.

That would be great.

>>
>> Only confusion I can think of is someone following the register values
>> across a systemcall instruction. Then the swizzling may be unexpected.
>> But if they do that they could check how the sycall was entered and
>> compensate for that. (I can't think of any requirement why this would
>> need to be race-free.)
>>
>
> You'd have to know how you'd entered, which right now you don't have any
> way to know.

You can check the syscall instruction itself, either before it's executed
or afterwards by checking the IP. Though that's trickier, because the
kernel points the IP to just after int80 for a sysenter call, so you have
to check if there's a sysenter nearby too.

You can also figure out what the entry instruction was by comparing the
register values with the expected ones and deducing it that way.

But the kernel is actually changing the registers, so why hide that?

I mean, once user space is aware that the kernel may do swizzling, is there
any actual problem left? Because this sounds like user space was trying to
be clever, but got it wrong. E.g. it knew the kernel was entered not via
int80, but then got confused because of the swizzling.

Greetings,

Indan


