Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015Ab2ILSnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:43:46 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:42362 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2ILSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:43:44 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sage Ahn <syahn@gctsemi.com>, Ben Chan <benchan@chromium.org>
Subject: [PATCH] staging: gdm72xx: simplify alloc_tx_struct and alloc_rx_struct
Date: Wed, 12 Sep 2012 11:43:41 -0700
Message-Id: <1347475421-1126-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies alloc_tx_struct and alloc_rx_struct in gdm_sdio.c
and gdm_usb.c by replacing kmalloc+memset with kzalloc and reorganizing
the code.

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_sdio.c |   30 ++++++++----------------
 drivers/staging/gdm72xx/gdm_usb.c  |   44 ++++++++++++++----------------------
 2 files changed, 27 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index a0621d9..ca38d71 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -60,25 +60,20 @@ static void hexdump(char *title, u8 *data, int len)
 
 static struct sdio_tx *alloc_tx_struct(struct tx_cxt *tx)
 {
-	struct sdio_tx *t = NULL;
+	struct sdio_tx *t = kzalloc(sizeof(*t), GFP_ATOMIC);
 
-	t = kzalloc(sizeof(*t), GFP_ATOMIC);
-	if (t == NULL)
-		goto out;
+	if (!t)
+		return NULL;
 
 	t->buf = kmalloc(TX_BUF_SIZE, GFP_ATOMIC);
-	if (t->buf == NULL)
-		goto out;
+	if (!t->buf) {
+		kfree(t);
+		return NULL;
+	}
 
 	t->tx_cxt = tx;
 
 	return t;
-out:
-	if (t) {
-		kfree(t->buf);
-		kfree(t);
-	}
-	return NULL;
 }
 
 static void free_tx_struct(struct sdio_tx *t)
@@ -91,15 +86,10 @@ static void free_tx_struct(struct sdio_tx *t)
 
 static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
 {
-	struct sdio_rx *r = NULL;
-
-	r = kmalloc(sizeof(*r), GFP_ATOMIC);
-	if (!r)
-		return NULL;
-
-	memset(r, 0, sizeof(*r));
+	struct sdio_rx *r = kzalloc(sizeof(*r), GFP_ATOMIC);
 
-	r->rx_cxt = rx;
+	if (r)
+		r->rx_cxt = rx;
 
 	return r;
 }
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 6d306f7..0c9e895 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -73,27 +73,23 @@ static void hexdump(char *title, u8 *data, int len)
 
 static struct usb_tx *alloc_tx_struct(struct tx_cxt *tx)
 {
-	struct usb_tx *t = NULL;
+	struct usb_tx *t = kzalloc(sizeof(*t), GFP_ATOMIC);
 
-	t = kzalloc(sizeof(*t), GFP_ATOMIC);
-	if (t == NULL)
-		goto out;
+	if (!t)
+		return NULL;
 
 	t->urb = usb_alloc_urb(0, GFP_ATOMIC);
 	t->buf = kmalloc(TX_BUF_SIZE, GFP_ATOMIC);
-	if (t->urb == NULL || t->buf == NULL)
-		goto out;
-
-	t->tx_cxt = tx;
-
-	return t;
-out:
-	if (t) {
+	if (!t->urb || !t->buf) {
 		usb_free_urb(t->urb);
 		kfree(t->buf);
 		kfree(t);
+		return NULL;
 	}
-	return NULL;
+
+	t->tx_cxt = tx;
+
+	return t;
 }
 
 static void free_tx_struct(struct usb_tx *t)
@@ -107,28 +103,22 @@ static void free_tx_struct(struct usb_tx *t)
 
 static struct usb_rx *alloc_rx_struct(struct rx_cxt *rx)
 {
-	struct usb_rx *r = NULL;
+	struct usb_rx *r = kzalloc(sizeof(*r), GFP_ATOMIC);
 
-	r = kmalloc(sizeof(*r), GFP_ATOMIC);
-	if (r == NULL)
-		goto out;
-
-	memset(r, 0, sizeof(*r));
+	if (!r)
+		return NULL;
 
 	r->urb = usb_alloc_urb(0, GFP_ATOMIC);
 	r->buf = kmalloc(RX_BUF_SIZE, GFP_ATOMIC);
-	if (r->urb == NULL || r->buf == NULL)
-		goto out;
-
-	r->rx_cxt = rx;
-	return r;
-out:
-	if (r) {
+	if (!r->urb || !r->buf) {
 		usb_free_urb(r->urb);
 		kfree(r->buf);
 		kfree(r);
+		return NULL;
 	}
-	return NULL;
+
+	r->rx_cxt = rx;
+	return r;
 }
 
 static void free_rx_struct(struct usb_rx *r)
-- 
1.7.7.3

