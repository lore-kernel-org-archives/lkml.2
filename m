Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2GIFLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 01:11:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2GIFLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 01:11:17 -0400
Date: Mon, 9 Jul 2012 13:10:55 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/memcg: return -EBUSY when oom-kill-disable modified
 and memcg use_hierarchy, has children
Message-ID: <20120709051036.GA8304@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1341485708-14221-1-git-send-email-liwp.linux@gmail.com>
 <4FFA616B.4000608@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFA616B.4000608@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 01:43:23PM +0900, Kamezawa Hiroyuki wrote:
>(2012/07/05 19:55), Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> When oom-kill-disable modified by the user and current memcg use_hierarchy,
>> the change can occur, provided the current memcg has no children. If it
>> has children, return -EBUSY is enough.
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>
>I'm sorry what is the point ? You think -EBUSY should be returned in this case 
>rather than -EINVAl ? Then, why ?

just like in function cmem_cgroup_hierarchy_write:

if((!parent_memcg || !parent_memcg->use_hierarchy) &&
		(val == 1 || val == 0) {
		if (list_empty(&cont->children))
			memcg->use_hierarchy = val;
		else
			return -EBUSY;
} else
		return = -EINVAL;

If memcg->use_hierarchy && has children memcg, the user can try again
if children memcg disappear. Or I miss something ....

Regards,
Wanpeng Li

>
>
>> ---
>>   mm/memcontrol.c |    7 +++++--
>>   1 files changed, 5 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 63e36e7..4b64fe0 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4521,11 +4521,14 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
>>   
>>   	cgroup_lock();
>>   	/* oom-kill-disable is a flag for subhierarchy. */
>> -	if ((parent->use_hierarchy) ||
>> -	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
>> +	if (parent->use_hierarchy) {
>>   		cgroup_unlock();
>>   		return -EINVAL;
>> +	} else if (memcg->use_hierarchy && !list_empty(&cgrp->children)) {
>> +		cgroup_unlock();
>> +		return -EBUSY;
>>   	}
>> +
>>   	memcg->oom_kill_disable = val;
>>   	if (!val)
>>   		memcg_oom_recover(memcg);
>> 
>
>
