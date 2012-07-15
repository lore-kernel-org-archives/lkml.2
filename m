Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2GOJZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:25:38 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:16113 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab2GOJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:25:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,588,1336341600"; 
   d="scan'208";a="166905832"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/dvb/siano/smscoreapi.c: use list_for_each_entry
Date: Sun, 15 Jul 2012 11:25:22 +0200
Message-Id: <1342344322-11122-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use list_for_each_entry and perform some other induced simplifications.

The semantic match that finds the opportunity for this reorganization is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
struct list_head *pos;
struct list_head *head;
statement S;
@@

*for (pos = (head)->next; pos != (head); pos = pos->next)
S
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/media/dvb/siano/smscoreapi.c |   39 ++++++++++++++---------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 7331e84..9cc5554 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -276,16 +276,13 @@ static void smscore_notify_clients(struct smscore_device_t *coredev)
 static int smscore_notify_callbacks(struct smscore_device_t *coredev,
 				    struct device *device, int arrival)
 {
-	struct list_head *next, *first;
+	struct smscore_device_notifyee_t *elem;
 	int rc = 0;
 
 	/* note: must be called under g_deviceslock */
 
-	first = &g_smscore_notifyees;
-
-	for (next = first->next; next != first; next = next->next) {
-		rc = ((struct smscore_device_notifyee_t *) next)->
-				hotplug(coredev, device, arrival);
+	list_for_each_entry(elem, &g_smscore_notifyees, entry) {
+		rc = elem->hotplug(coredev, device, arrival);
 		if (rc < 0)
 			break;
 	}
@@ -940,29 +937,25 @@ static struct
 smscore_client_t *smscore_find_client(struct smscore_device_t *coredev,
 				      int data_type, int id)
 {
-	struct smscore_client_t *client = NULL;
-	struct list_head *next, *first;
+	struct list_head *first;
+	struct smscore_client_t *client;
 	unsigned long flags;
-	struct list_head *firstid, *nextid;
-
+	struct list_head *firstid;
+	struct smscore_idlist_t *client_id;
 
 	spin_lock_irqsave(&coredev->clientslock, flags);
 	first = &coredev->clients;
-	for (next = first->next;
-	     (next != first) && !client;
-	     next = next->next) {
-		firstid = &((struct smscore_client_t *)next)->idlist;
-		for (nextid = firstid->next;
-		     nextid != firstid;
-		     nextid = nextid->next) {
-			if ((((struct smscore_idlist_t *)nextid)->id == id) &&
-			    (((struct smscore_idlist_t *)nextid)->data_type == data_type ||
-			    (((struct smscore_idlist_t *)nextid)->data_type == 0))) {
-				client = (struct smscore_client_t *) next;
-				break;
-			}
+	list_for_each_entry(client, first, entry) {
+		firstid = &client->idlist;
+		list_for_each_entry(client_id, firstid, entry) {
+			if ((client_id->id == id) &&
+			    (client_id->data_type == data_type ||
+			    (client_id->data_type == 0)))
+				goto found;
 		}
 	}
+	client = NULL;
+found:
 	spin_unlock_irqrestore(&coredev->clientslock, flags);
 	return client;
 }

