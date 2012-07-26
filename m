Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2GZVVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:21:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2GZVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Lyakas <alex.bolshoy@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 02/23] md/raid1: close some possible races on write errors during resync
Date: Thu, 26 Jul 2012 14:19:41 -0700
Message-Id: <20120726211406.053709887@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1821,8 +1821,14 @@ static void sync_request_write(struct md
 
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
 


