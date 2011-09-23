Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1IWLAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:00:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59097 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1IWLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:00:23 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, akpm@linux-foundation.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] loop: prevent information leak after failed read
Date: Fri, 23 Sep 2011 15:01:28 +0400
Message-Id: <1316775689-22695-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If read was not fully successful we have to fail whole bio to
prevent information leak of old pages

##Testcase_begin
dd if=/dev/zero of=./file bs=1M count=1
losetup /dev/loop0 ./file -o 4096
truncate -s 0 ./file
# OOps loop offset is now beyond i_size, so read will silently fail.
# So bio's pages would not be cleared, may which result in information leak.
hexdump -C /dev/loop0
##testcase_end

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/block/loop.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 4720c7a..0dcc7bf 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -447,7 +447,8 @@ do_lo_receive(struct loop_device *lo,
 
 	if (retval < 0)
 		return retval;
-
+	if (retval != bvec->bv_len)
+		return -EIO;
 	return 0;
 }
 
-- 
1.7.1

