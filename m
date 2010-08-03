Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0HCOxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:53:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0HCOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=COBbwn5qi6luhejoGX8IFzq8HQKU1E80FsBWCu4gsdEwBGMTYvHKP8+FlM77n8Dt8I
         JNGVsJTHzMVoTLb9aeNmKtTRxYM/QBH8rzsvM2X+9DMKNL5sVNpZKTW2VWFsraQphHUt
         XyhmIderYGvV5YD28MLxmaqNjGFJFNU1aGuNs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
Date: Tue,  3 Aug 2010 17:53:05 +0300
Message-Id: <1280847186-11501-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280847186-11501-1-git-send-email-maximlevitsky@gmail.com>
References: <1280847186-11501-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that del_gendisk syncs, we better start rejecting requests right away.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 8327e24..8d27c13 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1330,13 +1330,14 @@ static void mspro_block_remove(struct memstick_dev *card)
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	unsigned long flags;
 
-	del_gendisk(msb->disk);
-	dev_dbg(&card->dev, "mspro block remove\n");
 	spin_lock_irqsave(&msb->q_lock, flags);
 	msb->eject = 1;
 	blk_start_queue(msb->queue);
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 
+	del_gendisk(msb->disk);
+	dev_dbg(&card->dev, "mspro block remove\n");
+
 	blk_cleanup_queue(msb->queue);
 	msb->queue = NULL;
 
-- 
1.7.0.4

