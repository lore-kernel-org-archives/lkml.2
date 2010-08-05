Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754Ab0HEPXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:23:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38720 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679Ab0HEPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kOpzB+A8xrxRSJcLUmTCJSiI1K+ONPJ8ceZ0Pwm7CIoy+hpEYrcFHq8Va2b1pjLvTx
         pm0Tie8naYMs02gcb4wmR/gPeQu22nqAgQJ6SqAFilA28W7LlifayiOBNeDKoedMwAmH
         86NodRzO0lIFXgk/ig4m8wgszfb5tgMpTzhrY=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2/3] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
Date: Thu,  5 Aug 2010 18:23:28 +0300
Message-Id: <1281021809-20924-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
References: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mspro_block_remove is called from detect thread that first calls
the mspro_block_stop, which stops the request queue.
If we call del_gendisk with queue stopped we get a deadlock.


Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 369313f..300ec15 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1331,13 +1331,14 @@ static void mspro_block_remove(struct memstick_dev *card)
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

