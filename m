Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2KTScZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:32:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2KTScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:32:23 -0500
Date: Tue, 20 Nov 2012 19:32:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121120183243.GA31290@redhat.com>
References: <20121109182943.GA2789@redhat.com> <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com> <1353349500.6276.9.camel@gandalf.local.home> <20121120154824.GA17534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120154824.GA17534@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Oleg Nesterov wrote:
>
> On 11/19, Steven Rostedt wrote:
> >
> > Is this really what we want?
>
> I am not sure, that is why I am asking.

Yes.

And,

> Well yes, with the new implementation __vsyscall_page simply does
> syscall, so I guess (say) strace will "just work". But, afaics, only
> if vsyscall_mode == NATIVE.
>
> So perhaps bp in vsyscall_page still makes sense...

Or. Perhaps we can define TRAP_VSYSCALL and change emulate_vsyscall() to do


	if (current->ptrace && test_thread_flag(TIF_SYSCALL_TRACE))
		send_sigtrap(TRAP_VSYSCALL, ...);

if it returns true?

This way the debugger doesn't need to play with the debug registers,
it can use ptrace(PTRACE_SYSCALL). The tracee will report SIGTRAP after
vsyscall, debugger can detect this case looking at info->si_code.

Yes, the tracee won't report _before_ it calls the function, but perhaps
this is enough? Amnon?

Oleg.

