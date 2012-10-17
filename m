Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2JQPHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab2JQPHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:07:53 -0400
Date: Wed, 17 Oct 2012 11:07:21 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
In-Reply-To: <507E48ED.8060809@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.1210171046130.26481@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
 <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
 <507E48ED.8060809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


On Wed, 17 Oct 2012, Lai Jiangshan wrote:

> On 10/17/2012 10:23 AM, Linus Torvalds wrote:
> > [ Architecture people, note the potential new SMP barrier! ]
> > 
> > On Tue, Oct 16, 2012 at 4:30 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> +       /*
> >> +        * The lock is considered unlocked when p->locked is set to false.
> >> +        * Use barrier prevent reordering of operations around p->locked.
> >> +        */
> >> +#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
> >> +       barrier();
> >> +#else
> >> +       smp_mb();
> >> +#endif
> >>         p->locked = false;
> > 
> > Ugh. The #if is too ugly to live.
> 
> Even the previous patch is applied, percpu_down_read() still
> needs mb() to pair with it.

percpu_down_read uses rcu_read_lock which should guarantee that memory 
accesses don't escape in front of a rcu-protected section.

If rcu_read_unlock has only an unlock barrier and not a full barrier, 
memory accesses could be moved in front of rcu_read_unlock and reordered 
with this_cpu_inc(*p->counters), but it doesn't matter because 
percpu_down_write does synchronize_rcu(), so it never sees these accesses 
halfway through.

> > This is a classic case of "people who write their own serialization
> > primitives invariably get them wrong". And this fix is just horrible,
> > and code like this should not be allowed.
> 
> One of the most major problems of 62ac665ff9fc07497ca524bd20d6a96893d11071 is that
> it is merged without Ackeds or Revieweds from Paul or Peter or someone else
> who are expert at synchronization/arch memory models.
> 
> I suggest any new synchronization should stay in -tip for 2 or more cycles
> before merged to mainline.

But the bug that this synchronization is fixing is quite serious (it 
causes random crashes when block size is being changed, the crash happens 
regularly at multiple important business sites) so it must be fixed soon 
and not wait half a year.

> Thanks,
> Lai

Mikulas
