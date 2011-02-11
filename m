Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1BKBt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:49:28 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34862 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1BKBt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:49:27 -0500
Date: Thu, 10 Feb 2011 17:49:24 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 04/10] staging: olpc_dcon: Remove _strtoul() function.
Message-ID: <20110210174924.7c591dc5@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Marek Belisko <marek.belisko@open-nandra.com>

olpc_dcon driver use self invented _strtoul  function
which make similar check like strict_strtoul just extend
for space checking at last string place. Normally access
to sys file looks echo 1024 > /sys/... so space could be considered
as error character and we could simplify code using just strict_strtoul
function instead self invented.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   57 +++++++++++++--------------------
 1 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index d3c2800..52b7b30 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -549,48 +549,33 @@ static ssize_t dcon_resumeline_show(struct device *dev,
 	return sprintf(buf, "%d\n", resumeline);
 }
 
-static int _strtoul(const char *buf, int len, unsigned int *val)
-{
-
-	char *endp;
-	unsigned int output = simple_strtoul(buf, &endp, 0);
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
 static ssize_t dcon_mono_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int enable_mono;
-	int rc = -EINVAL;
+	unsigned long enable_mono;
+	int rc;
 
-	if (_strtoul(buf, count, &enable_mono))
-		return -EINVAL;
+	rc = strict_strtoul(buf, 10, &enable_mono);
+	if (rc)
+		return rc;
 
 	dcon_set_mono_mode(dev_get_drvdata(dev), enable_mono ? true : false);
-	rc = count;
 
-	return rc;
+	return count;
 }
 
 static ssize_t dcon_freeze_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct dcon_priv *dcon = dev_get_drvdata(dev);
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
@@ -612,26 +597,28 @@ static ssize_t dcon_freeze_store(struct device *dev,
 static ssize_t dcon_resumeline_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rl;
-	int rc = -EINVAL;
+	unsigned long rl;
+	int rc;
 
-	if (_strtoul(buf, count, &rl))
+	rc = strict_strtoul(buf, 10, &rl);
+	if (rc)
 		return rc;
 
 	resumeline = rl;
 	dcon_write(dev_get_drvdata(dev), DCON_REG_SCAN_INT, resumeline);
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
-		return -EINVAL;
+	ret = strict_strtoul(buf, 10, &output);
+	if (ret)
+		return ret;
 
 	dcon_sleep(dev_get_drvdata(dev), output ? true : false);
 	return count;
-- 
1.7.2.3

