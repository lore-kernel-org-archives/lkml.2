Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2ARGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 01:25:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39280 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2ARGZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 01:25:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jan 2012 22:25:32 -0800
X-Google-Sender-Auth: iRFzZllJtx6xckR3xV0k7jPr1-4
Message-ID: <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
To: Indan Zupancic <indan@nul.nu>
Cc: Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
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
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - in that page, do this:
>
>      lea 1f,%edx
>      movl $SYSCALL,%eax
>      movl $-1,4096(%edx)
>  1:
>      int 0x80
>
> and what happens is that the move that *overwrites* the int 0x80 will
> not be noticed by the I$ coherency because it's at another address,
> but by the time you read at $pc-2, you'll get -1, not "int 0x80"

Btw, that's I$ coherency comment is not technically the correct explanation.

The I$ coherency isn't the problem, the problem is that the pipeline
has already fetched the "int 0x80" before the write happens. And the
write - because it's not to the same linear address as the code fetch
- won't trigger the internal "pipeline flush on write to code stream".
So the D$ (and I$) will have the -1 in it, but the instruction fetch
will have walked ahead and seen the "int 80" that existed earlier, and
will execute it.

And the above depends very much on uarch details, so depending on
microarchitecture it may or may not work. But I think the "use a
different virtual address, but same physical address" thing will fake
out all modern x86 cpu's, and your 'ptrace' will see the -1, even
though the system call happened.

Anyway, the *kernel* knows, since the kernel will have seen which
entrypoint it comes through. So we can handle it in the kernel. But
no, you cannot currently securely/reliably use $pc-2 in gdb or ptrace
to determine how the system call was made, afaik.

Of course, limiting things so that you cannot map the same page
executably *and* writably is one solution - and a good idea regardless
- so secure environments can still exist. But even then you could have
races in a multi-threaded environment (they'd just be *much* harder to
trigger for an attacker).

                 Linus
