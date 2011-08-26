Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1HZPVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:21:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34581 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1HZPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:21:45 -0400
Date: Fri, 26 Aug 2011 17:21:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bblum@andrew.cmu.edu, fweisbec@gmail.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org
Subject: Re: + cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
 added to -mm tree
Message-ID: <20110826152139.GH2632@htj.dyndns.org>
References: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
 <20110826151245.GA16243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826151245.GA16243@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, Aug 26, 2011 at 05:12:45PM +0200, Oleg Nesterov wrote:
> Yes, I think this is what we need, the patch itself looks fine.
> 
> But this doesn't answer my another question. After that the code does
> 
> 	 * step 4: do expensive, non-thread-specific subsystem callbacks.
> 
> 		ss->attach(ss, cgrp, oldcgrp, leader);
> 
> OK, non-thread-specific is nice, but how can this "leader" represent
> the process?
> 
> It can be zombie (but still group_leader) even without any races.
> Say, cpuset_attach() and mem_cgroup_move_task() need get_task_mm(p).
> How this can work if the leader is dead?
> 
> Also. Even if we add the locking around while_each_thread() (btw,
> we need this in any case), we can race with exec which can change
> the leader. In this case this task_struct has nothing to do with
> the process we are going to attach, at all.
> 
> And, ss->can_attach(leader) has the same problems, it seems.

Please take a look at the following series.

  http://thread.gmane.org/gmane.linux.kernel/1184375

attach racing against exit/exec is problematic and maybe we should
extend task->threadgroup_fork_lock protection to cover both exit and
exec.  I can't like it tho.  I hope this can be somehow done in
lighter way.  cgroup attaches are quite cold paths and we're putting
an extra rwsem in each task for that.

Thanks.

-- 
tejun
