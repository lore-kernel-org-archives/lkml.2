Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1FBW0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:26:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1FBW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=RMR4GHtf4hPPFAzdoN+VBj1KoWLqJN7l3XJOW+Vpn8Ew0Tm4xpj0KTxsOUcspE0Tqs
         ABd6DRHQBoW7+a7f2yQiFcyjbwn61p4McjeERK2F9qMDInBgMNHC/A4a1sY2ZGOClD77
         OGckWx5iyl/F2NO6J06drNktXQ9cC/1wIG5xU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: thread leader death under strace (was Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE)
Date: Fri, 3 Jun 2011 00:26:18 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        indan@nul.nu, bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
References: <BANLkTin1q-r=b3ZVbT3vdJ59OEddrRWfsQ@mail.gmail.com> <20110602163654.GA17754@redhat.com> <20110602163909.GA18025@redhat.com>
In-Reply-To: <20110602163909.GA18025@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_K4A6N573xMOgUwN"
Message-Id: <201106030026.18523.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_K4A6N573xMOgUwN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 02 June 2011 18:39, Oleg Nesterov wrote:
> On 06/02, Oleg Nesterov wrote:
> >
> > On 06/02, Denys Vlasenko wrote:
> > >
> > > The problem is that right now it seems that if tracer doesn't catch
> > > EVENT_EXIT and detach tracee when it sees it, really weird things
> > > happen.
> >
> > The test-case is wrong afaics...
> >
> > Perhaps this should be considered as a bug in glibc, I dunno.
> >
> > > thread1(void *unused)
> > > {
> > > //	usleep(100*1000);
> > > //	VERBOSE("WINCH\n");
> > > //	raise(SIGWINCH);
> > >
> > > 	usleep(100*1000);
> > > 	VERBOSE("DYING\n");
> > > 	raise(SIGUSR1);
> >
> > This doesn't send a signal. This does tgkill(tgid, 0, SIGUSR1) which
> > fails correctly with -EINVAL.

Yes. After I fixed this, it works as expected. See attached.
The output is:

# ./thread_leader_exit
2876: thread leader
2876: status:0003057f WIFSTOPPED sig:5 (TRAP) event:CLONE eventdata:0xb3d
2877: status:0000137f WIFSTOPPED sig:19 (STOP) event:none eventdata:0x0
Leader exits
2876: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT eventdata:0x7700
Sending WINCH to self (pid,tid:2876,2877)
2877: status:00001c7f WIFSTOPPED sig:28 (WINCH) event:none eventdata:0x0
res:0
Sending USR1 to self (pid,tid:2876,2877)
2877: status:00000a7f WIFSTOPPED sig:10 (USR1) event:none eventdata:0x0
2877: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT eventdata:0xa
2877: status:0000000a WIFSIGNALED sig:10 (USR1)
2876: status:0000000a WIFSIGNALED sig:10 (USR1)



> > > static int
> > > thread_leader(void *unused)
> > > {
> > > 	/* malloc gives sufficiently aligned buffer.
> > > 	 * long buf[] does not! (on ia64).
> > > 	 */
> > > 	clone2(thread1, malloc(16 * 1024), 16 * 1024, 0
> >
> > Probably because of this clone2.

This seems to be not a problem (it is defined to clone()).

-- 
vda

--Boundary-00=_K4A6N573xMOgUwN
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="thread_leader_exit.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="thread_leader_exit.c"

/* ...DESCRITION...

   This software is provided 'as-is', without any express or implied
   warranty.  In no event will the authors be held liable for any damages
   arising from the use of this software.

   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it
   freely.  */

#define _GNU_SOURCE 1
#include <assert.h>
#include <limits.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/syscall.h>
/* #include <pthread.h> */
/* Dance around ptrace.h + user.h incompatibility */
#ifdef __ia64__
# define ia64_fpreg ia64_fpreg_DISABLE
# define pt_all_user_regs pt_all_user_regs_DISABLE
#endif
#include <sys/ptrace.h>
#include <linux/ptrace.h>
#ifdef __ia64__
# undef ia64_fpreg
# undef pt_all_user_regs
#endif
#include <sys/user.h>
#if defined __i386__ || defined __x86_64__
# include <sys/debugreg.h>
#endif
/* Define clone2 for all arches */
#ifdef __ia64__
extern int __clone2(int (*fn) (void *), void *child_stack_base,
                     size_t stack_size, int flags, void *arg, ...);
#define clone2 __clone2
#else
#define clone2(func, stack_base, size, flags, arg...) \
        clone(func, (stack_base) + (size), flags, arg)
#endif
/* Direct calls to syscalls, avoiding libc wrappers */
#define syscall_tgkill(pid, tid, sig) syscall(__NR_tgkill, (pid), (tid), (sig))
#define syscall_getpid() syscall(__NR_getpid)
#define syscall_gettid() syscall(__NR_gettid)
#define syscall_exit(v) syscall(__NR_exit, (v));



static int verbose;

#define VERBOSE(...) do { \
	if (verbose) { \
		printf(__VA_ARGS__); fflush(stdout); \
	} \
} while (0)

static pid_t child;
/*static pid_t grandchild;*/

static void
sigkill(pid_t *pp)
{
	pid_t pid = *pp;
	*pp = 0;
	if (pid > 0)
		kill(pid, SIGKILL);
}

static void
cleanup(void)
{
	/*sigkill(&grandchild);*/
	sigkill(&child);
	while (waitpid(-1, NULL, __WALL) > 0)
		continue;
}

static void
handler_fail(int signo)
{
	VERBOSE("alarm timed out\n");
	sigset_t set;
	signal(SIGABRT, SIG_DFL);
	signal(SIGALRM, SIG_DFL);
	/* SIGALRM may be blocked in sighandler, need to unblock */
	sigfillset(&set);
	sigprocmask(SIG_UNBLOCK, &set, NULL);
	/* Due to kernel bugs, waitpid may block. Need to have a timeout */
	alarm(1);
	cleanup();
	exit(0); //assert(0);
}

static const char* sig_name(unsigned sig)
{
	static const char *const sigs[] = {
		[SIGSTOP] = "STOP", [SIGTRAP] = "TRAP", [SIGKILL] = "KILL",
		[SIGTERM] = "TERM", [SIGINT ] = "INT" , [SIGALRM] = "ALRM",
		[SIGABRT] = "ABRT", [SIGUSR1] = "USR1", [SIGUSR2] = "USR2",
		[SIGWINCH]= "WINCH",
		[0      ] = "0",
		[SIGTRAP|0x80] = "TRAP|80",
	};
	static const unsigned num_sigs = sizeof(sigs) / sizeof(sigs[0]);
	if (sig < num_sigs)
		return sigs[sig];
	return NULL;
}

static const char* event_name(int status)
{
	static const char *const events[] = {
		[0]                       = "none",
		[PTRACE_EVENT_FORK      ] = "FORK",
		[PTRACE_EVENT_VFORK     ] = "VFORK",
		[PTRACE_EVENT_CLONE     ] = "CLONE",
		[PTRACE_EVENT_EXEC      ] = "EXEC",
		[PTRACE_EVENT_VFORK_DONE] = "VFORK_DONE",
		[PTRACE_EVENT_EXIT      ] = "EXIT",
	};
	static const unsigned num_events = sizeof(events) / sizeof(events[0]);
	status = (unsigned)status >> 16;
	if (status < num_events)
		return events[status];
	return NULL;
}

/****************** Standard scaffolding ends here ****************/

/*
 * Extended commentary of the entire test.
 *
 * What kernels / patches exhibit it? When it was fixed?
 * Is it CPU vendor/model dependent? SMP dependent?
 * Is it deterministic?
 * How easy/hard is to reproduce it
 * (always? a dozen loops? a second? minute? etc)
 */

/* If the test is not deterministic:
 * Amount of seconds needed to almost 100% catch it */
//#define DEFAULT_TESTTIME 5
/* or (if reproducible in a few loops only) */
//#define DEFAULT_LOOPS 100

static int
thread1(void *unused)
{
	int r;
	int pid = syscall_getpid();
	int tid = syscall_gettid();

	usleep(100*1000);
	VERBOSE("Sending WINCH to self (pid,tid:%d,%d)\n", pid, tid);
	r = syscall_tgkill(pid, tid, SIGWINCH);
	VERBOSE("res:%d\n", r);

	usleep(100*1000);
	VERBOSE("Sending USR1 to self (pid,tid:%d,%d)\n", pid, tid);
	r = syscall_tgkill(pid, tid, SIGUSR1);
	VERBOSE("res:%d\n", r);

	for(;;) pause();
	return 0;
}

static int
thread_leader(void *unused)
{
	/* malloc gives sufficiently aligned buffer.
	 * long buf[] does not! (on ia64).
	 */
	clone2(thread1, malloc(16 * 1024), 16 * 1024, 0
		| CLONE_VM
		| CLONE_FS
		| CLONE_FILES | CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM
//		| CLONE_PTRACE
		| 0        /* no signal to send on death */
		, NULL);
	VERBOSE("Leader exits\n");
	syscall_exit(0x77);
	for(;;) pause();
	return 0;
}

/* If nothing strange happens, just returns.
 * Notable events (which are not bugs) print some sort of marker
 * is verbose is on, but still continue and return normally.
 * Known bugs also print a message if verbose, but they exit(1).
 * New bugs are likely to trip asserts or cause hang/kernel crash :)
 */
static void
reproduce(void)
{
	int status;
	pid_t pid;

	alarm(1);

	/* Typical scenario starts like this.  */
	child = fork();
	assert(child != -1);
	if (child == 0) {
		/* child */
		errno = 0;
		ptrace(PTRACE_TRACEME, 0, (void *) 0, (void *) 0);
		assert_perror(errno);
		raise(SIGSTOP);
		assert_perror(errno);

		printf("%d: thread leader\n", getpid());
		thread_leader(NULL);
	}

	/* We are parent tracer */
	assert(child > 0);
	errno = 0;

	/* Child has stopped itself, checking */
	pid = waitpid(child, &status, 0);
	assert(pid == child);
	assert(WIFSTOPPED(status));
	assert(WSTOPSIG(status) == SIGSTOP);

	ptrace(PTRACE_SETOPTIONS, child, (void *) 0, 0
		| PTRACE_O_TRACESYSGOOD
		| PTRACE_O_TRACECLONE
		| PTRACE_O_TRACEEXIT
		| PTRACE_O_TRACEEXEC
	);
	assert_perror(errno);

	ptrace(PTRACE_CONT, child, (void *) 0, (void *) 0);
	assert_perror(errno);

	/* Let's just look on the resulting sequence of events */
	for (;;) {
		pid_t pid = waitpid(-1, &status, __WALL);
		if (pid <= 0) {
			printf("waitpid returned %d\n", pid);
			return;
		}
		if (WIFSTOPPED(status)) {
			int sig = WSTOPSIG(status);

			char event_str[sizeof(long)*3] = "<err>";
			long event_data = 0x11111111;
			int have_event = (0 == ptrace(PTRACE_GETEVENTMSG, pid, (void *) 0, &event_data));
			if (have_event)
				sprintf(event_str, "0x%lx", event_data);

			printf("%d: status:%08x WIFSTOPPED sig:%d (%s) event:%s eventdata:%s\n",
				pid, status,
				sig, sig_name(sig),
				event_name(status),
				event_str
			);
			if (sig == SIGSTOP) sig = 0;
			if (sig == SIGTRAP) sig = 0;
			if (sig == (SIGTRAP|0x80)) sig = 0;
			ptrace(PTRACE_CONT, pid, (void *) 0, sig);
			assert_perror(errno);
		}
		else if (WIFEXITED(status))
			printf("%d: status:%08x WIFEXITED exitcode:%d\n",
				pid, status, WEXITSTATUS(status));
		else if (WIFSIGNALED(status))
			printf("%d: status:%08x WIFSIGNALED sig:%d (%s)\n",
				pid, status, WTERMSIG(status), sig_name(WTERMSIG(status)));
		else
			printf("%d: status:%08x - ???\n",
				pid, status);
	}

	cleanup();
}

int
main(int argc, char **argv)
{
	setbuf(stdout, NULL);

#if defined DEFAULT_TESTTIME || defined DEFAULT_LOOPS
	int i;
	char *env_testtime = getenv("TESTTIME");  /* misnomer */
	int testtime = (env_testtime ? atoi(env_testtime) : 1);
#endif

	atexit(cleanup);
	signal(SIGINT, handler_fail);
	signal(SIGABRT, handler_fail);
	signal(SIGALRM, handler_fail);
	verbose = 1 ;//(argc - 1);

#if defined DEFAULT_TESTTIME
	testtime *= DEFAULT_TESTTIME;
	for(i = 0; i < testtime; i++) {
		time_t t = time(NULL);
		while (t == time(NULL)) {
			VERBOSE(".");
			reproduce();
		}
	}
	VERBOSE("\n");
#elif defined DEFAULT_LOOPS
	testtime *= DEFAULT_LOOPS;
	for(i = 0; i < testtime; i++) {
		VERBOSE(".");
		reproduce();
	}
	VERBOSE("\n");
#else
	reproduce();
#endif

	return 0;
}

--Boundary-00=_K4A6N573xMOgUwN--
