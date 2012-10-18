Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2JRXsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:48:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34809 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2JRXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:48:04 -0400
Date: Thu, 18 Oct 2012 16:47:26 -0700
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@linux.vnet.ibm.com>, rjw@sisk.pl, oleg@redhat.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121018234726.GC6223@us.ibm.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
 <20121018211434.GI13370@google.com>
 <20121018222155.GB6223@us.ibm.com>
 <20121018223517.GQ13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018223517.GQ13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101823-7606-0000-0000-0000049F1EDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:35:17PM -0700, Tejun Heo wrote:
> Hello, Matt.
> 
> On Thu, Oct 18, 2012 at 03:21:55PM -0700, Matt Helsley wrote:
> > > Hmmm?  Nothing prevents kthreads from being moved around.  We only
> > > recently added the restriction to prevent migration of the kthreadd
> > > (the one which creates other kthreads).  You can reproduce it with
> > > khungtask or any other !freezable kthreads.
> > 
> > Ok. I don't immmediately see why that'd be a good idea but it's
> > possible..
> 
> Beats me too.  There were talks about restricting all kthreads from
> being moved out of the root cgroup.  Dunno.  Maybe.
> 
> > <off_topic>
> > "Whoever" did the freeze needs a way to "lock" access to the freezer state,
> > change the freezer state itself, do something (e.g. CRIU) which relies on
> > the state not changing, and then release the lock. Plus the lock has to be
> > released by the kernel if "Whoever" dies without the chance to release it.
> > So I was thinking who holds the lock and its lifetime could be represented
> > in userspace by file descriptor(s).
> > </off_topic>
> 
> Long term, I don't think it's feasible to continue to use cgroup
> kernel interface as the multiplexing layer among different users.
> cgroup core simply doesn't have enough context or infrastructure to
> support such usages.  It's somewhere between being a pure interface to
> the provided kernel feature and fully multiplexed interface which
> userland applications can depend on for arbitration.  It tries to have
> the appearance of the latter but fails.
> 
> I think the only sane way would be having a userland arbitrator which
> owns the kernel interface to itself and makes policy decisions from
> userland clients and configures cgroup accordingly.

OK -- yeah, solving the arbitration issue in userspace might be best.

> 
> > > As for CRIU, it isn't using cgroup freezer at the moment because
> > > frozen tasks can't be ptraced currently.  Something I'm hoping to
> > > change but not sure when it can be done.
> > 
> > OK, but that doesn't mean the frozen nature of the task list itself
> > won't be useful in the future.
> 
> I think that should be solved via userland policies rather than
> depending on this accidental cgroup_freezer feature.

It's not accidental -- it *was an intended feature*:

  22 # This bash script tests freezer code by starting a long sleep process.
  23 # The sleep process is frozen. We then move the sleep process to a THAWED
  24 # cgroup. We expect moving the sleep process to fail.

( This atrocious link is the easiest way to see the testcase:
http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=blob;f=testcases/kernel/controllers/freezer/freeze_move_thaw.sh;h=b2d5a83506a8425b117be9ff775d9f73d2d58393;hb=0436176dbfe6fdaaf97590d2356eb23d2739b2c2
)

It was intended for something very much like the CRIU case I mentioned
:).

Cheers,
	-Matt Helsley

