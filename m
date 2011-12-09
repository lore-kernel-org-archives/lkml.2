Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1LIXnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:43:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1LIXnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:43:01 -0500
Date: Sat, 10 Dec 2011 00:42:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paul@paulmenage.org,
        rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED AGAIN 03/10] threadgroup: extend
 threadgroup_lock() to cover exit and exec
Message-ID: <20111209234246.GC27173@somewhere>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
 <20111205184315.GJ627@google.com>
 <20111207153046.GC13252@somewhere.redhat.com>
 <20111207182214.GA7610@google.com>
 <20111208205055.GB12108@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208205055.GB12108@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:50:55PM -0800, Tejun Heo wrote:
> (Note for Linus at the bottom)
> 
> threadgroup_lock() protected only protected against new addition to
> the threadgroup, which was inherently somewhat incomplete and
> problematic for its only user cgroup.  On-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
> 
> This patch extends threadgroup_lock() such that it protects against
> all three threadgroup altering operations - fork, exit and exec.  For
> exit, threadgroup_change_begin/end() calls are added to exit_signals
> around assertion of PF_EXITING.  For exec, threadgroup_[un]lock() are
> updated to also grab and release cred_guard_mutex.
> 
> With this change, threadgroup_lock() guarantees that the target
> threadgroup will remain stable - no new task will be added, no new
> PF_EXITING will be set and exec won't happen.
> 
> The next patch will update cgroup so that it can take full advantage
> of this change.
> 
> -v2: beefed up comment as suggested by Frederic.
> 
> -v3: narrowed scope of protection in exit path as suggested by
>      Frederic.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> Okay, narrowed exit path protection down to setting of PF_EXITING
> itself.  ->exit() on dangling tasks is a bit weird but I don't think
> it's too bad.  Frederic, are you okay with this version?

Yeah that new scheme that only protects PF_EXITING may look a bit
strange. But I think we are fine. With rcu list traversal, it should
be safe even if a group member is concurrently dropped from the list (in that
case all we check if its PF_EXITING then we give up). And we may
have a concurrent ->exit() but that should be fine too.

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> 
> Linus, if Frederic is okay with it, I'm gonna rebase the series on top
> of freezer changes in pm tree to avoid conflicts in cgroup_freezer,
> which sits between cgroup and freezer, both of which are going through
> non-trivial changes, push the branch to linux-next and put pending
> cgroup patches on top.  Please scream if you're mighty unhappy with it
> or have a better idea.
> 
> Thank you.
