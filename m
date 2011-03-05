Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685Ab1CEBLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:11:47 -0500
Received: from kroah.org ([198.145.64.141]:50320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760444Ab1CEBAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.866486409@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Varun Wadekar <vwadekar@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [44/73] mfd: Avoid tps6586x burst writes
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: vwadekar@nvidia.com <vwadekar@nvidia.com>

commit 4b57018dcd6418e18c08088c89f123da8a7bfc45 upstream.

tps6586 does not support burst writes. i2c writes have to be
1 byte at a time.

Signed-off-by: Varun Wadekar <vwadekar@nvidia.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/tps6586x.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -152,12 +152,12 @@ static inline int __tps6586x_write(struc
 static inline int __tps6586x_writes(struct i2c_client *client, int reg,
 				  int len, uint8_t *val)
 {
-	int ret;
+	int ret, i;
 
-	ret = i2c_smbus_write_i2c_block_data(client, reg, len, val);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed writings to 0x%02x\n", reg);
-		return ret;
+	for (i = 0; i < len; i++) {
+		ret = __tps6586x_write(client, reg + i, *(val + i));
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;


