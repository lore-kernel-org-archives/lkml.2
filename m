Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab2JWUhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:37:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42218 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933836Ab2JWUg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:36:56 -0400
Date: Tue, 23 Oct 2012 13:29:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
Message-ID: <20121023202902.GJ2585@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com>
 <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
 <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <20121023165912.GA18712@redhat.com>
 <20121023180558.GF2585@linux.vnet.ibm.com>
 <20121023184123.GB24055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023184123.GB24055@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102320-5930-0000-0000-00000D5F98AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 08:41:23PM +0200, Oleg Nesterov wrote:
> On 10/23, Paul E. McKenney wrote:
> >
> >  * Note that this guarantee implies a further memory-ordering guarantee.
> >  * On systems with more than one CPU, when synchronize_sched() returns,
> >  * each CPU is guaranteed to have executed a full memory barrier since
> >  * the end of its last RCU read-side critical section
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Ah wait... I misread this comment.

And I miswrote it.  It should say "since the end of its last RCU-sched
read-side critical section."  So, for example, RCU-sched need not force
a CPU that is idle, offline, or (eventually) executing in user mode to
execute a memory barrier.  Fixed this.

> But this patch needs more? Or I misunderstood. There is no RCU unlock
> in percpu_up_read().
> 
> IOW. Suppose the code does
> 
> 	percpu_down_read();
> 	x = PROTECTED_BY_THIS_RW_SEM;
> 	percpu_up_read();
> 
> Withoit mb() the load above can be reordered with this_cpu_dec() in
> percpu_up_read().
> 
> However, we do not care if we can guarantee that the next
> percpu_down_write() can not return (iow, the next "write" section can
> not start) until this load is complete.
> 
> And I _think_ that another synchronize_sched() in percpu_down_write()
> added by this patch should work.
> 
> But, "since the end of its last  RCU read-side critical section"
> does not look enough.
> 
> Or I misundersood you/Mikulas/both ?

I clearly need to look more carefully at Mikulas's code...

							Thanx, Paul

