Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2HMUmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:42:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2HMUUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:53 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 2/2] apple_gmux: Add support for newer hardware
Date: Mon, 13 Aug 2012 16:20:32 -0400
Message-Id: <1344889232-3907-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1344889232-3907-1-git-send-email-mjg@redhat.com>
References: <1344889232-3907-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New gmux devices have a different method for accessing the registers.
Update the driver to cope. Incorporates feedback from Bernhard Froemel.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Cc: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/apple-gmux.c | 181 ++++++++++++++++++++++++++++++++++----
 1 file changed, 166 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 43721c1..612b6f6 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -18,12 +18,15 @@
 #include <linux/pnp.h>
 #include <linux/apple_bl.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <acpi/video.h>
 #include <asm/io.h>
 
 struct apple_gmux_data {
 	unsigned long iostart;
 	unsigned long iolen;
+	bool indexed;
+	struct mutex index_lock;
 
 	struct backlight_device *bdev;
 };
@@ -45,6 +48,9 @@ struct apple_gmux_data {
 #define GMUX_PORT_DISCRETE_POWER	0x50
 #define GMUX_PORT_MAX_BRIGHTNESS	0x70
 #define GMUX_PORT_BRIGHTNESS		0x74
+#define GMUX_PORT_VALUE			0xc2
+#define GMUX_PORT_READ			0xd0
+#define GMUX_PORT_WRITE			0xd4
 
 #define GMUX_MIN_IO_LEN			(GMUX_PORT_BRIGHTNESS + 4)
 
@@ -59,24 +65,24 @@ struct apple_gmux_data {
 #define GMUX_BRIGHTNESS_MASK		0x00ffffff
 #define GMUX_MAX_BRIGHTNESS		GMUX_BRIGHTNESS_MASK
 
-static inline u8 gmux_read8(struct apple_gmux_data *gmux_data, int port)
+static u8 gmux_pio_read8(struct apple_gmux_data *gmux_data, int port)
 {
 	return inb(gmux_data->iostart + port);
 }
 
-static inline void gmux_write8(struct apple_gmux_data *gmux_data, int port,
+static void gmux_pio_write8(struct apple_gmux_data *gmux_data, int port,
 			       u8 val)
 {
 	outb(val, gmux_data->iostart + port);
 }
 
-static inline u32 gmux_read32(struct apple_gmux_data *gmux_data, int port)
+static u32 gmux_pio_read32(struct apple_gmux_data *gmux_data, int port)
 {
 	return inl(gmux_data->iostart + port);
 }
 
-static inline u32 gmux_write32(struct apple_gmux_data *gmux_data, int port,
-			       u32 val)
+static void gmux_pio_write32(struct apple_gmux_data *gmux_data, int port,
+			     u32 val)
 {
 	int i;
 	u8 tmpval;
@@ -87,6 +93,144 @@ static inline u32 gmux_write32(struct apple_gmux_data *gmux_data, int port,
 	}
 }
 
+static int gmux_index_wait_ready(struct apple_gmux_data *gmux_data)
+{
+	int i = 200;
+	u8 gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
+
+	while (i && (gwr & 0x01)) {
+		inb(gmux_data->iostart + GMUX_PORT_READ);
+		gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
+		msleep(100);
+		i--;
+	}
+
+	return !!i;
+}
+
+static int gmux_index_wait_complete(struct apple_gmux_data *gmux_data)
+{
+	int i = 200;
+	u8 gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
+
+	while (i && (gwr & 0x01)) {
+		gwr = inb(gmux_data->iostart + GMUX_PORT_WRITE);
+		msleep(100);
+		i--;
+	}
+
+	if (gwr & 0x01)
+		inb(gmux_data->iostart + GMUX_PORT_READ);
+
+	return !!i;
+}
+
+static u8 gmux_index_read8(struct apple_gmux_data *gmux_data, int port)
+{
+	u8 val;
+
+	mutex_lock(&gmux_data->index_lock);
+	outb((port & 0xff), gmux_data->iostart + GMUX_PORT_READ);
+	gmux_index_wait_ready(gmux_data);
+	val = inb(gmux_data->iostart + GMUX_PORT_VALUE);
+	mutex_unlock(&gmux_data->index_lock);
+
+	return val;
+}
+
+static void gmux_index_write8(struct apple_gmux_data *gmux_data, int port,
+			      u8 val)
+{
+	mutex_lock(&gmux_data->index_lock);
+	outb(val, gmux_data->iostart + GMUX_PORT_VALUE);
+	gmux_index_wait_ready(gmux_data);
+	outb(port & 0xff, gmux_data->iostart + GMUX_PORT_WRITE);
+	gmux_index_wait_complete(gmux_data);
+	mutex_unlock(&gmux_data->index_lock);
+}
+
+static u32 gmux_index_read32(struct apple_gmux_data *gmux_data, int port)
+{
+	u32 val;
+
+	mutex_lock(&gmux_data->index_lock);
+	outb((port & 0xff), gmux_data->iostart + GMUX_PORT_READ);
+	gmux_index_wait_ready(gmux_data);
+	val = inl(gmux_data->iostart + GMUX_PORT_VALUE);
+	mutex_unlock(&gmux_data->index_lock);
+
+	return val;
+}
+
+static void gmux_index_write32(struct apple_gmux_data *gmux_data, int port,
+			       u32 val)
+{
+	int i;
+	u8 tmpval;
+
+	mutex_lock(&gmux_data->index_lock);
+
+	for (i = 0; i < 4; i++) {
+		tmpval = (val >> (i * 8)) & 0xff;
+		outb(tmpval, gmux_data->iostart + GMUX_PORT_VALUE + i);
+	}
+
+	gmux_index_wait_ready(gmux_data);
+	outb(port & 0xff, gmux_data->iostart + GMUX_PORT_WRITE);
+	gmux_index_wait_complete(gmux_data);
+	mutex_unlock(&gmux_data->index_lock);
+}
+
+static u8 gmux_read8(struct apple_gmux_data *gmux_data, int port)
+{
+	if (gmux_data->indexed)
+		return gmux_index_read8(gmux_data, port);
+	else
+		return gmux_pio_read8(gmux_data, port);
+}
+
+static void gmux_write8(struct apple_gmux_data *gmux_data, int port, u8 val)
+{
+	if (gmux_data->indexed)
+		gmux_index_write8(gmux_data, port, val);
+	else
+		gmux_pio_write8(gmux_data, port, val);
+}
+
+static u32 gmux_read32(struct apple_gmux_data *gmux_data, int port)
+{
+	if (gmux_data->indexed)
+		return gmux_index_read32(gmux_data, port);
+	else
+		return gmux_pio_read32(gmux_data, port);
+}
+
+static void gmux_write32(struct apple_gmux_data *gmux_data, int port,
+			     u32 val)
+{
+	if (gmux_data->indexed)
+		gmux_index_write32(gmux_data, port, val);
+	else
+		gmux_pio_write32(gmux_data, port, val);
+}
+
+static bool gmux_is_indexed(struct apple_gmux_data *gmux_data)
+{
+	u16 val;
+
+	outb(0xaa, gmux_data->iostart + 0xcc);
+	outb(0x55, gmux_data->iostart + 0xcd);
+	outb(0x00, gmux_data->iostart + 0xce);
+
+	val = inb(gmux_data->iostart + 0xcc) |
+		(inb(gmux_data->iostart + 0xcd) << 8);
+
+	if (val == 0x55aa)
+		return true;
+
+	return false;
+}
+
 static int gmux_get_brightness(struct backlight_device *bd)
 {
 	struct apple_gmux_data *gmux_data = bl_get_data(bd);
@@ -102,7 +246,7 @@ static int gmux_update_status(struct backlight_device *bd)
 	if (bd->props.state & BL_CORE_SUSPENDED)
 		return 0;
 
-	gmux_write32(gmux_data, GMUX_PORT_BRIGHTNES, brightness);
+	gmux_write32(gmux_data, GMUX_PORT_BRIGHTNESS, brightness);
 
 	return 0;
 }
@@ -150,22 +294,29 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
 	}
 
 	/*
-	 * On some machines the gmux is in ACPI even thought the machine
-	 * doesn't really have a gmux. Check for invalid version information
-	 * to detect this.
+	 * Invalid version information may indicate either that the gmux
+	 * device isn't present or that it's a new one that uses indexed
+	 * io
 	 */
+
 	ver_major = gmux_read8(gmux_data, GMUX_PORT_VERSION_MAJOR);
 	ver_minor = gmux_read8(gmux_data, GMUX_PORT_VERSION_MINOR);
 	ver_release = gmux_read8(gmux_data, GMUX_PORT_VERSION_RELEASE);
 	if (ver_major == 0xff && ver_minor == 0xff && ver_release == 0xff) {
-		pr_info("gmux device not present\n");
-		ret = -ENODEV;
-		goto err_release;
+		if (gmux_is_indexed(gmux_data)) {
+			mutex_init(&gmux_data->index_lock);
+			gmux_data->indexed = true;
+		} else {
+			pr_info("gmux device not present\n");
+			ret = -ENODEV;
+			goto err_release;
+		}
+		pr_info("Found indexed gmux\n");
+	} else {
+		pr_info("Found gmux version %d.%d.%d\n", ver_major, ver_minor,
+			ver_release);
 	}
 
-	pr_info("Found gmux version %d.%d.%d\n", ver_major, ver_minor,
-		ver_release);
-
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = gmux_read32(gmux_data, GMUX_PORT_MAX_BRIGHTNESS);
-- 
1.7.11.2

