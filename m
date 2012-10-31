Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab2J3SQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:16:11 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59055 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934048Ab2J3SMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:44 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH] pwm: export of_pwm_request
Date: Wed, 31 Oct 2012 17:57:10 +0200
Message-Id: <1351699030-4401-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to hide of_pwm_request, it's useful to other in-kernel users.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/pwm/core.c  | 6 +++++-
 include/linux/pwm.h | 7 +++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index f5acdaa..f8c7e6b 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -457,7 +457,7 @@ static struct pwm_chip *of_node_to_pwmchip(struct device_node *np)
  * becomes mandatory for devices that look up the PWM device via the con_id
  * parameter.
  */
-static struct pwm_device *of_pwm_request(struct device_node *np,
+struct pwm_device *of_pwm_request(struct device_node *np,
 					 const char *con_id)
 {
 	struct pwm_device *pwm = NULL;
@@ -466,6 +466,9 @@ static struct pwm_device *of_pwm_request(struct device_node *np,
 	int index = 0;
 	int err;
 
+	if (!np)
+		return ERR_PTR(-ENODEV);
+
 	if (con_id) {
 		index = of_property_match_string(np, "pwm-names", con_id);
 		if (index < 0)
@@ -516,6 +519,7 @@ put:
 
 	return pwm;
 }
+EXPORT_SYMBOL(of_pwm_request);
 
 /**
  * pwm_add_table() - register PWM device consumers
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 112b314..fafbb1c 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -171,6 +171,7 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 					 unsigned int index,
 					 const char *label);
 
+struct pwm_device *of_pwm_request(struct device_node *np, const char *consumer);
 struct pwm_device *pwm_get(struct device *dev, const char *consumer);
 void pwm_put(struct pwm_device *pwm);
 
@@ -204,6 +205,12 @@ static inline struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct pwm_device *of_pwm_request(struct device_node *np,
+					 const char *consumer)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct pwm_device *pwm_get(struct device *dev,
 					 const char *consumer)
 {
-- 
1.7.12

