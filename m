Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0J1Ekw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 00:40:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49732 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0J1Ekt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 00:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=PnIwWzY5Th0OOtHGLZi75sy7eCowhsoSAKwHXIBIC5O+Wdn9FMXL2kCnaZDgFg1CkY
         Wb3967Q/D15NFCxJWQOmJZFTGBNkVXWsznbClVrZZyLFI0WqwhUbtpV3LXzy4jqydxPM
         jb8kbYbYKO68Kz2FDMWQ/uVxbyBkviE2klQpc=
Date: Thu, 28 Oct 2010 06:40:37 +0200
From: Dan Carpenter <error27@gmail.com>
To: Liu Hong <hong.liu@intel.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] misc/isl29020: signedness bug in als_sensing_range_store()
Message-ID: <20101028044037.GS6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Liu Hong <hong.liu@intel.com>,
	Kalhan Trisal <kalhan.trisal@intel.com>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ret_val" is supposed to be signed here or the error handling breaks.
Also we should check the return value from i2c_smbus_read_byte_data().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 34fe835..ca47e62 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -87,7 +87,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 		struct device_attribute *attr, const  char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	unsigned int ret_val;
+	int ret_val;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 10, &val))
@@ -106,6 +106,8 @@ static ssize_t als_sensing_range_store(struct device *dev,
 		val = 4;
 
 	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	if (ret_val < 0)
+		return ret_val;
 
 	ret_val &= 0xFC; /*reset the bit before setting them */
 	ret_val |= val - 1;
