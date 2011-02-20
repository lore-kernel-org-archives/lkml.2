Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1BTR4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:56:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1BTR4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:56:45 -0500
Date: Sun, 20 Feb 2011 18:48:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>, torvalds@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110220174827.GA28509@redhat.com>
References: <20110220094050.GA7714@host1.dyn.jankratochvil.net> <201102201806.30273.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102201806.30273.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Denys Vlasenko wrote:
>
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

Yes, I didn't notice the second report doesn't show SIGSTOP twice.
The only important change is

	(gdb) continue
	Continuing.
-	# State:        S (sleeping)
+	# State:        T (stopped)


> I think you can use similar trick in gdb, so that second message says
> "Program stopped due to signal SIGSTOP, Stopped (signal)",
> not "Program received signal SIGSTOP, Stopped (signal)".

Agreed.

Oleg.

