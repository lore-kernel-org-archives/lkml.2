Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1H0BnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:43:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab1H0Bm7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E584492.5090406@zytor.com>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com> <4E584492.5090406@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 18:42:35 -0700
Message-ID: <CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 6:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> For reference, this is the current list (again, unaudited!) of unshared
> system calls.  Only the ones with *x32* in the the entry point name have
> any new code in the kernel at all.

So a *lot* of these make me extremely unhappy.

> # x32 system calls start at 512 to avoid cache impact for native 32 bit
> #
> 512     x32     open                    compat_sys_open

The only difference between open and compat_sys_open() is that the
latter doesn't set O_LARGEFILE, no?

That seems *extremely* wrong. Darn it, there is no reason we should
ever allow the old LARGEFILE crap in a new model. So why would we ever
want to that compat_open()?

> 513     x32     stat                    compat_sys_newstat
> 514     x32     fstat                   compat_sys_newfstat
> 515     x32     lstat                   compat_sys_newlstat

So these I'm unhappy with because I really think we should just use
the 64-bit stat format, instead of dicking around with the legacy
formats.

The native x86-64 stat is *better* than the crazy i386 formats, for
chissake! The i386 "newstat" has those crazy padding fields. They make
no sense.

> 516     x32     rt_sigaction            sys32_rt_sigaction
> 517     x32     rt_sigprocmask          sys32_rt_sigprocmask
> 518     x32     rt_sigreturn            stub_x32_rt_sigreturn

So these may be valid. I don't know what your stub_x32_rt_sigreturn
is, but I hope it still restores the full 64-bit registers? Even in
ULP64, I assume we still use 64-bit registers for "long long" etc?

> 519     x32     ioctl                   compat_sys_ioctl
> 520     x32     readv                   compat_sys_readv
> 521     x32     writev                  compat_sys_writev

Ok, these are the ones I expect. They are all about structures with
pointers in user space.

> 522     x32     select                  compat_sys_select

But this one I really suspect we'd be better off just having 64-bit
timeval, obviating the need for the compat system call.

time_t really *should* be 64-bit, the same way "off_t" should be. If
it's not, there's something wrong.

> 523     x32     shmat                   compat_sys_x32_shmat
> 524     x32     shmctl                  compat_sys_shmctl

I assume this is due to the same "return shm segment in low 4GB" thing.

I do think it would be better to have a "SHM_4G" flag that gets set by
user space, but I guess that's ok.

> 525     x32     nanosleep               compat_sys_nanosleep
> 526     x32     getitimer               compat_sys_getitimer
> 527     x32     setitimer               compat_sys_setitimer

Again, these would be better off with a 64-bit time_t. Seriously.

> 528     x32     recvfrom                compat_sys_recvfrom
> 529     x32     sendmsg                 compat_sys_sendmsg
> 530     x32     recvmsg                 compat_sys_recvmsg

Ok, pointers in user land.

> 531     x32     setsockopt              compat_sys_setsockopt
> 532     x32     getsockopt              compat_sys_getsockopt

Grr. I guess these fall under the same heading.

> 533     x32     execve                  stub_x32_execve

Yes.

> 534     x32     wait4                   compat_sys_wait4

Why is this? "rusage"? Can't we just make that 64-bit?

> 535     x32     semctl                  compat_sys_x32_semctl
> 536     x32     msgsnd                  compat_sys_x32_msgsnd
> 537     x32     msgrcv                  compat_sys_x32_msgrcv
> 538     x32     msgctl                  compat_sys_msgctl

Ok.

> 539     x32     fcntl                   compat_sys_fcntl64

flock?

> 540     x32     getdents                compat_sys_getdents

.. but why this? Isn't 'linux_dirent64' good enough?

> 541     x32     gettimeofday            compat_sys_gettimeofday

64-bit time_t?

> 542     x32     getrlimit               compat_sys_getrlimit
> 543     x32     getrusage               compat_sys_getrusage

Looks like another "should just be 64-bit"

> 544     x32     sysinfo                 compat_sys_sysinfo
> 545     x32     times                   compat_sys_times

64-bit time_t should fix this.
...
> 560     x32     nfsservctl              compat_sys_nfsservctl

We've removed this one.

.. lots more. It really looks annoying to me. A lot of the remaining
ones should just be "int 0x80", they aren't performance critical. Why
do they have to have new system call entry points?

                        Linus
