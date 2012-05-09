Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2EIGdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:33:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38664 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab2EIFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:40 -0400
Message-Id: <20120509055032.897593072@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Jan Ceuleers <jan.ceuleers@computer.org>
Subject: [ 024/167] [PATCH] md: dont call ->add_disk unless there is good reason.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit ed209584c38fb74b7eecc03e5b1bfe674e591bd8 upstream.

Commit 7bfec5f35c68121e7b18

   md/raid5: If there is a spare and a want_replacement device, start replacement.

cause md_check_recovery to call ->add_disk much more often.
Instead of only when the array is degraded, it is now called whenever
md_check_recovery finds anything useful to do, which includes
updating the metadata for clean<->dirty transition.
This causes unnecessary work, and causes info messages from ->add_disk
to be reported much too often.

So refine md_check_recovery to only do any actual recovery checking
(including ->add_disk) if MD_RECOVERY_NEEDED is set.

This fix is suitable for 3.3.y:

Reported-by: Jan Ceuleers <jan.ceuleers@computer.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b572e1e..8beb19c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7560,14 +7560,14 @@ void md_check_recovery(struct mddev *mddev)
 		 * any transients in the value of "sync_action".
 		 */
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		/* Clear some bits that don't mean anything, but
 		 * might be left set
 		 */
 		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 
-		if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
 			goto unlock;
 		/* no recovery is running.
 		 * remove any failed drives, then
-- 
1.7.10



