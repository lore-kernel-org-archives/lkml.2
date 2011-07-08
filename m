Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1GHFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:09:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab1GHFFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.108750878@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [086/107] md: avoid endless recovery loop when waiting for fail device to complete.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -7062,6 +7062,7 @@ static int remove_and_add_spares(mddev_t
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(Blocked, &rdev->flags))
 				spares++;
 			if (rdev->raid_disk < 0


