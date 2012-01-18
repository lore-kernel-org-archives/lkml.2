Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2ARBsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:48:55 -0500
Received: from mail2.shareable.org ([80.68.89.115]:45533 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2ARBsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:48:52 -0500
Date: Wed, 18 Jan 2012 01:48:09 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120118014809.GK7180@jl-vm1.vm.bytemark.co.uk>
References: <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
 <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
 <20120116183730.GB21112@redhat.com>
 <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com>
 <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com>
 <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Tue, January 17, 2012 18:45, Andrew Lutomirski wrote:
> > On Tue, Jan 17, 2012 at 9:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> On 01/17, Andrew Lutomirski wrote:
> >>>
> >>> (is_compat_task says whether the executable was marked as 32-bit. �The
> >>> actual execution mode is determined by the cs register, which the user
> >>> can control.
> >>
> >> Confused... Afaics, TIF_IA32 says that the binary is 32-bit (this comes
> >> along with TS_COMPAT).
> >>
> >> TS_COMPAT says that, say, the task did "int 80" to enters the kernel.
> >> 64-bit or not, we should treat is as 32-bit in this case.
> >
> > I think you're right, and checking which entry was used is better than
> > checking the cs register (since 64-bit code can use int80).  That's
> > what I get for insufficiently careful reading of the assembly.  (And
> > for going from memory from when I wrote the vsyscall emulation code --
> > that code is entered from a page fault, so the entry point used is
> > irrelevant.)
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

PTRACE_PEEKTEXT won't securely tell you if it's int 0x80 if there's
another thread modifying the code, or changing the mappings, or it's
executing from a file or shared memory that someone's writing to.

> I think this behaviour is so unexpected that it can only cause security
> problems in the long run. Is anyone counting on this? Where is this
> behaviour documented?

It's a surprise to me too.  And like you I'm using ptrace, to trace
what a process touches, not restrict it, but it's subject to the same problem.

This looks like it needs a kernel patch.

-- Jamie
