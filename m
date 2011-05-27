Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab1E0GAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:00:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53629 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1E0GAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sJ8vBxqsOmw1x5fRlW66mRFCOhmFRVkzqny/WIr2BmRatjT8uy1KXTazIOVeAzInez
         gzAZhJpkNmIh6kuB8M6rNBIXWFVpQJo+8rvP6tRgP8OQpejJlh0M6/R6fnaY87ljSjjG
         iniWPElPQPQIsqkdetwhfJCRJDL/US3pO3nhg=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 3/3] nbd: adjust 'max_part' according to part_shift
Date: Fri, 27 May 2011 15:00:03 +0900
Message-Id: <1306476003-4624-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
References: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'max_part' parameter determines how many partitions are supported
on each nbd device. However the actual number can be changed to the
power of 2 minus 1 form during the module initialization as
alloc_disk() is called with (1 << part_shift) for some reason.

So adjust 'max_part' also at least for consistency with loop and brd.
It is exported via sysfs already, and a user should check this value
after module loading if [s]he wants to use that number correctly
(i.e. fdisk or something).

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Paul Clements <Paul.Clements@steeleye.com>
---
 drivers/block/nbd.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fdee7567fd15..f533f3375e24 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -754,9 +754,20 @@ static int __init nbd_init(void)
 		return -ENOMEM;
 
 	part_shift = 0;
-	if (max_part > 0)
+	if (max_part > 0) {
 		part_shift = fls(max_part);
 
+		/*
+		 * Adjust max_part according to part_shift as it is exported
+		 * to user space so that user can know the max number of
+		 * partition kernel should be able to manage.
+		 *
+		 * Note that -1 is required because partition 0 is reserved
+		 * for the whole disk.
+		 */
+		max_part = (1UL << part_shift) - 1;
+	}
+
 	if ((1UL << part_shift) > DISK_MAX_PARTS)
 		return -EINVAL;
 
-- 
1.7.5.2

