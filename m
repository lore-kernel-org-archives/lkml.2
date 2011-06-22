Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab1FVBVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:21:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49615 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab1FVBVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uw9I7rUrWq0j0AK7xT0TaMjap5yktl1PS1bCQr+SIjx3UcghBjYqDo2vFeLYXHLi48
         A+WeBnvA8pjSa4Kj2Y5HniKIPVobPNW7+Vh9UWN5P1HHI0GBtlYBQ/Hwik8sf0gkPstE
         ctz0kfbUxAJZvyDQp3aTPyorvdvDBtpPmB4qY=
From: reimth@googlemail.com
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Subject: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
Date: Wed, 22 Jun 2011 03:20:39 +0200
Message-Id: <1308705639-4215-1-git-send-email-reimth@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Reim <rdratlos@yahoo.co.uk>

Some integrated ATI Radeon chipset implementations
(e. g. Asus M2A-VM HDMI) indicate the availability
of a DDC even when there's no monitor connected.
In this case, drm_get_edid() and drm_edid_block_valid()
periodically dump data and kernel errors into system
log files and onto terminals, which lead to an unacceptable
system behaviour.

Tested since kernel 2.35 on Asus M2A-VM HDMI board

Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |   21 +++++++++--
 drivers/gpu/drm/radeon/radeon_display.c    |   11 ++++++
 drivers/gpu/drm/radeon/radeon_i2c.c        |   55 ++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 4 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index cbfca3a..497e32a 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -825,9 +825,24 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 	int i;
 	enum drm_connector_status ret = connector_status_disconnected;
 	bool dret = false;
-
-	if (radeon_connector->ddc_bus)
-		dret = radeon_ddc_probe(radeon_connector);
+
+	if (radeon_connector->ddc_bus) {
+		/* AMD 690 chipset series HDMI DDC quirk:
+		 * Some integrated ATI Radeon chipset implementations (e. g.
+		 * Asus M2A-VM HDMI) indicate the availability of a DDC even
+		 * when there's no monitor connected to HDMI. For HDMI
+		 * connectors we check for the availability of EDID with
+		 * at least a correct EDID header and EDID version/revision
+		 * information. Only then, DDC is assumed to be available.
+		 * This prevents drm_get_edid() and drm_edid_block_valid() of
+		 * periodically dumping data and kernel errors into the logs
+		 * and onto the terminal, which would lead to an unacceptable
+		 * system behaviour */
+		if (connector->connector_type == DRM_MODE_CONNECTOR_HDMIA)
+			dret = radeon_ddc_edid_probe(radeon_connector);
+		else
+			dret = radeon_ddc_probe(radeon_connector);
+	}
 	if (dret) {
 		if (radeon_connector->edid) {
 			kfree(radeon_connector->edid);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 292f73f..550f143 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -715,6 +715,9 @@ static bool radeon_setup_enc_conn(struct drm_device *dev)
 	if (ret) {
 		radeon_setup_encoder_clones(dev);
 		radeon_print_display_setup(dev);
+		/* Is this really required here?
+		   Seems to just force drm to dump EDID errors
+		   to kernel logs */
 		list_for_each_entry(drm_connector, &dev->mode_config.connector_list, head)
 			radeon_ddc_dump(drm_connector);
 	}
@@ -777,8 +780,16 @@ static int radeon_ddc_dump(struct drm_connector *connector)
 	if (!radeon_connector->ddc_bus)
 		return -1;
 	edid = drm_get_edid(connector, &radeon_connector->ddc_bus->adapter);
+	/* Asus M2A-VM HDMI DDC quirk: Log EDID retrieval status here once,
+	 * instead of periodically dumping data and kernel errors into the
+	 * logs, if a monitor is not connected to HDMI */
 	if (edid) {
+		DRM_INFO("Radeon display connector %s: Found valid EDID",
+				drm_get_connector_name(connector));
 		kfree(edid);
+	} else {
+		DRM_INFO("Radeon display connector %s: No display connected or invalid EDID",
+				drm_get_connector_name(connector));
 	}
 	return ret;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index 781196d..80b871f 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -63,6 +63,61 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 	return false;
 }
 
+/*
+ * Probe EDID information via I2C:
+ * Try to fetch EDID information by calling i2c_transfer driver function and
+ * probe for valid EDID header and version information.
+ *
+ * AMD 690 chipset series HDMI DDC quirk:
+ * Some integrated ATI Radeon chipset implementations (e. g. Asus M2A-VM HDMI
+ * indicate the availability of a DDC even when there's no monitor connected.
+ * Invalid EDID leads to flooding of logs and terminals with error messages
+ */
+bool radeon_ddc_edid_probe(struct radeon_connector *radeon_connector)
+{
+	u8 out_buf[] = {0x0, 0x0};
+	u8 block[20];
+	int ret;
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= 0x50,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= out_buf,
+		}, {
+			.addr	= 0x50,
+			.flags	= I2C_M_RD,
+			.len	= 20,
+			.buf	= block,
+		}
+	};
+
+	/* on hw with routers, select right port */
+	if (radeon_connector->router.ddc_valid)
+		radeon_router_select_ddc_port(radeon_connector);
+
+	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
+	if (ret == 2)
+		if (block[0] == 0x00 &&
+		    block[7] == 0x00 &&
+		    block[1] == 0xff &&
+		    block[2] == 0xff &&
+		    block[3] == 0xff &&
+		    block[4] == 0xff &&
+		    block[5] == 0xff &&
+		    block[6] == 0xff)
+			/* EDID header starts with:
+			 * 0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00
+			 */
+			if (block[18] != 0x00 || block[19] != 0x00)
+				/* EDID header ends with EDID version and
+				 * revision number <> 0.0
+				 */
+				return true;
+	/* Couldn't find an accessible EDID on this connector */
+	return false;
+}
+
 /* bit banging i2c */
 
 static void radeon_i2c_do_lock(struct radeon_i2c_chan *i2c, int lock_state)
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 6df4e3c..14710fc 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -515,6 +515,7 @@ extern void radeon_i2c_put_byte(struct radeon_i2c_chan *i2c,
 extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_connector);
 extern void radeon_router_select_cd_port(struct radeon_connector *radeon_connector);
 extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector);
+extern bool radeon_ddc_edid_probe(struct radeon_connector *radeon_connector);
 extern int radeon_ddc_get_modes(struct radeon_connector *radeon_connector);
 
 extern struct drm_encoder *radeon_best_encoder(struct drm_connector *connector);
-- 
1.7.1

