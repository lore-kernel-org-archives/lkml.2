Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1G0VyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:54:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:50292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1G0VtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30901034"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [80/99] md: avoid endless recovery loop when waiting for fail device to complete.
Message-Id: <20110727214919.B8F632403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c
+++ linux-2.6.35.y/drivers/md/md.c
@@ -6967,6 +6967,7 @@ static int remove_and_add_spares(mddev_t
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(Blocked, &rdev->flags))
 				spares++;
 			if (rdev->raid_disk < 0
