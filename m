Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1LLL1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:27:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56715 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1LLL1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:27:47 -0500
Date: Mon, 12 Dec 2011 11:27:38 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Tao Ma <tm@tao.ma>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] vmscan/trace: Add 'active' and 'file' info to
 trace_mm_vmscan_lru_isolate.
Message-ID: <20111212112738.GA3277@csn.ul.ie>
References: <1323614784-2924-1-git-send-email-tm@tao.ma>
 <CAEwNFnCXJuH53ks=qPdHkm_hrcm+Nsh7f5APQx6BgQEQBKC_yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEwNFnCXJuH53ks=qPdHkm_hrcm+Nsh7f5APQx6BgQEQBKC_yQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:59:20AM +0900, Minchan Kim wrote:
> > <SNIP>
> > @@ -1237,7 +1237,7 @@ static unsigned long isolate_pages_global(unsigned long nr,
> >        if (file)
> >                lru += LRU_FILE;
> >        return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
> > -                                                               mode, file);
> > +                                                       mode, active, file);
> 
> I guess you want to count exact scanning number of which lru list.
> But It's impossible now since we do lumpy reclaim so that trace's
> result is mixed by active/inactive list scanning.
> And I don't like adding new argument for just trace although it's trivial.
> 

FWIW, lumpy reclaim is why the trace point does not report the active
or file information. Seeing active==1 does not imply that only active
pages were isolated and mode is already there as Minchan points out.

Similarly, seeing file==1 does not imply that only file-backed
pages were isolated. Any processing script that depends on just this
information would be misleading.  If more information on how much
each LRU was scanned is required, the mm_vmscan_lru_shrink_inactive
tracepoint already reports the number of pages scanned, reclaimed
and whether the pages isolated were anon, file or both so ordinarily
I would suggest using just that.

That said, I see that trace_shrink_flags() is currently misleading as
it should be used sc->order instead of sc->reclaim_mode to determine
if it was file, anon or a mix of both that was isolated. That should
be fixed.

If isolate_lru_pages really needs to export the file information,
then it would be preferable to fix trace_shrink_flags() and use it to
indicate if it was file, anon or a mix of both that was isolated. The
information needed to trace this is not available in isolate_lru_pages
so it would need to be passed down. Even with that, I would also
like to see trace/postprocess/trace-vmscan-postprocess.pl updated to
illustrate how this new information can be used to debug a problem
or at least describe what sort of problem it can debug.


> I think 'mode' is more proper rather than  specific 'active'.
> The 'mode' can achieve your goal without passing new argument "active".
> 

True.

> In addition to, current mmotm has various modes.
> So sometime we can get more specific result rather than vauge 'active'.
> 

Which also means that trace/postprocess/trace-vmscan-postprocess.pl
is not using mm_vmscan_lru_isolate properly as it does not understand
ISOLATE_CLEAN and ISOLATE_UNMAPPED. The impact for the script is that
the scan count it reports will deviate from what /proc/vmstat reports
which is irritating.

-- 
Mel Gorman
SUSE Labs
