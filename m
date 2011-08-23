Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1HWGsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:48:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19416 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1HWGsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:48:30 -0400
Message-ID: <4E534D13.5020102@openvz.org>
Date: Tue, 23 Aug 2011 10:47:47 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110702 Iceape/2.0.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
References: <20110822101721.19462.63082.stgit@zurg> <20110822143006.60f4b560.akpm@linux-foundation.org>
In-Reply-To: <20110822143006.60f4b560.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
<snip>
>>   		long new_nr;
>>   		long batch_size = shrinker->batch ? shrinker->batch
>>   						  : SHRINK_BATCH;
>>
>> +		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
>> +		if (max_pass<= 0)
>> +			continue;
>> +
>>   		/*
>>   		 * copy the current shrinker scan count into a local variable
>>   		 * and zero it so that other concurrent shrinker invocations
>> @@ -266,7 +270,6 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>>   		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
>>
>>   		total_scan = nr;
>> -		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
>>   		delta = (4 * nr_pages_scanned) / shrinker->seeks;
>>   		delta *= max_pass;
>>   		do_div(delta, lru_pages + 1);
>
> Why was the shrinker call moved to before the alteration of shrinker->nr?

I think, if we skip shrinker we shouldn't reset accumulated pressure,
because next reclaimer (for example with less strict gfp) can use it.
