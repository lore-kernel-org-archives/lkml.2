Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965830Ab2EOR7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:59:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:15896 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab2EOR7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153288721"
Subject: Re: [PATCH v2 2/4] coredump: ensure the fpu state is flushed for
 proper multi-threaded core dump
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, torvalds@linux-foundation.org
Cc: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Date: Tue, 15 May 2012 11:03:33 -0700
In-Reply-To: <20120513161117.GA6684@redhat.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
	 <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120511165128.GA21511@redhat.com>
	 <1336763121.12610.13.camel@sbsiddha-desk.sc.intel.com>
	 <20120513161117.GA6684@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337105014.12610.81.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 18:11 +0200, Oleg Nesterov wrote:
> On 05/11, Suresh Siddha wrote:
> >
> > On Fri, 2012-05-11 at 18:51 +0200, Oleg Nesterov wrote:
> > > On 05/10, Suresh Siddha wrote:
> > > >
> > > > --- a/fs/exec.c
> > > > +++ b/fs/exec.c
> > > > @@ -1930,8 +1930,21 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
> > > >  		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
> > > >  	up_write(&mm->mmap_sem);
> > > >
> > > > -	if (core_waiters > 0)
> > > > +	if (core_waiters > 0) {
> > > > +		struct core_thread *ptr;
> > > > +
> > > >  		wait_for_completion(&core_state->startup);
> > > > +		/*
> > > > +		 * Wait for all the threads to become inactive, so that
> > > > +		 * all the thread context (extended register state, like
> > > > +		 * fpu etc) gets copied to the memory.
> > > > +		 */
> > > > +		ptr = core_state->dumper.next;
> > > > +		while (ptr != NULL) {
> > > > +			wait_task_inactive(ptr->task, 0);
> > > > +			ptr = ptr->next;
> > > > +		}
> > > > +	}

Linus, are you ok with this?

> > and in most cases, wait_task_inactive() will
> > return success immediately.
> 
> I agree. Still, we add the O(n) loop which needs task_rq_lock() at least.

yeah I am not too happy with it. But we have only two choices and I
presented both of them.

1. What I do in this patch. Wait for all the threads to become inactive
so that core dumping thread can proceed with the dump operation.

2. call the equivalent of prepare_to_copy() in exit_mm() when the
mm->core_state is set, so that each thread's latest state is flushed to
the memory before we notify the main thread to start the core dump. You
and I think even Linus didn't like it.

May be there is a third one, which I don't want to pursue. using
finish_task_switch() to notify the main-core dumping thread that all the
other threads are now inactive. But adding the core-dump related check
in the hot task switch path is probably not a good idea :(

Given that the process exit with a signal leading to coredump is not a
common thing, we can probably live with option-1.

> I believe the patch is correct.
> 

Oleg, Can I treat this as your Ack for this patch?

thanks,
suresh

