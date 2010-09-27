Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0I0Qz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0I0Qz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:55:57 -0400
Date: Mon, 27 Sep 2010 18:51:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
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
Message-ID: <20100927165133.GA23535@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop> <1285250541.1837.95.camel@holzheu-laptop> <20100923171025.GA26623@redhat.com> <1285330688.2179.305.camel@holzheu-laptop> <20100926181127.GA26985@redhat.com> <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27, Martin Schwidefsky wrote:
>
> On Sun, 26 Sep 2010 20:11:27 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > No. Well yes, it is not accounted, but this is not because it is
> > kthread.
>
> We noticed that behavior with kernel threads but as you point out
> the problem is bigger than that.
>
> > It is very simple, currently linux accounts the exiting task's
> > utime and adds its to ->cutime _only_ if parent does do_wait().
> > If parent ignores SIGCHLD, the child reaps itself and it is not
> > accounted.
> >
> > I do not know why it was done this way, but I'm afraid we can't
> > change this historical behaviour.
>
> Why?

Please don't ask me ;) I was equally surprised when I studied this
code in the past.

> I would consider it to be a BUG() that the time is not accounted.
> Independent of the fact that a parent wants to see the SIGCHLD and
> the exit status of its child the process time of the child should be
> accounted, no?

I do not know. It doesn't look like a BUG(), I mean it looks as if
the code was intentionally written this way.

> And I'm not a particular fan of the "this has always
> been that way" reasoning.

Me too, but unfortunately it often happens, sometimes we can't improve
things just because we should not break existing programs.

Once again, don't get me wrong. Personally I agree, to me it makes
sense to move the "update parent's cxxx" code from wait_task_zombie()
to __exit_signal(), and account children unconditionally.

But I do not know who can approve this very much user-visible change.
Perhaps Roland.

> Got the part about self-reaping processes. But there is another issue:
> consider an exiting thread where the group leader is still active.
> The time for the thread will be added to the utime/stime fields in
> the signal structure.

(to clarify, s/group leader/last thread/)

> Taskstats will happily ignore that time while
> the group leader is still running.

Sorry. I didn't read the whole series and I forgot everything I knew
about taskstats. But I don't understand this "ignore" above, every
exiting thread calls taskstats_exit()->fill_pid()->bacct_add_tsk()
and reports ->ac_utime?

Never mind. You seem to want to update, say, cutime when a sub-thread
exits, before the whole process exits, right? Again, trivial to
implement but this is another user-visible change.

Oleg.

