Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1BHLHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:07:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46474 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1BHLHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:07:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OS1CQGShlM+jgrUV2lKDpA2sOPze8sND7OJvpudhlbxw/pOM58L3mTysJcNsZjglSB
         xcBbkCtVc/ChMfxcZlTBuJJirlB9OwWSFxOw2sJ2v+wA3KpvAUx0+Cn/Sdfrapl+aj9d
         pBP22DqQy+muF3w19JEhJBQE0xWWZ6zYbNgHc=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: dilinger@queued.net, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH RFC] staging: olpc_dcon: Remove _strtoul() function.
Date: Tue,  8 Feb 2011 12:06:00 +0100
Message-Id: <1297163160-23429-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

olpc_dcon driver use self invented _strtoul  function
which make similar check like strict_strtoul just extend
for space checking at last string place. Normally access
to sys file looks echo 1024 > /sys/... so space could be considered
as error character and we could simplify code using just strict_strtoul
function instead self invented.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   66 ++++++++++++++------------------
 1 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index b19cd34..df1f664 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -521,49 +521,35 @@ static ssize_t dcon_resumeline_show(struct device *dev,
 	return sprintf(buf, "%d\n", resumeline);
 }
 
-static int _strtoul(const char *buf, int len, unsigned int *val)
-{
-
-	char *endp;
-	unsigned int output = strict_strtoul(buf, &endp, 0);
-	int size = endp - buf;
-
-	if (*endp && isspace(*endp))
-		size++;
-
-	if (size != len)
-		return -EINVAL;
-
-	*val = output;
-	return 0;
-}
-
 static ssize_t dcon_output_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int output;
-	int rc = -EINVAL;
+	unsigned long output;
+	int ret;
 
-	if (_strtoul(buf, count, &output))
+	ret = strict_strtoul(buf, 10, &output);
+	if (ret)
+		return ret;
+
+	if ((output != DCON_OUTPUT_COLOR) && (output != DCON_OUTPUT_MONO))
 		return -EINVAL;
 
-	if (output == DCON_OUTPUT_COLOR || output == DCON_OUTPUT_MONO) {
-		dcon_set_output(output);
-		rc = count;
-	}
+	dcon_set_output(output);
 
-	return rc;
+	return count;
 }
 
 static ssize_t dcon_freeze_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int output;
+	unsigned long output;
+	int ret;
 
-	if (_strtoul(buf, count, &output))
-		return -EINVAL;
+	ret = strict_strtoul(buf, 10, &output);
+	if (ret)
+		return ret;
 
-	printk(KERN_INFO "dcon_freeze_store: %d\n", output);
+	printk(KERN_INFO "dcon_freeze_store: %lu\n", output);
 
 	switch (output) {
 	case 0:
@@ -585,28 +571,34 @@ static ssize_t dcon_freeze_store(struct device *dev,
 static ssize_t dcon_resumeline_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rl;
-	int rc = -EINVAL;
+	unsigned long rl;
+	int ret;
 
-	if (_strtoul(buf, count, &rl))
-		return rc;
+	ret = strict_strtoul(buf, 10, &rl);
+	if (ret)
+		return ret;
 
 	resumeline = rl;
 	dcon_write(DCON_REG_SCAN_INT, resumeline);
-	rc = count;
 
-	return rc;
+	return count;
 }
 
 static ssize_t dcon_sleep_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int output;
+	unsigned long output;
+	int ret;
 
-	if (_strtoul(buf, count, &output))
+	ret = strict_strtoul(buf, 10, &output);
+	if (ret)
+		return ret;
+
+	if (output != 0 && output != 1)
 		return -EINVAL;
 
 	dcon_sleep(output ? DCON_SLEEP : DCON_ACTIVE);
+
 	return count;
 }
 
-- 
1.7.1

