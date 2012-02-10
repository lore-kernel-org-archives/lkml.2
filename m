Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab2BJIsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 03:48:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54484 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2BJIsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 03:48:50 -0500
MIME-Version: 1.0
In-Reply-To: <CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com>
References: <4F315113.5010804@kernel.dk>
	<CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
	<20120207164735.GH21292@google.com>
	<CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
	<CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
	<20120208162925.GA19392@google.com>
	<CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
	<20120209175948.GE19392@google.com>
	<CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
	<20120209192431.GF19392@google.com>
	<20120209234844.GG19392@google.com>
	<CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com>
Date: Fri, 10 Feb 2012 16:48:49 +0800
X-Google-Sender-Auth: N83mqzb9XIe8pdqL2x-Ou6YvJh0
Message-ID: <CANejiEVBd6eu8LwmhbMvQqMW4LqUh6F-5psyW0dVYU06WEJqBQ@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/10 Shaohua Li <shli@kernel.org>:
> 2012/2/10 Tejun Heo <tj@kernel.org>:
>> Hello, Shaohua.
>>
>> Can you please test the following one?  It's probably the simplest
>> version w/o RCU and wq deferring.  RCUfying isn't too bad but I'm
>> still a bit hesitant because RCU coverage needs to be extended to
>> request_queue via conditional synchronize_rcu() in queue exit path
>> (can't enforce delayed RCU free on request_queues and unconditional
>> synchronize_rcu() may cause excessive delay during boot for certain
>> configurations).  It now can be done in the block core layer proper so
>> it shouldn't be as bad tho.  If this too flops, I'll get to that.
> doesn't work.
I added trace in the schedule_work code path of put_io_context, which
runs very rare. So it's not lock contention for sure.
Sounds the only difference between the good/bad cases is the good
case runs with rcu_lock_read/rcu_read_unlock. I also checked slab
info, the cfq related slab doesn't use too many memory, unlikely
because rcu latency uses too many memory.
