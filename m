Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1CBLcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:32:41 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:32928 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1CBLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:32:39 -0500
Message-ID: <6b211a19ed02fa7f001343fbd8e3d5a9.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110302074447.GE19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
    <201103011757.48593.vda.linux@googlemail.com>
    <20110301170953.GB17933@htj.dyndns.org>
    <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
    <20110301183454.GC23527@mtj.dyndns.org>
    <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
    <20110302074447.GE19669@htj.dyndns.org>
Date: Wed, 2 Mar 2011 12:32:36 +0100 (CET)
Subject: Re: [RFC] Proposal for ptrace improvements
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <tj@kernel.org>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Roland McGrath" <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 4c6e9116b9ad1e3c2304ae6adbe1e50f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 2, 2011 08:44, Tejun Heo wrote:
> On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
>> I'm not sure what Denys is talking about: Currently it's impossible to
>> pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
>>
>>    PTRACE_CONT
>>           Restarts  the stopped child process.  If data is nonzero and not
>>           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
>>           child;  otherwise,  no  signal is delivered.
>
> AFAICS, that's not true.  SIGSTOP isn't treated differently from other
> signals in the ptrace signal delivery path.  Maybe it was true in the
> past.

Well, I can't find it in the code either, but it's probably a side-effect
of how ptrace is currently implemented. Test program code below, see for
yourself. I hope it's a program bug, but perhaps it's a kernel bug, as I
seem to get two SIGSTOP events when I allow the SIGSTOP, but only one when
denying it. In both cases the traced process isn't actually stopped.

What might happen is that, because the current code handles the traced
task as stopped, the new SIGSTOP signal is first added and then cleared
when the task continues. This doesn't explain the double SIGSTOP
notifications, I'd expect it to either loop indefinitely or to not
notify the SIGSTOP twice.

>> As for distinguishing STOP signals from stopped childs: Just don't set
>> the WUNTRACED flag in the tracer for waitpid.
>
> I'm not following.  Can you please elaborate?

Sorry, should have quoted Denys:

 This proposal adds a new rule for handling of stop notification
 by debuggers. Let's spell it out, because currently strace
 doesn't act according to this new rule:


 "When waitpid indicates stop on a *stop* signal, then it may be either:
 * a signal delivery (strace will inject this signal with PTRACE_SYSCALL(sig));
 * or it may be a stop notification, in which case strace *must not*
   try to inject this signal (this would be a bug, it'd make task running).
   Instead, strace should just go back to waiting in waitpid().

 These two possibilities can be distinquished by querying
 PTRACE_GETSIGINFO. On stop notifications, PTRACE_GETSIGINFO
 errors out - stop notification is not a signal delivery
 and therefore it has no siginfo."

End quote.

You don't get the second case when not setting the WUNTRACED flag.

>> To me it seems clear that job ctl state should be managed independently
>> of ptrace stopped state.  I'm not sure how that fits in with your
>> proposed changes, but my impression is that you make everything a lot
>> simpler by separating traced stopping/continuing from SIGSTOP/SIGCONT
>> job control. It's just not the same. A task stopped by a trace event
>> shouldn't generate a STOP signal for it's parent, only for real SIGSTOPS.
>
> Again, not following.  In the proposal, job control and ptrace operate
> independently, so on that we seem to agree, but I can't understand
> where the STOP signal for the parent comes from?  What are you
> referring to?

What I mean is, if you have a parent P with a child C, and C is ptraced by T,
P shouldn't get SIGSTOP notifications when it waits for C with WUNTRACED set
and C is stopped because of a ptrace event.

Greetings,

Indan

---

Test program:

#include <errno.h>
#include <sched.h> /* clone */
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/stat.h>

typedef enum event_type
{
	EVENT_NONE,
	EVENT_INTR,
	EVENT_SIG,
	EVENT_EXIT,
} event_t;

struct event
{
	event_t type;
	int pid;
	int num;
};

int trace_fork(void);
event_t trace_event(struct event* e);
void event_allow(struct event* e);
void event_deny(struct event* e);
static void event_end(struct event* e, int deny);

int trace_fork(void)
{
	int pid;
	int ret;

	fflush(NULL);
	pid = fork();

	/* child */
	if (pid == 0){
		ret = ptrace(PTRACE_TRACEME, 0, NULL, NULL);
		if (ret)
			perror("ptrace");
		return 0;
	}
	/* parent process */
	return pid;
}

static void event_end(struct event* e, int deny)
{
	int ret;
	event_t type = e->type;
	long sig = 0;

	switch (type) {
	case EVENT_NONE:
	case EVENT_INTR:
	case EVENT_EXIT:
		return;
	case EVENT_SIG:
		if (!deny)
			sig = e->num;
		break;
	}
	/* continue the stopped child, sending signal 'sig' */
	ret = ptrace(PTRACE_SYSCALL, e->pid, NULL, (void*)sig);
	if (ret)
		perror("event_end");
}

void event_allow(struct event* e)
{
	event_end(e, 0);
}

void event_deny(struct event* e)
{
	event_end(e, 1);
}


event_t trace_event(struct event* e)
{
	long pid;
	int status, sig;
retry:
	memset(e, 0, sizeof(*e));
//	pid = waitpid(-1, &status, __WALL);
	pid = wait(&status);
	if (pid == -1){
		if (errno == EINTR){
			e->type = EVENT_INTR;
			return EVENT_INTR;
		}
		/* We've no child processes left */
		return EVENT_NONE;
	}
	e->pid = pid;
	if (!WIFSTOPPED(status)){
		e->type = EVENT_EXIT;
		if (WIFEXITED(status)){
			e->num = WEXITSTATUS(status);
		} else if (WIFSIGNALED(status)){
			e->num = WTERMSIG(status) + 128;
		} else {
			/* Don't send SIGCHLD signals up */
			goto retry;
		}
		return EVENT_EXIT;
	}
	e->type = EVENT_SIG;
	sig = WSTOPSIG(status);
	switch (sig){
	case SIGTRAP:
		/* Don't kill the prisoner by sending it SIGTRAP */
		event_deny(e);
		/* Don't sent SIGTRAP events up */
		goto retry;
	default:
		/* Signal */
		e->num = sig;
	}
	return e->type;
}

int main(int argc, char* argv[])
{
	struct event e;
	int pid;

	pid = trace_fork();
	if (pid < 0){
		perror("trace_fork");
		return errno;
	} else if (pid == 0){
		/* Child */
		while (1){
			sleep(2);
			printf("Still running!\n");
		}
		return 0;
	}
	/* Tracer */
	printf("New child %d\n", pid);
	while (1){
		int event = trace_event(&e);

		if (event == EVENT_NONE)
			return 0;
		if (event == EVENT_SIG)
			printf("Got signal %d\n", e.num);
		event_allow(&e);
	}
	return 0;
}


