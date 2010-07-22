Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0GVIvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:51:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46621 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0GVIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=u9Qem/V/js/mKZ2b/eGTL/lwA8Uh5q8pOHO6JiIkmh6PgmV4aA5fzo3MPAJVLYsKgP
         ZJQKnxZrgnAzQACj7NMYGeNMU6nxp+VfiAMyF6kFJM+B7n1PGJghJoUJHUgmwIpbB+W9
         Tn/aqYXC1jB0Q2CG9OjYoO01M83vVD++Ht304=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCHv4 1/2] usb: gadget: storage: strict coversion of 'ro' parameter
Date: Thu, 22 Jul 2010 11:58:47 +0300
Message-Id: <1279789128-11399-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100721191711.GA28893@kroah.com>
References: <20100721191711.GA28893@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring a strict way to get the 'ro' parameter from the user.

The patch followed by this one adds another boolean parameter. To be consistent
Michał Nazarewicz proposed to use simple_strtol() in both cases (correspondend
discussion in LKML [1]). Due to simple_strtol() doesn't return error in a good
way and we have a boolean parameter the strict_strtoul() is used.

[1] http://lkml.org/lkml/2010/7/14/169

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

