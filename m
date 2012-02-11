Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2BKLfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 06:35:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:44468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2BKLfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 06:35:16 -0500
Message-ID: <4F36526B.7070809@kernel.dk>
Date: Sat, 11 Feb 2012 12:35:07 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
References: <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com> <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com> <20120208162925.GA19392@google.com> <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com> <20120209175948.GE19392@google.com> <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com> <20120209192431.GF19392@google.com> <20120209234844.GG19392@google.com> <CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com> <CANejiEVBd6eu8LwmhbMvQqMW4LqUh6F-5psyW0dVYU06WEJqBQ@mail.gmail.com> <20120211021724.GO19392@google.com>
In-Reply-To: <20120211021724.GO19392@google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-11 03:17, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 10, 2012 at 04:48:49PM +0800, Shaohua Li wrote:
>>>> Can you please test the following one?  It's probably the simplest
>>>> version w/o RCU and wq deferring.  RCUfying isn't too bad but I'm
>>>> still a bit hesitant because RCU coverage needs to be extended to
>>>> request_queue via conditional synchronize_rcu() in queue exit path
>>>> (can't enforce delayed RCU free on request_queues and unconditional
>>>> synchronize_rcu() may cause excessive delay during boot for certain
>>>> configurations).  It now can be done in the block core layer proper so
>>>> it shouldn't be as bad tho.  If this too flops, I'll get to that.
>>> doesn't work.
>> I added trace in the schedule_work code path of put_io_context, which
>> runs very rare. So it's not lock contention for sure.
>> Sounds the only difference between the good/bad cases is the good
>> case runs with rcu_lock_read/rcu_read_unlock. I also checked slab
>> info, the cfq related slab doesn't use too many memory, unlikely
>> because rcu latency uses too many memory.
> 
> Yeah, that makes much more sense.  It just isn't hot enough path for
> this sort of micro locking changes to matter.  I think the problem is
> that, after the change, the cfqq aren't being expired immediately on
> task exit.  ie. While moving the cic destruction to release path, I
> accidentally removed exit notification to cfq.  I'll come up with a
> fix.

Was just thinking about that last night, the missing slice expire on
task exit makes a LOT more sense than changed locking.

I'm pushing off what I have to Linus today, since I'll be gone skiing
next week. I will check email regularly and be able to apply patches and
so forth, just a heads up on availability.

-- 
Jens Axboe

