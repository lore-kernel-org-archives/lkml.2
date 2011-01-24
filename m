Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1AXQop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:44:45 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33535 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1AXQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:44:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=TrCtJJp5cs0SRQmwXG8G+RIACsF7HZuUeky+CmP1FaBMESjTraK5TS+4TLFj0JATv+
         P2vFJ4EKFeE3ah93qam9tWiqrBma4nAwUck6VSnbWlIjdkU7hX6sG3cCORaIt9Rx+zza
         U5VjakKMya9OkUNwqumccyv6sT+Ys+dRQfxzY=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, akpm@linux-foundation.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] [PATCH] loop: prevent partial read
Date: Mon, 24 Jan 2011 19:43:44 +0300
Message-Id: <1295887425-7260-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If read was not fully successful we have to fail whole bio to
prevent information leak.

##Testcase_begin
dd if=/dev/zero of=./tmp bs=1M count=1
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
index 49e6a54..32e23f6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -448,7 +448,8 @@ do_lo_receive(struct loop_device *lo,
 
 	if (retval < 0)
 		return retval;
-
+	if (retval != bvec->bv_len)
+		return -EIO;
 	return 0;
 }
 
-- 
1.7.2.3

