Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab0I1HJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:09:16 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:56897 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0I1HJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:09:14 -0400
Date: Tue, 28 Sep 2010 09:09:04 +0200
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
        linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20100928090904.7edc7c02@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100927165133.GA23535@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	<1285250541.1837.95.camel@holzheu-laptop>
	<20100923171025.GA26623@redhat.com>
	<1285330688.2179.305.camel@holzheu-laptop>
	<20100926181127.GA26985@redhat.com>
	<20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	<20100927165133.GA23535@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 18:51:33 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 09/27, Martin Schwidefsky wrote:
> >
> > On Sun, 26 Sep 2010 20:11:27 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > No. Well yes, it is not accounted, but this is not because it is
> > > kthread.
> >
> > We noticed that behavior with kernel threads but as you point out
> > the problem is bigger than that.
> >
> > > It is very simple, currently linux accounts the exiting task's
> > > utime and adds its to ->cutime _only_ if parent does do_wait().
> > > If parent ignores SIGCHLD, the child reaps itself and it is not
> > > accounted.
> > >
> > > I do not know why it was done this way, but I'm afraid we can't
> > > change this historical behaviour.
> >
> > Why?
> 
> Please don't ask me ;) I was equally surprised when I studied this
> code in the past.

But I do ask >:-)
 
> > I would consider it to be a BUG() that the time is not accounted.
> > Independent of the fact that a parent wants to see the SIGCHLD and
> > the exit status of its child the process time of the child should be
> > accounted, no?
> 
> I do not know. It doesn't look like a BUG(), I mean it looks as if
> the code was intentionally written this way.

Well, one thing to consider is the fact that the exiting process can
not the process accounting by itself. While a process is still running
it uses cpu which has to bet accounted to cstime of the parent.
So logically some other process has to do the cutime/cstime update.

> > And I'm not a particular fan of the "this has always
> > been that way" reasoning.
> 
> Me too, but unfortunately it often happens, sometimes we can't improve
> things just because we should not break existing programs.
> 
> Once again, don't get me wrong. Personally I agree, to me it makes
> sense to move the "update parent's cxxx" code from wait_task_zombie()
> to __exit_signal(), and account children unconditionally.
> 
> But I do not know who can approve this very much user-visible change.
> Perhaps Roland.

I wonder which user space tool would break.

> > Got the part about self-reaping processes. But there is another issue:
> > consider an exiting thread where the group leader is still active.
> > The time for the thread will be added to the utime/stime fields in
> > the signal structure.
> 
> (to clarify, s/group leader/last thread/)
> 
> > Taskstats will happily ignore that time while
> > the group leader is still running.
> 
> Sorry. I didn't read the whole series and I forgot everything I knew
> about taskstats. But I don't understand this "ignore" above, every
> exiting thread calls taskstats_exit()->fill_pid()->bacct_add_tsk()
> and reports ->ac_utime?
> 
> Never mind. You seem to want to update, say, cutime when a sub-thread
> exits, before the whole process exits, right? Again, trivial to
> implement but this is another user-visible change.

No, not necessarily. But to get to 100% coverage of the cpu time we
need to be able to "find" the time. Currently the time of already
exited threads of a thread group is invisible via the taskstats
interface. New taskstats fields would do for this particular problem.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

