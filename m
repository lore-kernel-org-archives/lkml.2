Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1HJRmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab1HJRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:42:39 -0400
Date: Wed, 10 Aug 2011 19:39:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: samir baid <samirbaid@gmail.com>
Cc: tj@kernel.org, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: Question regarding ptrace
Message-ID: <20110810173953.GB19981@redhat.com>
References: <CAPoVYDc85W3qM_7vLwuMqP88epGgpvu4oBG5RiaRUKLWB-y6mA@mail.gmail.com> <20110810120042.GA3500@redhat.com> <CAPoVYDd1YfenMmdT6TS5-F1EXuJnkAh6sKbo4iFGjj7Q6ZDmWw@mail.gmail.com> <20110810172250.GA19099@redhat.com> <20110810173851.GA19981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810173851.GA19981@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed we discuss this offlist.

We hate the private discussions ;) lets add lkml. Perhaps you
found a kernel bug...

On 08/10, Oleg Nesterov wrote:
>
> On 08/10, samir baid wrote:
> >
> > Here is a
> > brief description of the code -
> 
> Oops. it is not that brief ;) I simply do not understand it, may be you
> can show the code... But please try to simplify it as much as possible
> to remove the unnecessary details,
> 
> > Running the above programs -
> >  1. Ran Tracee.
> >  2. Ran Tracer with the PID.
> >  3. Ran command - kill -s 30 <tracee pid>
> >
> > My understanding was, after i did step 3 above, tracer should get a signal
> > stop with signal 30. And then i perform a signal injection to tracee. What i
> > wanted to acheive was, once injected the signal to the tracee i wanted to
> > single step it at the instruction level.
> 
> This should work, the tracee should enter the handler. For example, see
> the test-case below.
> 
> Oleg.
> 
> #include <stdio.h>
> #include <unistd.h>
> #include <signal.h>
> #include <sys/ptrace.h>
> #include <sys/wait.h>
> #include <sys/user.h>
> #include <stddef.h>
> #include <assert.h>
> 
> void sigh(int sig)
> {
> }
> 
> void *getip(int pid)
> {
> 	return (void*)ptrace(PTRACE_PEEKUSER, pid,
> 			offsetof(struct user, regs.rip), 0);
> }
> 
> int main(void)
> {
> 	int pid;
> 
> 	signal(30, sigh);
> 
> 	pid = fork();
> 	if (!pid) {
> 		assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
> 
> 		kill(getpid(), SIGSTOP);
> 
> 		return 0;
> 	}
> 
> 	assert(wait(NULL) == pid);
> 
> 	assert(ptrace(PTRACE_SINGLESTEP, pid, 0, 30) == 0);
> 	assert(wait(NULL) == pid);
> 
> 	assert(sigh == getip(pid));
> 
> 	kill(SIGKILL, pid);
> 	return 0;
> }

