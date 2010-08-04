Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab0HDTya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:54:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:33595 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0HDTy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:54:28 -0400
Date: Wed, 4 Aug 2010 21:54:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/staging/iio: call mutex_unlock in error handling
 code
Message-ID: <Pine.LNX.4.64.1008042153460.30592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Adjust the error handling code so that it benefits from the call to
mutex_unlock at the end of the function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@rcu exists@
position p1;
expression E;
@@

mutex_lock@p1(E);
...
mutex_unlock(E);

@exists@
position rcu.p1;
expression E;
@@

*mutex_lock@p1(E);
... when != mutex_unlock(E);
?*return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/iio/magnetometer/hmc5843.c     |   25 +++++++++++++------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
index 92f6c6f..ea5f749 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.c
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -220,11 +220,15 @@ static ssize_t hmc5843_set_operating_mode(struct device *dev,
 	int error;
 	mutex_lock(&data->lock);
 	error = strict_strtoul(buf, 10, &operating_mode);
-	if (error)
-		return error;
+	if (error) {
+		count = error;
+		goto exit;
+	}
 	dev_dbg(dev, "set Conversion mode to %lu\n", operating_mode);
-	if (operating_mode > MODE_SLEEP)
-			return -EINVAL;
+	if (operating_mode > MODE_SLEEP) {
+		count = -EINVAL;
+		goto exit;
+	}
 
 	status = i2c_smbus_write_byte_data(client, this_attr->address,
 					operating_mode);
@@ -437,18 +441,23 @@ static ssize_t set_range(struct device *dev,
 	int error;
 	mutex_lock(&data->lock);
 	error = strict_strtoul(buf, 10, &range);
-	if (error)
-		return error;
+	if (error) {
+		count = error;
+		goto exit;
+	}
 	dev_dbg(dev, "set range to %lu\n", range);
 
-	if (range > RANGE_6_5)
-		return -EINVAL;
+	if (range > RANGE_6_5) {
+		count = -EINVAL;
+		goto exit;
+	}
 
 	data->range = range;
 	range = range << RANGE_GAIN_OFFSET;
 	if (i2c_smbus_write_byte_data(client, this_attr->address, range))
 		count = -EINVAL;
 
+exit:
 	mutex_unlock(&data->lock);
 	return count;
 
