Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab1DNS3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:29:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:37974 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab1DNRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, NeilBrown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 050/209] md/raid1: really fix recovery looping when single good device fails.
Date: Thu, 14 Apr 2011 13:41:20 -0400
Message-Id: <1302803039-9400-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/raid1.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 52c6b5f..aaa49f1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1214,6 +1214,7 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    !mddev->recovery_disabled &&
 		    mddev->degraded < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;
-- 
1.7.4.4

