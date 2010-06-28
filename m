Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0F1PEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0F1PE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:04:27 -0400
Date: Mon, 28 Jun 2010 17:02:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: Q: sys_futex() && timespec_valid()
Message-ID: <20100628150208.GA13954@redhat.com>
References: <4C2506C3.2000301@us.ibm.com> <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20100628135825.GA17681@redhat.com> <20100628143715.GJ25077@tyan-ft48-01.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628143715.GJ25077@tyan-ft48-01.lab.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Jakub Jelinek wrote:
>
> On Mon, Jun 28, 2010 at 03:58:25PM +0200, Oleg Nesterov wrote:
> > Honestly, it looks a bit strange to me that you blame the correct code,
>
> Whether that is correct or not is what is being disputed.

OK. I only argued with the "buggy" term. Once again, the code works
as expected.

> > and at the same time you ignore the test-case which hangs because the
> > kernel returns -EFAULT saying that this is the caller's problem.
>
> The userspace code reads the abstime->tv_nsec value, so if it wouldn't
> be valid address, the code would already segfault.  And that's fine, POSIX
> certainly allows that, reporting EFAULT isn't required.  Well, it doesn't
> read abstime->tv_sec in the assembly version, so if you try hard, you can
> avoid the segfault, yet get EFAULT from futex syscall by putting abstime
> 8 bytes before start of some page with previous page not mmapped.

And this is exactly what I did to prove that (in my opinion) libc needs
fixes anyway, even if we change the kernel to treat tv_sec < 0 specially.

	#include <stdio.h>
	#include <unistd.h>
	#include <pthread.h>
	#include <sys/mman.h>

	pthread_rwlock_t rwlock;

	static struct timespec *make_efault_ts(void)
	{
		int page_size = sysconf(_SC_PAGESIZE);
		void *ptr = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE,
					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		munmap(ptr, page_size);
		return ptr + page_size - sizeof(long);
	}

	static void *thread_func(void *arg)
	{
		int ret = pthread_rwlock_timedwrlock(&rwlock, make_efault_ts());
		printf("lock: ret=%d %m\n", ret);
		return NULL;
	}

	int main(int argv, char *argc[])
	{
		pthread_t tid;

		pthread_rwlock_init(&rwlock, NULL);
		pthread_rwlock_wrlock(&rwlock);

		pthread_create(&tid, NULL, thread_func, NULL);
		pthread_join(tid, NULL);

		return 0;
	}

It may hang or segfault on your machine, this depends on libc version.
It hangs on the testing machine which also suffers from the reported
timespec_valid() issue. I did this test-case looking at
"objdump -d /lib64/libpthread.so".

To me, this looks like a bug in libc, but I won't insist.

Oleg.

