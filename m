Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1GIGHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:07:39 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39073 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab1GIGA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:00:59 -0400
X-Sasl-enc: we+wfbe0N2aNM8LZvnicIC0hUzuQrSPCDe/gzJbeDteb 1310191259
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:11 2011
Message-Id: <20110708230111.216143870@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [17/35] md: avoid endless recovery loop when waiting for fail device to complete.
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 4274215d24633df7302069e51426659d4759c5ed upstream.

If a device fails in a way that causes pending request to take a while
to complete, md will not be able to immediately remove it from the
array in remove_and_add_spares.
It will then incorrectly look like a spare device and md will try to
recover it even though it is failed.
This leads to a recovery process starting and instantly aborting over
and over again.

We should check if the device is faulty before considering it to be a
spare.  This will avoid trying to start a recovery that cannot
proceed.

This bug was introduced in 2.6.26 so that patch is suitable for any
kernel since then.

Reported-by: Jim Paradis <james.paradis@stratus.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6862,6 +6862,7 @@ static int remove_and_add_spares(mddev_t
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(Blocked, &rdev->flags))
 				spares++;
 			if (rdev->raid_disk < 0


