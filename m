Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2CGJHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:07:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41557 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab2CGJHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:07:00 -0500
X-IronPort-AV: E=Sophos;i="4.73,545,1325433600"; 
   d="scan'208";a="4480137"
Message-ID: <4F5724BC.10207@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 17:05:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier related
 damage v2
References: <20120306132735.GA2855@suse.de> <20120306122657.8e5b128d.akpm@linux-foundation.org> <20120306224201.GA17697@suse.de> <20120306145451.8eff82a6.akpm@linux-foundation.org>
In-Reply-To: <20120306145451.8eff82a6.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:05:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:05:03,
	Serialize complete at 2012-03-07 17:05:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 14:54:51 -0800, Andrew Morton wrote:
>>>> -static inline void put_mems_allowed(void)
>>>> +/*
>>>> + * If this returns false, the operation that took place after get_mems_allowed
>>>> + * may have failed. It is up to the caller to retry the operation if
>>>> + * appropriate
>>>> + */
>>>> +static inline bool put_mems_allowed(unsigned int seq)
>>>>  {
>>>> -	/*
>>>> -	 * ensure that reading mems_allowed and mempolicy before reducing
>>>> -	 * mems_allowed_change_disable.
>>>> -	 *
>>>> -	 * the write-side task will know that the read-side task is still
>>>> -	 * reading mems_allowed or mempolicy, don't clears old bits in the
>>>> -	 * nodemask.
>>>> -	 */
>>>> -	smp_mb();
>>>> -	--ACCESS_ONCE(current->mems_allowed_change_disable);
>>>> +	return !read_seqcount_retry(&current->mems_allowed_seq, seq);
>>>>  }
>>>>  
>>>>  static inline void set_mems_allowed(nodemask_t nodemask)
>>>
>>> How come set_mems_allowed() still uses task_lock()?
>>>
>>
>> Consistency.
>>
>> The task_lock is taken by kernel/cpuset.c when updating
>> mems_allowed so it is taken here. That said, it is unnecessary to take
>> as the two places where set_mems_allowed is used are not going to be
>> racing. In the unlikely event that set_mems_allowed() gets another user,
>> there is no harm is leaving the task_lock as it is. It's not in a hot
>> path of any description.
> 
> But shouldn't set_mems_allowed() bump mems_allowed_seq?
> 

task_lock is also used to protect mempolicy, so ...

Thanks
Miao
