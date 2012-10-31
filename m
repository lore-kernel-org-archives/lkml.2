Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab2JaQ5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:57:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54347 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab2JaQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:57:44 -0400
Date: Wed, 31 Oct 2012 09:57:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
Message-ID: <20121031165739.GE2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-3-git-send-email-tj@kernel.org>
 <20121031153926.GC22809@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031153926.GC22809@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 04:39:26PM +0100, Michal Hocko wrote:
> >  	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
> >  
> > -	local_irq_disable();
> > -
> 
> OK, so the new charges shouldn't come from the IRQ context so we cannot
> race with css_tryget but why did we need this in the first place?
> A separate patch which removes this with an explanation would be nice.

The change is actually tied to this one.  Because css_tryget() busy
loops on DEACT_BIAS && !CSS_REMOVED and css_tryget() may happen from
an IRQ context, we need to disable IRQ while deactivating refcnts and
setting CSS_REMOVED.  I'll mention it in the commit message.

> > @@ -2343,7 +2343,6 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  again:
> >  	if (*ptr) { /* css should be a valid one */
> >  		memcg = *ptr;
> > -		VM_BUG_ON(css_is_removed(&memcg->css));
> 
> All the callers seem to be fine but this was a safety net that something
> didn't leak out. Can we keep it and test that the reference counter has
> been disabled already (css_refcnt(&memcg->css) < 0 - I do not care
> whether open coded or wrapped innsude css_is_removed albeit helper
> sounds nicer)?

I don't think that's a good idea.  In general, I think too much of
cgroup internals are exposed to controllers.  People try to implement
weird behaviors and expose cgroup internals for that, which in turn
attracts more weirdness, and there seems to be a pattern - cgroup core
is unnecessarily coupled with VFS locking like controllers are
unnecessarily coupled with cgroup internal locking.  I really wanna
move away from such pattern.  I mean, you can't even know
css_is_removed() isn't gonna change while the function is in progress.

I have a patch queued to add ->pre_destroy() - different from
Glauber's in that it can't fail, so we'll have

	->create()
		->post_create()
		->pre_destroy()
	->destroy()

Where ->create() may fail but none other can.  ->post_create() and
->pre_destroy() mark the point where a cgroup is committed to and
decommissioned from active service and thus can be used as
synchronization points.  If you want liveliness check inside memcg,
please take the necessary actions (synchronization and marking) from
->post_create() and ->pre_destroy() and check against that.  That way,
you control your locking and there will also be a general mechanism to
iterate through a cgroup's children/descendants which can also be
synchronized that way.  I'm planning to send the series out later
today.

> I think that something like the following would be more instructive:
> 
> + * rcu_read_lock(). The caller is responsible for calling css_tryget
> + * if the mem_cgroup is used for charging. (dropping refcnt from swap can be
> + * called against removed memcg.)

So updated.  Thanks!

-- 
tejun
