Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0KJKHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:07:40 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56710 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab0KJKHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:07:37 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH] regulator: enable supply regulator only when use count is zero
Date: Wed, 10 Nov 2010 11:06:22 +0100
Message-ID: <1289383582-10183-1-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply regulators are disabled only when the last
reference count is removed on the child regulator
(the use count goes from 1 to 0). This patch changes
the behaviour of enable so the supply regulator is
enabled only when the use count of the child
regulator goes from 0 to 1.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/core.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 27d062e..c577c6d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1267,15 +1267,17 @@ static int _regulator_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
 
-	/* do we need to enable the supply regulator first */
-	if (rdev->supply) {
-		mutex_lock(&rdev->supply->mutex);
-		ret = _regulator_enable(rdev->supply);
-		mutex_unlock(&rdev->supply->mutex);
-		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s: %d\n",
-			       __func__, rdev_get_name(rdev), ret);
-			return ret;
+	if (rdev->use_count == 0) {
+		/* do we need to enable the supply regulator first */
+		if (rdev->supply) {
+			mutex_lock(&rdev->supply->mutex);
+			ret = _regulator_enable(rdev->supply);
+			mutex_unlock(&rdev->supply->mutex);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to enable %s: %d\n",
+				       __func__, rdev_get_name(rdev), ret);
+				return ret;
+			}
 		}
 	}
 
-- 
1.7.2.2

