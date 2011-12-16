Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1LPTzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:55:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760363Ab1LPTxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:53:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:12 2011
Message-Id: <20111216194212.142775381@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux RAID <linux-raid@vger.kernel.org>,
        Alexander Lyakas <alex.bolshoy@gmail.com>, tim.gardner@canonical.com,
        NeilBrown <neilb@suse.de>
Subject: [33/45] md/raid5: fix bug that could result in reads from a failed device.
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: NeilBrown <neilb@suse.de>

commit 355840e7a7e56bb2834fd3b0da64da5465f8aeaa upstream.

commit a847627709b3402163d99f7c6fda4a77bcd6b51b in linux-3.0.9
attempted to backport this to 3.0 but only made one change were two
were necessary.  This add the second change.

This bug was introduced in 415e72d034c50520ddb7ff79e7d1792c1306f0c9
which was in 2.6.36.

There is a small window of time between when a device fails and when
it is removed from the array.  During this time we might still read
from it, but we won't write to it - so it is possible that we could
read stale data.

We didn't need the test of 'Faulty' before because the test on
In_sync is sufficient.  Since we started allowing reads from the early
part of non-In_sync devices we need a test on Faulty too.

This is suitable for any kernel from 2.6.36 onwards, though the patch
might need a bit of tweaking in 3.0 and earlier.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3078,7 +3078,7 @@ static void handle_stripe5(struct stripe
 			/* Not in-sync */;
 		else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else {
+		else if (!test_bit(Faulty, &rdev->flags)) {
 			/* could be in-sync depending on recovery/reshape status */
 			if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);


