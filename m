Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0KIPIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:08:47 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43008 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439Ab0KIPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:08:43 -0500
X-Greylist: delayed 1070 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 10:08:43 EST
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH] regulator: enable supply regulator only when use count is zero
Date: Tue, 9 Nov 2010 15:50:26 +0100
Message-ID: <1289314226-986-1-git-send-email-bengt.g.jonsson@stericsson.com>
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

Change-Id: Ic322801119fefaabc1ed4fef248e463e67fb1857
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/core.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..cd1f5a8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1268,13 +1268,15 @@ static int _regulator_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
 
-	/* do we need to enable the supply regulator first */
-	if (rdev->supply) {
-		ret = _regulator_enable(rdev->supply);
-		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s: %d\n",
-			       __func__, rdev_get_name(rdev), ret);
-			return ret;
+	if (rdev->use_count == 0) {
+		/* do we need to enable the supply regulator first */
+		if (rdev->supply) {
+			ret = _regulator_enable(rdev->supply);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to enable %s: %d\n",
+				       __func__, rdev_get_name(rdev), ret);
+				return ret;
+			}
 		}
 	}
 
-- 
1.7.2.2

