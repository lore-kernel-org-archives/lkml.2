Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2AZBKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:10:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34416 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2AZBKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:10:00 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Thu, 26 Jan 2012 02:09:54 +0100
User-Agent: KMail/1.8.2
Cc: "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Will Drewry" <wad@chromium.org>,
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
        "Roland McGrath" <mcgrathr@chromium.org>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <201201260032.57937.vda.linux@googlemail.com> <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
In-Reply-To: <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201260209.54513.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 January 2012 01:40, Indan Zupancic wrote:
> >> We can add the new events,
> >>
> >> 	PTRACE_EVENT_SYSCALL_ENTRY
> >> 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
> >> 	PTRACE_EVENT_SYSCALL_EXIT
> >> 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT
> >
> > We can get away with just the first one.
> > (1) It's unlikely people would want to get native sysentry events but not compat ones,
> > thus first two options can be combined into one;
> 
> True.
> 
> > (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> > (3) if we would flag syscall entry with an event value in wait status, then syscall
> > exit will be already distinquisable.
> 
> False for execve which messes everything up by changing TID sometimes.

Dealt with in Linus tree already: set PTRACE_O_TRACEEXEC option,
and use PTRACE_GETEVENTMSG in PTRACE_EVENT_EXEC stop to get
the old TID.


> > To future-proof this scheme we may reserve a few more event values
> > PTRACE_EVENT_SYSCALL_ENTRY2, PTRACE_EVENT_SYSCALL_ENTRY3, etc,
> > if we'll ever have arches with more than one non-native syscall
> > entry. I'm no expert, but looking at strace code, ARM may already have
> > more than one additional convention how to pass syscall args.
> 
> Please, no! This way lays madness, just one PTRACE_EVENT_SYSCALL_ENTRY,
> no PTRACE_EVENT_SYSCALL_ENTRY1 or PTRACE_EVENT_SYSCALL_ENTRY2, that
> would be horrible. Keep arch specific stuff in arch specific areas,
> please don't spread it around.

The situation when an architecture has 32- and 64-bit varieties,
and sometimes different ABIs (parameter passing comventions),
is rather typical, it's not a quirk of just one unfortunate
architecture.

Please look at strace source, get_scno() function, where
it reads syscall no and parameters. Let's see....
- POWERPC: has 32-bit and 64-bit mode
- X86_64: has 32-bit and 64-bit mode
- IA64: has i386-compat mode
- ARM: has more than one ABI
- SPARC: has 32-bit and 64-bit mode

Do you want to re-invent a different arch-specific way to report
syscall type for each of these arches?


> What was wrong with using eflags again? Is it too simple or something?

It's x86-specific, and abuses a bit in a real register.

-- 
vda
