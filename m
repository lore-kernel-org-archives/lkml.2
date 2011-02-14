Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1BNLkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:40:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1BNLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=P+mfR+9Kb8ILHfh3SdSBf+6NdP+ZHmunSzp9TnEWHjpZBZGnGK/kscI4PKrKK5O+oC
         LSjtDFHbyZrasMI6DtkyPChoGtcwYD97te8itOtJtglachcu/sVP6c8RkcamrlaQG1QO
         El0/hVYwpe/gRP0OT9oRKnT7gpUx8MVtvkfnY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Mon, 14 Feb 2011 12:39:53 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <20110204130455.GA3671@redhat.com> <201102140001.47218.vda.linux@googlemail.com> <20110214090356.GA21979@host1.dyn.jankratochvil.net>
In-Reply-To: <20110214090356.GA21979@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102141239.53893.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 February 2011 10:03, Jan Kratochvil wrote:
> On Mon, 14 Feb 2011 00:01:47 +0100, Denys Vlasenko wrote:
> > * sleep runs in nanosleep
> > * SIGSTOP arrives, strace sees it
> > * strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
> > * sleep process enters group-stop
> 
> The last point breaks the documented behavior of ptrace:
> 	If data is nonzero and not SIGSTOP, it is interpreted as a signal to
> 	be delivered to the child; otherwise, no signal is delivered.

But SIGSTOP _is_ delivered - that's why sleep process stops.

> I do not see it would affect gdb.  strace will change its behavior when
> SIGSTOP is sent to its tracee although the new behavior may be OK.
> 
> It is more a subject of apps compatibility testing with such a kernel change.
> 
> 
> > * nothing happens until some other signal arrives
> > * say, SIGCONT arrives
> 
> What if other signal arrives?  The tracer probably should not be notified as
> the tracee is in a group-stop.

The behavior here ideally should be the same as for non-traced process:
the signals are remembered while process is stopped, and it sees them
only after SIGCONT, as demonstrated by the following program

#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
static void sig(int n)
{
        char buf[128];
        int e = errno;
        sprintf(buf, "sig: %d %s\n", n, strsignal(n));
        write(1, buf, strlen(buf));
        errno = e;
}
int main()
{
        signal(SIGSTOP, sig);
        signal(SIGCONT, sig);
        signal(SIGWINCH, sig);
        signal(SIGABRT, sig);
 again:
        printf("PID: %d\n", getpid());
        fflush(NULL);
        errno = 0;
        sleep(30);
        int e = errno;
        printf("after sleep: errno=%d %s\n", e, strerror(e));
        if (e) goto again;
        return 0;
}

# ./a.out
PID: 16382
  <------ kill -STOP 16382
  <------ kill -ABRT 16382
  <------ kill -WINCH 16382
  <------ kill -CONT 16382
sig: 28 Window changed
sig: 18 Continued
sig: 6 Aborted
after sleep: errno=4 Interrupted system call
PID: 16382


I believe it would be best if debugger sees signals immediately,
but when it does ptrace(PTRACE_CONT/SYSCALL, ..., <sig>)
in order to send signals to group-stopped tracee, they are queued
to it without terminating group-stop. When SIGCONT arrives,
ptrace(PTRACE_CONT/SYSCALL, ..., SIGCONT) terminates group-stop
and causes all queued signals to be handled (in random order,
not necessarily in the order of arrival. Even CONT handler is
not guaranteed to be called first, as you see above).
 
-- 
vda
