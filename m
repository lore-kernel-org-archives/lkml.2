Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1EUAXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:23:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38613 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1EUAXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b9clUbLC4TKRLdfFv5DTA/3zRaVNpd5HMYwJ+WOolzoHOBfwElOt8d+lisNhesu9pc
         SFLlPTfv3UOcEqXgbESMWaGXU46RLtumkv2MYqA10Z7q6Fu1K71xKeUhsXvejECVmsDM
         xwmd/xrBnSHUTpzEAbKNCCcqX832xfCvpdW8I=
MIME-Version: 1.0
In-Reply-To: <20110520145008.1ea51f41.akpm@linux-foundation.org>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124753.56730b37.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520145008.1ea51f41.akpm@linux-foundation.org>
Date: Sat, 21 May 2011 09:23:46 +0900
Message-ID: <BANLkTi=y40Q5WcogT0VX2kwnYRWfi5jdSA@mail.gmail.com>
Subject: Re: [PATCH 7/8] memcg static scan reclaim for asyncrhonous reclaim
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
> On Fri, 20 May 2011 12:47:53 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> Ostatic scan rate async memory reclaim for memcg.
>>
>> This patch implements a routine for asynchronous memory reclaim for memory
>> cgroup, which will be triggered when the usage is near to the limit.
>> This patch includes only code codes for memory freeing.
>>
>> Asynchronous memory reclaim can be a help for reduce latency because
>> memory reclaim goes while an application need to wait or compute something.
>>
>> To do memory reclaim in async, we need some thread or worker.
>> Unlike node or zones, memcg can be created on demand and there may be
>> a system with thousands of memcgs. So, the number of jobs for memcg
>> asynchronous memory reclaim can be big number in theory. So, node kswapd
>> codes doesn't fit well. And some scheduling on memcg layer will be appreciated.
>>
>> This patch implements a static scan rate memory reclaim.
>> When shrink_mem_cgroup_static_scan() is called, it scans pages at most
>> MEMCG_STATIC_SCAN_LIMIT(2048) pages and returnes how memory shrinking
>> was hard. When the function returns false, the caller can assume memory
>> reclaim on the memcg seemed difficult and can add some scheduling delay
>> for the job.
>
> Fully and carefully define the new term "static scan rate"?
>

Ah, yes. It's need to be explained.

>> Note:
>>   - I think this concept can be used for enhancing softlimit, too.
>>     But need more study.
>>
>>
>> ...
>>
>> +             total_scan += nr[l];
>> +     }
>> +     /*
>> +      * Asynchronous reclaim for memcg uses static scan rate for avoiding
>> +      * too much cpu consumption in a memcg. Adjust the scan count to fit
>> +      * into scan_limit.
>> +      */
>> +     if (total_scan > sc->scan_limit) {
>> +             for_each_evictable_lru(l) {
>> +                     if (!nr[l] < SWAP_CLUSTER_MAX)
>
> That statement doesn't do what you think it does!
>
....that's my bug. will be fixed or removed in the next version.

>> +                             continue;
>> +                     nr[l] = div64_u64(nr[l] * sc->scan_limit, total_scan);
>> +                     nr[l] = max((unsigned long)SWAP_CLUSTER_MAX, nr[l]);
>> +             }
>>       }
>
> This gets included in CONFIG_CGROUP_MEM_RES_CTLR=n kernels.  Needlessly?
>
Yes, no global reclaim uses scan_limit, now. I'll add a
scanning_global_lru() check
and compiler can hide this.

> It also has the potential to affect non-memcg behaviour at runtime.
>
Hmm, if scan_limit is set by mistake....ok, I'll add scanning_global_lru().


>>  }
>>
>> @@ -1938,6 +1955,11 @@ restart:
>>                */
>>               if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
>>                       break;
>> +             /*
>> +              * static scan rate memory reclaim ?
>
> I still don't know what "static scan rate" means :(
>
static scan rate ....maybe my English skill is also bad ;(

Maybe I should name this as "stable scan rate per run" or "limited
scan reclaim",
 it means when it's invoked, scan pages up to the scan_limit, at most.
In usual reclaim, it tries to reclaim some amount of pages and may need to scan
the whole memory. But this logic stops and returns to the caller when
hits scan_limit.


>> +              */
>> +             if (sc->nr_scanned > sc->scan_limit)
>> +                     break;
>>       }
>>       sc->nr_reclaimed += nr_reclaimed;
>>
>>
>> ...
>>
>> +static void shrink_mem_cgroup_node(int nid,
>> +             int priority, struct scan_control *sc)
>> +{
>> +     unsigned long this_scanned = 0;
>> +     unsigned long this_reclaimed = 0;
>> +     int i;
>> +
>> +     for (i = 0; i < NODE_DATA(nid)->nr_zones; i++) {
>> +             struct zone *zone = NODE_DATA(nid)->node_zones + i;
>> +
>> +             if (!populated_zone(zone))
>> +                     continue;
>> +             if (!mem_cgroup_zone_reclaimable_pages(sc->mem_cgroup, nid, i))
>> +                     continue;
>> +             /* If recent scan didn't go good, do writepate */
>> +             sc->nr_scanned = 0;
>> +             sc->nr_reclaimed = 0;
>> +             shrink_zone(priority, zone, sc);
>> +             this_scanned += sc->nr_scanned;
>> +             this_reclaimed += sc->nr_reclaimed;
>> +             if (this_reclaimed >= sc->nr_to_reclaim)
>> +                     break;
>> +             if (sc->scan_limit < this_scanned)
>> +                     break;
>> +             if (need_resched())
>> +                     break;
>
> Whoa!  Explain?
>
>> +     }
>> +     sc->nr_scanned = this_scanned;
>> +     sc->nr_reclaimed = this_reclaimed;
>> +     return;
>> +}
>> +
>> +#define MEMCG_ASYNCSCAN_LIMIT                (2048)
>
> Needs documentation.  What happens if I set it to 1024?
>
I will do and explain why 2048 now.

>> +bool mem_cgroup_shrink_static_scan(struct mem_cgroup *mem, long required)
>
> Exported function has no interface documentation.
>
> `required' appears to have units of "number of pages".  Should be unsigned.
>
>
yes, I'll fix and add documents.

> +{
>> +     int nid, priority, noscan;
>
> `noscan' is poorly named and distressingly mysterious.  Basically I
> don't have a clue what you're doing with this.
>
> It should be unsigned.
>

ok, I'll think of better name ....hmm, scan_failed  or no_reclaimable_pages.


>> +     unsigned long total_scanned, total_reclaimed, reclaim_target;
>> +     struct scan_control sc = {
>> +             .gfp_mask      = GFP_HIGHUSER_MOVABLE,
>> +             .may_unmap     = 1,
>> +             .may_swap      = 1,
>> +             .order         = 0,
>> +             /* we don't writepage in our scan. but kick flusher threads */
>> +             .may_writepage = 0,
>> +     };
>> +     struct mem_cgroup *victim, *check_again;
>> +     bool congested = true;
>> +
>> +     total_scanned = 0;
>> +     total_reclaimed = 0;
>> +     reclaim_target = min(required, MEMCG_ASYNCSCAN_LIMIT/2L);
>> +     sc.swappiness = mem_cgroup_swappiness(mem);
>> +
>> +     noscan = 0;
>> +     check_again = NULL;
>> +
>> +     do {
>> +             victim = mem_cgroup_select_victim(mem);
>> +
>> +             if (!mem_cgroup_test_reclaimable(victim)) {
>> +                     mem_cgroup_release_victim(victim);
>> +                     /*
>> +                      * if selected a hopeless victim again, give up.
>> +                      */
>> +                     if (check_again == victim)
>> +                             goto out;
>> +                     if (!check_again)
>> +                             check_again = victim;
>> +             } else
>> +                     check_again = NULL;
>> +     } while (check_again);
>
> What's all this trying to do?
>
This tries to do walk hierarchy of memcg and select a victim memcg
to be scanned under given memcg. But if all pages under the memcg is
unevictable,
we have no job. So, this gives up when the same memcg found twice, which is
unevictable. This works because current select_victim() is round-robin....

Yes, need to be documented.


>> +     current->flags |= PF_SWAPWRITE;
>> +     /*
>> +      * We can use arbitrary priority for our run because we just scan
>> +      * up to MEMCG_ASYNCSCAN_LIMIT and reclaim only the half of it.
>> +      * But, we need to have early-give-up chance for avoid cpu hogging.
>> +      * So, start from a small priority and increase it.
>> +      */
>> +     priority = DEF_PRIORITY;
>> +
>> +     while ((total_scanned < MEMCG_ASYNCSCAN_LIMIT) &&
>> +             (total_reclaimed < reclaim_target)) {
>> +
>> +             /* select a node to scan */
>> +             nid = mem_cgroup_select_victim_node(victim);
>> +
>> +             sc.mem_cgroup = victim;
>> +             sc.nr_scanned = 0;
>> +             sc.scan_limit = MEMCG_ASYNCSCAN_LIMIT - total_scanned;
>> +             sc.nr_reclaimed = 0;
>> +             sc.nr_to_reclaim = reclaim_target - total_reclaimed;
>> +             shrink_mem_cgroup_node(nid, priority, &sc);
>> +             if (sc.nr_scanned) {
>> +                     total_scanned += sc.nr_scanned;
>> +                     total_reclaimed += sc.nr_reclaimed;
>> +                     noscan = 0;
>> +             } else
>> +                     noscan++;
>> +             mem_cgroup_release_victim(victim);
>> +             /* ok, check condition */
>> +             if (total_scanned > total_reclaimed * 2)
>> +                     wakeup_flusher_threads(sc.nr_scanned);
>> +
>> +             if (mem_cgroup_async_should_stop(mem))
>> +                     break;
>> +             /* If memory reclaim seems heavy, return that we're congested */
>> +             if (total_scanned > MEMCG_ASYNCSCAN_LIMIT/4 &&
>> +                 total_scanned > total_reclaimed*8)
>> +                     break;
>> +             /*
>> +              * The whole system is busy or some status update
>> +              * is not synched. It's better to wait for a while.
>> +              */
>> +             if ((noscan > 1) || (need_resched()))
>> +                     break;
>
> So we bale out if there were two priority levels at which
> shrink_mem_cgroup_node() didn't scan any pages?  What on earth???
>
I thought there is a case that a memcg contains only ANON in a node
on swapless system or all pages are isolated or some...

> And what was the point in calling shrink_mem_cgroup_node() if it didn't
> scan anything?

I wonder if there are threads in synchronous relcaim we can have race.

> I could understand using nr_reclaimed...
>
I'll reconsider why I inserted this..(I might add this before fixing
get_scan_count()..0

Maybe I can remove this check because I don't hit this case, and later,
memcg can have some logic similar to zone->all_unreclaimable.



>> +             /* ok, we can do deeper scanning. */
>> +             priority--;
>> +     }
>> +     current->flags &= ~PF_SWAPWRITE;
>> +     /*
>> +      * If we successfully freed the half of target, report that
>> +      * memory reclaim went smoothly.
>> +      */
>> +     if (total_reclaimed > reclaim_target/2)
>> +             congested = false;
>> +out:
>> +     return congested;
>> +}
>>  #endif
>
>
>
> I dunno, the whole thing seems sprinkled full of arbitrary assumptions
> and guess-and-giggle magic numbers.  I expect a lot of this stuff is
> just unnecessary.  And if it _is_ necessary then I'd expect there to
> be lots of situations and corner cases in which it malfunctions,
> because the magic numbers weren't tuned to that case.

Hmm, ok, I'll make this function simpler and add explanation to numbers.


Regards,
-Kame
