Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1DFVNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:13:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1DFVNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:13:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=yPMhGtrA2BKUw7ymvo4DGb8zCMO/11I0gbAb6aRWkKT1lwa8rCi3im6l+MmkLezI+
	Cp4RmCUVUtPkoKnKw7Z4A==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH 3/3] Make all it87 drivers SMP safe.
Date: Wed,  6 Apr 2011 14:13:16 -0700
Message-Id: <1302124396-22449-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03 - Adds changes to hwmon driver to use the new lock.

Signed-off-by: Nat Gurumoorthy <natg@google.com>

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 297bc9a..afe671a 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -436,6 +436,7 @@ config SENSORS_IBMPEX
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
 	select HWMON_VID
+	select IT87_LOCK
 	help
 	  If you say yes here you get support for ITE IT8705F, IT8712F,
 	  IT8716F, IT8718F, IT8720F, IT8721F, IT8726F and IT8758E sensor
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 316b648..bc32535 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -55,6 +55,8 @@
 #include <linux/dmi.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/it87_lock.h>
 
 #define DRVNAME "it87"
 
@@ -110,7 +112,9 @@ superio_select(int ldn)
 
 static inline void
 superio_enter(void)
+__acquires(&it87_io_lock)
 {
+	spin_lock(&it87_io_lock);
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -119,9 +123,11 @@ superio_enter(void)
 
 static inline void
 superio_exit(void)
+__releases(&it87_io_lock)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	spin_unlock(&it87_io_lock);
 }
 
 /* Logical device 4 registers */
@@ -1899,8 +1905,12 @@ static int __devexit it87_remove(struct platform_device *pdev)
    would slow down the IT87 access and should not be necessary. */
 static int it87_read_value(struct it87_data *data, u8 reg)
 {
+	int ret;
+	spin_lock(&it87_io_lock);
 	outb_p(reg, data->addr + IT87_ADDR_REG_OFFSET);
-	return inb_p(data->addr + IT87_DATA_REG_OFFSET);
+	ret = inb_p(data->addr + IT87_DATA_REG_OFFSET);
+	spin_unlock(&it87_io_lock);
+	return ret;
 }
 
 /* Must be called with data->update_lock held, except during initialization.
@@ -1908,8 +1918,10 @@ static int it87_read_value(struct it87_data *data, u8 reg)
    would slow down the IT87 access and should not be necessary. */
 static void it87_write_value(struct it87_data *data, u8 reg, u8 value)
 {
+	spin_lock(&it87_io_lock);
 	outb_p(reg, data->addr + IT87_ADDR_REG_OFFSET);
 	outb_p(value, data->addr + IT87_DATA_REG_OFFSET);
+	spin_unlock(&it87_io_lock);
 }
 
 /* Return 1 if and only if the PWM interface is safe to use */
-- 

