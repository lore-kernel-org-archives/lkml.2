Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1LIMk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:40:57 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50786 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab1LIMky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:40:54 -0500
Message-ID: <4EE201A0.9040601@parallels.com>
Date: Fri, 9 Dec 2011 10:40:00 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH v8 1/9] Basic kernel memory functionality for the Memory
 Controller
References: <1323120903-2831-1-git-send-email-glommer@parallels.com> <1323120903-2831-2-git-send-email-glommer@parallels.com> <20111209102113.cdb85da8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111209102113.cdb85da8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 11:21 PM, KAMEZAWA Hiroyuki wrote:
> On Mon,  5 Dec 2011 19:34:55 -0200
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> This patch lays down the foundation for the kernel memory component
>> of the Memory Controller.
>>
>> As of today, I am only laying down the following files:
>>
>>   * memory.independent_kmem_limit
>>   * memory.kmem.limit_in_bytes (currently ignored)
>>   * memory.kmem.usage_in_bytes (always zero)
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> Reviewed-by: Kirill A. Shutemov<kirill@shutemov.name>
>> CC: Paul Menage<paul@paulmenage.org>
>> CC: Greg Thelen<gthelen@google.com>
>
> As I wrote, please CC Johannes and  Michal Hocko for memcg related parts.

I forgot to add them to the patch itself, but they are in the CC list of 
the messages.

So they did get the mail.

> A few questions.
> ==
>> +	val = !!val;
>> +
>> +	if (parent&&  parent->use_hierarchy&&
>> +	   (val != parent->kmem_independent_accounting))
>> +		return -EINVAL;
> ==
> Hm, why you check val != parent->kmem_independent_accounting ?
>
> 	if (parent&&  parent->use_hierarchy)
> 		return -EINVAL;
> ?

Because I thought that making sure that everybody in the chain is 
consistent, it will make things simpler for us. But I am happy to change 
that if you prefer.

> BTW, you didn't check this cgroup has children or not.
> I think
>
> 	if (this_cgroup->use_hierarchy&&
>               !list_empty(this_cgroup->childlen))
> 		return -EINVAL;
>
Noted.

> ==
>> +	/*
>> +	 * TODO: We need to handle the case in which we are doing
>> +	 * independent kmem accounting as authorized by our parent,
>> +	 * but then our parent changes its parameter.
>> +	 */
>> +	cgroup_lock();
>> +	memcg->kmem_independent_accounting = val;
>> +	cgroup_unlock();
>
> Do we need cgroup_lock() here ?

Well, I removed almost all instances of it from previous patches, so I 
guess this one can go as well.

