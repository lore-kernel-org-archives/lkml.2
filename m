Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423202Ab2JaQO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:14:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423025Ab2JaQOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:14:51 -0400
Message-ID: <50914F10.2050903@redhat.com>
Date: Wed, 31 Oct 2012 12:17:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, klamm@yandex-team.ru,
        akpm@linux-foundation.org, mgorman@suse.de
Subject: Re: [PATCH RFC] mm,vmscan: only evict file pages when we have plenty
References: <20121030144204.0aa14d92@dull> <20121031153950.GA2305@cmpxchg.org>
In-Reply-To: <20121031153950.GA2305@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 11:39 AM, Johannes Weiner wrote:
> On Tue, Oct 30, 2012 at 02:42:04PM -0400, Rik van Riel wrote:
>> If we have more inactive file pages than active file pages, we
>> skip scanning the active file pages alltogether, with the idea
>> that we do not want to evict the working set when there is
>> plenty of streaming IO in the cache.
>>
>> However, the code forgot to also skip scanning anonymous pages
>> in that situation.  That lead to the curious situation of keeping
>> the active file pages protected from being paged out when there
>> are lots of inactive file pages, while still scanning and evicting
>> anonymous pages.
>>
>> This patch fixes that situation, by only evicting file pages
>> when we have plenty of them and most are inactive.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>>   mm/vmscan.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 2624edc..1a53fbb 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1686,6 +1686,15 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>>   			fraction[1] = 0;
>>   			denominator = 1;
>>   			goto out;
>> +		} else if (!inactive_file_is_low_global(zone)) {
>> +			/*
>> +			 * There is enough inactive page cache, do not
>> +			 * reclaim anything from the working set right now.
>> +			 */
>> +			fraction[0] = 0;
>> +			fraction[1] = 1;
>> +			denominator = 1;
>> +			goto out;
>
> Is there a specific reason for making this exclusive to global
> reclaim?  The "force scan anon when file is low" HAS to be specific to
> global reclaim because swapping may not be allowed in memcg limit
> reclaim, but not scanning anon when there is enough easy page cache is
> a legitimate memcg limit reclaim thing to do as well.

Good point.  I guess this check would work fine inside
cgroup reclaim, too.

Want to give that a try?

>
> I.e. could this check be moved just below the
>
> 	/* If we have no swap space, do not bother scanning anon pages. */
> 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
> 		noswap = 1;
> 		fraction[0] = 0;
> 		fraction[1] = 1;
> 		denominator = 1;
> 		goto out;
> 	}
>
> section?
>

