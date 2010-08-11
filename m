Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0HKQjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:39:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0HKQjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:39:07 -0400
Message-ID: <4C62D241.2040208@vflare.org>
Date: Wed, 11 Aug 2010 22:09:29 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-4-git-send-email-ngupta@vflare.org> <20100809213431.d7699d46.akpm@linux-foundation.org>
In-Reply-To: <20100809213431.d7699d46.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 10:04 AM, Andrew Morton wrote:
> On Mon,  9 Aug 2010 22:56:49 +0530 Nitin Gupta <ngupta@vflare.org> wrote:
> 
>> +/*
>> + * Individual percpu values can go negative but the sum across all CPUs
>> + * must always be positive (we store various counts). So, return sum as
>> + * unsigned value.
>> + */
>> +static u64 zram_get_stat(struct zram *zram, enum zram_stats_index idx)
>>  {
>> -	u64 val;
>> -
>> -	spin_lock(&zram->stat64_lock);
>> -	val = *v;
>> -	spin_unlock(&zram->stat64_lock);
>> +	int cpu;
>> +	s64 val = 0;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		s64 temp;
>> +		unsigned int start;
>> +		struct zram_stats_cpu *stats;
>> +
>> +		stats = per_cpu_ptr(zram->stats, cpu);
>> +		do {
>> +			start = u64_stats_fetch_begin(&stats->syncp);
>> +			temp = stats->count[idx];
>> +		} while (u64_stats_fetch_retry(&stats->syncp, start));
>> +		val += temp;
>> +	}
>>  
>> +	WARN_ON(val < 0);
>>  	return val;
>>  }
> 
> That reimplements include/linux/percpu_counter.h, poorly.
> 
> Please see the June discussion "[PATCH v2 1/2] tmpfs: Quick token
> library to allow scalable retrieval of tokens from token jar" for some
> discussion.
> 
> 

I read the discussion you pointed out but still fail to see how percpu_counters,
with all their overhead, are better than simple pcpu variable used in current
version. What is the advantage?

Thanks,
Nitin

