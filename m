Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2GIOv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:51:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38088 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218Ab2GIOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:58 -0400
Message-Id: <20120709143119.150675604@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Christian Balzer <chibi@gol.com>
Subject: [ 17/48] md/raid10: fix failure when trying to repair a read error.
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

commit 055d3747dbf00ce85c6872ecca4d466638e80c22 upstream.

commit 58c54fcca3bac5bf9290cfed31c76e4c4bfbabaf
     md/raid10: handle further errors during fix_read_error better.

in 3.1 added "r10_sync_page_io" which takes an IO size in sectors.
But we were passing the IO size in bytes!!!
This resulting in bio_add_page failing, and empty request being sent
down, and a consequent BUG_ON in scsi_lib.

[fix missing space in error message at same time]

This fix is suitable for 3.1.y and later.

Reported-by: Christian Balzer <chibi@gol.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1919,7 +1919,7 @@ static void fix_read_error(struct r10con
 			if (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s<<9, conf->tmppage, WRITE)
+					     s, conf->tmppage, WRITE)
 			    == 0) {
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
@@ -1956,7 +1956,7 @@ static void fix_read_error(struct r10con
 			switch (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s<<9, conf->tmppage,
+					     s, conf->tmppage,
 						 READ)) {
 			case 0:
 				/* Well, this device is dead */
@@ -2119,7 +2119,7 @@ read_more:
 	rdev = conf->mirrors[mirror].rdev;
 	printk_ratelimited(
 		KERN_ERR
-		"md/raid10:%s: %s: redirecting"
+		"md/raid10:%s: %s: redirecting "
 		"sector %llu to another mirror\n",
 		mdname(mddev),
 		bdevname(rdev->bdev, b),


