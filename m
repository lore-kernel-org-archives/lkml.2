Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0J1KEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:04:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32872 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0J1KEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:04:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Oct 2010 18:58:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
Message-Id: <20101028185839.4b951bdb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101028094903.GC4896@csn.ul.ie>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie>
	<1288169256-7174-2-git-send-email-mel@csn.ul.ie>
	<20101028100920.5d4ce413.kamezawa.hiroyu@jp.fujitsu.com>
	<20101028094903.GC4896@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 10:49:03 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Thu, Oct 28, 2010 at 10:09:20AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 27 Oct 2010 09:47:35 +0100
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > Commit [aa45484: calculate a better estimate of NR_FREE_PAGES when
> > > memory is low] noted that watermarks were based on the vmstat
> > > NR_FREE_PAGES. To avoid synchronization overhead, these counters are
> > > maintained on a per-cpu basis and drained both periodically and when a
> > > threshold is above a threshold. On large CPU systems, the difference
> > > between the estimate and real value of NR_FREE_PAGES can be very high.
> > > The system can get into a case where pages are allocated far below the
> > > min watermark potentially causing livelock issues. The commit solved the
> > > problem by taking a better reading of NR_FREE_PAGES when memory was low.
> > > 
> > > <SNIP>
> > > 
> > > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > > index 355a9e6..cafcc2d 100644
> > > --- a/mm/vmstat.c
> > > +++ b/mm/vmstat.c
> > > @@ -81,6 +81,12 @@ EXPORT_SYMBOL(vm_stat);
> > >  
> > >  #ifdef CONFIG_SMP
> > >  
> > > +static int calculate_pressure_threshold(struct zone *zone)
> > > +{
> > > +	return max(1, (int)((high_wmark_pages(zone) - low_wmark_pages(zone) /
> > > +				num_online_cpus())));
> > > +}
> > > +
> > 
> > Could you add background theory of this calculation as a comment to
> > show the difference with calculate_threshold() ?
> > 
> 
> Sure. When writing it, I realised that the calculations here differ from
> what percpu_drift_mark does. This is what I currently have
> 
> int calculate_pressure_threshold(struct zone *zone)
> {
>         int threshold;
>         int watermark_distance;
> 
>         /*
>          * As vmstats are not up to date, there is drift between the estimated
>          * and real values. For high thresholds and a high number of CPUs, it
>          * is possible for the min watermark to be breached while the estimated
>          * value looks fine. The pressure threshold is a reduced value such
>          * that even the maximum amount of drift will not accidentally breach
>          * the min watermark
>          */
>         watermark_distance = low_wmark_pages(zone) - min_wmark_pages(zone);
>         threshold = max(1, watermark_distance / num_online_cpus());
> 
>         /*
>          * Maximum threshold is 125
>          */
>         threshold = min(125, threshold);
> 
>         return threshold;
> }
> 
> Is this better?
> 

sounds nice.

Regards,
-Kame


