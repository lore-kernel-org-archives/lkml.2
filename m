Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1IPMfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:35:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1IPMfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:35:08 -0400
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Fri, 16 Sep 2011 14:34:50 +0200
In-Reply-To: <20110914133750.831707072@chello.nl>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.831707072@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316176490.10174.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 15:30 +0200, Peter Zijlstra wrote:
> @@ -964,6 +961,7 @@ futex_wake(u32 __user *uaddr, unsigned i
>         struct futex_q *this, *next;
>         struct plist_head *head;
>         union futex_key key = FUTEX_KEY_INIT;
> +       WAKE_LIST(wake_list);
>         int ret;
>  
>         if (!bitset)
> @@ -988,7 +986,7 @@ futex_wake(u32 __user *uaddr, unsigned i
>                         if (!(this->bitset & bitset))
>                                 continue;
>  
> -                       wake_futex(this);
> +                       wake_futex(&wake_list, this);
>                         if (++ret >= nr_wake)
>                                 break;
>                 }
> @@ -996,6 +994,8 @@ futex_wake(u32 __user *uaddr, unsigned i
>  
>         spin_unlock(&hb->lock);
>         put_futex_key(&key);
> +
> +       wake_up_list(&wake_list, TASK_NORMAL);
>  out:
>         return ret;
>  } 

So while initially I thought the sem patch was busted, it turns out this
one is.

Thomas managed to spot the race:

  Task-0			Task-1

futex_wait()
  queue_me()

				futex_wake()
				  wake_list_add();
				  __unqueue_futex();
				    plist_del();
  if (!plist_node_empty())
  __set_current_state(TASK_RUNNNIG);

				  wake_up_list();
				    /* waking an already running task-0 */


I guess the biggest question is, do we care? Ideally everything should
be able to deal with spurious wakeups, although we generally try to
avoid them.


