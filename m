Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2ECDPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:15:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40713 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2ECDPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:15:13 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 23:15:13 EDT
Message-ID: <4FA1F6FD.7060100@gmail.com>
Date: Thu, 03 May 2012 11:09:49 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sha Zhengju <handai.szj@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RESEND] memcg: Free spare array to avoid memory leak
References: <1334825690-9065-1-git-send-email-handai.szj@taobao.com> <20120501140314.1d7312fb.akpm@linux-foundation.org>
In-Reply-To: <20120501140314.1d7312fb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 05:03 AM, Andrew Morton wrote:
> On Thu, 19 Apr 2012 16:54:50 +0800
> Sha Zhengju<handai.szj@gmail.com>  wrote:
>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> When the last event is unregistered, there is no need to keep the spare
>> array anymore. So free it to avoid memory leak.
> How serious is this leak?  Is there any way in which it can be used to
> consume unbounded amounts of memory?

While registering events, the ->primary will apply for a larger array to 
store
the new threshold info and the ->spare holds the old primary space.
But once unregistering event, the ->primary and ->spare pointer will be 
swapped
after updating thresholds info. So if we have an eventfd with many(>1) 
thresholds
attached to it, mem_cgroup_usage_unregister_event() will finally leave 
->spare
holding a large array and have no chance to be freed.

I hope it is clear.

>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>>   swap_buffers:
>>   	/* Swap primary and spare array */
>>   	thresholds->spare = thresholds->primary;
>> +	/* If all events are unregistered, free the spare array */
>> +	if (!new) {
>> +		kfree(thresholds->spare);
>> +		thresholds->spare = NULL;
>> +	}
>> +
>>   	rcu_assign_pointer(thresholds->primary, new);
>>
> The resulting code is really quite convoluted.  Try to read through it
> and follow the handling of ->primary and ->spare.  Head spins.
>
> What is the protocol here?  If ->primary is NULL then ->spare must also
> be NULL?
>

To be simple:  if new(->primary) is NULL, it means we are unregistering
the last threshold and there is no need to keep ->spare any more.
So give the ->spare array a chance to be freed.

Thanks,
Sha

> I'll apply the patch, although I don't (yet) have sufficient info to
> know which kernels it should be applied to.  Perhaps someone could
> revisit this code and see if it can be made more straightforward.
>
> .
>

