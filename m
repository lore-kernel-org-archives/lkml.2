Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1BHL7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:59:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1BHL7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sVOojrI/nju6hlUcuI3ro5oW2vYyiU5yAWBZB3CYYO6ahAuS6FcvdzjK3C15rt/jtP
         7ALAHhOV4jsAgUNaAYC6hBtvc0mE+a/oQqiG5FsetyctnWSmTxzGEfugncjG6sG9BtJ3
         R2Zfnc9XspJU91nhO7CwvALqeSefJeM3PgEkg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: dilinger@queued.net, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH RFC resend] staging: olpc_dcon: Remove _strtoul() function.
Date: Tue,  8 Feb 2011 12:59:43 +0100
Message-Id: <1297166383-25390-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297166383-25390-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297166383-25390-1-git-send-email-marek.belisko@open-nandra.com>
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
 drivers/staging/olpc_dcon/olpc_dcon.c |   57 +++++++++++++--------------------
 1 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index dbe3049..23c0d4b 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -538,48 +538,33 @@ static ssize_t dcon_resumeline_show(struct device *dev,
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
 
 	dcon_set_mono_mode(dev_get_drvdata(dev), enable_mono ? 1 : 0);
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
@@ -601,26 +586,28 @@ static ssize_t dcon_freeze_store(struct device *dev,
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
1.7.1

