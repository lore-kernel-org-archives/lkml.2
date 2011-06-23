Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab1FWRgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:34643 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427Ab1FWRgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, NeilBrown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 131/247] md: correctly handle probe of an 'mdp' device.
Date: Thu, 23 Jun 2011 13:33:19 -0400
Message-Id: <1308850515-15242-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8f5f02c460b7ca74ce55ce126ce0c1e58a3f923d upstream.

'mdp' devices are md devices with preallocated device numbers
for partitions. As such it is possible to mknod and open a partition
before opening the whole device.

this causes  md_probe() to be called with a device number of a
partition, which in-turn calls mddev_find with such a number.

However mddev_find expects the number of a 'whole device' and
does the wrong thing with partition numbers.

So add code to mddev_find to remove the 'partition' part of
a device number and just work with the 'whole device'.

This patch addresses https://bugzilla.kernel.org/show_bug.cgi?id=28652

Reported-by: hkmaly@bigfoot.com
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7db9ceb..f468ec6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -410,6 +410,9 @@ static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
 
+	if (unit && MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1<<MdpMinorShift)-1);
+
  retry:
 	spin_lock(&all_mddevs_lock);
 
-- 
1.7.4.4

