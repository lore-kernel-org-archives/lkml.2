Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1HDOMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1HDOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:12:16 -0400
Date: Thu, 4 Aug 2011 10:12:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
Message-ID: <20110804141210.GA429@redhat.com>
References: <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com>
 <4E3902C7.9050907@cn.fujitsu.com>
 <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com>
 <4E391986.90108@cn.fujitsu.com>
 <20110803154533.GB32385@redhat.com>
 <20110803175101.GC32385@redhat.com>
 <CANejiEXAtzExExqmTXA=hmpGh8DVVo9ncbRMdkB+avq+G3LuqQ@mail.gmail.com>
 <4E39FD41.4090103@cn.fujitsu.com>
 <CANejiEVh4hvi5S18H7XHihxZt+JcRU7W5MGpQwQc_ZtiFCa2jw@mail.gmail.com>
 <4E3A4DF7.3020605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A4DF7.3020605@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:44:55PM +0800, Gui Jianfeng wrote:

[..]
> > oh, not related per your blktrace. so we have two problems here:
> > 1. fio doesn't dispatch request in 8ms.
> > 2. no close request preempt.
> 
> Yes, these're actual factors why performance is so bad.
> 
> > both looks quite wield. can you post a longer blktrace output, like
> > for one second? the piece is too short.
> 
> Attached.

Gui, few observations from you log file.

- preemption happened 1631 times and did not happen 527 times and idle
  timer fired.

- In some cases where preemption did not happen, next request seems to
  be too far away (more than CFQQ_CLOSE_THR=8K sectors).

- I noticed couple of cases where next request was with-in 8K distanace
  still preemption did not happen. This makes me curious. Can you please
  put some trace messages in should_preempt() and rq_close() call and see
  what's going on?

For example, following trace shows that next request is 5176 sector behind
the previous one completed. I am wondering why did preemption not take
place.

  8,0    0      606     2.751892651 16420  D   W 512146800 + 8 [fio]
  8,0    2      579     2.752127950     0  C   W 512146800 + 8 [0]

  8,0    0      609     2.752235995 16421  Q  WS 512141624 + 8 [fio]
  8,0    0      610     2.752238859 16421  G  WS 512141624 + 8 [fio]
  8,0    0      612     2.752243818 16421  I   W 512141624 + 8 [fio]
  8,0    0        0     2.752246262     0  m   N cfq16421S / insert_request
  8,0    0        0     2.752247729     0  m   N cfq16421S / add_to_rr
  8,0    2        0     2.759710295     0  m   N cfq idle timer fired

Putting some extra trace messages in CFQ might help here. BTW, which 
kernel version are you using? 3.0?

Thanks
Vivek
