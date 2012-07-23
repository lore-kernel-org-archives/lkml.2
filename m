Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2GWBnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54204 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272Ab2GWBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:55 -0400
Message-Id: <20120723010702.560293644@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 073/108] dm raid1: set discard_zeroes_data_unsupported
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7c8d3a42fe1c58a7e8fd3f6a013e7d7b474ff931 upstream.

We can't guarantee that REQ_DISCARD on dm-mirror zeroes the data even if
the underlying disks support zero on discard.  So this patch sets
ti->discard_zeroes_data_unsupported.

For example, if the mirror is in the process of resynchronizing, it may
happen that kcopyd reads a piece of data, then discard is sent on the
same area and then kcopyd writes the piece of data to another leg.
Consequently, the data is not zeroed.

The flag was made available by commit 983c7db347db8ce2d8453fd1d89b7a4bb6920d56
(dm crypt: always disable discard_zeroes_data).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-raid1.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ea16984..b58b7a3 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1084,6 +1084,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->split_io = dm_rh_get_region_size(ms->rh);
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->discard_zeroes_data_unsupported = 1;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord",
 					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);


