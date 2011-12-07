Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1LGPeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:34:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38643 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1LGPeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:34:22 -0500
Date: Wed, 7 Dec 2011 16:30:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock() to
 cover exit and exec
Message-ID: <20111207153046.GC13252@somewhere.redhat.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
 <20111205184315.GJ627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205184315.GJ627@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:43:15AM -0800, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Fri, Dec 02, 2011 at 05:28:03PM +0100, Frederic Weisbecker wrote:
> > But I don't think it's very useful to protect against irq_exit_thread(),
> > what happens there is purely of internal irq interest.
> > 
> > Then right after, PF_EXITING is set before any interesting change.
> > Isn't it possible to simply lock this flag setting? IIRC, as soon
> > as the PF_EXITING flag is set, you ignore the task for attachment.
> 
> I think that's technically possible but it does introduce another
> class of tasks - the dying ones.  e.g. If a task has PF_EXITING set
> and the containing process is migrating, we'll have to migrate all
> tasks but the dying one and cgroup ->exit callbacks can be called on
> the lonely task after the migration is complete.  It's kinda messy and
> if someone makes a wrong assumption there, the bug is gonna be even
> more difficult to reproduce / track down than now.  Yes, smaller scope
> locking is nicer but I would like to avoid api weirdities like that.

I don't understand what you mean. On your patches, you only process tasks
that don't have PF_EXITING, ie: you don't include these in the flex array
on cgroup_attach_proc(). So that still applies in my proposal.

>From the exit path we would have:

	exit_signal() {
		lock_threadgroup_change(task);
		task->flags |= PF_EXITING;
		lock_threadgroup(task);
	}

	exit all the rest: mm, etc...

Then from cgroup_attach_proc():

	lock_threadgroup(task);
	for_each_thread(task) {
		if (!(task->flags & PF_EXITING))
			include in flex array
	}

Am I forgetting something?
