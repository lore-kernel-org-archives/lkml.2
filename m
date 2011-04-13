Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab1DMWhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:37:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab1DMWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=JJw+xxJUu4RNG4EpyzNXtG+n/7w01hdMnkg/KwsAyhWXloMdx+fV/lGkTYTGrSoTRM
         wBbQBvBUYl6oII13mHfQ==
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: storage_common: use kstrto*()
Date: Thu, 14 Apr 2011 00:37:00 +0200
Message-Id: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit replaces the usage of strict_strtoul() (which
became deprecated after commit 33ee3b2e) with kstrtouint().

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/storage_common.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

Feel free to ignore the patch.

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index b015561..109635a 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -711,10 +711,11 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	ssize_t		rc = count;
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
-	unsigned long	ro;
+	unsigned	ro;
 
-	if (strict_strtoul(buf, 2, &ro))
-		return -EINVAL;
+	rc = kstrtouint(buf, 2, &ro);
+	if (rc)
+		return rc;
 
 	/*
 	 * Allow the write-enable status to change only while the
@@ -738,10 +739,12 @@ static ssize_t fsg_store_nofua(struct device *dev,
 			       const char *buf, size_t count)
 {
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-	unsigned long	nofua;
+	unsigned	nofua;
+	int		ret;
 
-	if (strict_strtoul(buf, 2, &nofua))
-		return -EINVAL;
+	ret = kstrtouint(buf, 2, &nofua);
+	if (ret)
+		return ret;
 
 	/* Sync data when switching from async mode to sync */
 	if (!nofua && curlun->nofua)
-- 
1.7.3.1

