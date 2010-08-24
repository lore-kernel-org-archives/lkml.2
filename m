Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab0HXXmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:42:03 -0400
Received: from kroah.org ([198.145.64.141]:52393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab0HXW54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:57:56 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:12 2010
Message-Id: <20100824224212.241449199@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>
Subject: [02/91] memstick: fix hangs on unexpected device removal in mspro_blk
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit d862b13bc8cbab9692fbe0ef44c40d0488b81af1 upstream.

mspro_block_remove() is called from detect thread that first calls the
mspro_block_stop(), which stops the request queue.  If we call
del_gendisk() with the queue stopped we get a deadlock.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/memstick/core/mspro_block.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1331,13 +1331,14 @@ static void mspro_block_remove(struct me
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
 


