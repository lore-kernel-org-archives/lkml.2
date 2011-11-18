Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1KSAIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab1KSAI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:05 2011
Message-Id: <20111119000005.570284097@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        NeilBrown <neilb@suse.de>
Subject: [18/26] md/raid5: abort any pending parity operations when array fails.
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 9a3f530f39f4490eaa18b02719fb74ce5f4d2d86 upstream.

When the number of failed devices exceeds the allowed number
we must abort any active parity operations (checks or updates) as they
are no longer meaningful, and can lead to a BUG_ON in
handle_parity_checks6.

This bug was introduce by commit 6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8
in 2.6.29.

Reported-by: Manish Katiyar <mkatiyar@gmail.com>
Tested-by: Manish Katiyar <mkatiyar@gmail.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3120,12 +3120,16 @@ static void handle_stripe5(struct stripe
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (s.failed > 1 && s.to_read+s.to_write+s.written)
-		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
-	if (s.failed > 1 && s.syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-		s.syncing = 0;
+	if (s.failed > 1) {
+		sh->check_state = 0;
+		sh->reconstruct_state = 0;
+		if (s.to_read+s.to_write+s.written)
+			handle_failed_stripe(conf, sh, &s, disks, &return_bi);
+		if (s.syncing) {
+			md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+			clear_bit(STRIPE_SYNCING, &sh->state);
+			s.syncing = 0;
+		}
 	}
 
 	/* might be able to return some write requests if the parity block
@@ -3412,12 +3416,16 @@ static void handle_stripe6(struct stripe
 	/* check if the array has lost >2 devices and, if so, some requests
 	 * might need to be failed
 	 */
-	if (s.failed > 2 && s.to_read+s.to_write+s.written)
-		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
-	if (s.failed > 2 && s.syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-		s.syncing = 0;
+	if (s.failed > 2) {
+		sh->check_state = 0;
+		sh->reconstruct_state = 0;
+		if (s.to_read+s.to_write+s.written)
+			handle_failed_stripe(conf, sh, &s, disks, &return_bi);
+		if (s.syncing) {
+			md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+			clear_bit(STRIPE_SYNCING, &sh->state);
+			s.syncing = 0;
+		}
 	}
 
 	/*


