Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2ARNMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:12:49 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:57503 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2ARNMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:12:47 -0500
Message-ID: <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
In-Reply-To: <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com>
    <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
    <20120117164523.GA17070@redhat.com>
    <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
Date: Wed, 18 Jan 2012 14:12:34 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Jamie Lokier" <jamie@shareable.org>,
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
X-Scan-Signature: 6c56b5a68734eff3bb82063186e8a5cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, January 18, 2012 07:25, Linus Torvalds wrote:
> On Tue, Jan 17, 2012 at 9:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> 	- in that page, do this:
>>
>> 			lea 1f,%edx
>> 			movl $SYSCALL,%eax
>> 			movl $-1,4096(%edx)
>> 	1:
>> 			int 0x80
>>
>> and what happens is that the move that *overwrites* the int 0x80 will
>> not be noticed by the I$ coherency because it's at another address,
>> but by the time you read at $pc-2, you'll get -1, not "int 0x80"

Oh jolly. I feared something like that might have been possible.

> Btw, that's I$ coherency comment is not technically the correct explanation.
>
> The I$ coherency isn't the problem, the problem is that the pipeline
> has already fetched the "int 0x80" before the write happens. And the
> write - because it's not to the same linear address as the code fetch
> - won't trigger the internal "pipeline flush on write to code stream".
> So the D$ (and I$) will have the -1 in it, but the instruction fetch
> will have walked ahead and seen the "int 80" that existed earlier, and
> will execute it.
>
> And the above depends very much on uarch details, so depending on
> microarchitecture it may or may not work. But I think the "use a
> different virtual address, but same physical address" thing will fake
> out all modern x86 cpu's, and your 'ptrace' will see the -1, even
> though the system call happened.
>
> Anyway, the *kernel* knows, since the kernel will have seen which
> entrypoint it comes through. So we can handle it in the kernel. But
> no, you cannot currently securely/reliably use $pc-2 in gdb or ptrace
> to determine how the system call was made, afaik.

So there is this gap and there is no good way to handle it at all for
user space? And even if it's fixed in the kernel, that won't help with
older kernels, so it will stay a problem for a while.

Can this int 0x80 trick be blocked for ptraced task (preferably always),
pretty please?

> Of course, limiting things so that you cannot map the same page
> executably *and* writably is one solution - and a good idea regardless
> - so secure environments can still exist.

We got the infrastructure in place to do that, though it would be a hassle.
But browsing around in /proc/$PID/maps, it seems w+x mappings are very
common, and we want to jail normal programs, so that seems a bit of a
problem. We could disallow system calls coming from such double mapped
memory, instead of disallowing such mappings altogether.

We'd either need to keep track of all mappings or scan /proc/$PID/maps.
Because that is a pain, we need to cache the results and invalidate or
update the cache after each new writeable mapping.

Doable, but starting to look silly and fragile.

I suppose restarting the system call would avoid same-task tricks,
but doesn't solve the other-task-having-a-writeable-mapping problem.

> But even then you could have
> races in a multi-threaded environment (they'd just be *much* harder to
> trigger for an attacker).

All hostile threads are either jailed or running as a different user,
so at least the mapping checks can be done race-free. Syscall from
unknown mappings can be disallowed.

I hope there is a really dirty trick that works reliable to find a very
subtle difference between system call entered via 'syscall' or 'int 0x80'.

At this point it starts to look attractive to only allow system calls
coming from vdso and protecting the vdso mapping (or is that done by
the kernel already?) System calls coming from elsewhere can be
restarted at the vdso (need to fix up EIP post-syscall then too.)
All in all something like this seems the simplest and most practical
solution to me.

Anyone got any better idea?

Greetings,

Indan


