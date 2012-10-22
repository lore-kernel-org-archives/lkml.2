Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2JVXhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:37:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2JVXhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:37:00 -0400
Date: Mon, 22 Oct 2012 19:36:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/2] fix and improvements for percpu-rw-semaphores (was:
 brw_mutex: big read-write mutex)
In-Reply-To: <20121019192838.GM2518@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com>
 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ooooh. And I just noticed include/linux/percpu-rwsem.h which does
> > something similar. Certainly it was not in my tree when I started
> > this patch... percpu_down_write() doesn't allow multiple writers,
> > but the main problem it uses msleep(1). It should not, I think.
> > 
> > But. It seems that percpu_up_write() is equally wrong? Doesn't
> > it need synchronize_rcu() before "p->locked = false" ?
> > 
> > (add Mikulas)
> 
> Mikulas said something about doing an updated patch, so I figured I
> would look at his next version.
> 
> 							Thanx, Paul

The best ideas proposed in this thread are:

Using heavy/light barries by Lai Jiangshan. This fixes the missing barrier 
bug, removes the ugly test "#if defined(X86) ..." and makes the read path 
use no barrier instruction on all architectures.

Instead of rcu_read_lock, we can use rcu_read_lock_sched (or 
preempt_disable) - the resulting code is smaller. The critical section is 
so small that there is no problem disabling preemption.

I am sending these two patches. Linus, please apply them if there are no 
objections.

Mikulas
