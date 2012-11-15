Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767586Ab2KOI47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:56:59 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58346 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992592Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 3/9] ISDN: capi, use kref from tty_port
Date: Thu, 15 Nov 2012 09:49:50 +0100
Message-Id: <1352969396-23760-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue. So fix the drivers to fulfil this
assumption.

Here it is enough to switch to refcounting in tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/isdn/capi/capi.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index c679867..89562a8 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -77,8 +77,6 @@ struct ackqueue_entry {
 };
 
 struct capiminor {
-	struct kref kref;
-
 	unsigned int      minor;
 
 	struct capi20_appl	*ap;
@@ -190,7 +188,20 @@ static void capiminor_del_all_ack(struct capiminor *mp)
 
 /* -------- struct capiminor ---------------------------------------- */
 
-static const struct tty_port_operations capiminor_port_ops; /* we have none */
+static void capiminor_destroy(struct tty_port *port)
+{
+	struct capiminor *mp = container_of(port, struct capiminor, port);
+
+	kfree_skb(mp->outskb);
+	skb_queue_purge(&mp->inqueue);
+	skb_queue_purge(&mp->outqueue);
+	capiminor_del_all_ack(mp);
+	kfree(mp);
+}
+
+static const struct tty_port_operations capiminor_port_ops = {
+	.destruct = capiminor_destroy,
+};
 
 static struct capiminor *capiminor_alloc(struct capi20_appl *ap, u32 ncci)
 {
@@ -204,8 +215,6 @@ static struct capiminor *capiminor_alloc(struct capi20_appl *ap, u32 ncci)
 		return NULL;
 	}
 
-	kref_init(&mp->kref);
-
 	mp->ap = ap;
 	mp->ncci = ncci;
 	INIT_LIST_HEAD(&mp->ackqueue);
@@ -247,21 +256,10 @@ err_out2:
 	spin_unlock(&capiminors_lock);
 
 err_out1:
-	kfree(mp);
+	tty_port_put(&mp->port);
 	return NULL;
 }
 
-static void capiminor_destroy(struct kref *kref)
-{
-	struct capiminor *mp = container_of(kref, struct capiminor, kref);
-
-	kfree_skb(mp->outskb);
-	skb_queue_purge(&mp->inqueue);
-	skb_queue_purge(&mp->outqueue);
-	capiminor_del_all_ack(mp);
-	kfree(mp);
-}
-
 static struct capiminor *capiminor_get(unsigned int minor)
 {
 	struct capiminor *mp;
@@ -269,7 +267,7 @@ static struct capiminor *capiminor_get(unsigned int minor)
 	spin_lock(&capiminors_lock);
 	mp = capiminors[minor];
 	if (mp)
-		kref_get(&mp->kref);
+		tty_port_get(&mp->port);
 	spin_unlock(&capiminors_lock);
 
 	return mp;
@@ -277,7 +275,7 @@ static struct capiminor *capiminor_get(unsigned int minor)
 
 static inline void capiminor_put(struct capiminor *mp)
 {
-	kref_put(&mp->kref, capiminor_destroy);
+	tty_port_put(&mp->port);
 }
 
 static void capiminor_free(struct capiminor *mp)
-- 
1.8.0


