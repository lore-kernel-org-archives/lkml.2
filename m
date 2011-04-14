Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1DNVjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:39:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1DNVjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:39:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=GeBBkqDDBkDOCmwKQdfoTYKrZ5EstBm6xotJSjvOqGXa3kVLTl4yMgiIAgBKXCRXa
	HHGWZrPha7vDog125xsSA==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v6 2/2] Use "request_muxed_region" in it87 hwmon drivers
Date: Thu, 14 Apr 2011 14:38:16 -0700
Message-Id: <1302817096-6433-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1302816996-6345-1-git-send-email-natg@google.com>
References: <1302816996-6345-1-git-send-email-natg@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02 - Chages to hwmon it87 driver to use "request_muxed_region"
Serialize access to the hardware by using "request_muxed_region" macro defined
by Alan Cox. Call to this macro will hold off the requestor if the resource is
currently busy. The first call to request_muxed_region will attempt 10 times 
to reserve the region before it gives up. This will typically get called from
the driver init routines. If this succeeds then subsequent calls wait forever
for the resource to be available.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 316b648..2c349be 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -108,13 +108,34 @@ superio_select(int ldn)
 	outb(ldn, VAL);
 }
 
-static inline void
-superio_enter(void)
-{
+static inline int
+try_superio_enter(void)
+{
+	int num_tries = 10;
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 * Give up after 10 attempts.
+	 */
+	while (num_tries--) {
+		if (!request_muxed_region(REG, 2, DRVNAME)) {
+			if (num_tries)
+				continue;
+
+			/*
+			 * Someone is holding the region. Give up.
+			 */
+			pr_err("I/O address 0x%04x already in use\n", REG);
+			return -EBUSY;
+		}
+
+		break;
+	}
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void
@@ -122,6 +143,7 @@ superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 /* Logical device 4 registers */
@@ -1546,7 +1568,9 @@ static int __init it87_find(unsigned short *address,
 	u16 chip_type;
 	const char *board_vendor, *board_name;
 
-	superio_enter();
+	if (try_superio_enter())
+		return -EBUSY;
+
 	chip_type = force_id ? force_id : superio_inw(DEVID);
 
 	switch (chip_type) {
-- 
1.7.3.1

