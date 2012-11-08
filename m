Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2KHSCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:02:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35223 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2KHSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:02:50 -0500
Date: Thu, 8 Nov 2012 19:02:46 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9 v3] cgroup_freezer: implement proper hierarchy support
Message-ID: <20121108180246.GA17415@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121108175750.GK12973@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108175750.GK12973@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-11-12 09:57:50, Tejun Heo wrote:
> Up until now, cgroup_freezer didn't implement hierarchy properly.
> cgroups could be arranged in hierarchy but it didn't make any
> difference in how each cgroup_freezer behaved.  They all operated
> separately.
> 
> This patch implements proper hierarchy support.  If a cgroup is
> frozen, all its descendants are frozen.  A cgroup is thawed iff it and
> all its ancestors are THAWED.  freezer.self_freezing shows the current
> freezing state for the cgroup itself.  freezer.parent_freezing shows
> whether the cgroup is freezing because any of its ancestors is
> freezing.
> 
> freezer_post_create() locks the parent and new cgroup and inherits the
> parent's state and freezer_change_state() applies new state top-down
> using cgroup_for_each_descendant_pre() which guarantees that no child
> can escape its parent's state.  update_if_frozen() uses
> cgroup_for_each_descendant_post() to propagate frozen states
> bottom-up.
> 
> Synchronization could be coarser and easier by using a single mutex to
> protect all hierarchy operations.  Finer grained approach was used
> because it wasn't too difficult for cgroup_freezer and I think it's
> beneficial to have an example implementation and cgroup_freezer is
> rather simple and can serve a good one.
> 
> As this makes cgroup_freezer properly hierarchical,
> freezer_subsys.broken_hierarchy marking is removed.
> 
> Note that this patch changes userland visible behavior - freezing a
> cgroup now freezes all its descendants too.  This behavior change is
> intended and has been warned via .broken_hierarchy.
> 
> v2: Michal spotted a bug in freezer_change_state() - descendants were
>     inheriting from the wrong ancestor.  Fixed.
> 
> v3: Documentation/cgroups/freezer-subsystem.txt updated.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Tejun Heo <tj@kernel.org>

You probably meant Reviewed-by: Michal Hocko .... ;)
-- 
Michal Hocko
SUSE Labs
