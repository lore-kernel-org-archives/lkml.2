Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1COVTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab1COVTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:19:11 -0400
Date: Tue, 15 Mar 2011 22:08:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Linux 2.6.38
Message-ID: <20110315210855.GI21640@redhat.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com> <20110314213331.24229139.akpm@linux-foundation.org> <alpine.DEB.2.00.1103142137020.13734@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103142137020.13734@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, David Rientjes wrote:
>
> He also presented a test case on linux-mm that caused the oom killer to 
> avoid acting if a thread is ptracing a thread in the exit path with 
> PTRACE_O_TRACEEXIT.  That should be fixed with
>
> 	http://marc.info/?l=linux-mm&m=129997893430351

I don't think it can fix this. I didn't verify this, but the slightly
different test-case below should have the same effect.

But this doesn't matter. We can fix this particular case, and we have
the problems with the coredump anyway.

What I can't understand is what exactly the first patch tries to fix.
When I ask you, you tell me that for_each_process() can miss the group
leader because it can exit before sub-threads. This must not happen,
or we have some serious bug triggered by your workload.

So, once again. Could you please explain the original problem and how
this patch helps?

Oleg.

#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <assert.h>
#include <stdio.h>

void *tfunc(void* arg)
{
	if (arg) {
		ptrace(PTRACE_TRACEME, 0,0,0);
		raise(SIGSTOP);
		pthread_kill(*(pthread_t*)arg, SIGQUIT);
	}
	pause();
}

int main(void)
{
	int pid;

	if (!fork()) {
		pthread_t thread1, thread2;
		pthread_create(&thread1, NULL, tfunc, NULL);
		pthread_create(&thread2, NULL, tfunc, &thread1);
		pause();
		return 0;
	}

	assert((pid = waitpid(-1, NULL, __WALL)) > 0);
	assert(ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_TRACEEXIT) == 0);
	assert(ptrace(PTRACE_CONT, pid, 0, 0) == 0);
	wait(NULL);

	pause();
	return 0;
}

