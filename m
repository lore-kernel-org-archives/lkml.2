Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab2GDFMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:12:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2GDFMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:12:30 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/25] leds: convert PCA955x LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:06 +0800
Message-Id: <1341378617-10386-15-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Nate Case <ncase@xes-inc.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-pca955x.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 5f462db..aef3cf0 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -293,15 +293,14 @@ static int __devinit pca955x_probe(struct i2c_client *client,
 		}
 	}
 
-	pca955x = kzalloc(sizeof(*pca955x), GFP_KERNEL);
+	pca955x = devm_kzalloc(&client->dev, sizeof(*pca955x), GFP_KERNEL);
 	if (!pca955x)
 		return -ENOMEM;
 
-	pca955x->leds = kzalloc(sizeof(*pca955x_led) * chip->bits, GFP_KERNEL);
-	if (!pca955x->leds) {
-		err = -ENOMEM;
-		goto exit_nomem;
-	}
+	pca955x->leds = devm_kzalloc(&client->dev,
+			sizeof(*pca955x_led) * chip->bits, GFP_KERNEL);
+	if (!pca955x->leds)
+		return -ENOMEM;
 
 	i2c_set_clientdata(client, pca955x);
 
@@ -361,10 +360,6 @@ exit:
 		cancel_work_sync(&pca955x->leds[i].work);
 	}
 
-	kfree(pca955x->leds);
-exit_nomem:
-	kfree(pca955x);
-
 	return err;
 }
 
@@ -378,9 +373,6 @@ static int __devexit pca955x_remove(struct i2c_client *client)
 		cancel_work_sync(&pca955x->leds[i].work);
 	}
 
-	kfree(pca955x->leds);
-	kfree(pca955x);
-
 	return 0;
 }
 
-- 
1.7.10.4

