Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1JJRLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:11:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43811 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1JJRLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:11:10 -0400
Date: Mon, 10 Oct 2011 10:11:05 -0700
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111010171105.GE8100@google.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <1315159280-25032-4-git-send-email-htejun@gmail.com>
 <20110918173723.GA2384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110918173723.GA2384@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

Sorry about the very long delay.  I moved cross atlantic and had a
pretty long vacation while doing it.  Hope you can still remember some
of this one. :)

On Sun, Sep 18, 2011 at 07:37:23PM +0200, Oleg Nesterov wrote:
> > With this change, threadgroup_lock() guarantees that the target
> > threadgroup will remain stable - no new task will be added, no new
> > PF_EXITING will be set and exec won't happen.
> 
> To me, this is the only "contradictory" change,

What do you mean "contradictory"?  Can you please elaborate?

> > +	/*
> > +	 * Release threadgroup and make sure we are holding no locks.
> > +	 */
> > +	threadgroup_change_done(tsk);
> 
> I am wondering, can't we narrow the scope of threadgroup_change_begin/done
> in do_exit() path?
> 
> The code after 4/4 still has to check PF_EXITING, this is correct. And yes,
> with this patch PF_EXITING becomes stable under ->group_rwsem. But, it seems,
> we do not really need this?
> 
> I mean, can't we change cgroup_exit() to do threadgroup_change_begin/done
> instead? We do not really care about PF_EXITING, we only need to ensure that
> we can't race with cgroup_exit(), right?

If we confine our usage to cgroup, excluding just against
cgroup_exit() might work although this is still a bit nasty.  ie. some
callbacks might not expect half torn-down tasks in methods other than
the exit callback.

Also, it makes the mechanism unnecessarily cgroup-specific without
gaining much if anything.  It's per-threadgroup rwsem so contention
isn't a problem and narrowing critical section isn't likely to be
beneficial (maybe slightly increase the chance of the cacheline for
the lock to be hot?).

Thank you.

-- 
tejun
