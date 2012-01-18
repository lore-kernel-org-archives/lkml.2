Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2ARBrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:47:24 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:35624 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2ARBrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:47:20 -0500
Message-ID: <9cadce30fd4f1ea67fdcdebfeb7f91b8.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAB=4xhr1rBaHavhTX-zcofNqwP8XMYe1UacvuW+YykUpQCVSSw@mail.gmail.com>
References: <20120112172315.GA26295@redhat.com>
    <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
    <20120113173153.GA24273@redhat.com>
    <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
    <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
    <20120116183730.GB21112@redhat.com>
    <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
    <20120117164523.GA17070@redhat.com>
    <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <CAB=4xhr1rBaHavhTX-zcofNqwP8XMYe1UacvuW+YykUpQCVSSw@mail.gmail.com>
Date: Wed, 18 Jan 2012 02:47:04 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: "Indan Zupancic" <indan@nul.nu>
To: "Roland McGrath" <mcgrathr@google.com>
Cc: "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        "Andi Kleen" <andi@firstfloor.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: bc82d6a2e188773012c482ed32290af0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, January 18, 2012 02:07, Roland McGrath wrote:
> On Tue, Jan 17, 2012 at 4:56 PM, Indan Zupancic <indan@nul.nu> wrote:
>> Wait: If a tasks is set to 64 bit mode, but calls into the kernel via
>> int 0x80 it's changed to 32 bit mode for that system call and back to
>> 64 bit mode when the system call is finished!?
>
> Well, saying it like that suggests that there is more of a "mode change"
> than really exists.  It's simply that any task can use int $0x80 and
> this always means using the 32-bit syscall table with TS_COMPAT set.

True, the kernel always runs in 64-bit mode, it just selects which path
is taken.

>> Our ptrace jailer is checking cs to figure out if a task is a compat task
>> or not, if the kernel can change that behind our back it means our jailer
>> isn't secure for x86_64 with compat enabled. Or is cs changed before the
>> ptrace stuff and ptrace sees the "right" cs value? If not, we have to add
>> an expensive PTRACE_PEEKTEXT to check if it's an int 0x80 or not. Or is
>> there another way?
>
> I don't think there's another way.  hpa and I once discussed adding a field
> to the extractable "register state" that would say which method the syscall
> in progress had taken to enter the kernel.  That would tell you which
> flavor of syscall instruction was used (or none, i.e. a trap/interrupt).
> But nobody ever had a real need for it, and we didn't pursue it further.
> (We originally talked about it in the context of distinguishing whether a
> 32-bit task had used sysenter or syscall or int $0x80, I think.)

Argh. So strace and all other ptrace users will think the task is calling a
different system call than it executes, except if they check for int 0x80,
which I bet they don't.

I suppose I could cache the checked EIP-2's results, but then I also have to
check if the memory is read-only and invalide the cache when the mapping may
be changed. Probably not worth the complexity.

>> I think this behaviour is so unexpected that it can only cause security
>> problems in the long run. Is anyone counting on this? Where is this
>> behaviour documented?
>
> It's documented the same place the entire Linux machine-level ABI is
> documented, which is nowhere.

AMD wrote the "System V Application Binary Interface" which decribes
some Linux conventions. It's better than nothing. But it just mentions
'syscall', not what happens when int 0x80 is called anyway.

> Someone somewhere may once have been
> counting on it.  (The story I heard was about an implementation of valgrind
> for 32-bit code that ran in 64-bit tasks, but I don't know for sure that it
> was really done.)  The general rule is that if it ever worked before in a
> coherent way, we don't break binary compatibility.

Well, considering the code can't be sure if the kernel supports compat mode
at all, I think this case is getting even more obscure than it already is.
Disallowing it won't change the kernel behaviour compared to a kernel with
compat disabled.

What about disallowing this path when the task is being ptraced?

> In the implementation, it would require a special check to make it barf.
> It's really just something that falls out of how the hardware and the
> kernel implementation works.  I suppose you could add such a check under a
> new kconfig option that's marked as being potentially incompatible with
> some old applications.  Good luck with that.

That seems a hopeless path to follow, and won't solve my problem because
my code has to be able to run on all kernels. Half the point of using
ptrace for jailing was that it's mostly portable with no special kernel
support.

Greetings,

Indan


