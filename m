Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab0I0NnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:43:06 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46606 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab0I0NnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:43:04 -0400
Date: Mon, 27 Sep 2010 15:42:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100926181127.GA26985@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
 <1285250541.1837.95.camel@holzheu-laptop>
 <20100923171025.GA26623@redhat.com>
 <1285330688.2179.305.camel@holzheu-laptop>
 <20100926181127.GA26985@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010 20:11:27 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Hi,
> 
> On 09/24, Michael Holzheu wrote:
> >
> > On Thu, 2010-09-23 at 19:10 +0200, Oleg Nesterov wrote:
> > >
> > > On 09/23, Michael Holzheu wrote:
> > > >
> > > > Currently there are code pathes (e.g. for kthreads) where the consumed
> > > > CPU time is not accounted to the parents cumulative counters.
> > >
> > > Could you explain more?
> >
> > I think one place was "khelper" (kmod.c). It is created with
> > kernel_thread() and it exits without having accounted the times with
> > sys_wait() to the parent's ctimes
> 
> No. Well yes, it is not accounted, but this is not because it is
> kthread.

We noticed that behavior with kernel threads but as you point out
the problem is bigger than that.
 
> To simplify the discussion, lets talk about utime/cutime only,
> and lets forget about the multithreading.
> 
> It is very simple, currently linux accounts the exiting task's
> utime and adds its to ->cutime _only_ if parent does do_wait().
> If parent ignores SIGCHLD, the child reaps itself and it is not
> accounted.
> 
> I do not know why it was done this way, but I'm afraid we can't
> change this historical behaviour.

Why? I would consider it to be a BUG() that the time is not accounted.
Independent of the fact that a parent wants to see the SIGCHLD and
the exit status of its child the process time of the child should be
accounted, no? And I'm not a particular fan of the "this has always
been that way" reasoning.

> > Ok, the problem is that I did not consider exiting threads that are no
> > thread group leaders. When they exit the ctime of the parent is not
> > updated. Instead the time is accumulated in the signal struct.
> 
> I think I am a bit confused, but see above. With or without threads
> the whole process can exit without accounting.

Got the part about self-reaping processes. But there is another issue:
consider an exiting thread where the group leader is still active.
The time for the thread will be added to the utime/stime fields in
the signal structure. Taskstats will happily ignore that time while
the group leader is still running.

Please keep in mind that we want to get to a point where it is
possible to get a 100% coverage of cpu cycles in the last snapshot
cycle through the taskstats interface. Otherwise the precise top
would not be very precise ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

