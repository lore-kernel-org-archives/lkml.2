Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2GFJiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:38:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47027 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2GFJio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:38:44 -0400
Message-ID: <4FF6B20E.7000402@gmail.com>
Date: Fri, 06 Jul 2012 17:38:22 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Changli Gao <xiaosuo@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidel@xmailserver.org
Subject: Re: [RFC] Introduce to batch variants of accept() and epoll_ctl()
 syscall
References: <4FDAB652.6070201@gmail.com>  <CABa6K_H3NrvvZ3Bh7JqsR6h33BSqYPBenUDG5Yt1U=2VvP700g@mail.gmail.com>  <4FDACA26.70004@gmail.com> <1339750318.7491.70.camel@edumazet-glaptop>
In-Reply-To: <1339750318.7491.70.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年06月15日 16:51, Eric Dumazet 写道:
> On Fri, 2012-06-15 at 13:37 +0800, Li Yu wrote:
>
>> Of course, I think that implementing them should not be a hard work :)
>>
>> Em. I really do not know whether it is necessary to introduce to a new
>> syscall here. An alternative solution to add new socket option to handle
>> such batch requirement, so applications also can detect if kernel has
>> this extended ability with a easy getsockopt() call.
>>
>> Any way, I am going to try to write a prototype first.
>
> Before that, could you post the result of "perf top", or "perf
> record ...;perf report"
>

Sorry for I just have time to write a benchmark to reproduce this
problem on my test bed, below are results of "perf record -g -C 0".
kernel is 3.4.0:

Events: 7K cycles
+  54.87%  swapper  [kernel.kallsyms]  [k] poll_idle
-   3.10%   :22984  [kernel.kallsyms]  [k] _raw_spin_lock
    - _raw_spin_lock
       - 64.62% sch_direct_xmit
            dev_queue_xmit
            ip_finish_output
            ip_output
          - ip_local_out
             + 49.48% ip_queue_xmit
             + 37.48% ip_build_and_send_pkt
             + 13.04% ip_send_skb

I can not reproduce complete same high CPU usage on my testing 
environment, but top show that it has similar ratio of sys% and
si% on one CPU:

Tasks: 125 total,   2 running, 123 sleeping,   0 stopped,   0 zombie
Cpu0  :  1.0%us, 30.7%sy,  0.0%ni, 18.8%id,  0.0%wa,  0.0%hi, 49.5%si, 
0.0%st

Well, it seem that I must acknowledge I was wrong here. however,
I recall that I indeed ever encountered this in another benchmarking a
small packets performance.

I guess, this is since TX softirq and syscall context contend same lock
in sch_direct_xmit(), is this right?

thanks

Yu

>>   The top shows the kernel is most cpu hog, the testing is simple,
>> just a accept() -> epoll_ctl(ADD) loop, the ratio of cpu util sys% to
>> si% is about 2:5.
>
> This ratio is not meaningful, if we dont know where time is spent.
>
>
> I doubt epoll_ctl(ADD) is a problem here...
>
> If it is, batching the fds wont speed the thing anyway...
>
> I believe accept() is the problem here, because it contends with the
> softirq processing the tcp session handshake.
>
>
>
>


