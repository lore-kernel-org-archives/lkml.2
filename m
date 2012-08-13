Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2HMUWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:22:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2HMUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Lyakas <alex.bolshoy@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 33/82] md/raid1: dont abort a resync on the first badblock.
Date: Mon, 13 Aug 2012 13:19:09 -0700
Message-Id: <20120813201749.333309384@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2428,7 +2428,10 @@ static sector_t sync_request(struct mdde
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


