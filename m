Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162950Ab2GLXHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:07:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47342 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162922Ab2GLXGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Balzer <chibi@gol.com>, NeilBrown <neilb@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 61/68] md/raid10: Dont try to recovery unmatched (and unused) chunks.
Date: Thu, 12 Jul 2012 16:02:35 -0700
Message-Id: <20120712175040.812339812@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1858,6 +1858,12 @@ static sector_t sync_request(mddev_t *md
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


