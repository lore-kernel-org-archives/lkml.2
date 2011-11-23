Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab1KWEAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:00:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:25988 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab1KWEAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:00:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,557,1315206000"; 
   d="scan'208";a="78229599"
Date: Wed, 23 Nov 2011 12:00:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: hard throttle 1000+ dd on a slow USB stick
Message-ID: <20111123040037.GA18053@localhost>
References: <20111117115914.GA24502@localhost>
 <20111121203742.GD4017@quack.suse.cz>
 <20111122022053.GA20982@localhost>
 <20111122192736.GG8058@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122192736.GG8058@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 03:27:36AM +0800, Jan Kara wrote:
> On Tue 22-11-11 10:20:53, Wu Fengguang wrote:
> > On Tue, Nov 22, 2011 at 04:37:42AM +0800, Jan Kara wrote:
> > > On Thu 17-11-11 19:59:14, Wu Fengguang wrote:
> > > > The sleep based balance_dirty_pages() can pause at most MAX_PAUSE=200ms
> > > > on every 1 4KB-page, which means it cannot throttle a task under
> > > > 4KB/200ms=20KB/s. So when there are more than 512 dd writing to a
> > > > 10MB/s USB stick, its bdi dirty pages could grow out of control.
> > > > 
> > > > Even if we can increase MAX_PAUSE, the minimal (task_ratelimit = 1)
> > > > means a limit of 4KB/s.
> > > > 
> > > > They can eventually be safeguarded by the global limit check
> > > > (nr_dirty < dirty_thresh). However if someone is also writing to an
> > > > HDD at the same time, it'll get poor HDD write performance.
> > > > 
> > > > We at least want to maintain good write performance for other devices
> > > > when one device is attacked by some "massive parallel" workload, or
> > > > suffers from slow write bandwidth, or somehow get stalled due to some
> > > > error condition (eg. NFS server not responding).
> > > > 
> > > > For a stalled device, we need to completely block its dirtiers, too,
> > > > before its bdi dirty pages grow all the way up to the global limit and
> > > > leave no space for the other functional devices.
> > >   This is a fundamental question - how much do you allow dirty cache of one
> > > device to grow when other devices are relatively idle? Every choice has
> > > advantages and disadvantages. If you allow device to occupy lot of the
> > > cache, you may later find yourself short on dirtiable memory when other
> > > devices become active. On the other hand allowing more dirty memory can
> > > improve IO pattern and thus writeout speed. So whatever choice we make,
> > > we should explain our choice somewhere in the code and stick to that...
> > 
> > The answer lies in bdi_thresh and will continue to be so with this patch :)
> >
> > Basically we let active devices to grow its quota of dirty pages and
> > stalled/inactive devices to decrease its quota over time. That's the
> > backing rational for Peter's "floating proportions".
>   Sure, but how we use bdi_thresh was changing in the past. For example at
> which global level of dirty pages we decide to enforce bdi_thresh. Now you
> again slightly change the logic when bdi_thresh is enforced and when not...
> So my suggestion was more aiming at having somewhere documented, when we
> enforce bdi_thresh and when not, together with description of goals we try
> to achieve with this setting.

Yes it deserves some document. I write up some comments on this,
please review :)

---
Subject: writeback: comment on the bdi dirty threshold
Date: Wed Nov 23 11:44:41 CST 2011

We do "floating proportions" to let active devices to grow its target
share of dirty pages and stalled/inactive devices to decrease its target
share over time.

It works well except in the case of "an inactive disk suddenly goes
busy", where the initial target share may be too small. To mitigate
this, bdi_position_ratio() has the below line to raise a small
bdi_thresh when it's safe to do so, so that the disk be feed with enough
dirty pages for efficient IO and in turn fast rampup of bdi_thresh:

        bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);

balance_dirty_pages() normally does negative feedback control which
adjusts ratelimit to balance the bdi dirty pages around the target.
In some extreme cases when that is not enough, it will have to block 
the tasks completely until the bdi dirty pages drop below bdi_thresh.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-11-23 10:57:41.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-23 11:44:39.000000000 +0800
@@ -411,8 +411,13 @@ void global_dirty_limits(unsigned long *
  *
  * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
  * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
- * And the "limit" in the name is not seriously taken as hard limit in
- * balance_dirty_pages().
+ *
+ * Note that balance_dirty_pages() will only seriously take it as a hard limit
+ * when sleeping max_pause per page is not enough to keep the dirty pages under
+ * control. For example, when the device is completely stalled due to some error
+ * conditions, or when there are 1000 dd tasks writing to a slow 10MB/s USB key.
+ * In the other normal situations, it acts more gently by throttling the tasks
+ * more (rather than completely block them) when the bdi dirty pages go high.
  *
  * It allocates high/low dirty limits to fast/slow devices, in order to prevent
  * - starving fast devices
@@ -594,6 +599,13 @@ static unsigned long bdi_position_ratio(
 	 */
 	if (unlikely(bdi_thresh > thresh))
 		bdi_thresh = thresh;
+	/*
+	 * It's very possible that bdi_thresh is close to 0 not because the
+	 * device is slow, but that it has remained inactive for long time.
+	 * Honour such devices a reasonable good (hopefully IO efficient)
+	 * threshold, so that the occasional writes won't be blocked and active
+	 * writes can rampup the threshold quickly.
+	 */
 	bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
 	/*
 	 * scale global setpoint to bdi's:
