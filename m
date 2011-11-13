Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1KMBah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 20:30:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54323 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1KMBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 20:30:36 -0500
Message-ID: <4EBF1DD1.8090600@solonet.org.ua>
Date: Sun, 13 Nov 2011 03:30:57 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to wrong
 GPIO line exporting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Kuzmenko <linux@solonet.org.ua>

Fix bug in gpio-sysfs interface (export of busy GPIO line leads to export of different GPIO line).

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
---

Patch is against 3.0.9
When trying to export GPIO line 37(40) which is already exported/requested by kernel code we got GPIO line 3(4) exported.
Looks like this is done because `export_store` function doesn't return the number of processed bytes and gets a part of previous buffer again.
This fix works for me (Samsung s3c2440).

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..ccec497 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -633,7 +633,7 @@ static ssize_t export_store(struct class *class,
 done:
 	if (status)
 		pr_debug("%s: status %d\n", __func__, status);
-	return status ? : len;
+	return len;
 }
 
 static ssize_t unexport_store(struct class *class,
