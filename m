Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2AXDpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:45:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54254 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2AXDpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 22:45:53 -0500
MIME-Version: 1.0
In-Reply-To: <CALWz4iyB0oSMBsfLJYD+xrB7ua9bRg5FD=cw4Sc-EdG1iLynow@mail.gmail.com>
References: <CAJd=RBBG5X8=vkdRTCZ1bvTaVxPAVun9O+yiX0SM6yDzrxDGDQ@mail.gmail.com>
	<CALWz4iyB0oSMBsfLJYD+xrB7ua9bRg5FD=cw4Sc-EdG1iLynow@mail.gmail.com>
Date: Tue, 24 Jan 2012 11:45:52 +0800
Message-ID: <CAJd=RBC+y3pVAsbCNP+mBm6Lfcx5XpTcg6D-us5J1E+W+_JcAQ@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: check mem cgroup over reclaimed
From: Hillf Danton <dhillf@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

On Tue, Jan 24, 2012 at 3:04 AM, Ying Han <yinghan@google.com> wrote:
> On Sun, Jan 22, 2012 at 5:55 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> To avoid reduction in performance of reclaimee, checking overreclaim is added
>> after shrinking lru list, when pages are reclaimed from mem cgroup.
>>
>> If over reclaim occurs, shrinking remaining lru lists is skipped, and no more
>> reclaim for reclaim/compaction.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/mm/vmscan.c       Mon Jan 23 00:23:10 2012
>> +++ b/mm/vmscan.c       Mon Jan 23 09:57:20 2012
>> @@ -2086,6 +2086,7 @@ static void shrink_mem_cgroup_zone(int p
>>        unsigned long nr_reclaimed, nr_scanned;
>>        unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>>        struct blk_plug plug;
>> +       bool memcg_over_reclaimed = false;
>>
>>  restart:
>>        nr_reclaimed = 0;
>> @@ -2103,6 +2104,11 @@ restart:
>>
>>                                nr_reclaimed += shrink_list(lru, nr_to_scan,
>>                                                            mz, sc, priority);
>> +
>> +                               memcg_over_reclaimed = !scanning_global_lru(mz)
>> +                                       && (nr_reclaimed >= nr_to_reclaim);
>> +                               if (memcg_over_reclaimed)
>> +                                       goto out;
>
> Why we need the change here? Do we have number to demonstrate?

See below please 8-)

>
>
>>                        }
>>                }
>>                /*
>> @@ -2116,6 +2122,7 @@ restart:
>>                if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
>>                        break;
>>        }
>> +out:
>>        blk_finish_plug(&plug);
>>        sc->nr_reclaimed += nr_reclaimed;
>>
>> @@ -2127,7 +2134,8 @@ restart:
>>                shrink_active_list(SWAP_CLUSTER_MAX, mz, sc, priority, 0);
>>
>>        /* reclaim/compaction might need reclaim to continue */
>> -       if (should_continue_reclaim(mz, nr_reclaimed,
>> +       if (!memcg_over_reclaimed &&
>> +           should_continue_reclaim(mz, nr_reclaimed,
>>                                        sc->nr_scanned - nr_scanned, sc))
>
> This changes the existing logic. What if the nr_reclaimed is greater
> than nr_to_reclaim, but smaller than pages_for_compaction? The
> existing logic is to continue reclaiming.
>
With soft limit available, what if nr_to_reclaim set to be the number of
pages exceeding soft limit? With over reclaim abused, what are the targets
of soft limit?

Thanks
Hillf
