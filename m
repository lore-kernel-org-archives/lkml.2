Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2JRWfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:35:25 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49565 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab2JRWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:35:22 -0400
Date: Thu, 18 Oct 2012 15:35:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, oleg@redhat.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121018223517.GQ13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
 <20121018211434.GI13370@google.com>
 <20121018222155.GB6223@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018222155.GB6223@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Thu, Oct 18, 2012 at 03:21:55PM -0700, Matt Helsley wrote:
> > Hmmm?  Nothing prevents kthreads from being moved around.  We only
> > recently added the restriction to prevent migration of the kthreadd
> > (the one which creates other kthreads).  You can reproduce it with
> > khungtask or any other !freezable kthreads.
> 
> Ok. I don't immmediately see why that'd be a good idea but it's
> possible..

Beats me too.  There were talks about restricting all kthreads from
being moved out of the root cgroup.  Dunno.  Maybe.

> <off_topic>
> "Whoever" did the freeze needs a way to "lock" access to the freezer state,
> change the freezer state itself, do something (e.g. CRIU) which relies on
> the state not changing, and then release the lock. Plus the lock has to be
> released by the kernel if "Whoever" dies without the chance to release it.
> So I was thinking who holds the lock and its lifetime could be represented
> in userspace by file descriptor(s).
> </off_topic>

Long term, I don't think it's feasible to continue to use cgroup
kernel interface as the multiplexing layer among different users.
cgroup core simply doesn't have enough context or infrastructure to
support such usages.  It's somewhere between being a pure interface to
the provided kernel feature and fully multiplexed interface which
userland applications can depend on for arbitration.  It tries to have
the appearance of the latter but fails.

I think the only sane way would be having a userland arbitrator which
owns the kernel interface to itself and makes policy decisions from
userland clients and configures cgroup accordingly.

> > As for CRIU, it isn't using cgroup freezer at the moment because
> > frozen tasks can't be ptraced currently.  Something I'm hoping to
> > change but not sure when it can be done.
> 
> OK, but that doesn't mean the frozen nature of the task list itself
> won't be useful in the future.

I think that should be solved via userland policies rather than
depending on this accidental cgroup_freezer feature.

Thanks.

-- 
tejun
