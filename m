Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1DXB5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:57:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55553 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757429Ab1DXB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:57:17 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+NrgU61nGNHlsrkA8AUAh3OME+AeojOiDprp3dXc
	b36jeLPlCU5ObW
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: add X server compatibility mode
Date: Sun, 24 Apr 2011 02:13:21 +0000
Message-Id: <1303611201-8727-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a config option to be compatible with X servers like
OpenChrome. This is required as for example the X server does not
handle things like disabled IGAs/PLLs resulting in a potential
freeze on X startup. With this option disabled we can provide some
nice features like power management and not reinitializing the
hardware on every mode switch (taking long time, causing flickering).

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/Kconfig  |   11 +++++++++++
 drivers/video/via/hw.c |    7 +++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 6bafb51..4923b5e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1607,6 +1607,17 @@ config FB_VIA_DIRECT_PROCFS
 	  correct output device configuration.
 	  Its use is strongly discouraged.
 
+config FB_VIA_X_COMPATIBILITY
+	bool "X server compatibility"
+	depends on FB_VIA
+	default n
+	help
+	  This option reduces the functionality (power saving, ...) of the
+	  framebuffer to avoid negative impact on the OpenChrome X server.
+	  If you use any X server other than fbdev you should enable this
+	  otherwise it should be safe to disable it and allow using all
+	  features.
+
 endif
 
 config FB_NEOMAGIC
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index e531147..104f3e1 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2293,6 +2293,12 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	clock.set_primary_clock_source(VIA_CLKSRC_X1, true);
 	clock.set_secondary_clock_source(VIA_CLKSRC_X1, true);
 
+#ifdef CONFIG_FB_VIA_X_COMPATIBILITY
+	clock.set_primary_pll_state(VIA_STATE_ON);
+	clock.set_primary_clock_state(VIA_STATE_ON);
+	clock.set_secondary_pll_state(VIA_STATE_ON);
+	clock.set_secondary_clock_state(VIA_STATE_ON);
+#else
 	if (viaparinfo->shared->iga1_devices) {
 		clock.set_primary_pll_state(VIA_STATE_ON);
 		clock.set_primary_clock_state(VIA_STATE_ON);
@@ -2308,6 +2314,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		clock.set_secondary_pll_state(VIA_STATE_OFF);
 		clock.set_secondary_clock_state(VIA_STATE_OFF);
 	}
+#endif /*CONFIG_FB_VIA_X_COMPATIBILITY*/
 
 	via_set_state(devices, VIA_STATE_ON);
 	device_screen_on();
-- 
1.6.3.2

