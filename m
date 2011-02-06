Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1BFX2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:28:43 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:54834 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1BFX2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:28:42 -0500
Date: Sun, 6 Feb 2011 15:28:39 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        jon.nettleton@gmail.com
Subject: [PATCH 2/4] olpc_dcon: change sysfs 'output' toggle to be
 clearer...
Message-ID: <20110206152839.21629ba7@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


..and store it in dcon_priv.  This renames it to 'monochrome',
which I think is much clearer.  Previously, "echo 1 > output"
toggled mono mode, while "echo 0 > output" enabled color.
"Echo 1 > monochrome" makes more sense to me.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   34 +++++++++++++++-----------------
 drivers/staging/olpc_dcon/olpc_dcon.h |    4 ---
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index f43c4ec..a81e325 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -58,6 +58,9 @@ struct dcon_priv {
 
 	struct work_struct switch_source;
 	struct notifier_block reboot_nb;
+
+	/* Current output type; true == mono, false == color */
+	bool mono:1;
 };
 
 /* I2C structures */
@@ -81,9 +84,6 @@ static int dcon_source;
 /* Desired source */
 static int dcon_pending;
 
-/* Current output type */
-static int dcon_output = DCON_OUTPUT_COLOR;
-
 /* Current sleep status (not yet implemented) */
 static int dcon_sleep_val = DCON_ACTIVE;
 
@@ -265,15 +265,14 @@ static void dcon_set_backlight(struct dcon_priv *dcon, int level)
 }
 
 /* Set the output type to either color or mono */
-
-static int dcon_set_output(struct dcon_priv *dcon, int arg)
+static int dcon_set_mono_mode(struct dcon_priv *dcon, bool enable_mono)
 {
-	if (dcon_output == arg)
+	if (dcon->mono == enable_mono)
 		return 0;
 
-	dcon_output = arg;
+	dcon->mono = enable_mono;
 
-	if (arg == DCON_OUTPUT_MONO) {
+	if (enable_mono) {
 		dcon_disp_mode &= ~(MODE_CSWIZZLE | MODE_COL_AA);
 		dcon_disp_mode |= MODE_MONO_LUMA;
 	} else {
@@ -525,10 +524,11 @@ static ssize_t dcon_freeze_show(struct device *dev,
 	return sprintf(buf, "%d\n", dcon_source == DCON_SOURCE_DCON ? 1 : 0);
 }
 
-static ssize_t dcon_output_show(struct device *dev,
+static ssize_t dcon_mono_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dcon_output);
+	struct dcon_priv *dcon = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", dcon->mono ? 1 : 0);
 }
 
 static ssize_t dcon_resumeline_show(struct device *dev,
@@ -554,19 +554,17 @@ static int _strtoul(const char *buf, int len, unsigned int *val)
 	return 0;
 }
 
-static ssize_t dcon_output_store(struct device *dev,
+static ssize_t dcon_mono_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int output;
+	int enable_mono;
 	int rc = -EINVAL;
 
-	if (_strtoul(buf, count, &output))
+	if (_strtoul(buf, count, &enable_mono))
 		return -EINVAL;
 
-	if (output == DCON_OUTPUT_COLOR || output == DCON_OUTPUT_MONO) {
-		dcon_set_output(dev_get_drvdata(dev), output);
-		rc = count;
-	}
+	dcon_set_mono_mode(dev_get_drvdata(dev), enable_mono ? 1 : 0);
+	rc = count;
 
 	return rc;
 }
@@ -631,7 +629,7 @@ static struct device_attribute dcon_device_files[] = {
 	__ATTR(mode, 0444, dcon_mode_show, NULL),
 	__ATTR(sleep, 0644, dcon_sleep_show, dcon_sleep_store),
 	__ATTR(freeze, 0644, dcon_freeze_show, dcon_freeze_store),
-	__ATTR(output, 0644, dcon_output_show, dcon_output_store),
+	__ATTR(monochrome, 0644, dcon_mono_show, dcon_mono_store),
 	__ATTR(resumeline, 0644, dcon_resumeline_show, dcon_resumeline_store),
 };
 
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index e566d21..77dcbd1 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -41,10 +41,6 @@
 #define DCON_SOURCE_DCON        0
 #define DCON_SOURCE_CPU         1
 
-/* Output values */
-#define DCON_OUTPUT_COLOR       0
-#define DCON_OUTPUT_MONO        1
-
 /* Sleep values */
 #define DCON_ACTIVE             0
 #define DCON_SLEEP              1
-- 
1.7.2.3

