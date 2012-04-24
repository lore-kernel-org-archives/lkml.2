Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab2DXWzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:55:04 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab2DXWfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:33 -0400
Message-Id: <20120424223244.701664774@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Ceuleers <jan.ceuleers@computer.org>,
        NeilBrown <neilb@suse.de>
Subject: [ 32/62] md: dont call ->add_disk unless there is good reason.
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7580,14 +7580,14 @@ void md_check_recovery(struct mddev *mdd
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


