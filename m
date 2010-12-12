Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0LMAO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:14:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0LLXqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [90/223] md/raid1: really fix recovery looping when single good device fails.
Message-Id: <20101212234629.E7874B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: NeilBrown <neilb@suse.de>

commit 8f9e0ee38f75d4740daa9e42c8af628d33d19a02 upstream.

Commit 4044ba58dd15cb01797c4fd034f39ef4a75f7cc3 supposedly fixed a
problem where if a raid1 with just one good device gets a read-error
during recovery, the recovery would abort and immediately restart in
an infinite loop.

However it depended on raid1_remove_disk removing the spare device
from the array.  But that does not happen in this case.  So add a test
so that in the 'recovery_disabled' case, the device will be removed.

This suitable for any kernel since 2.6.29 which is when
recovery_disabled was introduced.

Reported-by: Sebastian Färber <faerber@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/raid1.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c
+++ linux/drivers/md/raid1.c
@@ -1208,6 +1208,7 @@ static int raid1_remove_disk(mddev_t *md
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    !mddev->recovery_disabled &&
 		    mddev->degraded < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;
