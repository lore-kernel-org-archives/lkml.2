Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2DBX5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:57:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab2DBX47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:56:59 -0400
Message-ID: <4F7A3CC2.1040200@zytor.com>
Date: Mon, 02 Apr 2012 16:56:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
In-Reply-To: <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 04:17 PM, KOSAKI Motohiro wrote:
> 
> Sorry for the long delay comment. I realized this thread now. I think
> /proc no mount case is not good explanation for the worth of this patch. The problem
> is, we can't use opendir() after fork() if an app has multi threads.
> 
> SUS clearly say so,
>  http://pubs.opengroup.org/onlinepubs/009695399/functions/fork.html
> 
> we can only call async-signal-safe functions after fork() when multi threads and
> opendir() call malloc() internally.
> 
> As far as I know, OpenJDK has a such fork-readdir-exec code and it can
> make deadlock
> when spawnning a new process. Unfortunately Java language perfeter to
> make a lot of threads rather than other language.
> 
> This patch can solve such multi threaded case.
> 
> offtopic, glibc malloc is a slightly clever. It reinitialize its
> internal lock when fork by using thread_atfork() hook. It mean glibc malloc can be used after
> fork() and the technique can avoid this issue. But, glibc malloc still has several
> performance problem and many people prefer to use jemalloc or google malloc instead. Then,
> they hit an old issue, bah.
> 

OK, so what you're saying here is:

Linux doesn't actually have a problem unless:
1. You use the library implementation of opendir/readdir/closedir;
2. You use a nonstandard malloc for the platform which doesn't
   correctly set up fork hooks (which I would consider a bug);

You can deal with this in one of two ways:

2. Fix your malloc().
1. Use the low level open()/getdents()/close() functions instead of
   opendir()/readdir()/closedir().

> and I've received a request that linux aim fdwalk() several times. Example,

It doesn't sound very hard to implement fdwalk() in terms of
open/getdents/close without using malloc; since the fdwalk() interface
lets you use the stack for storage.  You can then implement closefrom()
in terms of fdwalk().  Something like this (untested):

int fdwalk(int (*func)(void *, int), void *cd)
{
	char buf[4096];	/* ... could be less... */
	const char *p, *q;
	const struct linux_dirent *dp
	int dfd, fd;
	unsigned char c;
	int rv = 0;
	int sz;

	dfd = open("/proc/self/fd", O_RDONLY|O_DIRECTORY|O_CLOEXEC);
	if (dfd < 0)
		return -1;

	/*** XXX: may want to check for procfs magic here ***/

	while ((sz = getdents(dfd, buf, sizeof buf)) > 0) {
		p = buf;

		while (sz > offsetof(struct linux_dirent, d_name)) {
			dp = (const struct linux_dirent *)p;

			if (sz < dp->d_reclen)
				break;

			q   = dp->d_name;
			p  += dp->d_reclen;
			sz -= dp->d_reclen;

			fd = 0;
			while (q < p && (c = *q++)) {
				c -= '0';
				if (c >= 10)
					goto skip;
				fd = fd*10 + c;
			}

			if (fd != dfd)
				rv = func(cd, fd);
		skip:
			;
		}
	}

	if (close(dfd))
		return -1;

	return rv;
}
