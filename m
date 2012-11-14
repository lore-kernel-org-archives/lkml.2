Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2KNDVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:21:40 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47619 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2KNDVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:21:38 -0500
Message-ID: <50A30E0F.7000408@huawei.com>
Date: Wed, 14 Nov 2012 11:20:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mhocko@suse.cz>,
        <glommer@parallels.com>
Subject: Re: [PATCH 04/17] cgroup: create directory before linking while creating
 a new cgroup
References: <1352775704-9023-1-git-send-email-tj@kernel.org> <1352775704-9023-5-git-send-email-tj@kernel.org>
In-Reply-To: <1352775704-9023-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/13 11:01, Tejun Heo wrote:
> While creating a new cgroup, cgroup_create() links the newly allocated
> cgroup into various places before trying to create its directory.
> Because cgroup life-cycle is tied to the vfs objects, this makes it
> impossible to use cgroup_rmdir() for rolling back creation - the
> removal logic depends on having full vfs objects.
> 
> This patch moves directory creation above linking and collect linking
> operations to one place.  This allows directory creation failure to
> share error exit path with css allocation failures and any failure
> sites afterwards (to be added later) can use cgroup_rmdir() logic to
> undo creation.
> 

> It also removes the need to check whether cgroup->dentry is %NULL in
> cgroup_path.  If a cgroup is visible, its dentry is guaranteed to be
> visible too.
> 

I'm afraid this isn't safe.

The cgroup is visible to a controller soon after ss->create(), and then
the controller might call cgroup_path() while cgrp->dentry is still NULL.

This can happen for cpu cgroup I think, and in fact the NULL check was
added for this reason IIRC.

> Note that this also makes the memory barriers around cgroup->dentry,
> which currently is misleadingly using RCU operations, unnecessary.
> This will be handled in the next patch.
> 
> While at it, locking BUG_ON() on i_mutex is converted to
> lockdep_assert_held().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup.c | 32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)

