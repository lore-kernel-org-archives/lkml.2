Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1A3JqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 04:46:09 -0500
Received: from grimli.r00tworld.net ([83.169.44.195]:36990 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1A3JqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 04:46:08 -0500
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jan 2011 04:46:07 EST
From: Mathias Krause <minipli@googlemail.com>
To: linux-mtd@lists.infradead.org
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] mtd: fix memory leak
Date: Sun, 30 Jan 2011 10:31:48 +0100
Message-Id: <1296379908-10150-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4f678a58 missed two cases where the memory allocated for name
would be leaked. This commit frees the memory when register_device()
fails and on unregister_devices().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 drivers/mtd/devices/phram.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 5239328..8d28fa0 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -117,6 +117,7 @@ static void unregister_devices(void)
 	list_for_each_entry_safe(this, safe, &phram_list, list) {
 		del_mtd_device(&this->mtd);
 		iounmap(this->mtd.priv);
+		kfree(this->mtd.name);
 		kfree(this);
 	}
 }
@@ -275,6 +276,8 @@ static int phram_setup(const char *val, struct kernel_param *kp)
 	ret = register_device(name, start, len);
 	if (!ret)
 		pr_info("%s device: %#x at %#x\n", name, len, start);
+	else
+		kfree(name);
 
 	return ret;
 }
-- 
1.5.6.5

