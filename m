Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2FOEaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 00:30:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33367 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2FOEaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 00:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FDAB652.6070201@gmail.com>
References: <4FDAB652.6070201@gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 15 Jun 2012 12:29:45 +0800
Message-ID: <CABa6K_H3NrvvZ3Bh7JqsR6h33BSqYPBenUDG5Yt1U=2VvP700g@mail.gmail.com>
Subject: Re: [RFC] Introduce to batch variants of accept() and epoll_ctl() syscall
To: Li Yu <raise.sail@gmail.com>
Cc: Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidel@xmailserver.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 12:13 PM, Li Yu <raise.sail@gmail.com> wrote:
> Hi,
>
>  We encounter a performance problem in a large scale computer
> cluster, which needs to handle a lot of incoming concurrent TCP
> connection requests.
>
>  The top shows the kernel is most cpu hog, the testing is simple,
> just a accept() -> epoll_ctl(ADD) loop, the ratio of cpu util sys% to
> si% is about 2:5.
>
>  I also asked some experienced webserver/proxy developers in my team
> for suggestions, it seem that behavior of many userland programs already
> called accept() multiple times after it is waked up by
> epoll_wait(). And the common action is adding the fd that accept()
> return into epoll interface by epoll_ctl() syscall then.
>
>  Therefore, I think that we'd better to introduce to batch variants of
> accept() and epoll_ctl() syscall, just like sendmmsg() or recvmmsg().
>
>  For accept(), we may need a new syscall, it may like this,
>
>  struct accept_result {
>      int fd;
>      struct sockaddr addr;
>      socklen_t addr_len;
>  };
>
>  int maccept4(int fd, int flags, int nr_accept_result, struct
> accept_result *results);
>
>  For epoll_ctl(), there are two means to extend it, I prefer to extend
> current interface instead of introduce to new syscall. We may introduce
> to a new flag EPOLL_CTL_BATCH. If userland call epoll_ctl() with this
> flag set, the meaning of last two arguments of epoll_ctl() change, .e.g:
>
>  struct batch_epoll_event batch_event[] = {
>         {
>              .fd = a_newsock_fd;
>              .epoll_event = { ... };
>         },
>         ...
>  };
>
>  ret = epoll_ctl(fd, EPOLL_CTL_ADD|EPOLL_CTL_BATCH, nr_batch_events,
> batch_events);
>

I think it is good idea. Would you please implement a prototype and
give some numbers? This kind of data may help selling this idea.
Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
