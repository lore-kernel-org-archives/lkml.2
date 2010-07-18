Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0GRJu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:50:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54381 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0GRJu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:50:57 -0400
Message-ID: <4C42CE9D.1090303@vflare.org>
Date: Sun, 18 Jul 2010 15:21:25 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] Basic zcache functionality
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>	 <1279283870-18549-3-git-send-email-ngupta@vflare.org> <1279442671.2476.34.camel@edumazet-laptop>
In-Reply-To: <1279442671.2476.34.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 02:14 PM, Eric Dumazet wrote:
> Le vendredi 16 juillet 2010 à 18:07 +0530, Nitin Gupta a écrit :
> 
>> This particular patch implemets basic functionality only:
>> +static u64 zcache_get_stat(struct zcache_pool *zpool,
>> +		enum zcache_pool_stats_index idx)
>> +{
>> +	int cpu;
>> +	s64 val = 0;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		unsigned int start;
>> +		struct zcache_pool_stats_cpu *stats;
>> +
>> +		stats = per_cpu_ptr(zpool->stats, cpu);
>> +		do {
>> +			start = u64_stats_fetch_begin(&stats->syncp);
>> +			val += stats->count[idx];
>> +		} while (u64_stats_fetch_retry(&stats->syncp, start));
>> +	}
>> +
>> +	BUG_ON(val < 0);
>> +	return val;
>> +}
> 
> Sorry this is wrong.
> 
> Inside the fetch/retry block you should not do the addition to val, only
> a read of value to a temporary variable, since this might be done
> several times.
> 
> You want something like :
> 
> static u64 zcache_get_stat(struct zcache_pool *zpool,
> 			   enum zcache_pool_stats_index idx)
> {
> 	int cpu;
> 	s64 temp, val = 0;
> 
> 	for_each_possible_cpu(cpu) {
> 		unsigned int start;
> 		struct zcache_pool_stats_cpu *stats;
> 
> 		stats = per_cpu_ptr(zpool->stats, cpu);
> 		do {
> 			start = u64_stats_fetch_begin(&stats->syncp);
> 			temp = stats->count[idx];
> 		} while (u64_stats_fetch_retry(&stats->syncp, start));
> 		val += temp;
> 	}
> 
> ...
> }
> 
> 

Oh, my bad. Thanks for the fix!

On a side note: u64_stats_* should probably be renamed to stats64_* since
they are equally applicable for s64.


Thanks,
Nitin
