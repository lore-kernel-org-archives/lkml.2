Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab2EKTBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:01:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:16456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab2EKTBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165083939"
Subject: Re: [PATCH v2 2/4] coredump: ensure the fpu state is flushed for
 proper multi-threaded core dump
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Date: Fri, 11 May 2012 12:05:21 -0700
In-Reply-To: <20120511165128.GA21511@redhat.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
	 <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120511165128.GA21511@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336763121.12610.13.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 18:51 +0200, Oleg Nesterov wrote:
> On 05/10, Suresh Siddha wrote:
> >
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1930,8 +1930,21 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
> >  		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
> >  	up_write(&mm->mmap_sem);
> >
> > -	if (core_waiters > 0)
> > +	if (core_waiters > 0) {
> > +		struct core_thread *ptr;
> > +
> >  		wait_for_completion(&core_state->startup);
> > +		/*
> > +		 * Wait for all the threads to become inactive, so that
> > +		 * all the thread context (extended register state, like
> > +		 * fpu etc) gets copied to the memory.
> > +		 */
> > +		ptr = core_state->dumper.next;
> > +		while (ptr != NULL) {
> > +			wait_task_inactive(ptr->task, 0);
> > +			ptr = ptr->next;
> > +		}
> > +	}
> 
> OK, but this adds the unnecessary penalty if we are not going to dump
> the core.

If we are not planning to dump the core, then we will not be in the
coredump_wait() right?

coredump_wait() already waits for all the threads to respond (referring
to the existing wait_for_completion() line before the proposed
addition). wait_for_completion() already ensures that the other threads
are close to schedule() with TASK_UNINTERRUPTIBLE, so most of the
penalty is already taken and in most cases, wait_task_inactive() will
return success immediately. And in the corner cases (where we hit the
bug_on before) we will spin a bit now while the other thread is still on
the rq.

> Perhaps it makes sense to create a separate helper and call it from
> do_coredump() right before "retval = binfmt->core_dump(&cprm)" ?

I didn't want to spread the core dump waits at multiple places.
coredump_wait() seems to be the natural place, as we are already waiting
for other threads to join.

thanks,
suresh

