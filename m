Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab1DRTBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:01:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab1DRTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:01:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=iqeCi1yyii2MhP//xIoTjvYS3obgOhvEUpQGh8oy0S1yTk/JEVoJBtbUPdtRPElyz
	lY7GO6z0aFRyQWngAAWcQ==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v7 2/2] Use "request_muxed_region" in it87 hwmon drivers
Date: Mon, 18 Apr 2011 12:00:38 -0700
Message-Id: <1303153238-11825-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303153127-11717-1-git-send-email-natg@google.com>
References: <1303153127-11717-1-git-send-email-natg@google.com>
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
index 316b648..fa3ff02 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -108,13 +108,20 @@ superio_select(int ldn)
 	outb(ldn, VAL);
 }
 
-static inline void
+static inline int
 superio_enter(void)
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
 
 static inline void
@@ -122,6 +129,7 @@ superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 /* Logical device 4 registers */
@@ -1546,7 +1554,9 @@ static int __init it87_find(unsigned short *address,
 	u16 chip_type;
 	const char *board_vendor, *board_name;
 
-	superio_enter();
+	if (superio_enter())
+		return -EBUSY;
+
 	chip_type = force_id ? force_id : superio_inw(DEVID);
 
 	switch (chip_type) {
-- 
1.7.3.1

