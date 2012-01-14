Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2ANNUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 08:20:53 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65420 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2ANNUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 08:20:52 -0500
Message-ID: <1326547247.5287.19.camel@edumazet-laptop>
Subject: Re: The thundering herd like problem when multi epolls on one fd
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Li Yu <raise.sail@gmail.com>
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org
Date: Sat, 14 Jan 2012 14:20:47 +0100
In-Reply-To: <4F116350.6090704@gmail.com>
References: <4F116350.6090704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 14 janvier 2012 à 19:13 +0800, Li Yu a écrit :
> Hi, 
> 
> 	My buddy reported a thundering herd problem about using epoll 
> on TCP listen sockets. He said their usage like below:
> 
> 	1. sk = new tcp_listen_socket();
> 	2. create many child processes or threads.
> 	3. in new created processes (threads), use epoll API on listen
> sk to provide HTTP service.
> 
> 	Such using pattern means we have multi wait queues when 
> accepting one socket, and it is not exclusive waking up, so we get a 
> thundering herd like problem. And, so I heard many popular applications
> can use such pattern, which includes nginx, lighttpd, haproxy at least.

It is not very scalable. But we really lack a fanout mechanism to allow
better paralelism on accept(), its not a poll() vs select() vs epoll()
problem per se, but a generic problem.

> So should we change this waking up behavior to exclusive too ? 
> 

Certainly not.

> 	Below is a simple patch (tested and works) for epoll() to do it,
> of course, we also should fix select() and poll() syscalls if it is right.
> 
> 	Thanks.
> 
> Yu	
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 828e750..a3d6ab4 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -898,7 +899,7 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
>                 init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
>                 pwq->whead = whead;
>                 pwq->base = epi;
> -               add_wait_queue(whead, &pwq->wait);
> +               add_wait_queue_exclusive(whead, &pwq->wait);
>                 list_add_tail(&pwq->llink, &epi->pwqlist);
>                 epi->nwait++;
>         } else {
> --


What happens if the awaken thread does not consume the event, and prefer
to exit ?

If several threads are doing select()/poll()/epoll() on a shared fd,
they _all_ must be notified the fd is ready, as manpages claim.

Doing otherwise would require the prior consent of the user, using a
special flag for example, and documentation.


