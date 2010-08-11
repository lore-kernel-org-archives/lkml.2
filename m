Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0HKIBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:01:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0HKIBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TyycXmFApIuUyVvJqJnjoZG7ik8yV2lZ7JHI72isv33t1J1U/8XexKNuW6JtKSCIgh
         kLAhlI49GhceokhPgryR3xlQ8FqsgeOXF33sDKWj6r1ZsMQsEJbQVmOvbIqAVBmbo1ip
         lKTNsVWIbJQUTIajMimNe0HdKmyksIWz+co8c=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Matthias Brugger <mensch0815@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: adis16255: fix sysfs leak
Date: Wed, 11 Aug 2010 12:00:48 +0400
Message-Id: <1281513650-5346-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original code does not call sysfs_remove_group() on error. This can lead
to NULL dereference.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/adis16255/adis16255.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/adis16255/adis16255.c b/drivers/staging/adis16255/adis16255.c
index c3e6a4d..8d4d7cb 100644
--- a/drivers/staging/adis16255/adis16255.c
+++ b/drivers/staging/adis16255/adis16255.c
@@ -406,12 +406,14 @@ static int __devinit spi_adis16255_probe(struct spi_device *spi)
 
 	status = spi_adis16255_bringup(spiadis);
 	if (status != 0)
-		goto irq_err;
+		goto sysfs_err;
 
 	dev_info(&spi->dev, "spi_adis16255 driver added!\n");
 
 	return status;
 
+sysfs_err:
+	sysfs_remove_group(&spiadis->spi->dev.kobj, &adis16255_attr_group);
 irq_err:
 	free_irq(spiadis->irq, spiadis);
 gpio_err:
-- 
1.7.0.4

