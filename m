Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2HOTwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:37079 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2HOTwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 130/165] md/raid5: abort any pending parity operations when array fails.
Date: Wed, 15 Aug 2012 15:47:54 -0400
Message-ID: <1345060109-9187-131-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
[PG: use 2.6.32.49 backport since raid5.c @ 9a3f530f/v3.2 differs more]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/raid5.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc3e4fc..2936c3b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3040,12 +3040,16 @@ static void handle_stripe5(struct stripe_head *sh)
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
@@ -3323,12 +3327,16 @@ static void handle_stripe6(struct stripe_head *sh)
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
-- 
1.7.12.rc2

