Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab0JEI7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0JEI7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:59:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: holzheu@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
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
In-Reply-To: Michael Holzheu's message of  Thursday, 30 September 2010 15:47:40 +0200 <1285854460.1856.14.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
	<1285250541.1837.95.camel@holzheu-laptop>
	<20100923171025.GA26623@redhat.com>
	<1285330688.2179.305.camel@holzheu-laptop>
	<20100926181127.GA26985@redhat.com>
	<20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	<20100927165133.GA23535@redhat.com>
	<20100929191916.21E1840038@magilla.sf.frob.com>
	<1285854460.1856.14.camel@holzheu-laptop>
Emacs: it's all fun and games, until somebody tries to edit a file.
Message-Id: <20101005085751.4490A401B2@magilla.sf.frob.com>
Date: Tue,  5 Oct 2010 01:57:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks! That information was missing! Although still for me it not seems
> to be a good decision to do it that way. Because of that it currently is
> not possible to evaluate all consumed CPU time by looking at the current
> processes. Time can simply disappear.

I agree that it seems dubious.  I don't know why that decision was made in
POSIX, but that's how it is.  Anyway, POSIX only constrains what we report
in the POSIX calls, i.e. getrusage, times, waitid, SIGCHLD siginfo_t.
Nothing says we can't track more information and make it accessible in
other ways on Linux.

> What about adding a new set of CPU time fields (e.g. cr-times) for the
> cumulative "autoreap" children times to the signal struct and export
> them via taskstats?

I don't have a particular opinion about the details of how you export the
information.  Something generally along those lines certainly sounds
reasonable to me.

> Then the following set of CPU times will give a complete picture (I also
> added steal time (st) that is currently not accounted in Linux per
> task):
> 
> * task->(u/s/st-time):
>   Time that has been consumed by task itself

There is also "gtime", "guest time" when the task is a kvm vcpu.

There is also "sched time" (task->se.sum_exec_runtime), which is
all states of task time, tracked by a different method than [usg]time.

> * task->signal->(c-u/s/st-time):
>   Time that has been consumed by dead children of process where parent
>   has done a sys_wait()

Also cgtime (to gtime as cutime is to utime).

> * task->signal->(u/s/st-time):
>   Time that has been consumed by dead threads of thread group of process
>   - NEW: Has to be exported via taskstats

Also gtime here.  These are reported as part of the aggregate process times
that include both live and dead threads, but not distinguished.

> * task->signal->(cr-u/s/st-time):
>   Time that has been consumed by dead children that reaped 
>   themselves, because parent ignored SIGCHLD or has set SA_NOCLDWAIT
>   - NEW: Fields have to be added to signal struct
>   - NEW: Has to be exported via taskstats

Note that there are other stats aside from times that are treated the same
way (c{min,maj}_flt, cn{v,iv}csw, c{in,ou}block, cmaxrss, and io accounting).

What probably makes sense is to move all those cfoo fields from
signal_struct into foo fields in a new struct, and then signal_struct can
have "struct child_stats reaped_children, ignored_children" or whatnot.


Thanks,
Roland
