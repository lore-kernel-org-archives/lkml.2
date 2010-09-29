Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0I2EmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:42:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48530 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0I2EmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tG5eBfMOj0/cu5BJBetDvMo0aRdodoK63CdnAymJgGZOmX+8aEzNAoliRihcA4T1zx
         qioACqHgu/X9jU9ybjaduEK7UJB+vTrwZIgzP02SWRcvCgHRVzh8HMGxl9/czxklKdwH
         4v2kaIWNQXkjjMFBuEEMveWYkNv4igL6HqRpo=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: Pat Gefre <pfg@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-mips@linux-mips.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] serial: ioc3_serial: release resources in error return path
Date: Wed, 29 Sep 2010 10:11:19 +0530
Message-Id: <1285735279-2952-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ioc3uart_probe()
resources were not released during error return path
- ports[phys_port]

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/serial/ioc3_serial.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
index 93de907..1a182cf 100644
--- a/drivers/serial/ioc3_serial.c
+++ b/drivers/serial/ioc3_serial.c
@@ -2017,6 +2017,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 	struct ioc3_port *port;
 	struct ioc3_port *ports[PORTS_PER_CARD];
 	int phys_port;
+	int cnt;
 
 	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __func__, is, idd));
 
@@ -2044,7 +2045,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 		if (!port) {
 			printk(KERN_WARNING
 			       "IOC3 serial memory not available for port\n");
-			goto out4;
+			goto out3;
 		}
 		spin_lock_init(&port->ip_lock);
 
@@ -2138,13 +2139,16 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 	/* register port with the serial core */
 
 	if ((ret = ioc3_serial_core_attach(is, idd)))
-		goto out4;
+		goto out3;
 
 	Num_of_ioc3_cards++;
 
 	return ret;
 
 	/* error exits that give back resources */
+out3:
+	for (cnt = 0; cnt < phys_port; cnt++)
+		kfree(ports[cnt]);
 out4:
 	kfree(card_ptr);
 	return ret;
-- 
1.7.2.3

