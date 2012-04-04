Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2DDQb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:31:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46285 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab2DDQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:31:56 -0400
Message-ID: <4F7C777E.10608@gmail.com>
Date: Wed, 04 Apr 2012 09:31:58 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com> <4F7A3CC2.1040200@zytor.com>
In-Reply-To: <4F7A3CC2.1040200@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/2/12 4:56 PM), H. Peter Anvin wrote:
> On 04/02/2012 04:17 PM, KOSAKI Motohiro wrote:
>>
>> Sorry for the long delay comment. I realized this thread now. I think
>> /proc no mount case is not good explanation for the worth of this patch. The problem
>> is, we can't use opendir() after fork() if an app has multi threads.
>>
>> SUS clearly say so,
>>   http://pubs.opengroup.org/onlinepubs/009695399/functions/fork.html
>>
>> we can only call async-signal-safe functions after fork() when multi threads and
>> opendir() call malloc() internally.
>>
>> As far as I know, OpenJDK has a such fork-readdir-exec code and it can
>> make deadlock
>> when spawnning a new process. Unfortunately Java language perfeter to
>> make a lot of threads rather than other language.
>>
>> This patch can solve such multi threaded case.
>>
>> offtopic, glibc malloc is a slightly clever. It reinitialize its
>> internal lock when fork by using thread_atfork() hook. It mean glibc malloc can be used after
>> fork() and the technique can avoid this issue. But, glibc malloc still has several
>> performance problem and many people prefer to use jemalloc or google malloc instead. Then,
>> they hit an old issue, bah.
>>
>
> OK, so what you're saying here is:
>
> Linux doesn't actually have a problem unless:
> 1. You use the library implementation of opendir/readdir/closedir;
> 2. You use a nonstandard malloc for the platform which doesn't
>     correctly set up fork hooks (which I would consider a bug);

Right. but I'm argue "correctly set up" term because SUS/POSIX don't require it.
It is only a workaround of buggy userland in glibc. SUS still says you can't
use opendir and typical userland people don't want ignore SUS as far as possible.


> You can deal with this in one of two ways:
>
> 2. Fix your malloc().
> 1. Use the low level open()/getdents()/close() functions instead of
>     opendir()/readdir()/closedir().

Ideally possible. but practically impossible. 2) people don't use a their
own malloc. they only uses open sources alternative malloc. And, I think
you have too narrowing concern. Even though malloc people adds a workaround,
the standard inhibit to use it and people may continue to use more dangerous
RLIM_NOFILE loop. 1) I haven't seen _practical_ userland software uses such
linux internal hacking. Almost all major software can run on multiple OSs.


>> and I've received a request that linux aim fdwalk() several times. Example,
>
> It doesn't sound very hard to implement fdwalk() in terms of
> open/getdents/close without using malloc; since the fdwalk() interface
> lets you use the stack for storage.  You can then implement closefrom()
> in terms of fdwalk().  Something like this (untested):
>
> int fdwalk(int (*func)(void *, int), void *cd)
> {
> 	char buf[4096];	/* ... could be less... */
> 	const char *p, *q;
> 	const struct linux_dirent *dp
> 	int dfd, fd;
> 	unsigned char c;
> 	int rv = 0;
> 	int sz;
>
> 	dfd = open("/proc/self/fd", O_RDONLY|O_DIRECTORY|O_CLOEXEC);
> 	if (dfd<  0)
> 		return -1;
>
> 	/*** XXX: may want to check for procfs magic here ***/
>
> 	while ((sz = getdents(dfd, buf, sizeof buf))>  0) {
> 		p = buf;
>
> 		while (sz>  offsetof(struct linux_dirent, d_name)) {
> 			dp = (const struct linux_dirent *)p;
>
> 			if (sz<  dp->d_reclen)
> 				break;
>
> 			q   = dp->d_name;
> 			p  += dp->d_reclen;
> 			sz -= dp->d_reclen;
>
> 			fd = 0;
> 			while (q<  p&&  (c = *q++)) {
> 				c -= '0';
> 				if (c>= 10)
> 					goto skip;
> 				fd = fd*10 + c;
> 			}
>
> 			if (fd != dfd)
> 				rv = func(cd, fd);
> 		skip:
> 			;
> 		}
> 	}
>
> 	if (close(dfd))
> 		return -1;
>
> 	return rv;
> }

It can. but more ugly. no?

