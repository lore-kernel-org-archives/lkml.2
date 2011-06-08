Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1FHAN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:13:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055Ab1FHANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:13:54 -0400
Date: Tue, 7 Jun 2011 17:13:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml@pengaru.com, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, miklos <miklos@szeredi.hu>
Subject: Re: bdi_min_ratio never shrinks, ultimately preventing valid
 setting of min_ratio
Message-Id: <20110607171347.a0bbdfd8.akpm@linux-foundation.org>
In-Reply-To: <1307049958.2497.726.camel@laptop>
References: <20110601002854.GV5753@shells.gnugeneration.com>
	<1307015011.2497.633.camel@laptop>
	<20110602183244.GB5753@shells.gnugeneration.com>
	<1307049958.2497.726.camel@laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011 23:25:58 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2011-06-02 at 13:32 -0500, lkml@pengaru.com wrote:
> > > > There is no place in this listing where the value is decremented by the
> > > > respective bdi's min_ratio when a bdi is torn down. 
> > > 
> > > There is, adding a negative number is equal to a subtraction.
> > > 
> > >                 min_ratio -= bdi->min_ratio;
> > >                 if (bdi_min_ratio + min_ratio < 100) {
> > >                         bdi_min_ratio += min_ratio;
> > >                         bdi->min_ratio += min_ratio;
> > >                 }
> > > 
> > > is the relevant piece, note that bdi->min_ratio is the current setting,
> > > this makes min_ratio the difference between the new and old setting, and
> > > adding this to both bdi_min_ratio (the global sum) and bdi->min_ratio
> > > dtrt regardless if the new value is larger or smaller than the old
> > > value.
> > 
> > This accounts for the repeated setting of min_ratio on the same bdi.  But
> > does bdi_set_min_ratio() get entered with a min_ratio of 0 on bdi removal?
> > If not, we leak the non-zero min_ratio of a removed bdi.
> 
> That does not appear to be the case, good catch. Would you be bitten by
> that particular scenario? If so, does the below cure things for you?
> 
> ---
>  mm/backing-dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index f032e6e..e56fe35 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -606,6 +606,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
>  void bdi_unregister(struct backing_dev_info *bdi)
>  {
>  	if (bdi->dev) {
> +		bdi_set_min_ratio(bdi, 0);
>  		trace_writeback_bdi_unregister(bdi);
>  		bdi_prune_sb(bdi);
>  		del_timer_sync(&bdi->wb.wakeup_timer);

I grabbed this, wrote a changelog and stuck your signed-off-by on it. 
Vito, it would be great if you are able to test this please.

I also added a cc:stable but I didn't work out how far back in time it
goes.  A long way, I think?

