Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2FOFht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 01:37:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52764 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2FOFhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 01:37:48 -0400
Message-ID: <4FDACA26.70004@gmail.com>
Date: Fri, 15 Jun 2012 13:37:42 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidel@xmailserver.org
Subject: Re: [RFC] Introduce to batch variants of accept() and epoll_ctl()
 syscall
References: <4FDAB652.6070201@gmail.com> <CABa6K_H3NrvvZ3Bh7JqsR6h33BSqYPBenUDG5Yt1U=2VvP700g@mail.gmail.com>
In-Reply-To: <CABa6K_H3NrvvZ3Bh7JqsR6h33BSqYPBenUDG5Yt1U=2VvP700g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年06月15日 12:29, Changli Gao 写道:
> On Fri, Jun 15, 2012 at 12:13 PM, Li Yu<raise.sail@gmail.com>  wrote:
>> Hi,
>>
>>   We encounter a performance problem in a large scale computer
>> cluster, which needs to handle a lot of incoming concurrent TCP
>> connection requests.
>>
>>   The top shows the kernel is most cpu hog, the testing is simple,
>> just a accept() ->  epoll_ctl(ADD) loop, the ratio of cpu util sys% to
>> si% is about 2:5.
>>
>>   I also asked some experienced webserver/proxy developers in my team
>> for suggestions, it seem that behavior of many userland programs already
>> called accept() multiple times after it is waked up by
>> epoll_wait(). And the common action is adding the fd that accept()
>> return into epoll interface by epoll_ctl() syscall then.
>>
>>   Therefore, I think that we'd better to introduce to batch variants of
>> accept() and epoll_ctl() syscall, just like sendmmsg() or recvmmsg().
>>
>>   For accept(), we may need a new syscall, it may like this,
>>
>>   struct accept_result {
>>       int fd;
>>       struct sockaddr addr;
>>       socklen_t addr_len;
>>   };
>>
>>   int maccept4(int fd, int flags, int nr_accept_result, struct
>> accept_result *results);
>>
>>   For epoll_ctl(), there are two means to extend it, I prefer to extend
>> current interface instead of introduce to new syscall. We may introduce
>> to a new flag EPOLL_CTL_BATCH. If userland call epoll_ctl() with this
>> flag set, the meaning of last two arguments of epoll_ctl() change, .e.g:
>>
>>   struct batch_epoll_event batch_event[] = {
>>          {
>>               .fd = a_newsock_fd;
>>               .epoll_event = { ... };
>>          },
>>          ...
>>   };
>>
>>   ret = epoll_ctl(fd, EPOLL_CTL_ADD|EPOLL_CTL_BATCH, nr_batch_events,
>> batch_events);
>>
>
> I think it is good idea. Would you please implement a prototype and
> give some numbers? This kind of data may help selling this idea.
> Thanks.
>

Of course, I think that implementing them should not be a hard work :)

Em. I really do not know whether it is necessary to introduce to a new 
syscall here. An alternative solution to add new socket option to handle 
such batch requirement, so applications also can detect if kernel has 
this extended ability with a easy getsockopt() call.

Any way, I am going to try to write a prototype first.

Thanks

Yu
