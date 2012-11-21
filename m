Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2KUOQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:16:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab2KUOQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:16:09 -0500
Date: Wed, 21 Nov 2012 15:16:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: u3557@miso.sublimeip.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121121141627.GB21030@redhat.com>
References: <20121109182943.GA2789@redhat.com> <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com> <1353349500.6276.9.camel@gandalf.local.home> <20121120154824.GA17534@redhat.com> <20121120183243.GA31290@redhat.com> <3501c254c970c4dbd933022651622f79.squirrel@mail.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3501c254c970c4dbd933022651622f79.squirrel@mail.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amnon,

Please read my previous email ;)
http://marc.info/?l=linux-kernel&m=135342649119153

On 11/21, u3557@miso.sublimeip.com wrote:
>
> Hi Oleg,
>
> > Or. Perhaps we can define TRAP_VSYSCALL and change emulate_vsyscall() to
> > do
> >
> >
> > 	if (current->ptrace && test_thread_flag(TIF_SYSCALL_TRACE))
> > 		send_sigtrap(TRAP_VSYSCALL, ...);
> >
> > if it returns true?
> >
>
> I wish it were possible, but the vsyscall page is entered in user-mode,

Only in NATIVE mode. emulate_vsyscall() runs in kernel mode.

And in the NATIVE mode PTRACE_SYSCALL should work just fine, because:

> The vsyscall page was designed in order to avoid user/kernel context
> switches,

True, it was. But not today. Please look at __vsyscall_page:

	__vsyscall_page:

		mov $__NR_gettimeofday, %rax
		syscall
		ret

If you want the "fast" sys_time() without entering the kernel, you can
use __vdso_time(). And since vdso has the user-space mapping you can
insert "int3" or use hw breakpoints.

At least this is my understanding after I glanced at the new implementation.


However. It is not that I think that TRAP_VSYSCALL is really good idea.
At least it needs another option...

Oleg.

