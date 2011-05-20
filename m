Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1ETX4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:56:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57061 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab1ETX4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NrXz8Mgoc6DmhzBdUzKAEhe+7pWfFaTPCR7zXo+nsRZ9w4OZRGzD6aZHF5ljMeLUEQ
         D/UvUrifjDmh1cJhviyMx7QuRof2ZT8rd1lZPa7oNtfOMtRFRb0dOkL6MnFnTM19NSYX
         xeSVfrNEjkeD46uNA7NSPwI4FXMDiB3ExoK+M=
MIME-Version: 1.0
In-Reply-To: <20110520144935.3bfdb2e2.akpm@linux-foundation.org>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124636.45c26cfa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520144935.3bfdb2e2.akpm@linux-foundation.org>
Date: Sat, 21 May 2011 08:56:46 +0900
Message-ID: <BANLkTi=Ap=NdZ+05UjjEsC5f5wdjo9yvew@mail.gmail.com>
Subject: Re: [PATCH 6/8] memcg asynchronous memory reclaim interface
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/21 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 20 May 2011 12:46:36 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> This patch adds a logic to keep usage margin to the limit in asynchronous way.
>> When the usage over some threshould (determined automatically), asynchronous
>> memory reclaim runs and shrink memory to limit - MEMCG_ASYNC_STOP_MARGIN.
>>
>> By this, there will be no difference in total amount of usage of cpu to
>> scan the LRU
>
> This is not true if "don't writepage at all (revisit this when
> dirty_ratio comes.)" is true.  Skipping over dirty pages can cause
> larger amounts of CPU consumption.
>
>> but we'll have a chance to make use of wait time of applications
>> for freeing memory. For example, when an application read a file or socket,
>> to fill the newly alloated memory, it needs wait. Async reclaim can make use
>> of that time and give a chance to reduce latency by background works.
>>
>> This patch only includes required hooks to trigger async reclaim and user interfaces.
>> Core logics will be in the following patches.
>>
>>
>> ...
>>
>>  /*
>> + * For example, with transparent hugepages, memory reclaim scan at hitting
>> + * limit can very long as to reclaim HPAGE_SIZE of memory. This increases
>> + * latency of page fault and may cause fallback. At usual page allocation,
>> + * we'll see some (shorter) latency, too. To reduce latency, it's appreciated
>> + * to free memory in background to make margin to the limit. This consumes
>> + * cpu but we'll have a chance to make use of wait time of applications
>> + * (read disk etc..) by asynchronous reclaim.
>> + *
>> + * This async reclaim tries to reclaim HPAGE_SIZE * 2 of pages when margin
>> + * to the limit is smaller than HPAGE_SIZE * 2. This will be enabled
>> + * automatically when the limit is set and it's greater than the threshold.
>> + */
>> +#if HPAGE_SIZE != PAGE_SIZE
>> +#define MEMCG_ASYNC_LIMIT_THRESH      (HPAGE_SIZE * 64)
>> +#define MEMCG_ASYNC_MARGIN         (HPAGE_SIZE * 4)
>> +#else /* make the margin as 4M bytes */
>> +#define MEMCG_ASYNC_LIMIT_THRESH      (128 * 1024 * 1024)
>> +#define MEMCG_ASYNC_MARGIN            (8 * 1024 * 1024)
>> +#endif
>
> Document them, please.  How are they used, what are their units.
>

will do.


>> +static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem);
>> +
>> +/*
>>   * The memory controller data structure. The memory controller controls both
>>   * page cache and RSS per cgroup. We would eventually like to provide
>>   * statistics based on the statistics developed by Rik Van Riel for clock-pro,
>> @@ -278,6 +303,12 @@ struct mem_cgroup {
>>        */
>>       unsigned long   move_charge_at_immigrate;
>>       /*
>> +      * Checks for async reclaim.
>> +      */
>> +     unsigned long   async_flags;
>> +#define AUTO_ASYNC_ENABLED   (0)
>> +#define USE_AUTO_ASYNC               (1)
>
> These are really confusing.  I looked at the implementation and at the
> documentation file and I'm still scratching my head.  I can't work out
> why they exist.  With the amount of effort I put into it ;)
>
> Also, AUTO_ASYNC_ENABLED and USE_AUTO_ASYNC have practically the same
> meaning, which doesn't help things.
>
Ah, yes it's confusing.

> Some careful description at this place in the code might help clear
> things up.
>
yes, I'll fix and add text, consider better name.

> Perhaps s/USE_AUTO_ASYNC/AUTO_ASYNC_IN_USE/ is what you meant.
>
Ah, good name :)

>>
>> ...
>>
>> +static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem)
>> +{
>> +     if (!test_bit(USE_AUTO_ASYNC, &mem->async_flags))
>> +             return;
>> +     if (res_counter_margin(&mem->res) <= MEMCG_ASYNC_MARGIN) {
>> +             /* Fill here */
>> +     }
>> +}
>
> I'd expect a function called foo_may_bar() to return a bool.
>
ok,

> But given the lack of documentation and no-op implementation, I have o
> idea what's happening here!
>
yes. Hmm, maybe adding an empty function here and comments on the
function will make this better.

Thank you for review.
-Kame
