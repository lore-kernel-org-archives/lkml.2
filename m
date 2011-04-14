Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1DNJ4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:56:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab1DNJ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dT5A9+AXRMx5Ao/n31gN/z24gNq1ZLeQ2l0Yh28yioAzniKMFnvreqJPfOvkagRbPo
         kzCdncSn84V2fv8Mj/dA==
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: storage_common: use kstrto*() [bug fix]
Date: Thu, 14 Apr 2011 11:55:43 +0200
Message-Id: <6ae9c2910c59d7b8ce92e5293a3097e39485ac16.1302774745.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110414021635.GA13169@suse.de>
References: <20110414021635.GA13169@suse.de>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes an embarrassing bug in the "storage_common:
use kstrto*()" patch which caused fsg_store_ro() to return
zero instead of the length of the consumed buffer.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/storage_common.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

On Thu, 14 Apr 2011 04:16:35 +0200, Greg KH <gregkh@suse.de> wrote:
> Ugh, I applied the first one already :(

Yes, I hoped you could quickly replace the patch without anyone
noticing.

> Care to send a follow-on patch that fixes this properly?

Natuarry.

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 109635a..1fa4f70 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -708,7 +708,7 @@ static ssize_t fsg_show_file(struct device *dev, struct device_attribute *attr,
 static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	ssize_t		rc = count;
+	ssize_t		rc;
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
 	unsigned	ro;
@@ -729,6 +729,7 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 		curlun->ro = ro;
 		curlun->initially_ro = ro;
 		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
+		rc = count;
 	}
 	up_read(filesem);
 	return rc;
-- 
1.7.3.1

