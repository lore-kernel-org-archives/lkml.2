Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2CCC3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 21:29:08 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58928 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2CCC3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 21:29:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.28.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F514E09.5060801@redhat.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
	<4F514E09.5060801@redhat.com>
Date: Sat, 3 Mar 2012 10:29:04 +0800
Message-ID: <CAJd=RBBdnA-gCXo8w5afng_v+AgfQF797pKW0eDdVJbszULvhg@mail.gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 6:47 AM, Rik van Riel <riel@redhat.com> wrote:
> On 03/02/2012 12:36 PM, Satoru Moriya wrote:
>>
>> Sometimes we'd like to avoid swapping out anonymous memory
>> in particular, avoid swapping out pages of important process or
>> process groups while there is a reasonable amount of pagecache
>> on RAM so that we can satisfy our customers' requirements.
>>
>> OTOH, we can control how aggressive the kernel will swap memory pages
>> with /proc/sys/vm/swappiness for global and
>> /sys/fs/cgroup/memory/memory.swappiness for each memcg.
>>
>> But with current reclaim implementation, the kernel may swap out
>> even if we set swappiness==0 and there is pagecache on RAM.
>>
>> This patch changes the behavior with swappiness==0. If we set
>> swappiness==0, the kernel does not swap out completely
>> (for global reclaim until the amount of free pages and filebacked
>> pages in a zone has been reduced to something very very small
>> (nr_free + nr_filebacked<  high watermark)).
>>
>> Any comments are welcome.
>>
>> Regards,
>> Satoru Moriya
>>
>> Signed-off-by: Satoru Moriya<satoru.moriya@hds.com>
>> ---
>>  mm/vmscan.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index c52b235..27dc3e8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1983,10 +1983,10 @@ static void get_scan_count(struct mem_cgroup_zone
>> *mz, struct scan_control *sc,
>>         * proportional to the fraction of recently scanned pages on
>>         * each list that were recently referenced and in active use.
>>         */
>> -       ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
>> +       ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
>>        ap /= reclaim_stat->recent_rotated[0] + 1;
>>
>> -       fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
>> +       fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
>>        fp /= reclaim_stat->recent_rotated[1] + 1;
>>        spin_unlock_irq(&mz->zone->lru_lock);
>
>
> ACK on this bit of the patch.
>
>> @@ -1999,7 +1999,7 @@ out:
>>                unsigned long scan;
>>
>>                scan = zone_nr_lru_pages(mz, lru);
>> -               if (priority || noswap) {
>> +               if (priority || noswap || !vmscan_swappiness(mz, sc)) {
>>                        scan>>= priority;
>>                        if (!scan&&  force_scan)
>>                                scan = SWAP_CLUSTER_MAX;
>
>
> However, I do not understand why we fail to scale
> the number of pages we want to scan with priority
> if "noswap".
>
> For that matter, surely if we do not want to swap
> out anonymous pages, we WANT to go into this if
> branch, in order to make sure we set "scan" to 0?
>
> scan = div64_u64(scan * fraction[file], denominator);
>
> With your patch and swappiness=0, or no swap space, it
> looks like we do not zero out "scan" and may end up
> scanning anonymous pages.
>
> Am I overlooking something?  Is this correct?
>

Try to simplify the complex a bit :)

Good weekend
-hd

--- a/mm/vmscan.c	Wed Feb  8 20:10:14 2012
+++ b/mm/vmscan.c	Sat Mar  3 10:02:10 2012
@@ -1997,15 +1997,23 @@ static void get_scan_count(struct mem_cg
 out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
-		unsigned long scan;
+		unsigned long scan = 0;

-		scan = zone_nr_lru_pages(mz, lru);
-		if (priority || noswap) {
-			scan >>= priority;
-			if (!scan && force_scan)
-				scan = SWAP_CLUSTER_MAX;
+		/* First, check noswap */
+		if (noswap && !file)
+			goto set;
+
+		/* Second, apply priority */
+		scan = zone_nr_lru_pages(mz, lru) >> priority;
+
+		/* Third, check force */
+		if (!scan && force_scan)
+			scan = SWAP_CLUSTER_MAX;
+
+		/* Finally, try to avoid div64 */
+		if (scan)
 			scan = div64_u64(scan * fraction[file], denominator);
-		}
+set:
 		nr[lru] = scan;
 	}
 }
--
