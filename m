Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2KPGEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:04:43 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:13478 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2KPGEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:04:41 -0500
Message-ID: <50A5D76D.70805@huawei.com>
Date: Fri, 16 Nov 2012 14:04:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mhocko@suse.cz>,
        <glommer@parallels.com>
Subject: Re: [PATCH 04/17] cgroup: create directory before linking while creating
 a new cgroup
References: <1352775704-9023-1-git-send-email-tj@kernel.org> <1352775704-9023-5-git-send-email-tj@kernel.org> <50A30E0F.7000408@huawei.com> <20121114190407.GI21185@mtj.dyndns.org>
In-Reply-To: <20121114190407.GI21185@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/15 3:04, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Nov 14, 2012 at 11:20:47AM +0800, Li Zefan wrote:
>>> It also removes the need to check whether cgroup->dentry is %NULL in
>>> cgroup_path.  If a cgroup is visible, its dentry is guaranteed to be
>>> visible too.
>>
>> I'm afraid this isn't safe.
>>
>> The cgroup is visible to a controller soon after ss->create(), and then
>> the controller might call cgroup_path() while cgrp->dentry is still NULL.
> 
> Hmmm... I can't find any case where ss->create() is calling
> cgroup_path().  Do you remember which one that was?
> 

I meant cgroup_create() may race with cgroup_path(). We used to have
this race:

(cpu0)                          (cpu1)
mkdir                           cat /proc/sched_debug

cgroup_create()
  cpu_cgroup_create()
    register_fair_sched_group()
      list_add_rcu(...)
				print_cfs_stats()
				  for_each_leaf_cfs_rq()
				    print_cfs_rq()
				      cgroup_path()
  css->cgroup = cgroup;
  cgroup->dentry = dentry;

In this case, cgroup_path() might access NULL cgroup or NULL dentry.

But I've looked the current scheduler code, no race anymore, because now the
cfs_rq won't be added to the gloal list until there's task in the cgroup.
(in the old time it was added to the list when creating a cgroup)

