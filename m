Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2AZI0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 03:26:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2AZI0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 03:26:10 -0500
Message-ID: <4F210D9B.3030808@redhat.com>
Date: Thu, 26 Jan 2012 08:23:55 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <20120125193635.GA30311@redhat.com> <201201260032.57937.vda.linux@googlemail.com> <20120126005901.GC18613@jl-vm1.vm.bytemark.co.uk>
In-Reply-To: <20120126005901.GC18613@jl-vm1.vm.bytemark.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 12:59 AM, Jamie Lokier wrote:
> Tracers mainly want to know if it's a 32-bit or 64-bit syscall, not
> whether it's compat as such.

Another idea, avoiding new PTRACE_EVENTs per arch, would be to make
the abi32/abi64/compat/whatnot discriminator retrievable with PTRACE_GETEVENTMSG
instead.  So you'd get PTRACE_EVENT_SYSCALL_ENTRY|EXIT, or the regular old
0x80|SIGTRAP, you'd still fetch the syscall number from $orig_ax (or whatever means
for other archs), as usual, then have extra syscall info in PTRACE_GETEVENTMSG.
I don't know if it'd be simple to make it possible to do PTRACE_GETEVENTMSG
on a 0x80|SIGTRAP trap, but I imagine it so.

-> wait
  <- 0x80|SIGTRAP   (or PTRACE_EVENT_SYSCALL_ENTRY)
-> read regs, find out syscall number
-> PTRACE_GETEVENTMSG, figure out which entry mode was used.

-- 
Pedro Alves
