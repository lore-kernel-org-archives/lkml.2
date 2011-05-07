Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1EGFV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:21:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8001 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1EGFVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:21:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=S25DXJ4W+oYHfpnSmTJIgWeGsoRGzW9VwEUxnRfbhYHUsg1nGKmoxGoJTWs/Wl2QU
	aJd41e/KLtkh7TzNWcBcQ==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc: mikew@google.com, Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v9 2/2] Use "request_muxed_region" in it87 hwmon drivers
Date: Fri,  6 May 2011 22:21:14 -0700
Message-Id: <1304745674-13094-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304745564-13003-1-git-send-email-natg@google.com>
References: <1304745564-13003-1-git-send-email-natg@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02 - Chages to hwmon it87 driver to use "request_muxed_region"
Serialize access to the hardware by using "request_muxed_region" macro defined
by Alan Cox. Call to this macro will hold off the requestor if the resource is
currently busy. "superio_enter" will return an error if call to 
"request_muxed_region" fails. Rest of the code change is to ripple an error
return from superio_enter to the top level.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 316b648..bb6405b 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -77,15 +77,13 @@ static struct platform_device *pdev;
 #define	DEVID	0x20	/* Register: Device ID */
 #define	DEVREV	0x22	/* Register: Device Revision */
 
-static inline int
-superio_inb(int reg)
+static inline int superio_inb(int reg)
 {
 	outb(reg, REG);
 	return inb(VAL);
 }
 
-static inline void
-superio_outb(int reg, int val)
+static inline void superio_outb(int reg, int val)
 {
 	outb(reg, REG);
 	outb(val, VAL);
@@ -101,27 +99,32 @@ static int superio_inw(int reg)
 	return val;
 }
 
-static inline void
-superio_select(int ldn)
+static inline void superio_select(int ldn)
 {
 	outb(DEV, REG);
 	outb(ldn, VAL);
 }
 
-static inline void
-superio_enter(void)
+static inline int superio_enter(void)
 {
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
 	outb(0x55, REG);
+	return 0;
 }
 
-static inline void
-superio_exit(void)
+static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 /* Logical device 4 registers */
@@ -1542,11 +1545,15 @@ static const struct attribute_group it87_group_label = {
 static int __init it87_find(unsigned short *address,
 	struct it87_sio_data *sio_data)
 {
-	int err = -ENODEV;
+	int err;
 	u16 chip_type;
 	const char *board_vendor, *board_name;
 
-	superio_enter();
+	err = superio_enter();
+	if (err)
+		return err;
+
+	err = -ENODEV;
 	chip_type = force_id ? force_id : superio_inw(DEVID);
 
 	switch (chip_type) {
-- 
1.7.3.1

