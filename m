Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935378Ab2JXSmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429Ab2JXSmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:42:19 -0400
Date: Wed, 24 Oct 2012 20:43:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
Message-ID: <20121024184311.GA5025@redhat.com>
References: <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com> <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com> <20121024161638.GA2465@linux.vnet.ibm.com> <20121024171855.GA22371@redhat.com> <20121024182005.GF2465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024182005.GF2465@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Paul E. McKenney wrote:
>
> On Wed, Oct 24, 2012 at 07:18:55PM +0200, Oleg Nesterov wrote:
> > On 10/24, Paul E. McKenney wrote:
> > >
> > > static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> > > {
> > > 	/*
> > > 	 * Decrement our count, but protected by RCU-sched so that
> > > 	 * the writer can force proper serialization.
> > > 	 */
> > > 	rcu_read_lock_sched();
> > > 	this_cpu_dec(*p->counters);
> > > 	rcu_read_unlock_sched();
> > > }
> >
> > Yes, the explicit lock/unlock makes the new assumptions about
> > synchronize_sched && barriers unnecessary. And iiuc this could
> > even written as
> >
> > 	rcu_read_lock_sched();
> > 	rcu_read_unlock_sched();
> >
> > 	this_cpu_dec(*p->counters);
>
> But this would lose the memory barrier that is inserted by
> synchronize_sched() after the CPU's last RCU-sched read-side critical
> section.

How? Afaics there is no need to synchronize with this_cpu_dec(), its
result was already seen before the 2nd synchronize_sched() was called
in percpu_down_write().

IOW, this memory barrier is only needed to synchronize with memory
changes inside down_read/up_read.

To clarify, of course I do not suggest to write is this way. I am just
trying to check my understanding.

Oleg.

