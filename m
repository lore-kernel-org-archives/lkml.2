Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936153Ab1KJDuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:50:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966147Ab1KJDtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213208.142631690@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        NeilBrown <neilb@suse.de>
Subject: [254/264] md/raid5: abort any pending parity operations when array fails.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/raid5.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3165,10 +3165,14 @@ static void handle_stripe(struct stripe_
 	/* check if the array has lost more than max_degraded devices and,
 	 * if so, some requests might need to be failed.
 	 */
-	if (s.failed > conf->max_degraded && s.to_read+s.to_write+s.written)
-		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
-	if (s.failed > conf->max_degraded && s.syncing)
-		handle_failed_sync(conf, sh, &s);
+	if (s.failed > conf->max_degraded) {
+		sh->check_state = 0;
+		sh->reconstruct_state = 0;
+		if (s.to_read+s.to_write+s.written)
+			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
+		if (s.syncing)
+			handle_failed_sync(conf, sh, &s);
+	}
 
 	/*
 	 * might be able to return some write requests if the parity blocks


