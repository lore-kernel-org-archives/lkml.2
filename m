Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162156Ab2GLXA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:00:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162080Ab2GLWnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Balzer <chibi@gol.com>, NeilBrown <neilb@suse.de>
Subject: [ 130/187] md/raid10: fix failure when trying to repair a read error.
Date: Thu, 12 Jul 2012 15:34:46 -0700
Message-Id: <20120712191534.436359453@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2209,7 +2209,7 @@ static void fix_read_error(struct r10con
 			if (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s<<9, conf->tmppage, WRITE)
+					     s, conf->tmppage, WRITE)
 			    == 0) {
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
@@ -2246,7 +2246,7 @@ static void fix_read_error(struct r10con
 			switch (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s<<9, conf->tmppage,
+					     s, conf->tmppage,
 						 READ)) {
 			case 0:
 				/* Well, this device is dead */
@@ -2407,7 +2407,7 @@ read_more:
 	slot = r10_bio->read_slot;
 	printk_ratelimited(
 		KERN_ERR
-		"md/raid10:%s: %s: redirecting"
+		"md/raid10:%s: %s: redirecting "
 		"sector %llu to another mirror\n",
 		mdname(mddev),
 		bdevname(rdev->bdev, b),


