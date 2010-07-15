Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0GOJBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:01:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48634 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab0GOJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oLJKO71u4maeGG6hEJ/WcwAht5QftiL4LCGP4XU2ROKmwUUhMVLs06jL7faFLwAB+x
         AKrtjR3eZW5RR+v98H4L/GtKcuEqDTGbm2fAjsALj0SkLcNeJIupYTNas6zc49nWbsNt
         0VrePRjOQ3E7g5t0tYWGKqAJAe+gVGVtYYiFg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCHv3 1/2] usb: gadget: storage: strict coversion of 'ro' parameter
Date: Thu, 15 Jul 2010 12:07:20 +0300
Message-Id: <1279184841-15097-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <op.vft7mxqm7p4s8u@pikus>
References: <op.vft7mxqm7p4s8u@pikus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring a strict way to get the 'ro' parameter from the user.
The idea was discussed in LKML [1].

[1] http://lkml.org/lkml/2010/7/13/143

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/storage_common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 04c462f..7123929 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -723,9 +723,9 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	ssize_t		rc = count;
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
-	int		i;
+	unsigned long	ro;
 
-	if (sscanf(buf, "%d", &i) != 1)
+	if (strict_strtoul(buf, 2, &ro))
 		return -EINVAL;
 
 	/* Allow the write-enable status to change only while the backing file
@@ -735,8 +735,8 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 		LDBG(curlun, "read-only status change prevented\n");
 		rc = -EBUSY;
 	} else {
-		curlun->ro = !!i;
-		curlun->initially_ro = !!i;
+		curlun->ro = ro;
+		curlun->initially_ro = ro;
 		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
 	}
 	up_read(filesem);
-- 
1.6.3.3

