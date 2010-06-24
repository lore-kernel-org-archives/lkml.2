Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0FXVPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0FXVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:15:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: paulmck@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
In-Reply-To: Paul E. McKenney's message of  Thursday, 24 June 2010 11:07:26 -0700 <20100624180726.GK2373@linux.vnet.ibm.com>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621205128.GI2354@linux.vnet.ibm.com>
	<20100622212357.GA19670@redhat.com>
	<20100622221226.GP2290@linux.vnet.ibm.com>
	<20100623152421.GA8445@redhat.com>
	<20100624180726.GK2373@linux.vnet.ibm.com>
X-Shopping-List: (1) Aeronautical adhesives
   (2) Erratic riot concussions
   (3) Terrific abolitionists
Message-Id: <20100624211446.5713743188@magilla.sf.frob.com>
Date: Thu, 24 Jun 2010 14:14:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First, what "bad things" can happen to a reader scanning a thread
> group?
> 
> 1.	The thread-group leader might do exec(), destroying the old
> 	list and forming a new one.  In this case, we want any readers
> 	to stop scanning.

This doesn't do anything different (for these concerns) from just all the
other threads happening to exit right before the exec.  There is no
"destroying the old" and "forming the new", it's just that all the other
threads are convinced to die now.  There is no problem here.

> 2.	Some other thread might do exec(), destroying the old list and
> 	forming a new one.  In this case, we also want any readers to
> 	stop scanning.

Again, the list is not really destroyed, just everybody dies.  What is
different here is that ->group_leader changes.  This is the only time
that ever happens.  Moreover, it's the only time that a task that was
previously pointed to by any ->group_leader can be reaped before the
rest of the group has already been reaped first (and thus the
thread_group made a singleton).

> 3.	The thread-group leader might do pthread_exit(), removing itself
> 	from the thread group -- and might do so while the hapless reader
> 	is referencing that thread.

This is called the delay_group_leader() case.  It doesn't happen in a
way that has the problems you are concerned with.  The group_leader
remains in EXIT_ZOMBIE state and can't be reaped until all the other
threads have been reaped.  There is no time at which any thread in the
group is in any hashes or accessible by any means after the (final)
group_leader is reaped.

> 4.	Some other thread might do pthread_exit(), removing itself
> 	from the thread group, and again might do so while the hapless
> 	reader is referencing that thread.  In this case, we want
> 	the hapless reader to continue scanning the remainder of the
> 	thread group.

This is the most normal case (and #1 is effectively just this repeated
by every thread in parallel).

> 5.	The thread-group leader might do exit(), destroying the old
> 	list without forming a new one.  In this case, we want any
> 	readers to stop scanning.

All this means is everybody is convinced to die, and the group_leader
dies too.  It is not discernibly different from #6.

> 6.	Some other thread might do exit(), destroying the old list
> 	without forming a new one.  In this case, we also want any
> 	readers to stop scanning.

This just means everybody is convinced to die and is not materially
different from each individual thread all happening to die at the same
time.  

You've described all these cases as "we want any readers to stop
scanning".  That is far too strong, and sounds like some kind of
guaranteed synchronization, which does not and need not exist.  Any
reader that needs a dead thread to be off the list holds siglock
and/or tasklist_lock.  For the casual readers that only use
rcu_read_lock, we only "want any readers' loops eventually to
terminate and never to dereference stale pointers".  That's why
normal RCU listiness is generally fine.

The only problem we have is in #2.  This is only a problem because
readers' loops may be using the old ->group_leader pointer as the
anchor for their circular-list round-robin loop.  Once the former
leader is removed from the list, that loop termination condition can
never be met.


Thanks,
Roland
