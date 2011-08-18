Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1HRElI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 00:41:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:28959 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1HRElF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 00:41:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,243,1312182000"; 
   d="scan'208";a="39683080"
Date: Thu, 18 Aug 2011 12:41:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110818044101.GA32326@localhost>
References: <20110816022006.348714319@intel.com>
 <20110816022328.811348370@intel.com>
 <20110816194112.GA25517@quack.suse.cz>
 <20110817132347.GA6628@localhost>
 <20110817202414.GK9959@quack.suse.cz>
 <20110818041801.GA22662@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818041801.GA22662@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

> > > >   What if x_intercept >  bdi_thresh? Since 8*bdi->avg_write_bandwidth is
> > > > easily 500 MB, that happens quite often I imagine?
> > > 
> > > That's fine because I no longer target "bdi_thresh" as some limiting
> > > factor as the global "thresh". Due to it being unstable in small
> > > memory JBOD systems, which is the big and unique problem in JBOD.
> >   I see. Given the control mechanism below, I think we can try this idea
> > and see whether it makes problems in practice or not. But the fact that
> > bdi_thresh is no longer treated as limit should be noted in a changelog -
> > probably of the last patch (although that is already too long for my taste
> > so I'll look into how we could make it shorter so that average developer
> > has enough patience to read it ;).
> 
> Good point. I'll make it a comment in the last patch.

Just added this comment:

+               /*
+                * bdi_thresh is not treated as some limiting factor as
+                * dirty_thresh, due to reasons
+                * - in JBOD setup, bdi_thresh can fluctuate a lot
+                * - in a system with HDD and USB key, the USB key may somehow
+                *   go into state (bdi_dirty >> bdi_thresh) either because
+                *   bdi_dirty starts high, or because bdi_thresh drops low.
+                *   In this case we don't want to hard throttle the USB key
+                *   dirtiers for 100 seconds until bdi_dirty drops under
+                *   bdi_thresh. Instead the auxiliary bdi control line in
+                *   bdi_position_ratio() will let the dirtier task progress
+                *   at some rate <= (write_bw / 2) for bringing down bdi_dirty.
+                */
                bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);

Thanks,
Fengguang
