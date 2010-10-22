Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0JVXyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0JVXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m9nqi0DprhF8EWey59Zf/bSkTBGTbENiwzmAjXJCoQk77/BXwERSH5bEypwxgaQXzx
         IzaInQWIWBe4xd/300BFs/nBc/sicEdlHwQXFnD8ArDBuzde+Oq/bopQFC9UEUQbuvGg
         MwjqrdE+leEicXiPUQwevc8spLAl2OGiz1jt8=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 04/29] memstick: core: rework state machines
Date: Sat, 23 Oct 2010 01:53:32 +0200
Message-Id: <1287791637-10329-5-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make state machines in memstick core follow the
new style.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/memstick.c |   82 ++++++++++++++++++++-----------------
 1 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 9fe36c7..e1aa089 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -211,44 +211,57 @@ static int memstick_dummy_check(struct memstick_dev *card)
  */
 
 static int h_memstick_read_dev_id(struct memstick_dev *card,
-				  struct memstick_request **mrq)
+						struct memstick_request **mrq)
 {
 	struct ms_id_register id_reg;
 
-	if (!(*mrq)) {
-		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
-				  sizeof(struct ms_id_register));
-		*mrq = &card->current_mrq;
-		return 0;
-	} else {
-		if (!(*mrq)->error) {
-			memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
-			card->id.match_flags = MEMSTICK_MATCH_ALL;
-			card->id.type = id_reg.type;
-			card->id.category = id_reg.category;
-			card->id.class = id_reg.class;
-			dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
-		}
-		complete(&card->mrq_complete);
-		return -EAGAIN;
+	memstick_allocate_request(card, mrq);
+	if ((*mrq)->error)
+		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+
+	switch (card->state) {
+	case 0:
+		if (!memstick_read_regs(card,
+			offsetof(struct ms_register, id),
+			sizeof(struct ms_id_register), *mrq))
+			return 0;
+		break;
+	case 1:
+		memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
+		card->id.match_flags = MEMSTICK_MATCH_ALL;
+		card->id.type = id_reg.type;
+		card->id.category = id_reg.category;
+		card->id.class = id_reg.class;
+		dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
+		return memstick_exit_state_machine(card, *mrq, 0);
 	}
+
+	card->state++;
+	return 0;
 }
 
 static int h_memstick_set_rw_addr(struct memstick_dev *card,
 				  struct memstick_request **mrq)
 {
-	if (!(*mrq)) {
-		memstick_init_req(&card->current_mrq, MS_TPC_SET_RW_REG_ADRS,
+	memstick_allocate_request(card, mrq);
+	if ((*mrq)->error)
+		return memstick_exit_state_machine(card, *mrq, (*mrq)->error);
+
+	switch (card->state) {
+	case 0:
+		memstick_init_req(*mrq, MS_TPC_SET_RW_REG_ADRS,
 				  (char *)&card->reg_addr,
 				  sizeof(card->reg_addr));
-		*mrq = &card->current_mrq;
-		return 0;
-	} else {
-		complete(&card->mrq_complete);
-		return -EAGAIN;
+		break;
+	case 1:
+		return memstick_exit_state_machine(card, *mrq, 0);
 	}
+
+	card->state++;
+	return 0;
 }
 
+
 static int h_memstick_default_bad(struct memstick_dev *card,
 				     struct memstick_request **mrq)
 {
@@ -281,18 +294,18 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 		card->reg_addr.w_offset = offsetof(struct ms_register, id);
 		card->reg_addr.w_length = sizeof(id_reg);
 
+		host->card = card;
 		init_completion(&card->mrq_complete);
+		card->state = -1;
+		card->next_request = h_memstick_default_bad;
 
-		host->card = card;
 		if (memstick_set_rw_addr(card))
 			goto err_out;
 
-		card->next_request = h_memstick_read_dev_id;
-		memstick_new_req(host);
-		wait_for_completion(&card->mrq_complete);
-
-		if (card->current_mrq.error)
+		if (memstick_run_state_machine(card,
+						h_memstick_read_dev_id, true))
 			goto err_out;
+
 	}
 	host->card = old_card;
 	return card;
@@ -406,11 +419,7 @@ EXPORT_SYMBOL(memstick_unregister_driver);
  */
 int memstick_set_rw_addr(struct memstick_dev *card)
 {
-	card->next_request = h_memstick_set_rw_addr;
-	memstick_new_req(card->host);
-	wait_for_completion(&card->mrq_complete);
-
-	return card->current_mrq.error;
+	return memstick_run_state_machine(card, h_memstick_set_rw_addr, true);
 }
 EXPORT_SYMBOL(memstick_set_rw_addr);
 
@@ -481,9 +490,6 @@ EXPORT_SYMBOL(memstick_run_state_machine);
 int memstick_exit_state_machine(struct memstick_dev *card,
 			struct memstick_request *req, int error)
 {
-	if (error)
-		req->error = error;
-
 	card->state = -1;
 	card->exit_error = error;
 	card->next_request = h_memstick_default_bad;
-- 
1.7.1

