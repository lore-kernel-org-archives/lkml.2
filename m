Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab1ETQTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:19:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46299 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520Ab1ETQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=cZFCOnBdGVsGvUaVrYgnYpCU4ZqKeNlAR20MDsE+VfsIJn10mp1tJGHQG4yQh2euaJ
         gevLnmBFoWH/uX3RJ4uSHnFrpXLWdKVRD5xRJAH3EtA9Hc3QvFRg2JThScc1lgsb8PQB
         9WiuOv/ITQd5mO00UueAJfS4h+LtPfftPJjzE=
Date: Sat, 21 May 2011 01:19:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
Message-ID: <20110520161934.GA2386@barrios-desktop>
References: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
 <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
 <4DD5DC06.6010204@jp.fujitsu.com>
 <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
 <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
 <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com>
 <20110520101120.GC11729@random.random>
 <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com>
 <20110520153346.GA1843@barrios-desktop>
 <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:01:12PM -0400, Andrew Lutomirski wrote:
> On Fri, May 20, 2011 at 11:33 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 8bfd450..a5c01e9 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1430,7 +1430,10 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
> >
> >        /* Check if we should syncronously wait for writeback */
> >        if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
> > +               unsigned long nr_active;
> >                set_reclaim_mode(priority, sc, true);
> > +               nr_active = clear_active_flags(&page_list, NULL);
> > +               count_vm_events(PGDEACTIVATE, nr_active);
> >                nr_reclaimed += shrink_page_list(&page_list, zone, sc);
> >        }
> >
> > --
> 
> I'm now running that patch *without* the pgdat_balanced fix or the
> need_resched check.  The VM_BUG_ON doesn't happen but I still get

Please forget need_resched.
Instead of it, could you test shrink_slab patch with !pgdat_balanced?

@@ -231,8 +231,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
       if (scanned == 0)
               scanned = SWAP_CLUSTER_MAX;

-       if (!down_read_trylock(&shrinker_rwsem))
-               return 1;       /* Assume we'll be able to shrink next time */
+       if (!down_read_trylock(&shrinker_rwsem)) {
+               /* Assume we'll be able to shrink next time */
+               ret = 1;
+               goto out;
+       }

       list_for_each_entry(shrinker, &shrinker_list, list) {
               unsigned long long delta;
@@ -286,6 +289,8 @@ unsigned long shrink_slab(struct shrink_control *shrink,
               shrinker->nr += total_scan;
       }
       up_read(&shrinker_rwsem);
+out:
+       cond_resched();
       return ret;
 }

> incorrect OOM kills.
> 
> However, if I replace the check with:
> 
> 	if (false &&should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
> 
> then my system lags under bad memory pressure but recovers without
> OOMs or oopses.

I agree you can see OOM but oops? Did you see any oops?

> 
> Is that expected?


No..  :(

It's totally opposite.
That routine is for getting the memory althought we lose latency
It's another issue. :(

> 
> --Andy
> 
> > 1.7.1
> >
> > --
> > Kind regards,
> > Minchan Kim
> >

-- 
Kind regards,
Minchan Kim
