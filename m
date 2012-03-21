Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2CUFYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:24:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41596 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2CUFYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:24:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6965AC.4070004@jp.fujitsu.com>
Date: Wed, 21 Mar 2012 14:22:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org, mgorman@suse.de,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669C2E.1010502@jp.fujitsu.com> <874ntlkrp6.fsf@linux.vnet.ibm.com> <4F66D993.2080100@jp.fujitsu.com> <4F671AE6.5020204@parallels.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87obrqsgno.fsf@linux.vnet.ibm.com>
In-Reply-To: <87obrqsgno.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/21 13:48), Aneesh Kumar K.V wrote:

> Glauber Costa <glommer@parallels.com> writes:
> 
>> On 03/19/2012 11:00 AM, KAMEZAWA Hiroyuki wrote:
>>> (2012/03/19 15:52), Aneesh Kumar K.V wrote:
>>>
>>>>
>>>>>> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>>>>>> +static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
>>>>>> +{
>>>>>> +	int idx;
>>>>>> +	for (idx = 0; idx<  hugetlb_max_hstate; idx++) {
>>>>>> +		if (memcg->hugepage[idx].usage>  0)
>>>>>> +			return 1;
>>>>>> +	}
>>>>>> +	return 0;
>>>>>> +}
>>>>>
>>>>>
>>>>> Please use res_counter_read_u64() rather than reading the value directly.
>>>>>
>>>>
>>>> The open-coded variant is mostly derived from mem_cgroup_force_empty. I
>>>> have updated the patch to use res_counter_read_u64.
>>>>
>>>
>>> Ah, ok. it's(maybe) my bad. I'll schedule a fix.
>>>
>> Kame,
>>
>> I actually have it ready here. I can submit it if you want.
>>
>> This one has bitten me as well when I was trying to experiment with the 
>> res_counter performance...
> 
> Do we really need memcg.res.usage to be accurate in that while loop ? If
> we miss a zero update because we encountered a partial update; in the
> next loop we will find it zero right ?
> 

At rmdir(), I assume there is no task in memcg. It means res->usage never
increase and no other thread than force_empty will touch res->counter.
So, I think memcg->res.usage > 0 never be wrong and we'll find correct comparison
by continuing the loop.

But recent kmem accounting at el may break the assumption (I'm not fully sure..)
So, I think it will be good to use res_counter_u64(). This part is not important for
performance, anyway.

Thanks,
-Kame



