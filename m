Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1IAM6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:58:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51924 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1IAM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:58:29 -0400
Date: Thu, 1 Sep 2011 14:58:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/6] cgroup: kill subsys->can_attach_task(), pre_attach()
 and attach_task()
Message-ID: <20110901125822.GB24650@somewhere.redhat.com>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-7-git-send-email-tj@kernel.org>
 <20110830201030.GC15953@somewhere.redhat.com>
 <20110831070313.GA29179@mtj.dyndns.org>
 <20110831134220.GB20598@somewhere>
 <20110901112221.GA2752@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901112221.GA2752@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 08:22:21PM +0900, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 31, 2011 at 03:42:24PM +0200, Frederic Weisbecker wrote:
> > My task counter subsystem patchset brings a cancel_attach_task() callback
> > that cancels can_attach_task() effects.
> > 
> > I thought that rebased on top of your patch it's going to be merged inside
> > cancel_attach() but OTOH we can't cancel the effect of failed migration
> > on a thread that way.
> > 
> > May be we need to keep a cancel_attach_task() just for that purpose?
> 
> We can do that but I think that becomes a bit too complex and fragile.
> That path won't be traveled unless it races against exit.  Bugs will
> be difficult to detect and reproduce.  In this respect, the current
> code already seems racy.  ->can_attach (or other methods in the attach
> path) and ->exit can race each other and I don't think all subsystems
> handle that properly.

I guess subsystems don't care about that currently, although I haven't
checked. But the task counter will need this per thread cancellation in
migration failure, without the need for any synchronization between
can_attach, attach and exit.

Now if we want to solve this with a synchronization there, either
we task_lock() every tasks in the group in the beginning of cgroup_attach_proc().
But that's not very nice. Or we use cgroup_mutex on cgroup_exit() exit,
but that's even worse.

I guess we need the leader->sighand->siglock on both cgroup_attach_proc()
and cgroup_exit(). Besides we may have more reasons to have that:

https://lkml.org/lkml/2011/8/15/342

> 
> IMHO the right thing to do here is simplifying synchronization rules
> so that nothing else happens while migration is in progress.
> 
> Thanks.
> 
> -- 
> tejun
