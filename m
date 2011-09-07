Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1IGCrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:47:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48913 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1IGCrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:47:48 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
Date: Wed, 7 Sep 2011 04:47:45 +0200
User-Agent: KMail/1.8.2
Cc: "Denys Vlasenko" <dvlasenk@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <201109042311.18793.vda.linux@googlemail.com> <201109060305.19607.vda.linux@googlemail.com> <400150a2d773c6b7dd8f88e1b74c883d.squirrel@webmail.greenhost.nl>
In-Reply-To: <400150a2d773c6b7dd8f88e1b74c883d.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109070447.45193.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011 19:19, Indan Zupancic wrote:
> >> > In case you meant that "if we request group-stop notifications by using
> >> > __WALL | WSTOPPED, and we get group-stop notification, and we do
> >> > PTRACE_CONT, then task does not run (it sits in group-stop until SIGCONT
> >> > or death)", then we have a problem: gdb can't use this interface, it
> >> > needs to be able to restart the thread (only one thread, not all of
> >> > them, so sending SIGCONT is not ok!) from the group-stop. Yes, it's
> >> > weird, but it's the real requirement from gdb users.
> >> [...]
> >> > SIGCONT's side effect of waking up from group-stop can't be blocked.
> >> > SIGCONT always wakes up all threads in thread group.
> >> > Using SIGCONT to control tracee will race with SIGCONTs from other
> >> > sources.
> >> >
> >> > This makes SIGCONT a too coarse instrument for the job.
> >> [...]
> >> > Yes... until gdb will want to give user a choice after SIGSTOP: continue
> >> > to sit in group-stop until SIGCONT (wasn't possible until
> >> > PTRACE_LISTEN), or continue executing (gdb's current behavior if user
> >> > uses "continue" command). Therefore, gdb needs a way to do both.
> >>
> >> Having thought a bit more about this, I think this is less of a problem
> >> than it seems, because for a group stop we get a ptrace event for each
> >> task, and this should be true for SIGCONT as well. So gdb could also
> >> always let the group stop happen, and only when prompted to do so by
> >> a user, continue one thread by sending SIGCONT and letting all the other
> >> threads hang in trapped state.
> >
> > Won't work. SIGCONT unpauses all threads in the thread group,
> > and _then_ it is delivered to one of the threads.
> 
> No, it is delivered to _all_ threads.

Wrong.

> With current ptrace you never see a SIGCONT

Wrong. Even rather old strace 4.5.9 does show it.



#include <stdlib.h>
#include <pthread.h>
static void *threadfunc(void *p)
{
        sleep(10);
        exit(0);
}
int main()
{
        printf("%d\n", getpid());
        pthread_t thread;
        pthread_create(&thread, NULL, threadfunc, NULL);
        sleep(10);
        exit(0);
}


$ gcc -Os -lpthread t.c -ot
$ strace -V
strace -- version 4.5.9
$ strace -oLOG -s999 -tt -f ./t
umovestr: Input/output error
9590
umovestr: Input/output error
ptrace: umoven: Input/output error

In other terminal: "kill -CONT 9590"

LOG:

9590  04:41:13.984640 clone(...) = 9591
9590  04:41:13.984712 rt_sigprocmask(SIG_BLOCK, [CHLD],  <unfinished ...>
...
9591  04:41:13.984972 <... rt_sigaction resumed> {SIG_DFL}, 8) = 0
9590  04:41:13.984993 nanosleep({10, 0},  <unfinished ...>
9591  04:41:13.985015 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
9591  04:41:13.985056 nanosleep({10, 0},  <unfinished ...>
9590  04:41:19.969687 <... nanosleep resumed> 0xff9e6fa4) = ? ERESTART_RESTARTBLOCK (To be restarted)
9590  04:41:19.969762 --- SIGCONT (Continued) @ 0 (0) ---
9590  04:41:19.969791 setup()           = 0
9591  04:41:23.985155 <... nanosleep resumed> {10, 0}) = 0
9590  04:41:23.985201 exit_group(0)     = ?
9591  04:41:23.985231 exit_group(0)     = ?


Take a good look. There was no SIGCONT delivery to thread 9591.


> > You can block
> > or ignore it, yes, but it is too late: the unpausing already happened,
> > and blocking/ignoring will only affect SIGCONT handler execution,
> > if the program has one.
> 
> Not doing PTRACE_CONT will keep the thread hanging in trapped state.
> All threads get a SIGCONT, not only one, so you can pause all threads
> this way.

As I said, you are wrong about SIGCONT.

-- 
vda
