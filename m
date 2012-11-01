Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2KAJQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:16:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613Ab2KAJQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:16:46 -0400
Date: Thu, 1 Nov 2012 10:16:44 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in
 cgroup_create()
Message-ID: <20121101091644.GA8533@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-4-git-send-email-tj@kernel.org>
 <20121031155514.GD22809@dhcp22.suse.cz>
 <20121031170431.GF2945@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031170431.GF2945@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 10:04:31, Tejun Heo wrote:
> Hey, Michal.
> 
> On Wed, Oct 31, 2012 at 04:55:14PM +0100, Michal Hocko wrote:
> > > +	/*
> > > +	 * Only live parents can have children.  Note that the liveliness
> > > +	 * check isn't strictly necessary because cgroup_mkdir() and
> > > +	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
> > > +	 * anyway so that locking is contained inside cgroup proper and we
> > > +	 * don't get nasty surprises if we ever grow another caller.
> > > +	 */
> > > +	if (!cgroup_lock_live_group(parent)) {
> > > +		err = -ENODEV;
> > > +		goto err_free;
> > > +	}
> > > +
> > 
> > I think this should be moved up before we try to allocate any memory.
> > Or is your motivation to keep cgroup_lock held for shorter time?
> > I could agree with that but a small comment would be helpful.
> 
> Then I have to change the error out path more and I'm not sure I wanna
> call deactivate_super() under cgroup_mutex.  It's just simpler this
> way.

I am not sure I understand. What does deactivate_super has to do with
the above suggestion? cgroup_lock_live_group will take the cgroup_mutex
on the success or frees the previously allocated&unused memory. The
only thing I was suggesting is to do cgroup_lock_live_group first and
allocate the cgroup only if it doesn't fail.

-- 
Michal Hocko
SUSE Labs
