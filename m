Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2AYTou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:44:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2AYToq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:44:46 -0500
Date: Wed, 25 Jan 2012 20:36:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
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
        Roland McGrath <mcgrathr@chromium.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120125193635.GA30311@redhat.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl> <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk> <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl> <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com> <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Linus Torvalds wrote:
>
> Using the high bits of 'eflags' might work.

I thought about changing eflags too, this looks very natural to me.

But I do not understand the result of this discussion, are you going
to apply this change?

If not...

Not sure this is really better, but there is another idea. Currently we
have PTRACE_O_TRACESYSGOOD to avoid the confusion with the real SIGTRAP.
Perhaps we can add PTRACE_O_TRACESYS_VERY_GOOD (or we can look at
PT_SEIZED instead) and report TS_COMPAT via ptrace_report_syscall ?

IOW. Currently ptrace_report_syscall() does

	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));

We can add the new events,

	PTRACE_EVENT_SYSCALL_ENTRY
	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
	PTRACE_EVENT_SYSCALL_EXIT
	PTRACE_EVENT_SYSCALL_COMPAT_EXIT

and change ptrace_report_syscall() to do

	if (PT_SEIZED) /* or PT_TRACESYS_VERY_GOOD? */ {
		int event = entry ? PTRACE_EVENT_SYSCALL_ENTRY : EXIT;
		if (is_compat_task(current))
			event++;
		ptrace_notify((event << 8) | SIGTRAP);
	} else {
		ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
	}

This also allows to distinguish entry/exit.


However. The change in get_flags() also allows to know the state of
TIF_IA32 bit bit outside of syscall entry/exit reports, perhaps there
is a reason why do we want this?

Oleg.

