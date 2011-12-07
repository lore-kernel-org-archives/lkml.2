Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1LGSWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:22:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61702 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1LGSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:22:24 -0500
Date: Wed, 7 Dec 2011 10:22:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock()
 to cover exit and exec
Message-ID: <20111207182214.GA7610@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
 <20111205184315.GJ627@google.com>
 <20111207153046.GC13252@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207153046.GC13252@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Wed, Dec 07, 2011 at 04:30:54PM +0100, Frederic Weisbecker wrote:
> I don't understand what you mean. On your patches, you only process tasks
> that don't have PF_EXITING, ie: you don't include these in the flex array
> on cgroup_attach_proc(). So that still applies in my proposal.
> 
> From the exit path we would have:
> 
> 	exit_signal() {
> 		lock_threadgroup_change(task);
> 		task->flags |= PF_EXITING;
> 		lock_threadgroup(task);
> 	}
> 
> 	exit all the rest: mm, etc...
> 
> Then from cgroup_attach_proc():
> 
> 	lock_threadgroup(task);
> 	for_each_thread(task) {
> 		if (!(task->flags & PF_EXITING))
> 			include in flex array
> 	}
> 
> Am I forgetting something?

The point I was trying to make was that doing the above would make
->exit() called on dangling task of a threadgroup in rare cases.
ie. With the proposed change, after a threadgroup migration, all tasks
in the threadgroup is in the new cgroup.  No method will be called on
the old cgroup for any of the member task.  With the above change,
process migration would leave out dying tasks and ->exit() can be
called with the old cgroup.

Hmm... that said, it probably doesn't matter all that much either way.
I'll update the patchset and repost.

Thanks.

-- 
tejun
