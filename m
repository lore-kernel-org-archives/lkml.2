Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1FBVWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:22:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59528 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1FBVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:22:30 -0400
Subject: Re: bdi_min_ratio never shrinks, ultimately preventing valid
 setting of min_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: lkml@pengaru.com
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        miklos <miklos@szeredi.hu>
In-Reply-To: <20110602183244.GB5753@shells.gnugeneration.com>
References: <20110601002854.GV5753@shells.gnugeneration.com>
	 <1307015011.2497.633.camel@laptop>
	 <20110602183244.GB5753@shells.gnugeneration.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 23:25:58 +0200
Message-ID: <1307049958.2497.726.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 13:32 -0500, lkml@pengaru.com wrote:
> > > There is no place in this listing where the value is decremented by the
> > > respective bdi's min_ratio when a bdi is torn down. 
> > 
> > There is, adding a negative number is equal to a subtraction.
> > 
> >                 min_ratio -= bdi->min_ratio;
> >                 if (bdi_min_ratio + min_ratio < 100) {
> >                         bdi_min_ratio += min_ratio;
> >                         bdi->min_ratio += min_ratio;
> >                 }
> > 
> > is the relevant piece, note that bdi->min_ratio is the current setting,
> > this makes min_ratio the difference between the new and old setting, and
> > adding this to both bdi_min_ratio (the global sum) and bdi->min_ratio
> > dtrt regardless if the new value is larger or smaller than the old
> > value.
> 
> This accounts for the repeated setting of min_ratio on the same bdi.  But
> does bdi_set_min_ratio() get entered with a min_ratio of 0 on bdi removal?
> If not, we leak the non-zero min_ratio of a removed bdi.

That does not appear to be the case, good catch. Would you be bitten by
that particular scenario? If so, does the below cure things for you?

---
 mm/backing-dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f032e6e..e56fe35 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -606,6 +606,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
 		del_timer_sync(&bdi->wb.wakeup_timer);


