Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab1EKQZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:25:22 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:55619 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1EKQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YuRtIIFNlGUsBherz4M319AWPvnbwkfBa+vZ8zaIGoniNhPj4c6/2eZDr2a1xtYHfy
         PE+pEV9IGPMJXlTaS0UGDuQN7kVuRo253ViV4c5HH1oTl+aJmslnjHlW8Dz1I4Ck7HS5
         HKke/K9dMt2HqQ7BaJ9Gxx9Q5CZPTlgyVSkEI=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 06/12] staging: usbip: stub_main.c: code cleanup
Date: Wed, 11 May 2011 01:54:18 -0700
Message-Id: <3a932c55376e57a96881a654a0f6c3e6837f400e.1305103212.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder functions; remove match_find() and replace with
get_busid_idx(); change other functions to use get_busid_idx(); and
code cleanup in the other functions.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
I apologize for this one. I realize that I should have split it into two with
the reorder being separate.

Also, it seems as if there is a synchronization problem carried over from the
original code in get_busid_priv(). An address into the busid_table is returned
and then the element is accessed and modified elsewhere. Right? Or am I missing
something.

 drivers/staging/usbip/stub_main.c |  191 +++++++++++++++++++------------------
 1 files changed, 96 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 5de33c2..d918c49 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -35,112 +35,121 @@ struct kmem_cache *stub_priv_cache;
 static struct bus_id_priv busid_table[MAX_BUSID];
 static spinlock_t busid_table_lock;
 
-int match_busid(const char *busid)
+static void init_busid_table(void)
 {
 	int i;
 
-	spin_lock(&busid_table_lock);
-	for (i = 0; i < MAX_BUSID; i++)
-		if (busid_table[i].name[0])
-			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
-				/* already registerd */
-				spin_unlock(&busid_table_lock);
-				return 0;
-			}
-	spin_unlock(&busid_table_lock);
+	for (i = 0; i < MAX_BUSID; i++) {
+		memset(busid_table[i].name, 0, BUSID_SIZE);
+		busid_table[i].status = STUB_BUSID_OTHER;
+		busid_table[i].interf_count = 0;
+		busid_table[i].sdev = NULL;
+		busid_table[i].shutdown_busid = 0;
+	}
 
-	return 1;
+	spin_lock_init(&busid_table_lock);
 }
 
-struct bus_id_priv *get_busid_priv(const char *busid)
+/*
+ * Find the index of the busid by name.
+ * Must be called with busid_table_lock held.
+ */
+static int get_busid_idx(const char *busid)
 {
 	int i;
+	int idx = -1;
 
-	spin_lock(&busid_table_lock);
 	for (i = 0; i < MAX_BUSID; i++)
 		if (busid_table[i].name[0])
 			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
-				/* already registerd */
-				spin_unlock(&busid_table_lock);
-				return &(busid_table[i]);
+				idx = i;
+				break;
 			}
-	spin_unlock(&busid_table_lock);
-
-	return NULL;
+	return idx;
 }
 
-static ssize_t show_match_busid(struct device_driver *drv, char *buf)
+struct bus_id_priv *get_busid_priv(const char *busid)
 {
-	int i;
-	char *out = buf;
+	int idx;
+	struct bus_id_priv *bid = NULL;
 
 	spin_lock(&busid_table_lock);
-	for (i = 0; i < MAX_BUSID; i++)
-		if (busid_table[i].name[0])
-			out += sprintf(out, "%s ", busid_table[i].name);
+	idx = get_busid_idx(busid);
+	if (idx >= 0)
+		bid = &(busid_table[idx]);
 	spin_unlock(&busid_table_lock);
 
-	out += sprintf(out, "\n");
-	return out - buf;
+	return bid;
 }
 
 static int add_match_busid(char *busid)
 {
 	int i;
-
-	if (!match_busid(busid))
-		return 0;
+	int ret = -1;
 
 	spin_lock(&busid_table_lock);
+	/* already registered? */
+	if (get_busid_idx(busid) >= 0) {
+		ret = 0;
+		goto out;
+	}
+
 	for (i = 0; i < MAX_BUSID; i++)
 		if (!busid_table[i].name[0]) {
 			strncpy(busid_table[i].name, busid, BUSID_SIZE);
 			if ((busid_table[i].status != STUB_BUSID_ALLOC) &&
 			    (busid_table[i].status != STUB_BUSID_REMOV))
 				busid_table[i].status = STUB_BUSID_ADDED;
-			spin_unlock(&busid_table_lock);
-			return 0;
+			ret = 0;
+			break;
 		}
+
+out:
 	spin_unlock(&busid_table_lock);
 
-	return -1;
+	return ret;
 }
 
 int del_match_busid(char *busid)
 {
-	int i;
+	int idx;
+	int ret = -1;
 
 	spin_lock(&busid_table_lock);
-	for (i = 0; i < MAX_BUSID; i++)
-		if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
-			/* found */
-			if (busid_table[i].status == STUB_BUSID_OTHER)
-				memset(busid_table[i].name, 0, BUSID_SIZE);
-			if ((busid_table[i].status != STUB_BUSID_OTHER) &&
-			    (busid_table[i].status != STUB_BUSID_ADDED)) {
-				busid_table[i].status = STUB_BUSID_REMOV;
-			}
-			spin_unlock(&busid_table_lock);
-			return 0;
-		}
+	idx = get_busid_idx(busid);
+	if (idx < 0)
+		goto out;
+
+	/* found */
+	ret = 0;
+
+	if (busid_table[idx].status == STUB_BUSID_OTHER)
+		memset(busid_table[idx].name, 0, BUSID_SIZE);
+
+	if ((busid_table[idx].status != STUB_BUSID_OTHER) &&
+	    (busid_table[idx].status != STUB_BUSID_ADDED))
+		busid_table[idx].status = STUB_BUSID_REMOV;
+
+out:
 	spin_unlock(&busid_table_lock);
 
-	return -1;
+	return ret;
 }
 
-static void init_busid_table(void)
+static ssize_t show_match_busid(struct device_driver *drv, char *buf)
 {
 	int i;
+	char *out = buf;
 
-	for (i = 0; i < MAX_BUSID; i++) {
-		memset(busid_table[i].name, 0, BUSID_SIZE);
-		busid_table[i].status = STUB_BUSID_OTHER;
-		busid_table[i].interf_count = 0;
-		busid_table[i].sdev = NULL;
-		busid_table[i].shutdown_busid = 0;
-	}
+	spin_lock(&busid_table_lock);
+	for (i = 0; i < MAX_BUSID; i++)
+		if (busid_table[i].name[0])
+			out += sprintf(out, "%s ", busid_table[i].name);
+	spin_unlock(&busid_table_lock);
 
-	spin_lock_init(&busid_table_lock);
+	out += sprintf(out, "\n");
+
+	return out - buf;
 }
 
 static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
@@ -162,23 +171,24 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 	strncpy(busid, buf + 4, BUSID_SIZE);
 
 	if (!strncmp(buf, "add ", 4)) {
-		if (add_match_busid(busid) < 0)
+		if (add_match_busid(busid) < 0) {
 			return -ENOMEM;
-		else {
+		} else {
 			pr_debug("add busid %s\n", busid);
 			return count;
 		}
 	} else if (!strncmp(buf, "del ", 4)) {
-		if (del_match_busid(busid) < 0)
+		if (del_match_busid(busid) < 0) {
 			return -ENODEV;
-		else {
+		} else {
 			pr_debug("del busid %s\n", busid);
 			return count;
 		}
-	} else
+	} else {
 		return -EINVAL;
+	}
 }
-static DRIVER_ATTR(match_busid, S_IRUSR|S_IWUSR, show_match_busid,
+static DRIVER_ATTR(match_busid, S_IRUSR | S_IWUSR, show_match_busid,
 		   store_match_busid);
 
 static struct stub_priv *stub_priv_pop_from_listhead(struct list_head *listhead)
@@ -201,84 +211,75 @@ static struct stub_priv *stub_priv_pop(struct stub_device *sdev)
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
 	priv = stub_priv_pop_from_listhead(&sdev->priv_init);
-	if (priv) {
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-		return priv;
-	}
+	if (priv)
+		goto done;
 
 	priv = stub_priv_pop_from_listhead(&sdev->priv_tx);
-	if (priv) {
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-		return priv;
-	}
+	if (priv)
+		goto done;
 
 	priv = stub_priv_pop_from_listhead(&sdev->priv_free);
-	if (priv) {
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-		return priv;
-	}
 
+done:
 	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-	return NULL;
+
+	return priv;
 }
 
 void stub_device_cleanup_urbs(struct stub_device *sdev)
 {
 	struct stub_priv *priv;
+	struct urb *urb;
 
 	pr_debug("free sdev %p\n", sdev);
 
 	while ((priv = stub_priv_pop(sdev))) {
-		struct urb *urb = priv->urb;
-
-		pr_debug("   free urb %p\n", urb);
+		urb = priv->urb;
+		pr_debug("free urb %p\n", urb);
 		usb_kill_urb(urb);
 
 		kmem_cache_free(stub_priv_cache, priv);
 
 		kfree(urb->transfer_buffer);
 		kfree(urb->setup_packet);
-
 		usb_free_urb(urb);
 	}
 }
 
 static int __init usb_stub_init(void)
 {
-	int ret;
+	int ret = 0;
 
 	stub_priv_cache = kmem_cache_create("stub_priv",
 					    sizeof(struct stub_priv), 0,
 					    SLAB_HWCACHE_ALIGN, NULL);
-
 	if (!stub_priv_cache) {
-		pr_err("create stub_priv_cache error\n");
+		pr_err("kmem_cache_create failed\n");
 		return -ENOMEM;
 	}
 
 	ret = usb_register(&stub_driver);
-	if (ret) {
+	if (ret < 0) {
 		pr_err("usb_register failed %d\n", ret);
-		goto error_usb_register;
+		goto err_usb_register;
 	}
 
-	pr_info(DRIVER_DESC " " USBIP_VERSION "\n");
-
-	init_busid_table();
-
 	ret = driver_create_file(&stub_driver.drvwrap.driver,
 				 &driver_attr_match_busid);
-
-	if (ret) {
-		pr_err("create driver sysfs\n");
-		goto error_create_file;
+	if (ret < 0) {
+		pr_err("driver_create_file failed\n");
+		goto err_create_file;
 	}
 
-	return ret;
-error_create_file:
+	init_busid_table();
+	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
+	goto out;
+
+err_create_file:
 	usb_deregister(&stub_driver);
-error_usb_register:
+err_usb_register:
 	kmem_cache_destroy(stub_priv_cache);
+out:
 	return ret;
 }
 
-- 
1.7.5.1

