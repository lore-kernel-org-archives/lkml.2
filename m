Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2AUAHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:07:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60274 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2AUAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:07:44 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Sat, 21 Jan 2012 01:07:37 +0100
User-Agent: KMail/1.8.2
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Roland McGrath" <mcgrathr@google.com>,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
References: <20120116183730.GB21112@redhat.com> <4F19EDAF.2000109@zytor.com> <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl>
In-Reply-To: <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201210107.37250.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 January 2012 00:49, Indan Zupancic wrote:
> On Fri, January 20, 2012 23:41, H. Peter Anvin wrote:
> > On 01/20/2012 02:40 PM, Roland McGrath wrote:
> >> If you change the size of a regset, then the new full size will be the size
> >> of the core file notes.  Existing userland tools will not be expecting
> >> this, they expect a known exact size.  If you need to add new stuff, it
> >> really is easier all around to add a new regset flavor.  When adding a new
> >> one, you can make it variable-sized from the start so as to be extensible
> >> in the future.  We did this for NT_X86_XSTATE, for example.
> >>
> >
> > Yes, that definitely seems cleaner.
> 
> I would prefer Linus' way of just stuffing it into cs. Jamie also wanted
> a bit telling in what mode the userspace is running. That's 3 bits in total,
> with one bit telling whether the other bits are valid or not. Anything else?

There is actually a bunch of ptrace-specific stuff we want to return.

For example, Oleg wants to be able to print *which syscall*,
(along with its arguments if possible) is restarted when
we restart the ERESTART_RESTARTBLOCK-returning syscall.
Which happens every time strace attaches to a process sleeping
in nanosleep or poll, for example. We get just

$ strace -p 1234
Process 1234 attached - interrupt to quit
restart_syscall(<... resuming interrupted call ...>_

and that's it.

Returning syscall and its parameters require several words,
not a few bits.

> Maybe a bit telling whether it is syscall entry or exit?

Yes, this one too. This is one of longstanding annoyances
that this information is not exposed.

> As all this is very x86_64 specific and cs is already used to figure out
> the mode, it seems overkill to add a new regset just for this.
> 
> It's a lot easier for existing code to add an extra cs check than to use
> different register sets and different ptrace commands.

You don't understand. Returning new bits in cs will break *existing*
programs. This is generally a bad thing. For example, old strace binaries
on new kernel will complain:

        switch (x86_64_regs.cs) {
                case 0x23: currpers = 1; break;
                case 0x33: currpers = 0; break;
                default:
                        fprintf(stderr, "Unknown value CS=0x%08X while "
                                 "detecting personality of process "
                                 "PID=%d\n", (int)x86_64_regs.cs, tcp->pid);
                        currpers = current_personality;
                        break;
        }

when they'll see unfamiliar x86_64_regs.cs value.

-- 
vda
