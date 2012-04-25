Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2DYXDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:03:40 -0400
Received: from mail.pxnet.com ([89.1.7.7]:40599 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab2DYXDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:03:32 -0400
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20120425-patch-gigaset-08.tilman@imap.cc>
In-Reply-To: <20120425-patch-gigaset-00.tilman@imap.cc>
References: <20120425-patch-gigaset-00.tilman@imap.cc>
Subject: [PATCH 8/8] isdn/capi: elliminate capincci_find() in non-middleware case
Date: Thu, 26 Apr 2012 01:02:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If Kernel CAPI is compiled without CONFIG_ISDN_CAPI_MIDDLEWARE,
the structure retrieved via capincci_find() is never actually
used, so don't compile that function in that case.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/capi/capi.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 9ee3991..38c4bd8 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -336,11 +336,6 @@ static inline void
 capincci_alloc_minor(struct capidev *cdev, struct capincci *np) { }
 static inline void capincci_free_minor(struct capincci *np) { }
 
-static inline unsigned int capincci_minor_opencount(struct capincci *np)
-{
-	return 0;
-}
-
 #endif /* !CONFIG_ISDN_CAPI_MIDDLEWARE */
 
 static struct capincci *capincci_alloc(struct capidev *cdev, u32 ncci)
@@ -372,6 +367,7 @@ static void capincci_free(struct capidev *cdev, u32 ncci)
 		}
 }
 
+#ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 static struct capincci *capincci_find(struct capidev *cdev, u32 ncci)
 {
 	struct capincci *np;
@@ -382,7 +378,6 @@ static struct capincci *capincci_find(struct capidev *cdev, u32 ncci)
 	return NULL;
 }
 
-#ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 /* -------- handle data queue --------------------------------------- */
 
 static struct sk_buff *
@@ -578,8 +573,8 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 	struct tty_struct *tty;
 	struct capiminor *mp;
 	u16 datahandle;
-#endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 	struct capincci *np;
+#endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 
 	mutex_lock(&cdev->lock);
 
@@ -597,6 +592,12 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 		goto unlock_out;
 	}
 
+#ifndef CONFIG_ISDN_CAPI_MIDDLEWARE
+	skb_queue_tail(&cdev->recvqueue, skb);
+	wake_up_interruptible(&cdev->recvwait);
+
+#else /* CONFIG_ISDN_CAPI_MIDDLEWARE */
+
 	np = capincci_find(cdev, CAPIMSG_CONTROL(skb->data));
 	if (!np) {
 		printk(KERN_ERR "BUG: capi_signal: ncci not found\n");
@@ -605,12 +606,6 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 		goto unlock_out;
 	}
 
-#ifndef CONFIG_ISDN_CAPI_MIDDLEWARE
-	skb_queue_tail(&cdev->recvqueue, skb);
-	wake_up_interruptible(&cdev->recvwait);
-
-#else /* CONFIG_ISDN_CAPI_MIDDLEWARE */
-
 	mp = np->minorp;
 	if (!mp) {
 		skb_queue_tail(&cdev->recvqueue, skb);
@@ -893,6 +888,11 @@ register_out:
 			return -EFAULT;
 		return 0;
 
+#ifndef CONFIG_ISDN_CAPI_MIDDLEWARE
+	case CAPI_NCCI_OPENCOUNT:
+		return 0;
+
+#else /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 	case CAPI_NCCI_OPENCOUNT: {
 		struct capincci *nccip;
 		unsigned ncci;
@@ -909,7 +909,6 @@ register_out:
 		return count;
 	}
 
-#ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 	case CAPI_NCCI_GETUNIT: {
 		struct capincci *nccip;
 		struct capiminor *mp;
-- 
1.7.3.4

