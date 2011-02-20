Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1BTTKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:10:42 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:49071 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab1BTTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:10:41 -0500
Date: Sun, 20 Feb 2011 20:10:26 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: torvalds@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110220191026.GA16288@host1.dyn.jankratochvil.net>
References: <20110220094050.GA7714@host1.dyn.jankratochvil.net>
 <201102201806.30273.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102201806.30273.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 18:06:30 +0100, Denys Vlasenko wrote:
> On Sunday 20 February 2011 10:40, Jan Kratochvil wrote:
> > Sure by default GDB does not do anything special, it will respawn (using
> > PTRACE_CONT(SIGSTOP)) any SIGSTOP it sees due to the default setting of:
> > 	(gdb) handle SIGSTOP
> > 	Signal        Stop  Print Pass to program Description
> > 	SIGSTOP       Yes Yes Yes   Stopped (signal)
> > 
> > Therefore there happens the double SIGSTOP reporting as discussed before:
> > 	(gdb) run
> > 	Starting program: /bin/sleep 1h
> > 	# external kill -STOP <inferior pid>
> > 	Program received signal SIGSTOP, Stopped (signal).
> > 	# State:	t (tracing stop)
> > 	(gdb) continue 
> > 	Continuing.
> > 	Program received signal SIGSTOP, Stopped (signal).
> > 	# State:	t (tracing stop)
> > 	(gdb) continue 
> > 	Continuing.
> > 	# State:	S (sleeping)
> > 
> > Your proposal is I expect:
> > 	(gdb) run
> > 	Starting program: /bin/sleep 1h
> > 	# external kill -STOP <inferior pid>
> > 	Program received signal SIGSTOP, Stopped (signal).
> > 	# State:	t (tracing stop)
> > 	(gdb) continue 
> > 	Continuing.
> > 	# State:	T (stopped)
> 
> Not exactly. Even after we fix kernel so that it properly preserves
> group-stop across ptrace-stops, gdb will still see TWO 
> waitpid:SIGSTOP events, not one.
> 
> First one says "the tracee has received SIGSTOP", and after PTRACE_CONT(SIGSTOP),
> second one says "the tracee has stopped because of SIGSTOP".
> Currently, neither strace nor gdb understands that second one
> is different from first.

I thought the kernel change being discussed should be the second SIGSTOP will
receive the process's original parent, so that CTRL-Z on a debugged process
from shell works the normal way, as without a debugger.


Thanks,
Jan
