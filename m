Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2JRVOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:14:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38093 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2JRVOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:14:39 -0400
Date: Thu, 18 Oct 2012 14:14:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, oleg@redhat.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121018211434.GI13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017191606.GA6223@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Wed, Oct 17, 2012 at 12:16:06PM -0700, Matt Helsley wrote:
> > * Unfreezable kernel tasks don't prevent a cgroup from transitioning
> >   into FROZEN from FREEZING.  There's nothing userland can do with or
> >   about such tasks.
> 
> Seems like a non-problem. Do you have a testcase showing how kernel
> threads prevent cgroups that should be freezable from being frozen?
> It used to be that you couldn't move kernel threads out of the root
> cgroup and the root cgroup was not freezable. So this was never a
> problem before. Is there some change here that I'm unaware of?

Hmmm?  Nothing prevents kthreads from being moved around.  We only
recently added the restriction to prevent migration of the kthreadd
(the one which creates other kthreads).  You can reproduce it with
khungtask or any other !freezable kthreads.

> > * Tasks can be moved in and out of a frozen cgroup.  Tasks are made to
> >   conform to the state of the new cgroup during migration.  This
> >   behavior makes a lot more sense and removes the use of
> >   ->can_attach() which makes co-mounting difficult.
> 
> One nice aspect of freezing the set of tasks in the cgroup as well as the
> tasks themselves was you had a fixed set of tasks to work with (from
> userspace or otherwise). With this change that will no longer be true.
> This is a userspace-visible behavior change and userspace code may
> have relied on this feature.
>
> Will this work for the CRIU folks? With this patch one of the tasks being
> checkpointed could become thawed simply by some other process writing
> the pid into a different cgroup's tasks file. In contrast, with the
> current code they'd have to explicitly thaw its cgroup first.

Yeap, this is a userland visible behavior change.  Don't see any other
way around it tho and if you can't prevent someone else moving things
in/out of your cgroup, what prevents someone else echoing THAWED to
freezer.state?

As for CRIU, it isn't using cgroup freezer at the moment because
frozen tasks can't be ptraced currently.  Something I'm hoping to
change but not sure when it can be done.

Thanks.

-- 
tejun
