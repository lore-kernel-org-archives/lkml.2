Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0LDGnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 01:43:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0LDGnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 01:43:20 -0500
Date: Sat, 4 Dec 2010 01:43:08 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, jaxboe@fusionio.com,
        lars.ellenberg@linbit.com
Subject: [PATCH] dm: check max_sectors in dm_merge_bvec  (was: Re: dm:
 max_segments=1 if merge_bvec_fn is not supported)
Message-ID: <20101204064308.GA7639@redhat.com>
References: <20100306211012.GA9689@racke>
 <20100308163345.42841480@notabene.brown>
 <Pine.LNX.4.64.1003080321190.25635@hs20-bc2-1.build.redhat.com>
 <20100308131449.GA15156@racke>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308131449.GA15156@racke>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm late to this old thread but I stumbled across it while auditing the
various dm-devel patchwork patches, e.g.:
https://patchwork.kernel.org/patch/83666/
https://patchwork.kernel.org/patch/83932/

On Mon, Mar 08 2010 at  8:14am -0500,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Mon, Mar 08, 2010 at 03:35:37AM -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > That patch with limits->max_segments = 1; is wrong. It fixes this bug 
> > sometimes and sometimes not.
> > 
> > The problem is, if someone attempts to create a bio with two vector 
> > entries, the first maps the last sector contained in some page and the 
> > second maps the first sector of the next physical page: it has one 
> > segment, it has size <= PAGE_SIZE, but it still may cross raid stripe and 
> > the raid driver will reject it.
> 
> Now that you put it that way ;)
> You are right.
> 
> My asumption that "single segment" was  
> equalvalent in practice with "single bvec"
> does not hold true in that case.
> 
> Then, what about adding seg_boundary_mask restrictions as well?
> 	max_sectors = PAGE_SIZE >> 9;
> 	max_segments = 1;
> 	seg_boundary_mask = PAGE_SIZE -1;
> or some such.
> 
> > > > This is not the first time this has been patched, btw.
> > > > See https://bugzilla.redhat.com/show_bug.cgi?id=440093
> > > > and the patch by Mikulas:
> > > > https://bugzilla.redhat.com/attachment.cgi?id=342638&action=diff
> > 
> > Look at this patch, it is the proper way how to fix it: create a 
> > merge_bvec_fn that reject more than one biovec entry.
> 
> If adding seg_boundary_mask is still not sufficient,
> lets merge that patch instead?
> Why has it been dropped, respectively never been merged?
> It became obsolete for dm-linear by 7bc3447b,
> but in general the bug is still there, or am I missing something?

No it _should_ be fixed in general given DM's dm_merge_bvec() _but_ I
did uncover what I think is a subtle oversight in its implementation.

Given dm_set_device_limits() sets q->limits->max_sectors,
shouldn't dm_merge_bvec() be using queue_max_sectors rather than
queue_max_hw_sectors?

blk_queue_max_hw_sectors() establishes that max_hw_sectors is the hard
limit and max_sectors the soft.  But AFAICT no relation is maintained
between the two over time (even though max_sectors <= max_hw_sectors
_should_ be enforced; in practice there is no blk_queue_max_sectors
setter that uniformly enforces as much).

Anyway, I think we need the following patch:
--

From: Mike Snitzer <snitzer@redhat.com>
Subject: dm: check max_sectors in dm_merge_bvec

dm_set_device_limits() will set q->limits->max_sectors to <= PAGE_SIZE
if an underlying device has a merge_bvec_fn.  Therefore, dm_merge_bvec()
must use queue_max_sectors() rather than queue_max_hw_sectors() to check
the appropriate limit.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..e83dcc8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1358,12 +1358,11 @@ static int dm_merge_bvec(struct request_queue *q,
 	/*
 	 * If the target doesn't support merge method and some of the devices
 	 * provided their merge_bvec method (we know this by looking at
-	 * queue_max_hw_sectors), then we can't allow bios with multiple vector
+	 * queue_max_sectors), then we can't allow bios with multiple vector
 	 * entries.  So always set max_size to 0, and the code below allows
 	 * just one page.
 	 */
-	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
-
+	else if (queue_max_sectors(q) <= PAGE_SIZE >> 9)
 		max_size = 0;
 
 out_table:
