Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab2FGClA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:41:00 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60949 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab2FGCk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:40:58 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-35-4fd014b85943
Message-ID: <4FD014D7.6000605@kernel.org>
Date: Thu, 07 Jun 2012 11:41:27 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
References: <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com> <CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com> <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com> <CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com> <20120601122118.GA6128@lizard> <alpine.LFD.2.02.1206032125320.1943@tux.localdomain> <4FCC7592.9030403@kernel.org> <20120604113811.GA4291@lizard> <4FCD14F1.1030105@gmail.com> <CAOJsxLHR4wSgT2hNfOB=X6ud0rXgYg+h7PTHzAZYCUdLs6Ktug@mail.gmail.com> <20120605083921.GA21745@lizard>
In-Reply-To: <20120605083921.GA21745@lizard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 05:39 PM, Anton Vorontsov wrote:

> On Tue, Jun 05, 2012 at 10:47:18AM +0300, Pekka Enberg wrote:
>> On Mon, Jun 4, 2012 at 11:05 PM, KOSAKI Motohiro
>> <kosaki.motohiro@gmail.com> wrote:
>>>> Note that 1) and 2) are not problems per se, it's just implementation
>>>> details, easy stuff. Vmevent is basically an ABI/API, and I didn't
>>>> hear anybody who would object to vmevent ABI idea itself. More than
>>>> this, nobody stop us from implementing in-kernel vmevent API, and
>>>> make Android Lowmemory killer use it, if we want to.
>>>
>>> I never agree "it's mere ABI" discussion. Until the implementation is ugly,
>>> I never agree the ABI even if syscall interface is very clean.
>>
>> I don't know what discussion you are talking about.
>>
>> I also don't agree that something should be merged just because the
>> ABI is clean. The implementation must also make sense. I don't see how
>> we disagree here at all.
> 
> BTW, I wasn't implying that vmevent should be merged just because
> it is a clean ABI, and I wasn't implying that it is clean, and I
> didn't propose to merge it at all. :-)
> 
> I just don't see any point in trying to scrap vmevent in favour of
> Android low memory killer. This makes no sense at all, since today
> vmevent is more useful than Android's solution. For vmevent we have
> contributors from Nokia, Samsung, and of course Linaro, plus we
> have an userland killer daemon* for Android (which can work with
> both cgroups and vmevent backends). So vmevent is more generic
> already.
> 
> To me it would make more sense if mm guys would tell us "scrap
> this all, just use cgroups and its notifications; fix cgroups'
> slab accounting and be happy". Well, I'd understand that.
> 
> Anyway, we all know that vmevent is 'work in progress', so nobody
> tries to push it, nobody asks to merge it. So far we're just
> discussing any possible solutions, and vmevent is a good
> playground.
> 
> 
> So, question to Minchan. Do you have anything particular in mind
> regarding how the vmstat hooks should look like? And how all this
> would connect with cgroups, since KOSAKI wants to see it cgroups-
> aware...


How about this?

It's totally pseudo code just I want to show my intention and even it's not a math.
Totally we need more fine-grained some expression to standardize memory pressure.
For it, we can use VM's several parameter, nr_scanned, nr_reclaimed, order, dirty page scanning ratio
and so on. Also, we can aware of zone, node so we can pass lots of information to user space if they
want it. For making lowmem notifier general, they are must, I think.
We can have a plenty of tools for it.

And later as further step, we could replace it with memcg-aware after memcg reclaim work is
totally unified with global page reclaim. Many memcg guys have tried it so I expect it works
sooner or later but I'm not sure memcg really need it because memcg's goal is limit memory resource
among several process groups. If some process feel bad about latency due to short of free memory
and it's critical, I think it would be better to create new memcg group has tighter limit for
latency and put the process into the group.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eeb3bc9..eae3d2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2323,6 +2323,32 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
 }
 
 /*
+ * higher dirty pages, higher pressure
+ * higher nr_scanned, higher pressure
+ * higher nr_reclaimed, lower pressure
+ * higher unmapped pages, lower pressure
+ *
+ * index toward 0 implies memory pressure is heavy.
+ */
+int lowmem_index(struct zone *zone, struct scan_control *sc)
+{
+       int pressure = (1000 * (sc->nr_scanned * (zone_page_state(zone, NR_FILE_DIRTY) 
+                       * dirty_weight + 1) - sc->nr_reclaimed -
+                       zone_unmapped_file_pages(zone))) /
+                       zone_reclaimable_page(zone);
+
+       return 1000 - pressure;
+}
+
+void lowmem_notifier(struct zone *zone, int index)
+{
+       if (lowmem_has_interested_zone(zone)) {
+               if (index < sysctl_lowmem_threshold)
+                       notify(numa_node_id(), zone, index);
+       }
+}
+
+/*
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at high_wmark_pages(zone).
  *
@@ -2494,6 +2520,7 @@ loop_again:
                                    !zone_watermark_ok_safe(zone, testorder,
                                        high_wmark_pages(zone) + balance_gap,
                                        end_zone, 0)) {
+                               int index;
                                shrink_zone(zone, &sc);
 
                                reclaim_state->reclaimed_slab = 0;
@@ -2503,6 +2530,9 @@ loop_again:
 
                                if (nr_slab == 0 && !zone_reclaimable(zone))
                                        zone->all_unreclaimable = 1;
+
+                               index = lowmem_index(zone, &sc);
+                               lowmem_notifier(zone, index);

> 

> p.s. http://git.infradead.org/users/cbou/ulmkd.git
>      I haven't updated it for new vmevent changes, but still,
>      its idea should be clear enough.
> 


-- 
Kind regards,
Minchan Kim
