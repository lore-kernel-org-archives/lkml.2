Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0F2R5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0F2R5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:57:07 -0400
Date: Tue, 29 Jun 2010 19:54:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100629175422.GB18440@redhat.com>
References: <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com> <20100624215702.GA21360@redhat.com> <20100625034105.GD2391@linux.vnet.ibm.com> <20100625095548.GA6292@redhat.com> <20100628234358.GJ2357@linux.vnet.ibm.com> <20100629130503.GA5237@redhat.com> <20100629153445.GC2765@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629153445.GC2765@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Paul E. McKenney wrote:
>
> On Tue, Jun 29, 2010 at 03:05:03PM +0200, Oleg Nesterov wrote:
> >
> > Paul, please let me know if I misunderstood your concerns, or if I missed
> > something.
>
> Thank you very much for laying this out completely!  I was having a hard
> time believing that it was OK to miss threads in the "ls /proc/2910/task"
> case.  But of course similar issues can arise when running "ls" on a
> directory with lots of files that are coming and going quickly in the
> meantime, I guess.

Yes. And again, even if 2910 is not the group leader and it is exiting,
"ls /proc/2910/task" will work because proc_task_readdir() akways starts
at 2910->group_leader == 2008.

It doesn't work only if proc_task_readdir() can't find its leader, in
this particular case this just means 2910 no longer exists, and thus
/proc/2910/ is dead even if we can still find this dentry.

> And if proc_task_fill_cache() fails, we can miss
> tasks as well, correct?

Well, yes and no.

Sure, if proc_task_fill_cache() fails we didn't reported all threads.
But if /bin/ls does readdir() again after that, proc_task_readdir()
tries to contunue starting from the last-pid-we-failed-to-report.
If there is no task with that pid, we start from the group_leader
and skip the number-of-already-reported-threads.

So, we have a lot of issues here, we can miss some thread because
"skip the number-of-already-reported-threads" can't be really accurate.


But, to clarify, this has almost nothing to do with the original problem.
Afaics, if we change first_tid() to use next_thread_careful() instead
of next_thread(), we close the pure-theoretical race with exec but that
is all. (and I am still not sure this race does exist, and even if it
does we can fix it without next_thread_careful).

> Given all this, I believe that your fix really does work.

Great. I'll send the patch once I inspect zap_threads() and
current_is_single_threaded() to figure out which changes they need.

Oleg.

