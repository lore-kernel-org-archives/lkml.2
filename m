Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab1FDP3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab1FDP3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:29:36 -0400
Date: Sat, 4 Jun 2011 17:27:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        indan@nul.nu, bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
Subject: Re: thread leader death under strace (was Re: [PATCH 03/10]
	ptrace: implement PTRACE_SEIZE)
Message-ID: <20110604152726.GA5734@redhat.com>
References: <BANLkTin1q-r=b3ZVbT3vdJ59OEddrRWfsQ@mail.gmail.com> <201106030026.18523.vda.linux@googlemail.com> <20110603152937.GB23757@redhat.com> <201106032010.03947.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106032010.03947.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Denys Vlasenko wrote:
>
> On Friday 03 June 2011 17:29, Oleg Nesterov wrote:
> > > > > > thread_leader(void *unused)
> > > > > > {
> > > > > > 	/* malloc gives sufficiently aligned buffer.
> > > > > > 	 * long buf[] does not! (on ia64).
> > > > > > 	 */
> > > > > > 	clone2(thread1, malloc(16 * 1024), 16 * 1024, 0
> > > > >
> > > > > Probably because of this clone2.
> > >
> > > This seems to be not a problem (it is defined to clone()).
> >
> > Doesn't matter.
> >
> > Unlike pthread_create() which uses CLONE_SETTLS, this doesn't setup
> > the tls area, and I assume you used -lpthread. In this case it is clear
> > why raise() doesn't work, pt-raise.c thinks that THREAD_GETMEM(tid)
> > should always work.
>
> I don't link against pthread.

Hmm. OK, I was wrong, I thought that the !pt version in raise.c should
work because it does

	selftid = THREAD_GETMEM(tid);
	if (!selftid) {
		selftid = sys_gettid();
		THREAD_GETMEM(tid) = selftid;
	}

and thus uses the correct tid. But it doesn't work because it uses the
wrong _pid_ by the same reason (tls). It rechecks THREAD_GETMEM(tid)
but not THREAD_GETMEM(pid), then it does

	if (!pid)
		pid = selftid;

and tgkill() correctly fails again.


Heh,

	int tfunc(void *unused)
	{
		raise(SIGKILL);

		printf("WTF? SIGKILL doesn't work\n");
		printf("thread: tgid = %d\n", getpid());

		exit(0);
	}

	char stack[32 * 1024];

	int main(void)
	{
		printf("main: tgid = %ld\n", syscall(__NR_getpid));

		clone(tfunc, stack + sizeof(stack)/2,
			CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_THREAD,
			NULL);

		pause();
		assert(0);

		return 0;
	}

prints

	main: tgid = 5959
	WTF? SIGKILL doesn't work
	thread: tgid = 5960

on my machine. Note that if the main thread uses getpid() (which caches
the returned value in THREAD_GETMEM) instead of syscall, everything works.
And if you remove raise() from tfunc(), the thread prints the correct tgid.
This is because raise() fills THREAD_GETMEM(tid) which is used (why???) by
really_getpid() before sys_getpid().

Funny that...

On your machine you can have the different results, my glibc is rather
old. Anyway, I think we can conclude that there is no kernel bug involved.

I am not brave enough to contact glibc developers, may be you can ;)

Oleg.

