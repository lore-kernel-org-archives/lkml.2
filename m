Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2J2PJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:09:48 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49074 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446Ab2J2PJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:46 -0400
Message-ID: <508E9C28.1000308@parallels.com>
Date: Mon, 29 Oct 2012 19:09:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list error
 handling
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-4-git-send-email-mhocko@suse.cz> <508E8B95.406@parallels.com> <20121029141534.GB20757@dhcp22.suse.cz>
In-Reply-To: <20121029141534.GB20757@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> + * move charges to its parent or the root cgroup if the group has no
>>> + * parent (aka use_hierarchy==0).
>>> + * Although this might fail (get_page_unless_zero, isolate_lru_page or
>>> + * mem_cgroup_move_account fails) the failure is always temporary and
>>> + * it signals a race with a page removal/uncharge or migration. In the
>>> + * first case the page is on the way out and it will vanish from the LRU
>>> + * on the next attempt and the call should be retried later.
>>> + * Isolation from the LRU fails only if page has been isolated from
>>> + * the LRU since we looked at it and that usually means either global
>>> + * reclaim or migration going on. The page will either get back to the
>>> + * LRU or vanish.
>>
>> I just wonder for how long can it go in the worst case?
>  
> That's a good question and to be honest I have no idea. The point is
> that it will terminate eventually and that the group is on the way out
> so the time to complete the removal is not a big deal IMHO. We had
> basically similar situation previously when we would need to repeat
> rmdir loop on EBUSY. The only change is that we do not have to retry
> anymore.
> 
> So the key point is to check whether my assumption about temporarily is
> correct and that we cannot block the rest of the kernel/userspace to
> proceed even though we are waiting for finalization. I believe this is
> true but... (last famous words?)
> 
At least for me, it seems that this will hold.

