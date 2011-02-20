Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1BTV2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab1BTV2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:28:20 -0500
Date: Sun, 20 Feb 2011 22:19:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: `(T) stopped' preservation after _exit()  [Re: [PATCH 1/1]
	ptrace: make sure do_wait() won't hang after PTRACE_ATTACH]
Message-ID: <20110220211913.GA5488@redhat.com>
References: <20110219201603.GB8662@redhat.com> <20110219200637.GA8662@redhat.com> <20110220094050.GA7714@host1.dyn.jankratochvil.net> <20110220171658.GA27355@redhat.com> <20110220185204.GA14737@host1.dyn.jankratochvil.net> <20110220203819.GB32682@redhat.com> <20110220210608.GA23222@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220210608.GA23222@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Jan Kratochvil wrote:
>
> On Sun, 20 Feb 2011 21:38:19 +0100, Oleg Nesterov wrote:
> >
> > This doesn't explain why the kernel should restore TASK_STOPPED.
> > Suppose the tracee creates the file when it was run under debugger,
> > should the kernel remove this file after detach?
>
> No, opening such file is like writing data into a file.

OK, let it be writing data into a file. But in this case the kernel
shouldn't truncate the file after detach or if the tracer crashes ;)

> > And, if SIGCONT comes in between, the tracee is no longer stopped. It needs
> > another SIGSTOP, gdb can do this via ptrace(DETACH, SIGSTOP).
>
> It cannot if it crashes in between.

Yes,

> It would be OK if it can do so right
> after the inferior call.  Which I realize now it can, after the inferior call
> returns (wait->SIGTRAP) GDB can do PTRACE_CONT(SIGSTOP), wait->SIGSTOP and now
> it can do PTRACE_GETREGS etc. while after _exit() it will be like after
> PTRACE_DETACH(0) and the debuggee still remains `(T) stopped', doesn't it?

Yes. Or gdb can just send SIGSTOP to the tracee.

Modulo other bugs we have, but these bugs should be fixed anyway.

For example, once again, PTRACE_DETACH/PTRACE_CONT can ignore SIGXXX.
I never knew if it was designed this way or this should be fixed, but
there is one particular case which looks like the oversight to me: If
the tracee reports SIGTRAP after it steps into the signal handler, then
SIGXXX is ignored after PTRACE_CONT/DETACH (and this btw affects gdb).

Oleg.

