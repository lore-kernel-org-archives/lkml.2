Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2CaUpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab2CaUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:45:11 -0400
Date: Sat, 31 Mar 2012 22:45:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT
Message-ID: <20120331204501.GA18572@redhat.com>
References: <20120330183104.GA12927@redhat.com> <1333134131.23924.191.camel@gandalf.stny.rr.com> <20120330201550.GA16628@redhat.com> <1333152806.23924.196.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333152806.23924.196.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Steven Rostedt wrote:
>
> On Fri, 2012-03-30 at 22:15 +0200, Oleg Nesterov wrote:
>
> > But I don't really understand why do you think that "clear" is more
> > important.
>
> They are both important. But as I tend to consider performance when
> tracing is off as critical, I'm more concerned about that. But both must
> be fixed, because not reporting traces can confuse a developer.

Ah, got it, thanks.

I was going to send the simple patch we discussed, but suddenly I
realized that I have another question.

Why do we want to filter out the kernel threads in syscall_regfunc?

>From cc3b13c1 "tracing: Don't trace kernel thread syscalls"

	 then it has no effect to trace the kernel thread calls
	 to syscalls in that path.
	 Setting the TIF_SYSCALL_TRACEPOINT flag is then useless for these.

OK, but then it doesn't hurt? Or is there another reason why
TIF_SYSCALL_TRACEPOINT is not desirable on kthread?

The problem is ____call_usermodehelper() which execs the user-space
task. This clears PF_KTHREAD (sets ->mm), but obviously if
sys_tracepoint_refcount != 0 this is too late.

So what do you think we should do,

	- keep this check

	- remove it

	- remove it in a separate patch

	- add the "sync with sys_tracepoint_refcount" hook
	  before kernel_execve()

?

Oleg.

