Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2DBXSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:18:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35753 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2DBXSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 2 Apr 2012 16:17:46 -0700
Message-ID: <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/4/1 Alexey Dobriyan <adobriyan@gmail.com>:
> Currently there is no reliable way to close all opened file descriptors
> (which daemons need and like to do):
>
> * dumb close(fd) loop is slow, upper bound is unknown and
>  can be arbitrary large,
>
> * /proc/self/fd is unreliable:
>  proc may be unconfigured or not mounted at expected place.
>  Looking at /proc/self/fd requires opening directory
>  which may not be available due to malicious rlimit drop or ENOMEM situations.
>  Not opening directory is equivalent to dumb close(2) loop except slower.

Sorry for the long delay comment. I realized this thread now. I think
/proc no mount
case is not good explanation for the worth of this patch. The problem
is, we can't
use opendir() after fork() if an app has multi threads.

SUS clearly say so,
 http://pubs.opengroup.org/onlinepubs/009695399/functions/fork.html

we can only call async-signal-safe functions after fork() when multi threads and
opendir() call malloc() internally.

As far as I know, OpenJDK has a such fork-readdir-exec code and it can
make deadlock
when spawnning a new process. Unfortunately Java language perfeter to
make a lot of threads rather than other language.

This patch can solve such multi threaded case.

offtopic, glibc malloc is a slightly clever. It reinitialize its
internal lock when fork by
using thread_atfork() hook. It mean glibc malloc can be used after
fork() and the
technique can avoid this issue. But, glibc malloc still has several
performance problem and
many people prefer to use jemalloc or google malloc instead. Then,
they hit an old issue, bah.


> BSD added closefrom(fd) which is OK for this exact purpose but suboptimal
> on the bigger scale. closefrom(2) does only close(2) (obviously :-)
> closefrom(2) siletly ignores errors from close(2) which in theory is not OK
> for userspace.

Solaris don't only have a closefrom(), but also has fdwalk().

  http://docs.oracle.com/cd/E19082-01/819-2243/6n4i098vd/index.html

and I've received a request that linux aim fdwalk() several times. Example,

Ruby uses fcntl(FD_CLOEXEC) instead of close() because their community uses
valgrind for daily stress test and it don't support for(f<maxfd){
close() } pattern.
(I guess it is valgrind's bug, but I'm not sure.)

I have several other similar bug report of our proprietary software.
but i'm sorry.
I cant show it here. But clearly, fdwalk (or nextfd) is powerful than
closefrom().

Honestly, I had no idea to aim fdwalk cleanly. but your patch is much
cleaner to me.
So, I like this.

> So, don't add closefrom(2), add nextfd(2).
>
>        int nextfd(int fd)
>
> returns next opened file descriptor which is >= than fd or -1/ESRCH
> if there aren't any descriptors >= than fd.
>
> Thus closefrom(3) can be rewritten through it in userspace:
>
>        void closefrom(int fd)
>        {
>                while (1) {
>                        fd = nextfd(fd);
>                        if (fd == -1 && errno == ESRCH)
>                                break;
>                        (void)close(fd);
>                        fd++;
>                }
>        }
>
> Maybe it will grow other smart uses.
>
> nextfd(2) doesn't change kernel state and thus can't fail
> which is why it should go in. Other means may fail or
> may not be available or require linear time with only guessed
> upper boundaries (1024, getrlimit(RLIM_NOFILE), sysconf(_SC_OPEN_MAX).

This is not enough explanation. The problem is, RLIM_NOFILE can be changed
at runtime. then, a process can have a larger fd than RLIM_NOFILE.

Therefore, if you accept other developers opinion (especially linus's
flags argument suggestion), I'll ack this patch.

Thank you.
