Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab0J2O6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:58:31 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:48022 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932804Ab0J2O6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:58:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YVh9370VM1mDl4H5vnZCuBn3FoBuH45I8MPF_ih4PTyFo4f
 V1aioH9NGgTBV__KoW1mbflFy1rfuvuGEgxa6.mGrhmMHvb7XGyLsnin_srP
 8sQC6DoWOQn2iOsqRZJS792nv.Ejzw3CkXqfJcyyueGG8JTq0WNDgpm3Txdo
 kG0dNW8lAZNdBzVPI0UznbfFmOiH_x6QZiOQusJBCW6kAI3ipni3TaO6yksB
 ECc43A5qW7Pg_Ci.3Hx.yRzSYUtyb
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 29 Oct 2010 09:58:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
In-Reply-To: <20101028150433.fe4f2d77.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010290955510.20370@router.home>
References: <1288278816-32667-1-git-send-email-mel@csn.ul.ie> <1288278816-32667-2-git-send-email-mel@csn.ul.ie> <20101028150433.fe4f2d77.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Andrew Morton wrote:

> > To ensure that kswapd wakes up, a safe version of zone_watermark_ok()
> > is introduced that takes a more accurate reading of NR_FREE_PAGES when
> > called from wakeup_kswapd, when deciding whether it is really safe to go
> > back to sleep in sleeping_prematurely() and when deciding if a zone is
> > really balanced or not in balance_pgdat(). We are still using an expensive
> > function but limiting how often it is called.
>
> Here I go again.  I have a feeling that I already said this, but I
> can't find versions 2 or 3 in the archives..
>
> Did you evaluate using plain on percpu_counters for this?  They won't
> solve the performance problem as they're basically the same thing as
> these open-coded counters.  But they'd reduce the amount of noise and
> custom-coded boilerplate in mm/.

The zone counters are done using the ZVCs in vmstat.c to save space and to
be in the same cacheline as other hot data necessary for allocation and
free.
 >
> > +	threshold = max(1, (int)(watermark_distance / num_online_cpus()));
> > +
> > +	/*
> > +	 * Maximum threshold is 125
>
> Reasoning?

Differentials are stored in 8 bit signed ints.

> > +	put_online_cpus();
> > +}
>
> Given that ->stat_threshold is the same for each CPU, why store it for
> each CPU at all?  Why not put it in the zone and eliminate the inner
> loop?

Doing that caused cache misses in the past and reduced the performance of
the ZVCs. This way the threshold is in the same cacheline as the
differentials.



