Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2C1UH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:07:29 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:47876 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758145Ab2C1UH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:07:28 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2012 16:07:28 EDT
Date: Wed, 28 Mar 2012 21:58:48 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Jason Baron <jbaron@redhat.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
Message-ID: <20120328195848.GA5331@hell>
References: <1332943060-18374-1-git-send-email-hagen@jauu.net>
 <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
 <20120328162108.GB2381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328162108.GB2381@redhat.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron | 2012-03-28 12:21:08 [-0400]:

>Hmmm...Looking at ep_poll() it does an '__add_wait_queue_exclusive()'.
>So, I *think* epoll_wait() should do what you want, if you are waiting
>on the same epfd in all the threads.
>
>I think the case you are describing is where each thread does its own
>ep_create(), and then a subsequent epoll_wait() on the fd from the
>create?
>
>So, I *think* you can get what you want without adding this flag.

;) sorry:

epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned
epoll_wait returned


minimal example:

>>>>>>>>>>>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/epoll.h>

#define	AMAX 16

static void *runner(void *args)
{
	int fd = (int) *((int *) args);
	struct epoll_event events[AMAX];

	epoll_wait(fd, events, AMAX, -1);
	write(1, "epoll_wait returned\n", 20);

	return NULL;
}

int main(int ac, char **av)
{
	int i, evfd, pipefd[2];
	pthread_t thread_id[2];
	struct epoll_event epoll_ev;

	pipe(pipefd);
	evfd = epoll_create(64);

	memset(&epoll_ev, 0, sizeof(struct epoll_event));
	epoll_ev.events   = EPOLLIN | EPOLLPRI | EPOLLERR | EPOLLHUP;
	epoll_ctl(evfd, EPOLL_CTL_ADD, pipefd[0], &epoll_ev);

	for (i = 0; i < 10; i++)
		pthread_create(&thread_id[0], NULL, runner, &evfd);

	sleep(1);
	close(pipefd[1]);
	write(pipefd[0], "x", 1);
	sleep(1);

	return EXIT_SUCCESS;
}
<<<<<<<<<<<


Cheers, Hagen
