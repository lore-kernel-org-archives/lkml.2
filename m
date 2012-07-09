Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2GIOxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:53:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153Ab2GIOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:57 -0400
Message-Id: <20120709143118.748262282@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Christian Balzer <chibi@gol.com>
Subject: [ 14/48] md/raid10: Dont try to recovery unmatched (and unused) chunks.
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit fc448a18ae6219af9a73257b1fbcd009efab4a81 upstream.

If a RAID10 has an odd number of chunks - as might happen when there
are an odd number of devices - the last chunk has no pair and so is
not mirrored.  We don't store data there, but when recovering the last
device in an array we retry to recover that last chunk from a
non-existent location.  This results in an error, and the recovery
aborts.

When we get to that last chunk we should just stop - there is nothing
more to do anyway.

This bug has been present since the introduction of RAID10, so the
patch is appropriate for any -stable kernel.

Reported-by: Christian Balzer <chibi@gol.com>
Tested-by: Christian Balzer <chibi@gol.com>
Signed-off-by: NeilBrown <neilb@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2436,6 +2436,12 @@ static sector_t sync_request(struct mdde
 			/* want to reconstruct this device */
 			rb2 = r10_bio;
 			sect = raid10_find_virt(conf, sector_nr, i);
+			if (sect >= mddev->resync_max_sectors) {
+				/* last stripe is not complete - don't
+				 * try to recover this sector.
+				 */
+				continue;
+			}
 			/* Unless we are doing a full sync, we only need
 			 * to recover the block if it is set in the bitmap
 			 */


