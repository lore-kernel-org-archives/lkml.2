Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2JOOOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:14:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46867 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab2JOOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:14:39 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] PM / devfreq: fix sscanf handling for writable sysfs entries
Date: Mon, 15 Oct 2012 09:14:30 -0500
Message-ID: <1350310470-27621-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sscanf returns 0 when an invalid parameter like:
echo -n "a">min_freq
is attempted. Returning back the return result(0) will
cause the command not to return back to command
prompt.

Instead, just return -EINVAL when sscanf does not
return 1.

This is done for min_freq, max_freq and polling_interval

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/devfreq.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index b146d76..9f562ae 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -488,7 +488,7 @@ static ssize_t store_polling_interval(struct device *dev,
 
 	ret = sscanf(buf, "%u", &value);
 	if (ret != 1)
-		goto out;
+		return -EINVAL;
 
 	mutex_lock(&df->lock);
 	df->profile->polling_ms = value;
@@ -529,7 +529,7 @@ static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
 
 	ret = sscanf(buf, "%lu", &value);
 	if (ret != 1)
-		goto out;
+		return -EINVAL;
 
 	mutex_lock(&df->lock);
 	max = df->max_freq;
@@ -543,7 +543,6 @@ static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
 	ret = count;
 unlock:
 	mutex_unlock(&df->lock);
-out:
 	return ret;
 }
 
@@ -563,7 +562,7 @@ static ssize_t store_max_freq(struct device *dev, struct device_attribute *attr,
 
 	ret = sscanf(buf, "%lu", &value);
 	if (ret != 1)
-		goto out;
+		return -EINVAL;
 
 	mutex_lock(&df->lock);
 	min = df->min_freq;
@@ -577,7 +576,6 @@ static ssize_t store_max_freq(struct device *dev, struct device_attribute *attr,
 	ret = count;
 unlock:
 	mutex_unlock(&df->lock);
-out:
 	return ret;
 }
 
-- 
1.7.9.5

