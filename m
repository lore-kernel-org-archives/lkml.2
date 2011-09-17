Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1IQMvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 08:51:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab1IQMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 08:51:11 -0400
Message-ID: <4E749937.5090803@colorfullife.com>
Date: Sat, 17 Sep 2011 14:57:27 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
References: <20110914133034.687048806@chello.nl> <20110914133750.831707072@chello.nl> <1316176490.10174.22.camel@twins>
In-Reply-To: <1316176490.10174.22.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 02:34 PM, Peter Zijlstra wrote:
> So while initially I thought the sem patch was busted, it turns out this
> one is.
>
> Thomas managed to spot the race:
>
>    Task-0			Task-1
>
> futex_wait()
>    queue_me()
>
> 				futex_wake()
> 				  wake_list_add();
> 				  __unqueue_futex();
> 				    plist_del();
>    if (!plist_node_empty())
>    __set_current_state(TASK_RUNNNIG);
>
> 				  wake_up_list();
> 				    /* waking an already running task-0 */
>
>
> I guess the biggest question is, do we care? Ideally everything should
> be able to deal with spurious wakeups, although we generally try to
> avoid them.
>
>
The sem patch also causes such wakeups:

  Task-0                Task-1
  semtimedop()
   schedule_timeout()

                             semtimedop()
                             wake_list_add();
                             q->status = 0;
<Timeout>
   schedule_timeout() returns
   if (q->status==0)
     return;
  semtimedop() returns

  random user space/kernel space code

                             spin_unlock();
                             wake_up_list();

It's a rare event, but that does happen.
Which means:
How do we verify that everything is able to deal with spurious wakeups?

--
     Manfred
