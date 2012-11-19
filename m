Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KSN0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:26:23 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60058 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2KSN0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:26:22 -0500
Date: Mon, 19 Nov 2012 08:25:53 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy
 support
Message-ID: <20121119132553.GA16685@hmsreliant.think-freely.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353093624-22608-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 11:20:16AM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> This patchset implements hierarchy support for netprio_cgroup.
> netprio_cgroup along with netcls_cgroup is a rather weird in that it
> really isn't about resource control.  It just hitches on cgroup as a
> convenient mechanism to do stuff to groups of tasks.  The hierarchy
> support reflects such nature.  There's no limit being imposed from
> ancestors.  It simply propagates configuration downwards until there's
> a node with its own config.  IOW, any given cgroup inherits priorities
> from its parent for all netdevs which it doesn't have its own config
> for.
> 
> As a parent isn't affected by child inheriting its config, the
> hierarchy implementation is pretty simple.  It's enough to inherit
> config from ->css_online() and propagate new config downwards from
> write_priomap().  As each node needs to know which config is its local
> one and which is inherited, an extra config array is added -
> netprio_map->aux[].  It's a separate array to avoid disturbing spatial
> locality of ->priomap[].  While it currently contains single one-bit
> flag, I still made it a struct so that adding more configuration
> (e.g. max_prio) is easy.
> 
> Note that this does change userland-visible behavior.  Now, nesting is
> allowed and cgroups at the first level inherit priorities from the
> root cgroup.  I can't think of any better way than just biting the
> bullet here.  :(
> 
>  0001-cgroup-add-cgroup-id.patch
>  0002-netprio-simplify-write_priomap.patch
>  0003-netprio_cgroup-shorten-variable-names-in-extend_netd.patch
>  0004-netprio_cgroup-reimplement-priomap-expansion.patch
>  0005-netprio_cgroup-use-cgroup-id-instead-of-cgroup_netpr.patch
>  0006-netprio_cgroup-implement-netprio-_set-_prio-helpers.patch
>  0007-netprio_cgroup-keep-track-of-whether-prio-is-set-or-.patch
>  0008-netprio_cgroup-implement-hierarchy-support.patch
> 
> 0001 adds cgroup->id.  This will eventually replace css_id.
> 
> 0002-0006 are prep patches.
> 
> 0007 implements is_local flag which tracks whether a cgroup has its
> own config or should inherit from its parent.
> 
> 0008 implements hierarchy support.
> 
> This patchset is on top of
> 
> cgroup/for-3.8 ef9fe980c6 ("cgroup_freezer: implement proper hierarchy support")
> + [1] "[PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail"
> + [2] "[PATCH 1/2] cgroup: s/CGRP_CLONE_CHILDREN/CGRP_CPUSET_CLONE_CHILDREN/"
>       "[PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()"
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-netprio_cgroup-hierarchy
> 
> diffstat follows.
> 
>  Documentation/cgroups/net_prio.txt |   21 +-
>  include/linux/cgroup.h             |    2
>  include/net/netprio_cgroup.h       |   21 +-
>  kernel/cgroup.c                    |   15 +
>  net/core/netprio_cgroup.c          |  376 +++++++++++++++++++++++--------------
>  5 files changed, 284 insertions(+), 151 deletions(-)
> 
> Thanks.
> 
> --
> tejun
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5047
> [2] http://thread.gmane.org/gmane.linux.kernel/1393151
> 

Thanks Tejun

For the series:
Acked-by: Neil Horman <nhorman@tuxdriver.com>
