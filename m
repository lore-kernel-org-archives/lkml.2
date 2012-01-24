Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2AXCpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:45:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab2AXCpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:45:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:27 2012
Message-Id: <20120124023927.399359476@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [039/129] md/raid1: perform bad-block tests for WriteMostly devices too.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1469
Lines: 46

From: NeilBrown <neilb@suse.de>

commit 307729c8bc5b5a41361af8af95906eee7552acb1 upstream.

We normally try to avoid reading from write-mostly devices, but when
we do we really have to check for bad blocks and be sure not to
try reading them.

With the current code, best_good_sectors might not get set and that
causes zero-length read requests to be send down which is very
confusing.

This bug was introduced in commit d2eb35acfdccbe2 and so the patch
is suitable for 3.1.x and 3.2.x

Reported-and-tested-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reported-and-tested-by: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid1.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -525,8 +525,17 @@ static int read_balance(struct r1conf *c
 		if (test_bit(WriteMostly, &rdev->flags)) {
 			/* Don't balance among write-mostly, just
 			 * use the first as a last resort */
-			if (best_disk < 0)
+			if (best_disk < 0) {
+				if (is_badblock(rdev, this_sector, sectors,
+						&first_bad, &bad_sectors)) {
+					if (first_bad < this_sector)
+						/* Cannot use this */
+						continue;
+					best_good_sectors = first_bad - this_sector;
+				} else
+					best_good_sectors = sectors;
 				best_disk = disk;
+			}
 			continue;
 		}
 		/* This is a reasonable device to use.  It might


