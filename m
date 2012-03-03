Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab2CCI1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:27:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38039 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2CCI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:27:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.122.144 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F51D5FB.4050106@openvz.org>
Date: Sat, 03 Mar 2012 12:27:39 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] mm: rework __isolate_lru_page() file/anon filter
References: <20120229090748.29236.35489.stgit@zurg> <20120229091547.29236.28230.stgit@zurg> <alpine.LSU.2.00.1203021542560.3578@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203021542560.3578@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 29 Feb 2012, Konstantin Khlebnikov wrote:
>
>> This patch adds file/anon filter bits into isolate_mode_t,
>> this allows to simplify checks in __isolate_lru_page().
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> Almost-Acked-by: Hugh Dickins<hughd@google.com>
>
> with one whitespace nit, and one functional addition requested.
>
> I'm perfectly happy with your :?s myself, but some people do dislike
> them.  I'm happy with the switch alternative if it's as efficient:
> something that surprised me very much when trying to get convincing
> performance numbers for per-memcg per-zone lru_lock at home...
>
> ... __isolate_lru_page() featured astonishly high on the perf report
> of streaming from files on ext4 on /dev/ram0 to /dev/null, coming
> immediately below the obvious zeroing and copying: okay, the zeroing
> and copying were around 30% each, and __isolate_lru_page() down around
> 2% or below, but even so it seemed very odd that it should feature so
> high, and any optimizations to it very welcome - unless it was purely
> some bogus result.

Actually ANON/FILE ACTIVE/INACTIVE checks does not required at non-lumpy reclaim
(all pages are picked from right lru list) and compaction (it does not care).
But seems like removing these two bit-checks cannot give noticeable performance gain.

This patch can be postponed. It does not so important and
it does not share context with other patches in this set.

>
>> ---
>>   include/linux/mmzone.h |    4 ++++
>>   include/linux/swap.h   |    2 +-
>>   mm/compaction.c        |    5 +++--
>>   mm/vmscan.c            |   27 +++++++++++++--------------
>>   4 files changed, 21 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index eff4918..2fed935 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -193,6 +193,10 @@ struct lruvec {
>>   #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
>>   /* Isolate for asynchronous migration */
>>   #define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x10)
>> +/* Isolate swap-backed pages */
>> +#define	ISOLATE_ANON		((__force isolate_mode_t)0x20)
>> +/* Isolate file-backed pages */
>> +#define	ISOLATE_FILE		((__force isolate_mode_t)0x40)
>
>  From the patch you can see that the #defines above yours used a
> space where you have used a tab: better to use a space as above.
>
>> @@ -375,7 +376,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>>   			mode |= ISOLATE_ASYNC_MIGRATE;
>>
>>   		/* Try isolate the page */
>> -		if (__isolate_lru_page(page, mode, 0) != 0)
>> +		if (__isolate_lru_page(page, mode) != 0)
>>   			continue;
>
> I thought you were missing something there, but no, that's rather
> the case you are simplifying.  However...
>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index af6cfe7..1b70338 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1520,6 +1511,10 @@ shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone *mz,
>>   		isolate_mode |= ISOLATE_UNMAPPED;
>>   	if (!sc->may_writepage)
>>   		isolate_mode |= ISOLATE_CLEAN;
>> +	if (file)
>> +		isolate_mode |= ISOLATE_FILE;
>> +	else
>> +		isolate_mode |= ISOLATE_ANON;
>
> Above here, under "if (sc->reclaim_mode&  RECLAIM_MODE_LUMPYRECLAIM)",
> don't you need
>
> 		isolate_mode |= ISOLATE_ACTIVE | ISOLATE_FILE | ISOLATE_ANON;
>
> now to reproduce the same "all_lru_mode" behaviour as before?

Yes, I missed this. Thanks.

>
> Hugh

