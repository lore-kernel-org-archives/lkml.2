Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2ARBCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:02:08 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40390 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852Ab2ARBCE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:02:04 -0500
MIME-Version: 1.0
In-Reply-To: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
References: <20120112172315.GA26295@redhat.com> <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
 <20120113173153.GA24273@redhat.com> <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
 <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
 <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 17 Jan 2012 17:01:41 -0800
X-Google-Sender-Auth: HY3ttRpJj-jQaqJTFj2sUzxhLik
Message-ID: <CAObL_7HVGNdFhYfUDvJJWMK-2fVoG8KJj2_fuPvc7aBLBhBO4g@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
To: Indan Zupancic <indan@nul.nu>
Cc: Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 4:56 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Tue, January 17, 2012 18:45, Andrew Lutomirski wrote:
>> On Tue, Jan 17, 2012 at 9:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 01/17, Andrew Lutomirski wrote:
>>>>
>>>> (is_compat_task says whether the executable was marked as 32-bit. �The
>>>> actual execution mode is determined by the cs register, which the user
>>>> can control.
>>>
>>> Confused... Afaics, TIF_IA32 says that the binary is 32-bit (this comes
>>> along with TS_COMPAT).
>>>
>>> TS_COMPAT says that, say, the task did "int 80" to enters the kernel.
>>> 64-bit or not, we should treat is as 32-bit in this case.
>>
>> I think you're right, and checking which entry was used is better than
>> checking the cs register (since 64-bit code can use int80).  That's
>> what I get for insufficiently careful reading of the assembly.  (And
>> for going from memory from when I wrote the vsyscall emulation code --
>> that code is entered from a page fault, so the entry point used is
>> irrelevant.)
>
> Wait: If a tasks is set to 64 bit mode, but calls into the kernel via
> int 0x80 it's changed to 32 bit mode for that system call and back to
> 64 bit mode when the system call is finished!?
>
> Our ptrace jailer is checking cs to figure out if a task is a compat task
> or not, if the kernel can change that behind our back it means our jailer
> isn't secure for x86_64 with compat enabled. Or is cs changed before the
> ptrace stuff and ptrace sees the "right" cs value? If not, we have to add
> an expensive PTRACE_PEEKTEXT to check if it's an int 0x80 or not. Or is
> there another way?

I don't know what your ptrace jailer does.  But a task can switch
itself between 32-bit and 64-bit execution at will, and there's
nothing the kernel can do about it.  (That isn't quite true -- in
theory the kernel could fiddle with the GDT, but that would be
expensive and wouldn't work on Xen.)

That being said, is_compat_task is apparently a good indication of
whether the current *syscall* entry is a 64-bit syscall or a 32-bit
syscall.  Perhaps the function should be renamed to in_compat_syscall,
because that's what it does.

>
> I think this behaviour is so unexpected that it can only cause security
> problems in the long run. Is anyone counting on this? Where is this
> behaviour documented?

Nowhere, I think.

--Andy
