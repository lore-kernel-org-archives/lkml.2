Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2BMBex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 20:34:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49442 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2BMBew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 20:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120211021724.GO19392@google.com>
References: <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
	<CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
	<20120208162925.GA19392@google.com>
	<CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
	<20120209175948.GE19392@google.com>
	<CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
	<20120209192431.GF19392@google.com>
	<20120209234844.GG19392@google.com>
	<CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com>
	<CANejiEVBd6eu8LwmhbMvQqMW4LqUh6F-5psyW0dVYU06WEJqBQ@mail.gmail.com>
	<20120211021724.GO19392@google.com>
Date: Mon, 13 Feb 2012 09:34:51 +0800
X-Google-Sender-Auth: fTqolyR3uS1fm2SoT-yrNq2byPk
Message-ID: <CANejiEVQav8mtQHD0FETxo1-Zc7exMyb6ecjrAzdZWw68OkTug@mail.gmail.com>
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

2012/2/11 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Fri, Feb 10, 2012 at 04:48:49PM +0800, Shaohua Li wrote:
>> >> Can you please test the following one?  It's probably the simplest
>> >> version w/o RCU and wq deferring.  RCUfying isn't too bad but I'm
>> >> still a bit hesitant because RCU coverage needs to be extended to
>> >> request_queue via conditional synchronize_rcu() in queue exit path
>> >> (can't enforce delayed RCU free on request_queues and unconditional
>> >> synchronize_rcu() may cause excessive delay during boot for certain
>> >> configurations).  It now can be done in the block core layer proper so
>> >> it shouldn't be as bad tho.  If this too flops, I'll get to that.
>> > doesn't work.
>> I added trace in the schedule_work code path of put_io_context, which
>> runs very rare. So it's not lock contention for sure.
>> Sounds the only difference between the good/bad cases is the good
>> case runs with rcu_lock_read/rcu_read_unlock. I also checked slab
>> info, the cfq related slab doesn't use too many memory, unlikely
>> because rcu latency uses too many memory.
>
> Yeah, that makes much more sense.  It just isn't hot enough path for
> this sort of micro locking changes to matter.  I think the problem is
> that, after the change, the cfqq aren't being expired immediately on
> task exit.  ie. While moving the cic destruction to release path, I
> accidentally removed exit notification to cfq.  I'll come up with a
> fix.
ah, I felt a little strange looking at exit_io_context, but didn't realize
the exit notification is removed (confused by put_io_context). This
makes a lot of sense. Good catch!
