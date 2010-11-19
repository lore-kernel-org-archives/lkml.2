Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0KSSmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:42:23 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32907 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0KSSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=caGU/um728v1Ocm8KF3UWzQIjDuP4zlMnsqJXZ+7wKGdl1XvSGddI/G5wOjeOCVgfq
         fO7OovJocOpyWS+LnJk8K6vhqnbgxWqPzAWiP5xYd6f+ZpnC8Hv3T5u9bYKSc+WdmMoi
         zfWB1tvwvZ36mYNRs39bkPBI1cl8R5272+keM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] power: power_supply_core: fix use after free and memory leak
Date: Fri, 19 Nov 2010 21:41:58 +0300
Message-Id: <1290192119-11704-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_unregister() might free its argument.  This leads to freed
memory use in kfree().  Also use put_device() instead of kfree()
as dev may be already used in another layer after call to device_add().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/power/power_supply_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 91606bb..f06bad0 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -190,10 +190,10 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	goto success;
 
 create_triggers_failed:
-	device_unregister(psy->dev);
+	device_del(dev);
 kobject_set_name_failed:
 device_add_failed:
-	kfree(dev);
+	put_device(dev);
 success:
 	return rc;
 }
-- 
1.7.0.4

