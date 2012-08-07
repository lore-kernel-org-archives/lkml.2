Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874Ab2HGDjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:39:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59830 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964804Ab2HGDix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:53 -0400
Message-Id: <20120807032802.080640518@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [ 41/70] md/raid1: dont abort a resync on the first badblock.
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b7219ccb33aa0df9949a60c68b5e9f712615e56f upstream.

If a resync of a RAID1 array with 2 devices finds a known bad block
one device it will neither read from, or write to, that device for
this block offset.
So there will be one read_target (The other device) and zero write
targets.
This condition causes md/raid1 to abort the resync assuming that it
has finished - without known bad blocks this would be true.

When there are no write targets because of the presence of bad blocks
we should only skip over the area covered by the bad block.
RAID10 already gets this right, raid1 doesn't.  Or didn't.

As this can cause a 'sync' to abort early and appear to have succeeded
it could lead to some data corruption, so it suitable for -stable.

Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid1.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7aa958e..d2361b1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2502,7 +2502,10 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		/* There is nowhere to write, so all non-sync
 		 * drives must be failed - so we are finished
 		 */
-		sector_t rv = max_sector - sector_nr;
+		sector_t rv;
+		if (min_bad > 0)
+			max_sector = sector_nr + min_bad;
+		rv = max_sector - sector_nr;
 		*skipped = 1;
 		put_buf(r1_bio);
 		return rv;


