Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1DSUX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:23:56 -0400
Received: from kroah.org ([198.145.64.141]:35625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1DSUR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:48 2011
Message-Id: <20110419201047.963193415@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [45/70] i2c-algo-bit: Call pre/post_xfer for bit_test
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit d3b3e15da14ded61c9654db05863b04a2435f4cc upstream.

Apparently some distros set i2c-algo-bit.bit_test to 1 by
default.  In some cases this causes i2c_bit_add_bus
to fail and prevents the i2c bus from being added.  In the
radeon case, we fail to add the ddc i2c buses which prevents
the driver from being able to detect attached monitors.
The i2c bus works fine even if bit_test fails.  This is likely
due to gpio switching that is required and handled in the
pre/post_xfer hooks, so call the pre/post_xfer hooks in the
bit test as well.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=36221

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/algos/i2c-algo-bit.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -232,9 +232,17 @@ static int i2c_inb(struct i2c_adapter *i
  * Sanity check for the adapter hardware - check the reaction of
  * the bus lines only if it seems to be idle.
  */
-static int test_bus(struct i2c_algo_bit_data *adap, char *name)
+static int test_bus(struct i2c_adapter *i2c_adap)
 {
-	int scl, sda;
+	struct i2c_algo_bit_data *adap = i2c_adap->algo_data;
+	const char *name = i2c_adap->name;
+	int scl, sda, ret;
+
+	if (adap->pre_xfer) {
+		ret = adap->pre_xfer(i2c_adap);
+		if (ret < 0)
+			return -ENODEV;
+	}
 
 	if (adap->getscl == NULL)
 		pr_info("%s: Testing SDA only, SCL is not readable\n", name);
@@ -297,11 +305,19 @@ static int test_bus(struct i2c_algo_bit_
 		       "while pulling SCL high!\n", name);
 		goto bailout;
 	}
+
+	if (adap->post_xfer)
+		adap->post_xfer(i2c_adap);
+
 	pr_info("%s: Test OK\n", name);
 	return 0;
 bailout:
 	sdahi(adap);
 	sclhi(adap);
+
+	if (adap->post_xfer)
+		adap->post_xfer(i2c_adap);
+
 	return -ENODEV;
 }
 
@@ -607,7 +623,7 @@ static int __i2c_bit_add_bus(struct i2c_
 	int ret;
 
 	if (bit_test) {
-		ret = test_bus(bit_adap, adap->name);
+		ret = test_bus(adap);
 		if (ret < 0)
 			return -ENODEV;
 	}


