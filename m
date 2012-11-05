Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2KEFiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:38:13 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:32517 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2KEFiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:38:12 -0500
Message-ID: <509750AB.7070905@huawei.com>
Date: Mon, 5 Nov 2012 13:37:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-5-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/1 3:44, Tejun Heo wrote:
> Because ->pre_destroy() could fail and can't be called under
> cgroup_mutex, cgroup destruction did something very ugly.
> 
>   1. Grab cgroup_mutex and verify it can be destroyed; fail otherwise.
> 
>   2. Release cgroup_mutex and call ->pre_destroy().
> 
>   3. Re-grab cgroup_mutex and verify it can still be destroyed; fail
>      otherwise.
> 
>   4. Continue destroying.
> 
> In addition to being ugly, it has been always broken in various ways.
> For example, memcg ->pre_destroy() expects the cgroup to be inactive
> after it's done but tasks can be attached and detached between #2 and
> #3 and the conditions that memcg verified in ->pre_destroy() might no
> longer hold by the time control reaches #3.
> 
> Now that ->pre_destroy() is no longer allowed to fail.  We can switch
> to the following.
> 
>   1. Grab cgroup_mutex and verify it can be destroyed; fail otherwise.
> 
>   2. Deactivate CSS's and mark the cgroup removed thus preventing any
>      further operations which can invalidate the verification from #1.
> 
>   3. Release cgroup_mutex and call ->pre_destroy().
> 
>   4. Re-grab cgroup_mutex and continue destroying.
> 
> After this change, controllers can safely assume that ->pre_destroy()
> will only be called only once for a given cgroup and, once
> ->pre_destroy() is called, the cgroup will stay dormant till it's
> destroyed.
> 
> This removes the only reason ->pre_destroy() can fail - new task being
> attached or child cgroup being created inbetween.  Error out path is
> removed and ->pre_destroy() invocation is open coded in
> cgroup_rmdir().
> 
> v2: cgroup_call_pre_destroy() removal moved to this patch per Michal.
>     Commit message updated per Glauber.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Cc: Glauber Costa <glommer@parallels.com>

Acked-by: Li Zefan <lizefan@huawei.com>

