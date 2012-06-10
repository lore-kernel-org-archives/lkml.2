Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2FJHYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 03:24:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:55977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2FJHYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 03:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163720963"
Date: Sun, 10 Jun 2012 15:24:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        PeterZijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] page-writeback.c: fix update bandwidth time judgment
 error
Message-ID: <20120610072414.GA11283@localhost>
References: <1339302005-366-1-git-send-email-liwp.linux@gmail.com>
 <20120610043641.GA10355@localhost>
 <20120610045300.GA29336@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610045300.GA29336@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:54:03PM +0800, Wanpeng Li wrote:
> On Sun, Jun 10, 2012 at 12:36:41PM +0800, Fengguang Wu wrote:
> >Wanpeng,
> >
> >Sorry this I won't take this: it don't really improve anything.  Even
> >with the changed test, the real intervals are still some random values
> >above (and not far away from) 200ms.. We are saying about 200ms
> >intervals just for convenience.
> >
> But some parts like:
> 
> __bdi_update_bandwidth which bdi_update_bandwidth will call:
> 
> if(elapsed < BANDWIDTH_INTERVAL)
> 	return;
> 
> or
> 
> global_update_bandwidth:
> 
> if(time_before(now, update_time + BANDWIDTH_INTERVAL))
> 	return;
> 
> You me just ignore this disunion ?

Not a problem for me. But if that consistency makes you feel happy,
you might revise the changelog and resend. But it's not that simple
for the below reason..

> >On Sun, Jun 10, 2012 at 12:20:05PM +0800, Wanpeng Li wrote:
> >> From: Wanpneg Li <liwp@linux.vnet.ibm.com>
> >> 
> >> Since bdi_update_bandwidth function  should estimate write bandwidth at 200ms intervals,

The above line represents a wrong assumption. It's normal for the
re-estimate intervals to be >= 200ms.

> >> so the time is bdi->bw_time_stamp + BANDWIDTH_INTERVAL == jiffies, but
> >> if use time_is_after_eq_jiffies intervals will be bdi->bw_time_stamp +
> >> BANDWIDTH_INTERVAL + 1.

Strictly speaking, to ensure that ">= 200ms" is true, we'll have to
skip the "jiffies == bw_time_stamp + BANDWIDTH_INTERVAL" case. For
example, when HZ=100, the bw_time_stamp may actually be recorded in
the very last ms of a 10ms range, and jiffies may be in the very first
ms of the current 10ms range. So if using ">=" comparisons, it may
actually let less than 200ms intervals go though.

We can only reliably ensure "> 200ms", but no way for ">= 200ms".

Thanks,
Fengguang

> >> Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
> >> ---
> >>  mm/page-writeback.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> >> index c833bf0..099e225 100644
> >> --- a/mm/page-writeback.c
> >> +++ b/mm/page-writeback.c
> >> @@ -1032,7 +1032,7 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
> >>  				 unsigned long bdi_dirty,
> >>  				 unsigned long start_time)
> >>  {
> >> -	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
> >> +	if (time_is_after_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
> >>  		return;
> >>  	spin_lock(&bdi->wb.list_lock);
> >>  	__bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
> >> -- 
> >> 1.7.9.5
