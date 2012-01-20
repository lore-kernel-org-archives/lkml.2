Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2ATAVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:21:50 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:55620 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2ATAVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:21:46 -0500
Message-ID: <930b350b8504fa9e1272f93bf21dde49.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120119160429.GO7180@jl-vm1.vm.bytemark.co.uk>
References: <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <CA+55aFyVTh4SQjjcf3x9BSzULttNVcmG9FyaKzhok=2_804xWA@mail.gmail.com>
    <20120118023114.GA9643@alboin.amr.corp.intel.com>
    <CA+55aFyEde=PLkgsx+FECRrX-dSsOSQkeY_by5=+hnkQhj5hFw@mail.gmail.com>
    <mj+md-20120118.134958.22774.nikam@ucw.cz>
    <20120118182411.GT11715@one.firstfloor.org>
    <20120119160429.GO7180@jl-vm1.vm.bytemark.co.uk>
Date: Fri, 20 Jan 2012 01:21:14 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: "Indan Zupancic" <indan@nul.nu>
To: "Jamie Lokier" <jamie@shareable.org>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Martin Mares" <mj@ucw.cz>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <ak@linux.intel.com>, "Andrew Lutomirski" <luto@mit.edu>,
        "Oleg Nesterov" <oleg@redhat.com>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, eric.dumazet@gmail.com, gregkh@suse.de,
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
X-Scan-Signature: e462de357cb394d64966911c06262bc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 19, 2012 17:04, Jamie Lokier wrote:
> Andi Kleen wrote:
>> > Not everybody. There are programs which try hard to distinguish between
>> > int80 and syscall. One such example is a sandbox for programming contests
>> > I wrote several years ago. It analyses the instruction before EIP and as
>> > it does not allow threads nor executing writeable memory, it should be
>> > correct.
>>
>> There are other ways to break it, like using the syscall itself to change
>> input arguments or using ptrace from another process and other ways.
>>
>> Generally there are so many races with ptrace that if you want to do
>> things like that it's better to use a LSM. That's what they are for.
>
> I could see the LSM approach working *if* there was an LSM module to
> make it available to unpriviledged userspace.  I.e. a replacement for
> ptrace() for this purpose.
>
> It would be nice to be able to trace and check syscall strings properly.

With current ptrace you can do exactly that. It's just very slow, because
you have to copy the data word by word via PTRACE_PEEKDATA. But if Linux
would support something like BSD's PT_IO ptrace request, then it could be
limited to one extra ptrace command. (PTRACE_STRNCPY would be handy.)

After the check we memcpy the data to a shared read-only mapping, but
that's very quick. We could read the data directly into the RO area,
but as we're mostly dealing with path strings it seemed more efficient
to allocate the needed memory instead of the max every time.

No matter how you make it available to userspace via some LSM, you will
end up with the same context switch overhead ptrace suffers, so I don't
see how a LSM module would give either more options or make it much faster
compared to ptrace.

Greetings,

Indan


