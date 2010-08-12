Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab0HLAjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:39:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39010 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758915Ab0HKX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:07 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19qavRqEApq4qnDSEMcGKv/auKlODfVVt9kzrxuKn
	I+1sFFbez6yWE4
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [[PATCH 08/11]] viafb: reduce viafb_set_iga_path usage
Date: Thu, 12 Aug 2010 00:08:42 +0000
Message-Id: <1281571722-8940-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: reduce viafb_set_iga_path usage

The result of viafb_set_iga_path can change after init only in the
hotplug ioctl. So we can move it there rather than doing it always
when a new mode is set. The setup during init is done via a call
from the init chip funtion.
This change enables a stable mapping between the old device scheme
and a new more powerfull one.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c    |    1 -
 drivers/video/via/ioctl.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 4407943..638cf96 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2313,7 +2313,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		via_write_reg(VIASR, i, VPIT.SR[i - 1]);
 
 	viafb_write_reg_mask(0x15, VIASR, 0xA2, 0xA2);
-	viafb_set_iga_path();
 
 	/* Write CRTC */
 	viafb_fill_crtc_timing(crt_timing, vmode_tbl, video_bpp / 8, IGA1);
diff --git a/drivers/video/via/ioctl.c b/drivers/video/via/ioctl.c
index da03c07..455b39f 100644
--- a/drivers/video/via/ioctl.c
+++ b/drivers/video/via/ioctl.c
@@ -92,6 +92,7 @@ int viafb_ioctl_hotplug(int hres, int vres, int bpp)
 				viafb_CRT_ON = 0;
 				viafb_LCD_ON = 0;
 				viafb_DeviceStatus = DVI_Device;
+				viafb_set_iga_path();
 				return viafb_DeviceStatus;
 			}
 			status = 1;
@@ -105,6 +106,7 @@ int viafb_ioctl_hotplug(int hres, int vres, int bpp)
 		viafb_LCD_ON = 0;
 
 		viafb_DeviceStatus = CRT_Device;
+		viafb_set_iga_path();
 		return viafb_DeviceStatus;
 	}
 
-- 
1.6.3.2

