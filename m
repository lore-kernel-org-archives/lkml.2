Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2AYXdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:33:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54518 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2AYXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:33:05 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Thu, 26 Jan 2012 00:32:57 +0100
User-Agent: KMail/1.8.2
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
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
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <20120125193635.GA30311@redhat.com>
In-Reply-To: <20120125193635.GA30311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201260032.57937.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 20:36, Oleg Nesterov wrote:
> On 01/18, Linus Torvalds wrote:
> >
> > Using the high bits of 'eflags' might work.
> 
> I thought about changing eflags too, this looks very natural to me.
> 
> But I do not understand the result of this discussion, are you going
> to apply this change?
> 
> If not...
> 
> Not sure this is really better, but there is another idea. Currently we
> have PTRACE_O_TRACESYSGOOD to avoid the confusion with the real SIGTRAP.
> Perhaps we can add PTRACE_O_TRACESYS_VERY_GOOD (or we can look at
> PT_SEIZED instead) and report TS_COMPAT via ptrace_report_syscall ?
> 
> IOW. Currently ptrace_report_syscall() does
> 
> 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
> 
> We can add the new events,
> 
> 	PTRACE_EVENT_SYSCALL_ENTRY
> 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
> 	PTRACE_EVENT_SYSCALL_EXIT
> 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT

We can get away with just the first one.
(1) It's unlikely people would want to get native sysentry events but not compat ones,
thus first two options can be combined into one;
(2) syscall exit compat-ness is known from entry type - no need to indicate it; and
(3) if we would flag syscall entry with an event value in wait status, then syscall
exit will be already distinquisable.

Thus, minimally we need one new option, PTRACE_O_TRACE_SYSENTRY -
"on syscall entry ptrace stop, set a nonzero event value in wait status"
, and two event values: PTRACE_EVENT_SYSCALL_ENTRY (for native entry),
PTRACE_EVENT_SYSCALL_ENTRY1 for compat one.

To future-proof this scheme we may reserve a few more event values
PTRACE_EVENT_SYSCALL_ENTRY2, PTRACE_EVENT_SYSCALL_ENTRY3, etc,
if we'll ever have arches with more than one non-native syscall
entry. I'm no expert, but looking at strace code, ARM may already have
more than one additional convention how to pass syscall args.


-- 
vda
