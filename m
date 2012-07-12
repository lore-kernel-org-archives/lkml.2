Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2GLGEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:04:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49792 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab2GLGEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:04:00 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-96-4ffe68b9089b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] charger-manager: Set current limit of regulator for over
 current protection
Date: Thu, 12 Jul 2012 15:03:29 +0900
Message-id: <1342073009-9459-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd2dGf/8DbrXKlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MUxv+Mhbc5a84e3oRewNjE28XIyeHhICJxJn+aywQtpjEhXvr
	2boYuTiEBKYzSixbdpAZwlnKJHHvwgtWkCo2AS2J/S9usIHYIgJyEq/X/mUCKWIWOMUo8eji
	CWaQhLBAksSCU3OBijg4WARUJfqupYOEeQVcJOZ3TmSC2KYg0brsEPsERu4FjAyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYJ9+Ex6B+OqBotDjAIcjEo8vBci//kLsSaWFVfmHmKU4GBW
	EuF1BAnxpiRWVqUW5ccXleakFh9ilOZgURLnNfH+6i8kkJ5YkpqdmlqQWgSTZeLglGpgzCmx
	XLV4Z9JlPuaKLTWlN/VzhbwkvvldfBec17i/MvJL4f+vIS+Xl/Y8mvY0xNbuQUvpy/9+h60W
	RiwLfTzxnNqZZsl6XkmHpHipF5q7RJ9d/738asWP1lQGpucqTh+Tw5a8spfO1Lq6yi1txx0L
	kaCzPWv1T2wXmXd2wjovre4V13b+mZScr8RSnJFoqMVcVJwIAD2d/1ndAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support the protection of host device from over current.
The Charger-manager set proper current limit of charger(regulator) for
charging according to type of charger cable when external connector
is attached.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c       |   15 +++++++++++++++
 include/linux/power/charger-manager.h |    8 ++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index af03f23..4f1de56 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1001,6 +1001,21 @@ static void charger_extcon_work(struct work_struct *work)
 {
 	struct charger_cable *cable =
 			container_of(work, struct charger_cable, wq);
+	int ret;
+
+	if (cable->attached && cable->min_uA != 0 && cable->max_uA != 0) {
+		ret = regulator_set_current_limit(cable->charger->consumer,
+					cable->min_uA, cable->max_uA);
+		if (ret < 0) {
+			pr_err("Cannot set current limit of %s (%s)\n",
+				cable->charger->regulator_name, cable->name);
+			return;
+		}
+
+		pr_info("Set current limit of %s : %duA ~ %duA\n",
+					cable->charger->regulator_name,
+					cable->min_uA, cable->max_uA);
+	}
 
 	try_charger_enable(cable->cm, cable->attached);
 }
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 6cb9fbc..cd22029 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -94,6 +94,14 @@ struct charger_cable {
 	bool attached;
 
 	struct charger_regulator *charger;
+
+	/*
+	 * Set min/max current of regulator to protect over-current issue
+	 * according to a kind of charger cable when cable is attached.
+	 */
+	int min_uA;
+	int max_uA;
+
 	struct charger_manager *cm;
 };
 
-- 
1.7.0.4

