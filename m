Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0JVXyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0JVXyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yDooxH9OmOl/Zt3ns7pw26FalUeDM3jNLdyPRMRAp6plY5R1xZFFc0GfPn7MmNMbJn
         DqfYvMboqgh521Hkw5JyeFCYnfA0FEqBJ0DCqHsKNagq0UvxZEeTDwLlv6SmKFero2Pa
         d4zP6h8ShoBGLvJe3PL1VumLuGo6TChJPX/R0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 07/29] memstick: mspro: two fixes
Date: Sat, 23 Oct 2010 01:53:35 +0200
Message-Id: <1287791637-10329-8-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix uninitialized spinlock warning on resume
and race in idr_pre_get

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index a979c9d..13cb83b 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -485,6 +485,7 @@ has_int_reg:
 		t_offset = msb->req_sg[msb->current_seg].offset;
 		t_offset += msb->current_page * msb->page_size;
 
+		sg_init_table(&t_sg, 1);
 		sg_set_page(&t_sg,
 			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
 				     t_offset >> PAGE_SHIFT),
@@ -1056,10 +1057,13 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL))
+	mutex_lock(&mspro_block_disk_lock);
+
+	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
+		mutex_unlock(&mspro_block_disk_lock);
 		return -ENOMEM;
+	}
 
-	mutex_lock(&mspro_block_disk_lock);
 	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
 	mutex_unlock(&mspro_block_disk_lock);
 
@@ -1248,6 +1252,8 @@ static int mspro_block_resume(struct memstick_dev *card)
 
 	new_msb->card = card;
 	memstick_set_drvdata(card, new_msb);
+	spin_lock_init(&new_msb->q_lock);
+
 	if (mspro_block_init_card(card))
 		goto out_free;
 
-- 
1.7.1

