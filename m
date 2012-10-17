Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2JRU3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:29:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35672 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab2JRU3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:29:09 -0400
Date: Wed, 17 Oct 2012 12:16:06 -0700
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, oleg@redhat.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121017191606.GA6223@us.ibm.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350426526-14254-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101820-5112-0000-0000-00000D97FB11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 03:28:39PM -0700, Tejun Heo wrote:
> Hello,
> 
> This patchset updates cgroup_freezer so that
> 
> * Unfreezable kernel tasks don't prevent a cgroup from transitioning
>   into FROZEN from FREEZING.  There's nothing userland can do with or
>   about such tasks.

Seems like a non-problem. Do you have a testcase showing how kernel
threads prevent cgroups that should be freezable from being frozen?
It used to be that you couldn't move kernel threads out of the root
cgroup and the root cgroup was not freezable. So this was never a
problem before. Is there some change here that I'm unaware of?

> 
> * Tasks can be moved in and out of a frozen cgroup.  Tasks are made to
>   conform to the state of the new cgroup during migration.  This
>   behavior makes a lot more sense and removes the use of
>   ->can_attach() which makes co-mounting difficult.

One nice aspect of freezing the set of tasks in the cgroup as well as the
tasks themselves was you had a fixed set of tasks to work with (from
userspace or otherwise). With this change that will no longer be true.
This is a userspace-visible behavior change and userspace code may
have relied on this feature.

Will this work for the CRIU folks? With this patch one of the tasks being
checkpointed could become thawed simply by some other process writing
the pid into a different cgroup's tasks file. In contrast, with the
current code they'd have to explicitly thaw its cgroup first.

Cheers,
	-Matt Helsley

