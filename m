Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab2BJCaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:30:13 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:54895 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2BJCaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:30:08 -0500
Message-ID: <19ac5d5293110612dc17c514bc7e1ccd.squirrel@webmail.greenhost.nl>
In-Reply-To: <4F346FB0.9070203@zytor.com>
References: <20120116183730.GB21112@redhat.com>
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
    <CAMe9rOrf-DrgdwsnpX7pa=h1p9qSpqa9fwJAQJvjSzgR9MAB_w@mail.gmail.com>
    <b3f79ce8b30e2985723eec1a3337317e.squirrel@webmail.greenhost.nl>
    <4F346FB0.9070203@zytor.com>
Date: Fri, 10 Feb 2012 03:29:40 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
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
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: be1ed956250a6aced2eef8025a824392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, February 10, 2012 02:15, H. Peter Anvin wrote:
> On 02/09/2012 05:09 PM, Indan Zupancic wrote:
>> On Thu, February 9, 2012 17:00, H.J. Lu wrote:
>>> GDB uses CS value to tell ia32 process from x86-64 process.
>>
>> Are there any cases when this doesn't work? Someone said Xen can
>> have different CS values, but looking at the source it seems it's
>> using the same ones, at least with a Linux hypervisor. So perhaps
>> it was KVM. Looking at the header it seems paravirtualisation uses
>> different cs values. On the upside, it seems we can just use that
>> user_64bit_mode() to know whether it is 32 or 64 bit mode, so
>> adding a bit telling the process mode is easier than I thought.
>>
>> Currently there is a need to tell if the 32 or 64-bit syscall
>> path is being taken, which is independent of the process mode.
>>
>
> There are definitely cases where the current reliance on magic CS values
> doesn't work; never mind the fact that it's just broken.

It's only broken because it doesn't work sometimes. ;-)

>>> At minimum, we need a bit in CS for GDB.  But any changes
>>> will break old GDB.
>>
>> Would adding bits to the upper 32-bit of rflags break GDB?
>
> It doesn't work for i386, never mind that this is reserved hardware
> state and we don't have an OK at this time to redeclare them available.

It doesn't need to work for i386 because it's close to practically
impossible to ptrace a 64-bit task with a 32-bit ptracer.

An alternative would be to use some of the bits in the lower half.

E.g. bits 1, 3, 5 and 15 are reserved and very unlikely to be ever
used for anything, because they can use plenty of bits at the top.
Problem would be that we can't be sure that they are always zero.
If they are, they're safe to use.

The VIF and VIP flags can also be stolen as they're always zero
outside of vm86 mode (which can't be ptraced AFAIK). So we could
set VIF or VIP to tell if we stole bits 1, 3, 5 and/or 15. That
would give us 6 bits in total, and the only confusing thing might
be VIF or VIP set for user space. But anyone counting on those
being zero seems unlikely, and even more unlikely for the reserved
bits, as they are intermixed with unpredictable bits. We could use
VM too, but that might be too confusing, while VIF or VIP without
VM set make no sense.

Perhaps using VIF or VIP to tell whether the other bits are valid
is a good idea anyway, as it can never clash because they are well
defined already and always zero for non-VM mode.

With the current rate of adding flags it will take forever before
any of this might break. And if that happens, we just move to other
bits and user space needs to check those first. Or if the flags
aren't useful for userspace, hide them and keep using it for the
kernel.

>> Do you also need a way to know whether the kernel was entered via
>> int 0x80, SYSCALL32/64 or SYSENTER?
>
> gdb, probably not.  That came from another user (pin, I think, but I'm
> not sure.)

Could you find out? Because I have a hard time thinking of any good
reason why anyone would want to know this specifically.

If this info is added it can replace the bit saying if it's 32 or 64-bit
syscall path. So one bit for enabling all this, 2 bits for the syscall
entry instruction (with SYSCALL64 being 0 as an easy check for the 64-bit
path) and one bit for user space mode. This would end up being 4 bits in
total, except if I forgot anything.

Only downside of adding the entry instruction info would be that more
work in the entry-specific code is needed. The code wouldn't be contained
to a small ptrace specific bit anymore.

Greetings,

Indan


