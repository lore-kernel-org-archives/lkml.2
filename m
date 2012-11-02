Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454Ab2KBJoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:44:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59334 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292Ab2KBJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:44:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509395D3.2070708@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 18:43:47 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-5-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/31 13:22), Tejun Heo wrote:
> Because ->pre_destroy() could fail and can't be called under
> cgroup_mutex, cgroup destruction did something very ugly.
> 
>    1. Grab cgroup_mutex and verify it can be destroyed; fail otherwise.
> 
>    2. Release cgroup_mutex and call ->pre_destroy().
> 
>    3. Re-grab cgroup_mutex and verify it can still be destroyed; fail
>       otherwise.
> 
>    4. Continue destroying.
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
>    1. Grab cgroup_mutex and fail if it can't be destroyed; fail
>       otherwise.
> 
>    2. Deactivate CSS's and mark the cgroup removed thus preventing any
>       further operations which can invalidate the verification from #1.
> 
>    3. Release cgroup_mutex and call ->pre_destroy().
> 
>    4. Re-grab cgroup_mutex and continue destroying.
> 
> After this change, controllers can safely assume that ->pre_destroy()
> will only be called only once for a given cgroup and, once
> ->pre_destroy() is called, the cgroup will stay dormant till it's
> destroyed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Ok, cgroup_lock_live_group() will work synchronously against attach_task().
I welcome this.


