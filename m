Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1A2Jd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 04:33:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56892 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1A2Jdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 04:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=p+sLTvTWS3BXUpvmOWUhtpteeSocKv3eSLxlu9eHNb5L5IuU6RdFsLWKt/nPRmjZ1c
         y/FW8+/0uzal8ZiKszjSCexAj8Z2ZSGT/9zhNextC+H5pxeUBMpQewtk5OuNbfRGGfqH
         9np+latOmbfvaZ3xV5reRj2jc2ngIOCf40TME=
Subject: [PATCH 1/2] video: hpfb: use resource_size()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Phil Blundell <philb@gnu.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Jan 2011 17:33:48 +0800
Message-ID: <1296293628.13797.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size calculation is done incorrectly here because it should include
both the start and end (end - start + 1).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/hpfb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/hpfb.c b/drivers/video/hpfb.c
index c8e280f..ebf8495 100644
--- a/drivers/video/hpfb.c
+++ b/drivers/video/hpfb.c
@@ -321,11 +321,11 @@ static int __devinit hpfb_dio_probe(struct dio_dev * d, const struct dio_device_
 	unsigned long paddr, vaddr;
 
 	paddr = d->resource.start;
-	if (!request_mem_region(d->resource.start, d->resource.end - d->resource.start, d->name))
+	if (!request_mem_region(d->resource.start, resource_size(&d->resource), d->name))
                 return -EBUSY;
 
 	if (d->scode >= DIOII_SCBASE) {
-		vaddr = (unsigned long)ioremap(paddr, d->resource.end - d->resource.start);
+		vaddr = (unsigned long)ioremap(paddr, resource_size(&d->resource));
 	} else {
 		vaddr = paddr + DIO_VIRADDRBASE;
 	}
@@ -344,7 +344,7 @@ static void __devexit hpfb_remove_one(struct dio_dev *d)
 	unregister_framebuffer(&fb_info);
 	if (d->scode >= DIOII_SCBASE)
 		iounmap((void *)fb_regs);
-        release_mem_region(d->resource.start, d->resource.end - d->resource.start);
+	release_mem_region(d->resource.start, resource_size(&d->resource));
 }
 
 static struct dio_device_id hpfb_dio_tbl[] = {
-- 
1.7.0.4



