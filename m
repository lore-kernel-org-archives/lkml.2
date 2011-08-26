Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1HZGkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:40:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64758 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1HZGkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:40:16 -0400
Date: Fri, 26 Aug 2011 08:40:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
Message-ID: <20110826064011.GA2632@htj.dyndns.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-4-git-send-email-tj@kernel.org>
 <20110826023818.GC3457@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826023818.GC3457@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Thu, Aug 25, 2011 at 07:38:18PM -0700, Matt Helsley wrote:
> On Fri, Aug 26, 2011 at 12:43:09AM +0200, Tejun Heo wrote:
> > Currently, there's no way to pass multiple tasks to cgroup_subsys
> > methods necessitating the need for separate per-process and per-task
> > methods.  This patch introduces cgroup_taskset which can be used to
> > pass multiple tasks and their associated cgroups to cgroup_subsys
> > methods.
> 
> This will be the third iterator-ish pattern in the cgroup code.
> It's not your fault but it does seem a bit much to have:
...
> Is there a sane way to merge all this?

If merging isn't complicated and simplifies the code and its users,
definitely but I don't think that will be the case here.  If there are
different targets to iterate, having matching iterators isn't a weird
thing after all.  I personally am not too enthusiastic about mixing
locking with iterator (the implied read_lock in the cgroup iterator)
or iteration-by-callback but that's a different issue.

> Perhaps we could drop the iterator interfaces in 1) and 2) and replace
> it with:
> 
> 		tset cgroup_taskset_from_cgroup(cgroup)
> 
> which would grab the css set lock to construct the tset from the given
> cgroup -- essentially inlining the current iterator code into a single
> function.

* It doesn't need to walk the whole cgroup.

* It requires stable set of tasks (ie. atomicity w.r.t. the thread
  group) with sleepable context which is currently achieved by a rwsem
  in the task to protect against fork and getting an extra reference
  to the tasks in the set.

I don't think widening the scope would achieve much (why do we want to
pass in unrelated tasks to subsystems as a single bundle?) while
introducing unnecessary scalability limitation (moving out a single
process ends up being an operation on the whole cgroup).

I don't see how it would be better but, if you do, please go ahead.
Consolidating stuff is (almost) always a good idea. :)

Thanks.

-- 
tejun
