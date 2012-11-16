Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab2KPJR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:17:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65336 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2KPJR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:17:56 -0500
Message-ID: <1353057470.4277.5.camel@phoenix>
Subject: [PATCH RESEND] misc: apds9802als: Fix the logic checking timeout in
 als_wait_for_data_ready()
From: Axel Lin <axel.lin@ingics.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anantha Narayanan <anantha.narayanan@intel.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 17:17:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of timeout waiting for data ready, the retry variable is -1.
This also fixes a bug: current code returns -ETIMEDOUT if latest retry success
( which means retry is 0 when exiting the while loop ).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Resend to Greg's correct email address.

 drivers/misc/apds9802als.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 0314773..94923d2 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -68,7 +68,7 @@ static int als_wait_for_data_ready(struct device *dev)
 		ret = i2c_smbus_read_byte_data(client, 0x86);
 	} while (!(ret & 0x80) && retry--);
 
-	if (!retry) {
+	if (retry < 0) {
 		dev_warn(dev, "timeout waiting for data ready\n");
 		return -ETIMEDOUT;
 	}
-- 
1.7.9.5



