Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0KDOsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:48:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60202 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0KDOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=haynFWIt2uTKynLsIhuXFV7GZLynVA6sCpydKtz5h+OGzl1Odd/KvqfApv0u4XAeTq
         JpEC7XNxYRTjvsqbb9aWGqGCJb6qApqYho6T4C2MhDQ1BI1+rxRpEIGoJTQX5SkWs3cJ
         FO5TivM38YAu+X2ureI5fqPL9a4wgM+HYcI7k=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: ioctl: fix information leak to userland
Date: Thu,  4 Nov 2010 17:48:15 +0300
Message-Id: <1288882096-13456-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure hd_geometry is copied to userland with 4 padding bytes
between cylinders and start fields uninitialized on 64-bit platforms.
It leads to leaking of contents of kernel stack memory.

Currently there is no memset() in real implementations of getgeo()
in drivers/block/, so it makes sense to have memset() in blkdev_ioctl().

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 block/ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d724ceb..60bae81 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -242,6 +242,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		 * We need to set the startsect first, the driver may
 		 * want to override it.
 		 */
+		memset(&geo, 0, sizeof(geo));
 		geo.start = get_start_sect(bdev);
 		ret = disk->fops->getgeo(bdev, &geo);
 		if (ret)
-- 
1.7.0.4

