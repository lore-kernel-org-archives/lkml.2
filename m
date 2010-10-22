Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0JVXyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab0JVXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EtTg3tzxCJMgYZ6XIjSFVBdI3qGbmw8JMzqliZiQJSVvjFn90kxl5MENbrlLDZHT9I
         shORTJ+xnd57DxchbBmnu8bUNqmu6DZjP2Az8SJsLxMhlFPMTklsJfjfbK3DPQfEtXbD
         o/MRYS1r/2Gm36euQwE1/k9Vc69jt1bZ7L97A=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 14/29] memstick: remove the memstick_set_rw_addr
Date: Sat, 23 Oct 2010 01:53:42 +0200
Message-Id: <1287791637-10329-15-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this function, what was
last user that did send the MS_TPC_SET_RW_REG_ADRS
directly.

Just invalidate the register window, and next register
read/write will send that tpc automaticly.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c |   49 ++++----------------------------------
 1 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 9de64eb..66fc9d6 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -238,27 +238,6 @@ static int h_memstick_read_dev_id(struct memstick_dev *card)
 	return 0;
 }
 
-static int h_memstick_set_rw_addr(struct memstick_dev *card)
-{
-	struct memstick_request *mrq = &card->current_mrq;
-
-	if (mrq->error)
-		return memstick_exit_state_machine(card, mrq->error);
-
-	switch (card->state) {
-	case 0:
-		memstick_init_req(card, MS_TPC_SET_RW_REG_ADRS,
-				  (char *)&card->reg_addr,
-				  sizeof(card->reg_addr));
-		break;
-	case 1:
-		return memstick_exit_state_machine(card, 0);
-	}
-
-	card->state++;
-	return 0;
-}
-
 static int h_memstick_default_bad(struct memstick_dev *card)
 {
 	return -ENXIO;
@@ -274,7 +253,6 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
 					    GFP_KERNEL);
 	struct memstick_dev *old_card = host->card;
-	struct ms_id_register id_reg;
 
 	if (card) {
 		card->host = host;
@@ -284,18 +262,12 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 		card->dev.release = memstick_free_card;
 		card->check = memstick_dummy_check;
 
-		card->reg_addr.r_offset = offsetof(struct ms_register, id);
-		card->reg_addr.r_length = sizeof(id_reg);
-		card->reg_addr.w_offset = offsetof(struct ms_register, id);
-		card->reg_addr.w_length = sizeof(id_reg);
-
 		host->card = card;
 		init_completion(&card->mrq_complete);
 		card->state = -1;
 		card->next_request = h_memstick_default_bad;
 
-		if (memstick_set_rw_addr(card))
-			goto err_out;
+		memstick_invalidate_reg_window(card);
 
 		if (memstick_run_state_machine(card,
 						h_memstick_read_dev_id, true))
@@ -340,8 +312,10 @@ static void memstick_check(struct work_struct *work)
 	if (!host->card) {
 		if (memstick_power_on(host))
 			goto out_power_off;
-	} else if (host->card->stop)
+	} else if (host->card->stop) {
 		host->card->stop(host->card);
+		memstick_invalidate_reg_window(host->card);
+	}
 
 	card = memstick_alloc_card(host);
 
@@ -354,8 +328,7 @@ static void memstick_check(struct work_struct *work)
 		dev_dbg(&host->dev, "new card %02x, %02x, %02x\n",
 			card->id.type, card->id.category, card->id.class);
 		if (host->card) {
-			if (memstick_set_rw_addr(host->card)
-			    || !memstick_dev_match(host->card, &card->id)
+			if (!memstick_dev_match(host->card, &card->id)
 			    || !(host->card->check(host->card))) {
 				device_unregister(&host->card->dev);
 				host->card = NULL;
@@ -407,18 +380,6 @@ void memstick_unregister_driver(struct memstick_driver *drv)
 EXPORT_SYMBOL(memstick_unregister_driver);
 
 
-/**
- * memstick_set_rw_addr - issue SET_RW_REG_ADDR request and wait for it to
- *                        complete
- * @card - media device to use
- */
-int memstick_set_rw_addr(struct memstick_dev *card)
-{
-	return memstick_run_state_machine(card, h_memstick_set_rw_addr, true);
-}
-EXPORT_SYMBOL(memstick_set_rw_addr);
-
-
 /*** state machine support code ***/
 
 /**
-- 
1.7.1

