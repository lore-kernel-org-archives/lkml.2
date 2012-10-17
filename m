Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2JQPbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:31:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60819 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab2JQPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:31:07 -0400
Message-ID: <507ECF28.1060602@parallels.com>
Date: Wed, 17 Oct 2012 19:30:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC] memcg/cgroup: do not fail fail on pre_destroy callbacks
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 05:30 PM, Michal Hocko wrote:
> Hi,
> memcg is the only controller which might fail in its pre_destroy
> callback which makes the cgroup core more complicated for no good
> reason. This is an attempt to change this unfortunate state. 
> 
> I am sending this a RFC because I would like to hear back whether the
> approach is correct. I thought that the changes would be more invasive
> but it seems that the current code was mostly prepared for this and it
> needs just some small tweaks (so I might be missing something important
> here).
> 
> The first two patches are just clean ups. They could be merged even
> without the rest.
> 
> The real change, although the code is not changed that much, is the 3rd
> patch. It changes the way how we handle mem_cgroup_move_parent failures.
> We have to realize that all those failures are *temporal*. Because we
> are either racing with the page removal or the page is temporarily off
> the LRU because of migration resp. global reclaim. As a result we do
> not fail mem_cgroup_force_empty_list if the page cannot be moved to the
> parent and rather retry until the LRU is empty.
> 
> The 4th patch is for cgroup core. I have moved cgroup_call_pre_destroy
> inside the cgroup_lock which is not very nice because the callbacks
> can take some time. Maybe we can move this call at the very end of the
> function?
> All I need for memcg is that cgroup_call_pre_destroy has been called and
> that no new cgroups can be attached to the group. The cgroup_lock is
> necessary for the later condition but if we move after CGRP_REMOVED flag
> is set then we are safe as well.
> 
> The last two patches are trivial follow ups for the cgroups core change
> because now we know that nobody will interfere with us so we can drop
> those empty && no child condition.
> 
> Comments, thoughts?
> 

I personally don't see anything fundamentally wrong with this.
