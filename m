Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965852Ab2EOCxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:53:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:49618 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965075Ab2EOCRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 091/179] md: avoid endless recovery loop when waiting for fail device to complete.
Date: Mon, 14 May 2012 22:13:07 -0400
Message-ID: <1337048075-6132-92-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1287b03..d26df7f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6863,6 +6863,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(Blocked, &rdev->flags))
 				spares++;
 			if (rdev->raid_disk < 0
-- 
1.7.9.6

