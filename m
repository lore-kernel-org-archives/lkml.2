Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030626Ab2K3PKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:10:10 -0500
Received: from mx2.parallels.com ([64.131.90.16]:46208 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030598Ab2K3PKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:10:08 -0500
Message-ID: <50B8CC3D.3040901@parallels.com>
Date: Fri, 30 Nov 2012 19:09:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <lizefan@huawei.com>, <paul@paulmenage.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <bsingharora@gmail.com>, <hannes@cmpxchg.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
References: <1354138460-19286-1-git-send-email-tj@kernel.org> <50B8263C.7060908@jp.fujitsu.com> <50B875B4.2020507@parallels.com> <20121130092435.GD29317@dhcp22.suse.cz> <50B87F84.7040206@parallels.com> <20121130094959.GE29317@dhcp22.suse.cz> <50B883B5.8020705@parallels.com> <20121130145924.GA3873@htj.dyndns.org>
In-Reply-To: <20121130145924.GA3873@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 06:59 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 30, 2012 at 02:00:21PM +0400, Glauber Costa wrote:
>> Now, what I am actually seeing with cgroup creation, is that the
>> children will copy a lot of the values from the parent, like swappiness,
>> hierarchy, etc. Once the child copies it, we should no longer be able to
>> change those values in the parent: otherwise we'll get funny things like
>> parent.use_hierarchy = 1, child.use_hierarchy = 0.
> 
> So, the best way to do this is from ->css_online().  If memcg
> synchronizes and inherits from ->css_online(), it can guarantee that
> the new cgroup will be visible in any following iterations.  Just have
> an online flag which is turned on and off from ->css_on/offline() and
> ignore any cgroups w/o online set.
> 
>> One option is to take a global lock in memcg_alloc_css(), and keep it
>> locked until we did all the cgroup bookkeeping, and then unlock it in
>> css_online. But I am guessing Tejun won't like it very much.
> 
> No, please *NEVER* *EVER* do that.  You'll be creating a bunch of
> locking dependencies as cgroup walks through different controllers.
> 
> memcg should be able to synchornize fully both css on/offlining and
> task attachments in memcg proper.  Let's please be boring about
> locking.
> 

Of course, there was a purely rhetorical statement, as indicated by
"Tejun won't like it very much" =p

Take a look at the final result, I just posted a couple of hours ago.
Let me know if there is still something extremely funny, and I'll look
into fixing it.


