Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0KSSls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:41:48 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32907 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab0KSSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=bsvHpM5lifjt2Hv0DL1mMoYqFLBtDNh1qJGlY/dTPcRCrsDdrZfuR4ymRtY2Irwp56
         yw3X3WMqMJKoss/Cky0n5bmPtexaSSHo2JLJOcbV9Tfs+Vqb7DqAEYktXkyXtVj8JPkV
         wFUqdLknm40p8eOnx2M+Oku58V5hPzktweRXM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: base: core: do not put noninitialized devices
Date: Fri, 19 Nov 2010 21:41:40 +0300
Message-Id: <1290192100-11451-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kobject_set_name_vargs() fails then put_device() frees
device with zero kobj->state_initialized.  This leads to WARN().
Divide device_register() call to device_initialize() call before
kobject_set_name_vargs() and device_add() call after it.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/base/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 46ff6c2..833ccf3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1424,11 +1424,12 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
 	dev->release = device_create_release;
 	dev_set_drvdata(dev, drvdata);
 
+	device_initialize(dev);
 	retval = kobject_set_name_vargs(&dev->kobj, fmt, args);
 	if (retval)
 		goto error;
 
-	retval = device_register(dev);
+	retval = device_add(dev);
 	if (retval)
 		goto error;
 
-- 
1.7.0.4

