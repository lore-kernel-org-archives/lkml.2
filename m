Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0LERwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:52:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab0LERwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MiVWZijU0zaXSLHWs9wn1rKHzgFYrq75iZWsyhiKJi/HW/Nh/oRWd2mIuQoqmBwEs/
         QtBtLpPeuAW7UfmpqJ5pOX7/OcAyZaBWIWlgp4ONNa9QgcPYb2j2ixGO7l28TdmY8n++
         v45xYKauTtc/upatFhlDpo3q427XOa7RmYRYI=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 41/45] kstrtox: convert drivers/usb/
Date: Sun,  5 Dec 2010 19:49:38 +0200
Message-Id: <1291571382-2719-41-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/usb/gadget/storage_common.c |    7 ++++---
 drivers/usb/host/ehci-dbg.c         |    6 +++---
 drivers/usb/serial/iuu_phoenix.c    |   27 ++++++++++-----------------
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 3b513ba..b7c7df9 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -716,8 +716,9 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
 	unsigned long	ro;
 
-	if (strict_strtoul(buf, 2, &ro))
-		return -EINVAL;
+	rc = kstrtoul(buf, 2, &ro);
+	if (rc < 0)
+		return rc;
 
 	/*
 	 * Allow the write-enable status to change only while the
@@ -743,7 +744,7 @@ static ssize_t fsg_store_nofua(struct device *dev,
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 	unsigned long	nofua;
 
-	if (strict_strtoul(buf, 2, &nofua))
+	if (kstrtoul(buf, 2, &nofua))
 		return -EINVAL;
 
 	/* Sync data when switching from async mode to sync */
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 6e25996..34e263b 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -1000,7 +1000,7 @@ static ssize_t debug_lpm_write(struct file *file, const char __user *user_buf,
 		buf[len - 1] = '\0';
 
 	if (strncmp(buf, "enable", 5) == 0) {
-		if (strict_strtoul(buf + 7, 10, &port))
+		if (kstrtoul(buf + 7, 10, &port))
 			return -EINVAL;
 		params = ehci_readl(ehci, &ehci->caps->hcs_params);
 		if (port > HCS_N_PORTS(params)) {
@@ -1018,7 +1018,7 @@ static ssize_t debug_lpm_write(struct file *file, const char __user *user_buf,
 		printk(KERN_INFO "force enable LPM for port %lu\n", port);
 	} else if (strncmp(buf, "hird=", 5) == 0) {
 		unsigned long hird;
-		if (strict_strtoul(buf + 5, 16, &hird))
+		if (kstrtoul(buf + 5, 16, &hird))
 			return -EINVAL;
 		printk(KERN_INFO "setting hird %s %lu\n", buf + 6, hird);
 		temp = ehci_readl(ehci, &ehci->regs->command);
@@ -1026,7 +1026,7 @@ static ssize_t debug_lpm_write(struct file *file, const char __user *user_buf,
 		temp |= hird << 24;
 		ehci_writel(ehci, temp, &ehci->regs->command);
 	} else if (strncmp(buf, "disable", 7) == 0) {
-		if (strict_strtoul(buf + 8, 10, &port))
+		if (kstrtoul(buf + 8, 10, &port))
 			return -EINVAL;
 		params = ehci_readl(ehci, &ehci->caps->hcs_params);
 		if (port > HCS_N_PORTS(params)) {
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 12ed594..0d23f3d 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -1227,23 +1227,16 @@ static ssize_t store_vcc_mode(struct device *dev,
 {
 	struct usb_serial_port *port = to_usb_serial_port(dev);
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned long v;
-
-	if (strict_strtoul(buf, 10, &v)) {
-		dev_err(dev, "%s - vcc_mode: %s is not a unsigned long\n",
-				__func__, buf);
-		goto fail_store_vcc_mode;
-	}
-
-	dbg("%s: setting vcc_mode = %ld", __func__, v);
-
-	if ((v != 3) && (v != 5)) {
-		dev_err(dev, "%s - vcc_mode %ld is invalid\n", __func__, v);
-	} else {
-		iuu_vcc_set(port, v);
-		priv->vcc = v;
-	}
-fail_store_vcc_mode:
+	int v;
+	int rv;
+
+	rv = kstrtoint(buf, 10, &v);
+	if (rv < 0)
+		return rv;
+	if (v != 3 && v != 5)
+		return -EINVAL;
+	iuu_vcc_set(port, v);
+	priv->vcc = v;
 	return count;
 }
 
-- 
1.7.2.2

