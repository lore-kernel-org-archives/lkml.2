Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0LHCO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:14:28 -0500
Received: from kroah.org ([198.145.64.141]:46034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0LHArC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:02 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.010324394@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [037/127] md/raid1: really fix recovery looping when single good device fails.
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/md/raid1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1188,6 +1188,7 @@ static int raid1_remove_disk(mddev_t *md
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    !mddev->recovery_disabled &&
 		    mddev->degraded < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;


