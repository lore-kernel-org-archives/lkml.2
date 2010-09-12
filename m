Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0ILS4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:56:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab0ILS4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fobBBe8dxBbJWe7aEEJzF7ClAOslPKTTr5YM0PsXANNyYaEBUZupu19fWR2t5OYcvm
         MnXbO1iMkeC6Va+Na3zXTItzpq5xxmHfpbd42Wrqdx9U45iMnrzTE5ZMKplfWzYPp444
         aV51Iq/DCMZ4qpapdujHdmYnqsG/j3xX69YVg=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Sven Eckelmann <sven.eckelmann@gmx.de>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andreas Langer <an.langer@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: batman-adv: check kmalloc() return value
Date: Sun, 12 Sep 2010 22:56:26 +0400
Message-Id: <1284317791-4744-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() may fail, if so drop current packet.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/batman-adv/routing.c |    6 ++++--
 drivers/staging/batman-adv/unicast.c |    8 ++++++--
 drivers/staging/batman-adv/unicast.h |    2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/batman-adv/routing.c b/drivers/staging/batman-adv/routing.c
index e12fd99..e545260 100644
--- a/drivers/staging/batman-adv/routing.c
+++ b/drivers/staging/batman-adv/routing.c
@@ -1232,8 +1232,10 @@ int recv_ucast_frag_packet(struct sk_buff *skb, struct batman_if *recv_if)
 
 		orig_node->last_frag_packet = jiffies;
 
-		if (list_empty(&orig_node->frag_list))
-			create_frag_buffer(&orig_node->frag_list);
+		if (list_empty(&orig_node->frag_list)) {
+			if (create_frag_buffer(&orig_node->frag_list))
+				return NET_RX_DROP;
+		}
 
 		tmp_frag_entry =
 			search_frag_packet(&orig_node->frag_list,
diff --git a/drivers/staging/batman-adv/unicast.c b/drivers/staging/batman-adv/unicast.c
index f951abc..f7d2206 100644
--- a/drivers/staging/batman-adv/unicast.c
+++ b/drivers/staging/batman-adv/unicast.c
@@ -78,7 +78,7 @@ void create_frag_entry(struct list_head *head, struct sk_buff *skb)
 	return;
 }
 
-void create_frag_buffer(struct list_head *head)
+int create_frag_buffer(struct list_head *head)
 {
 	int i;
 	struct frag_packet_list_entry *tfp;
@@ -86,13 +86,17 @@ void create_frag_buffer(struct list_head *head)
 	for (i = 0; i < FRAG_BUFFER_SIZE; i++) {
 		tfp = kmalloc(sizeof(struct frag_packet_list_entry),
 			GFP_ATOMIC);
+		if (tfp == NULL) {
+			frag_list_free(head);
+			return -ENOMEM;
+		}
 		tfp->skb = NULL;
 		tfp->seqno = 0;
 		INIT_LIST_HEAD(&tfp->list);
 		list_add(&tfp->list, head);
 	}
 
-	return;
+	return 0;
 }
 
 struct frag_packet_list_entry *search_frag_packet(struct list_head *head,
diff --git a/drivers/staging/batman-adv/unicast.h b/drivers/staging/batman-adv/unicast.h
index 1d5cbeb..7973697 100644
--- a/drivers/staging/batman-adv/unicast.h
+++ b/drivers/staging/batman-adv/unicast.h
@@ -30,7 +30,7 @@ struct sk_buff *merge_frag_packet(struct list_head *head,
 	struct sk_buff *skb);
 
 void create_frag_entry(struct list_head *head, struct sk_buff *skb);
-void create_frag_buffer(struct list_head *head);
+int create_frag_buffer(struct list_head *head);
 struct frag_packet_list_entry *search_frag_packet(struct list_head *head,
 	struct unicast_frag_packet *up);
 void frag_list_free(struct list_head *head);
-- 
1.7.0.4

