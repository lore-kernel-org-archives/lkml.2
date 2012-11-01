Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885Ab2KAPFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:05:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761791Ab2KAPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:05:36 -0400
Date: Thu, 1 Nov 2012 16:05:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in
 cgroup_create()
Message-ID: <20121101150532.GA5065@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-4-git-send-email-tj@kernel.org>
 <20121031155514.GD22809@dhcp22.suse.cz>
 <20121031170431.GF2945@htj.dyndns.org>
 <20121101091644.GA8533@dhcp22.suse.cz>
 <CAOS58YM+kRtspVUzmnSmOmrDoNS_kF6KA02zWGxqH5FUcRWo1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YM+kRtspVUzmnSmOmrDoNS_kF6KA02zWGxqH5FUcRWo1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-11-12 07:52:24, Tejun Heo wrote:
> Hey, Michal.
> 
> On Thu, Nov 1, 2012 at 2:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > I am not sure I understand. What does deactivate_super has to do with
> > the above suggestion? cgroup_lock_live_group will take the cgroup_mutex
> > on the success or frees the previously allocated&unused memory. The
> > only thing I was suggesting is to do cgroup_lock_live_group first and
> > allocate the cgroup only if it doesn't fail.
> 
> It complicates updates to the error exit path.

Still don't get it, sorry. What prevents us to do:
static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
                             umode_t mode)
{
        struct cgroup *cgrp;
        struct cgroupfs_root *root = parent->root;
        int err = 0;
        struct cgroup_subsys *ss;
        struct super_block *sb = root->sb;

	if (!cgroup_lock_live_group(parent))
		return -ENODEV;

        cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
        if (!cgrp)
                return -ENOMEM;

> You end up having to update a lot more and it's not like grabbing lock
> first is substantially better in any way, so why bother?

Yes the allocation can sleep if we are short on memory so this can
potentially take long which is not entirely nice but a pointless
allocation is not nice either. Anyway I am asking because I am trying to
understand what is the motivation behind and your explanation about the
error exit path doesn't make much sense to me. So I am either missing
something or we are talking about two different things.
-- 
Michal Hocko
SUSE Labs
