Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2KUBDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:03:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58172 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2KUBC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:02:58 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50AC282A.4070309@jp.fujitsu.com>
Date: Wed, 21 Nov 2012 10:02:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com> <20121120134932.055bc192.akpm@linux-foundation.org>
In-Reply-To: <20121120134932.055bc192.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/21 6:49), Andrew Morton wrote:
> On Mon, 19 Nov 2012 17:44:34 -0800 (PST)
> David Rientjes <rientjes@google.com> wrote:
>
>> While profiling numa/core v16 with cgroup_disable=memory on the command
>> line, I noticed mem_cgroup_count_vm_event() still showed up as high as
>> 0.60% in perftop.
>>
>> This occurs because the function is called extremely often even when memcg
>> is disabled.
>>
>> To fix this, inline the check for mem_cgroup_disabled() so we avoid the
>> unnecessary function call if memcg is disabled.
>>
>> ...
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -181,7 +181,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>>   						gfp_t gfp_mask,
>>   						unsigned long *total_scanned);
>>
>> -void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
>> +void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
>> +static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
>> +					     enum vm_event_item idx)
>> +{
>> +	if (mem_cgroup_disabled() || !mm)
>> +		return;
>> +	__mem_cgroup_count_vm_event(mm, idx);
>> +}
>
> Does the !mm case occur frequently enough to justify inlining it, or
> should that test remain out-of-line?
>
I think this should be out-of-line.

Thanks,
-Kame

