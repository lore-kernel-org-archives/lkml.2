Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1DSIR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:17:28 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:49841 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1DSIRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JVPuTmQrgJsvJbNIvAivj+gpN8QmFWUU1qz3foVFR6PtsL9G2yPMN13wop5Edm6VUO
         guvPQszKTDmXBocE8jE5z035yYktIwpGgSHf6SgQndqBP4HFajYHJ+5ku2gBcd7UqmPv
         9SR+wNMvQV3FtuVrpwaoiR0cardyifNQs5YsA=
From: Liu Yuan <namei.unix@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block, blk-sysfs: Fix an err return path in blk_register_queue()
Date: Tue, 19 Apr 2011 16:17:18 +0800
Message-Id: <1303201038-11222-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

We do not call blk_trace_remove_sysfs() in err return path
if kobject_add() fails. This path fixes it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 block/blk-sysfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6d73512..5d696ad 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -508,8 +508,10 @@ int blk_register_queue(struct gendisk *disk)
 		return ret;
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
-	if (ret < 0)
+	if (ret < 0) {
+		blk_trace_remove_sysfs(dev);
 		return ret;
+	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
-- 
1.7.1

