Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab0JSBPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:15:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0JSBPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V27otgTY4TEYEYb6FurzcxA+VmQZEwGXHqxvTjhUneVUBI9CHmrOCns41K720/XVez
         orwR4tgg3rNnFfwN5t/o0HYh036zFRgTj85+h1Dv8K9iuWRnlK4dd+dP6yh9uH8/6mSD
         UKHQul9sl/TmbmUXeQQbH1L8oWA8aTX4M61n0=
MIME-Version: 1.0
In-Reply-To: <20101019095144.A1B0.A69D9226@jp.fujitsu.com>
References: <20101019093142.509d6947@notabene>
	<20101018154137.90f5325f.akpm@linux-foundation.org>
	<20101019095144.A1B0.A69D9226@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 10:15:06 +0900
Message-ID: <AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 9:57 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > I think there are two bugs here.
>> > The raid1 bug that Torsten mentions is certainly real (and has been around
>> > for an embarrassingly long time).
>> > The bug that I identified in too_many_isolated is also a real bug and can be
>> > triggered without md/raid1 in the mix.
>> > So this is not a 'full fix' for every bug in the kernel :-), but it could
>> > well be a full fix for this particular bug.
>> >
>>
>> Can we just delete the too_many_isolated() logic?  (Crappy comment
>> describes what the code does but not why it does it).
>
> if my remember is correct, we got bug report that LTP may makes misterious
> OOM killer invocation about 1-2 years ago. because, if too many parocess are in
> reclaim path, all of reclaimable pages can be isolated and last reclaimer found
> the system don't have any reclaimable pages and lead to invoke OOM killer.
> We have strong motivation to avoid false positive oom. then, some discusstion
> made this patch.
>
> if my remember is incorrect, I hope Wu or Rik fix me.

AFAIR, it's right.

How about this?

It's rather aggressive throttling than old(ie, it considers not lru
type granularity but zone )
But I think it can prevent unnecessary OOM problem and solve deadlock problem.


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f12ad18..acd6a65 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1961,6 +1961,21 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
        return alloc_flags;
 }

+/*
+ * Are there way too many processes are reclaiming this zone?
+ */
+static int too_many_isolated_zone(struct zone *zone)
+{
+       unsigned long inactive, isolated;
+
+       inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
+               zone_page_state(zone, NR_INACTIVE_ANON);
+       isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
+               zone_page_state(zone, NR_ISOLATED_ANON);
+
+       return isolated > inactive;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
        struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -2054,10 +2069,11 @@ rebalance:
                goto got_pg;

        /*
-        * If we failed to make any progress reclaiming, then we are
-        * running out of options and have to consider going OOM
+        * If we failed to make any progress reclaiming and there aren't
+        * many parallel reclaiming, then we are unning out of options and
+        * have to consider going OOM
         */
-       if (!did_some_progress) {
+       if (!did_some_progress && !too_many_isolated_zone(preferred_zone)) {
                if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
                        if (oom_killer_disabled)
                                goto nopage;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c5dfabf..f2109af 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1129,31 +1129,6 @@ int isolate_lru_page(struct page *page)
 }

 /*
- * Are there way too many processes in the direct reclaim path already?
- */
-static int too_many_isolated(struct zone *zone, int file,
-               struct scan_control *sc)
-{
-       unsigned long inactive, isolated;
-
-       if (current_is_kswapd())
-               return 0;
-
-       if (!scanning_global_lru(sc))
-               return 0;
-
-       if (file) {
-               inactive = zone_page_state(zone, NR_INACTIVE_FILE);
-               isolated = zone_page_state(zone, NR_ISOLATED_FILE);
-       } else {
-               inactive = zone_page_state(zone, NR_INACTIVE_ANON);
-               isolated = zone_page_state(zone, NR_ISOLATED_ANON);
-       }
-
-       return isolated > inactive;
-}
-
-/*
  * TODO: Try merging with migrations version of putback_lru_pages
  */
 static noinline_for_stack void
@@ -1290,15 +1265,6 @@ shrink_inactive_list(unsigned long nr_to_scan,
struct zone *zone,
        unsigned long nr_anon;
        unsigned long nr_file;

-       while (unlikely(too_many_isolated(zone, file, sc))) {
-               congestion_wait(BLK_RW_ASYNC, HZ/10);
-
-               /* We are about to die and free our memory. Return now. */
-               if (fatal_signal_pending(current))
-                       return SWAP_CLUSTER_MAX;
-       }
-
-
        lru_add_drain();
        spin_lock_irq(&zone->lru_lock);




-- 
Kind regards,
Minchan Kim
