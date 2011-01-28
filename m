Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1A1MxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:53:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46493 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1A1MxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JtoNDKe9QjOUoY1lGwi3xhl0H90PbpFjnEjgK0Jjg+a8XywIneNtGx6eBiriFhxk8d
         kmPMhDvNh90tlyLzwxOKT4weLCnlL/g2xiBjMb2yooj1ZOqr7v/UCkrh+ugIlVC7nc8w
         PIChrLd9cmYFIH7Iu2mgSE6wWj7BWCeWr/0G8=
From: Alexander Strakh <cromlehg@gmail.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alexander Strakh <cromlehg@gmail.com>,
        Alexander Strakh <strakh@ispras.ru>
Subject: [PATCH 1/1] drivers: rtc: Add module_put on error path in rtc_proc_open
Date: Fri, 28 Jan 2011 16:10:55 +0300
Message-Id: <1296220255-29069-1-git-send-email-strakh@ispras.ru>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Strakh <cromlehg@gmail.com>

In file drivers/rtc/rtc-proc.c in linux-2.6.37:
	
The seq_open function can return -ENOMEM.

 86        if (!try_module_get(THIS_MODULE))
 87                return -ENODEV;
 88
 89        return single_open(file, rtc_proc_show, rtc);

In this case before exiting (line 89) from rtc_proc_open 
the module_put(THIS_MODULE) must be called. 

Found by Linux Device Drivers Verification Project

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
---
 drivers/rtc/rtc-proc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index c086fc3..242bbf8 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -81,12 +81,16 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 
 static int rtc_proc_open(struct inode *inode, struct file *file)
 {
+	int ret;
 	struct rtc_device *rtc = PDE(inode)->data;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	return single_open(file, rtc_proc_show, rtc);
+	ret = single_open(file, rtc_proc_show, rtc);
+	if (ret)
+		module_put(THIS_MODULE);
+	return ret;
 }
 
 static int rtc_proc_release(struct inode *inode, struct file *file)
-- 
1.7.1

