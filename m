Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab2C2O4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179Ab2C2O4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:56:12 -0400
Date: Thu, 29 Mar 2012 10:16:53 -0400
From: Jason Baron <jbaron@redhat.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
Message-ID: <20120329141653.GA2424@redhat.com>
References: <1332943060-18374-1-git-send-email-hagen@jauu.net>
 <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
 <20120328162108.GB2381@redhat.com>
 <20120328195848.GA5331@hell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328195848.GA5331@hell>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:58:48PM +0200, Hagen Paul Pfeifer wrote:
> 
> >Hmmm...Looking at ep_poll() it does an '__add_wait_queue_exclusive()'.
> >So, I *think* epoll_wait() should do what you want, if you are waiting
> >on the same epfd in all the threads.
> >
> >I think the case you are describing is where each thread does its own
> >ep_create(), and then a subsequent epoll_wait() on the fd from the
> >create?
> >
> >So, I *think* you can get what you want without adding this flag.
> 
> ;) sorry:
> 
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> epoll_wait returned
> 
> 
> minimal example:
> 
> >>>>>>>>>>>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <pthread.h>
> #include <sys/epoll.h>
> 
> #define	AMAX 16
> 
> static void *runner(void *args)
> {
> 	int fd = (int) *((int *) args);
> 	struct epoll_event events[AMAX];
> 
> 	epoll_wait(fd, events, AMAX, -1);
> 	write(1, "epoll_wait returned\n", 20);
> 
> 	return NULL;
> }
> 
> int main(int ac, char **av)
> {
> 	int i, evfd, pipefd[2];
> 	pthread_t thread_id[2];
> 	struct epoll_event epoll_ev;
> 
> 	pipe(pipefd);
> 	evfd = epoll_create(64);
> 
> 	memset(&epoll_ev, 0, sizeof(struct epoll_event));
> 	epoll_ev.events   = EPOLLIN | EPOLLPRI | EPOLLERR | EPOLLHUP;
> 	epoll_ctl(evfd, EPOLL_CTL_ADD, pipefd[0], &epoll_ev);
> 
> 	for (i = 0; i < 10; i++)
> 		pthread_create(&thread_id[0], NULL, runner, &evfd);
> 
> 	sleep(1);
> 	close(pipefd[1]);
> 	write(pipefd[0], "x", 1);
> 	sleep(1);
> 
> 	return EXIT_SUCCESS;
> }

Right, for level triggered events, they all wait up. However, if you use
edge triggered, ie add 'EPOLLET', then the event gets 'consumed' by the
first thread that wakes up, and the subseqent waiters wouldn't get woken
up. IE you'll get one wakeup.

Thanks,

-Jason
