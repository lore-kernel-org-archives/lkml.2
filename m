Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2GWBnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54288 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab2GWBnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:07 -0400
Message-Id: <20120723010701.303457284@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [ 065/108] md/raid1: close some possible races on write errors during resync
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 58e94ae18478c08229626daece2fc108a4a23261 upstream.

commit 4367af556133723d0f443e14ca8170d9447317cb
   md/raid1: clear bad-block record when write succeeds.

Added a 'reschedule_retry' call possibility at the end of
end_sync_write, but didn't add matching code at the end of
sync_request_write.  So if the writes complete very quickly, or
scheduling makes it seem that way, then we can miss rescheduling
the request and the resync could hang.

Also commit 73d5c38a9536142e062c35997b044e89166e063b
    md: avoid races when stopping resync.

Fix a race condition in this same code in end_sync_write but didn't
make the change in sync_request_write.

This patch updates sync_request_write to fix both of those.
Patch is suitable for 3.1 and later kernels.

Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Original-version-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid1.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 240ff31..cacd008 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1818,8 +1818,14 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		/* if we're here, all write(s) have completed, so clean up */
-		md_done_sync(mddev, r1_bio->sectors, 1);
-		put_buf(r1_bio);
+		int s = r1_bio->sectors;
+		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+		    test_bit(R1BIO_WriteError, &r1_bio->state))
+			reschedule_retry(r1_bio);
+		else {
+			put_buf(r1_bio);
+			md_done_sync(mddev, s, 1);
+		}
 	}
 }
 


