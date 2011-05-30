Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1E3Uq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:46:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49711 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1E3Uq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bOeU/s/2yXZprd6+iaMkWnDRTuin+5VmhB3PLmD/st2OlsjNKLvoLRRpH6bobWXEGf
         hRErRY6277hroQw4jM8g4xwSL/4qyiKJIlymleCrIl6CnmglVbbr1XdWNu0UR2gnZh3Q
         fgIeGuYSnQUismUOxaws0e2A9b3Hfe9SWPj6U=
From: Andre Bartke <andre.bartke@googlemail.com>
To: mchehab@redhat.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] staging: altera-stapl: Fix memory leak of altera_init()
Date: Mon, 30 May 2011 22:45:04 +0200
Message-Id: <1306788304-21794-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case kzalloc() fails the second or third time
we should free the previous allocated resources.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/staging/altera-stapl/altera.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/altera-stapl/altera.c b/drivers/staging/altera-stapl/altera.c
index 05aad35..56ba557 100644
--- a/drivers/staging/altera-stapl/altera.c
+++ b/drivers/staging/altera-stapl/altera.c
@@ -2435,11 +2435,16 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 	if (!key)
 		return -ENOMEM;
 	value = kzalloc(257 * sizeof(char), GFP_KERNEL);
-	if (!value)
+	if (!value) {
+		kfree(key);
 		return -ENOMEM;
+	}
 	astate = kzalloc(sizeof(struct altera_state), GFP_KERNEL);
-	if (!astate)
+	if (!astate) {
+		kfree(key);
+		kfree(value);
 		return -ENOMEM;
+	}
 
 	astate->config = config;
 	if (!astate->config->jtag_io) {
-- 
1.7.5.2

