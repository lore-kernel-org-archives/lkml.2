Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2AHQEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:04:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43126 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2AHQEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:04:21 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <20120103142624.faf46d77.akpm@linux-foundation.org>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
	<1325499859-2262-2-git-send-email-gilad@benyossef.com>
	<20120103142624.faf46d77.akpm@linux-foundation.org>
Date: Sun, 8 Jan 2012 18:04:19 +0200
Message-ID: <CAOtvUMcx0etVbYWz_z66ns9NbU=rvRChQqc1YYYYNJjYmOUsoQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] smp: Introduce a generic on_each_cpu_mask function
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 12:26 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon,  2 Jan 2012 12:24:12 +0200
> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> on_each_cpu_mask calls a function on processors specified my cpumask,
>> which may include the local processor.
>>
>> All the limitation specified in smp_call_function_many apply.
>>
>> ...
>>
>> --- a/include/linux/smp.h
>> +++ b/include/linux/smp.h
>> @@ -102,6 +102,13 @@ static inline void call_function_init(void) { }
>>  int on_each_cpu(smp_call_func_t func, void *info, int wait);
>>
>>  /*
>> + * Call a function on processors specified by mask, which might include
>> + * the local one.
>> + */
>> +void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
>> +             void *info, bool wait);
>> +
>> +/*
>>   * Mark the boot cpu "online" so that it can call console drivers in
>>   * printk() and can access its per-cpu storage.
>>   */
>> @@ -132,6 +139,15 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
>>               local_irq_enable();             \
>>               0;                              \
>>       })
>> +#define on_each_cpu_mask(mask, func, info, wait) \
>> +     do {                                            \
>> +             if (cpumask_test_cpu(0, (mask))) {      \
>> +                     local_irq_disable();            \
>> +                     (func)(info);                   \
>> +                     local_irq_enable();             \
>> +             }                                       \
>> +     } while (0)
>
> Why is the cpumask_test_cpu() call there?  It's hard to think of a
> reason why "mask" would specify any CPU other than "0" in a
> uniprocessor kernel.

As Michal already answered, because the current CPU might be not
specified in the mask, even on UP.

> If this code remains as-is, please add a comment here explaining this,
> so others don't wonder the same thing.

Comment added and will be included in V6.

Thanks for the review.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
