Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887Ab2JaNmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:42:44 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47677 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933628Ab2JaNmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:42:40 -0400
Message-ID: <50912AC1.508@parallels.com>
Date: Wed, 31 Oct 2012 17:42:25 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-5-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:22 AM, Tejun Heo wrote:
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
>   1. Grab cgroup_mutex and fail if it can't be destroyed; fail
>      otherwise.
> 
fail, or fail otherwise? Seems quite negative =)

