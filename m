Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2JVNda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:33:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39514 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2JVNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:33:29 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] PM / OPP: predictable fail results for opp_find* functions
Date: Mon, 22 Oct 2012 08:33:19 -0500
Message-ID: <1350912799-17323-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the opp_find* functions return -ENODEV when:
a) it cant find a device (e.g. request for an OPP search on device
   which was not registered)
b) When it cant find a match for the search strategy used

This makes life a little in-efficient for users such as devfreq
to make reasonable judgement before switching search strategies.

So, standardize the return results as following:
 -EINVAL for bad pointer parameters
 -ENODEV when device cannot be found
 -ERANGE when search fails

This has the following benefit for devfreq implementation:
The search fails when an unregistered device pointer is provided.
This is a trigger to change the search direction and search for
a better fit, however, if we cannot differentiate between a valid
search range failure Vs an unregistered device, second search goes
through the same fail return condition. This can be avoided by
appropriate handling of error return code.

With this change, we also fix devfreq for the improved search
strategy with updated error code.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Reviewed-by: Kevin Hilman <khilman@ti.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
V2:
 * commit message change - updated frome example code, to verbose description
 * picked up Acked-by and Reviewed-by tags from V1.
 * rebased to v3.7-rc2
V1: https://patchwork.kernel.org/patch/1582111/

 drivers/base/power/opp.c  |   27 +++++++++++++++++++--------
 drivers/devfreq/devfreq.c |    4 ++--
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 4730a58..99d0573 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -234,7 +234,10 @@ EXPORT_SYMBOL(opp_get_opp_count);
  *
  * Searches for exact match in the opp list and returns pointer to the matching
  * opp if found, else returns ERR_PTR in case of error and should be handled
- * using IS_ERR.
+ * using IS_ERR. Error return values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
  *
  * Note: available is a modifier for the search. if available=true, then the
  * match is for exact matching frequency and is available in the stored OPP
@@ -253,7 +256,7 @@ struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
 				bool available)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
+	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	dev_opp = find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
@@ -283,7 +286,11 @@ EXPORT_SYMBOL(opp_find_freq_exact);
  * for a device.
  *
  * Returns matching *opp and refreshes *freq accordingly, else returns
- * ERR_PTR in case of error and should be handled using IS_ERR.
+ * ERR_PTR in case of error and should be handled using IS_ERR. Error return
+ * values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
  *
  * Locking: This function must be called under rcu_read_lock(). opp is a rcu
  * protected pointer. The reason for the same is that the opp pointer which is
@@ -294,7 +301,7 @@ EXPORT_SYMBOL(opp_find_freq_exact);
 struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
+	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	if (!dev || !freq) {
 		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
@@ -303,7 +310,7 @@ struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
 
 	dev_opp = find_device_opp(dev);
 	if (IS_ERR(dev_opp))
-		return opp;
+		return ERR_CAST(dev_opp);
 
 	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
 		if (temp_opp->available && temp_opp->rate >= *freq) {
@@ -326,7 +333,11 @@ EXPORT_SYMBOL(opp_find_freq_ceil);
  * for a device.
  *
  * Returns matching *opp and refreshes *freq accordingly, else returns
- * ERR_PTR in case of error and should be handled using IS_ERR.
+ * ERR_PTR in case of error and should be handled using IS_ERR. Error return
+ * values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
  *
  * Locking: This function must be called under rcu_read_lock(). opp is a rcu
  * protected pointer. The reason for the same is that the opp pointer which is
@@ -337,7 +348,7 @@ EXPORT_SYMBOL(opp_find_freq_ceil);
 struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
+	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	if (!dev || !freq) {
 		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
@@ -346,7 +357,7 @@ struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
 
 	dev_opp = find_device_opp(dev);
 	if (IS_ERR(dev_opp))
-		return opp;
+		return ERR_CAST(dev_opp);
 
 	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
 		if (temp_opp->available) {
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 0920d75..bee1c29 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -656,14 +656,14 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
 		opp = opp_find_freq_floor(dev, freq);
 
 		/* If not available, use the closest opp */
-		if (opp == ERR_PTR(-ENODEV))
+		if (opp == ERR_PTR(-ERANGE))
 			opp = opp_find_freq_ceil(dev, freq);
 	} else {
 		/* The freq is an lower bound. opp should be higher */
 		opp = opp_find_freq_ceil(dev, freq);
 
 		/* If not available, use the closest opp */
-		if (opp == ERR_PTR(-ENODEV))
+		if (opp == ERR_PTR(-ERANGE))
 			opp = opp_find_freq_floor(dev, freq);
 	}
 
-- 
1.7.9.5

