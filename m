Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2ARFYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:24:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51540 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2ARFYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:24:15 -0500
MIME-Version: 1.0
In-Reply-To: <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
References: <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jan 2012 21:23:51 -0800
X-Google-Sender-Auth: 0czJO7k3jXT7pLYF_zPoA_npUbA
Message-ID: <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 8:22 PM, Indan Zupancic <indan@nul.nu> wrote:
>
> Looking at EIP - 2 seems like a secure way to check how we entered the kernel.

Secure? No. Not at all.

It's actually very easy to fool it. Do something like this:

 - map the same physical page executably at one address, and writably
4kB above it (use shared memory, and map it twice).

 - in that page, do this:

      lea 1f,%edx
      movl $SYSCALL,%eax
      movl $-1,4096(%edx)
  1:
      int 0x80

and what happens is that the move that *overwrites* the int 0x80 will
not be noticed by the I$ coherency because it's at another address,
but by the time you read at $pc-2, you'll get -1, not "int 0x80"

                  Linus
